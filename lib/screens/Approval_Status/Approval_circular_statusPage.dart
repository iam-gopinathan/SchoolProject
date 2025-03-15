import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/circular_models/Circular_Approval_status_model.dart';
import 'package:flutter_application_1/services/Circular_Api/Circular_approval_status_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class ApprovalCircularStatuspage extends StatefulWidget {
  const ApprovalCircularStatuspage({super.key});

  @override
  State<ApprovalCircularStatuspage> createState() =>
      _ApprovalCircularStatuspageState();
}

class _ApprovalCircularStatuspageState
    extends State<ApprovalCircularStatuspage> {
  TextEditingController searchController = TextEditingController();
  //

  List<CircularApprovalStatusModel> circularList = [];
  List<CircularApprovalStatusModel> filteredCircularList = [];
  bool isLoading = true;

  Future<void> fetchCircularApproval({
    String status = '',
    String date = '',
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      List<CircularApprovalStatusModel> fetchedCirculars =
          await fetchCircularApprovalStatusData(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        date: date,
        status: status,
        screen: "maker",
      );

      setState(() {
        circularList = fetchedCirculars;
        filteredCircularList = circularList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching circular approval: $e");
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    // TODO: implement initState
    super.initState();
    fetchCircularApproval();
  }

  ScrollController _scrollController = ScrollController();
  void _scrollListener() {
    setState(() {});
  }

  void filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCircularList = circularList;
      } else {
        filteredCircularList = circularList
            .where((news) =>
                news.headLine.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void showNewsMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      color: Colors.black,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem<String>(
          value: 'All',
          child: Text(
            'All',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'regular',
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Pending',
          child: Text(
            'Pending',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'regular',
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Declined',
          child: Text(
            'Declined',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'regular',
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        print('Selected status: $value');
        fetchCircularApproval(status: value);
      }
    });
  }

  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  //select date
  String selectedDate = '';
  String displayDate = '';
  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppTheme.textFieldborderColor,
                onPrimary: Colors.black,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              )),
            ),
            child: child!,
          );
        });

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
      displayDate = DateFormat('EEEE, dd MMMM').format(pickedDate);
    }
  }
  //selected date end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: AppTheme.appBackgroundPrimaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04,
                  ), // 3% of screen height),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Circular Approvals Status',
                                style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  await _selectDate(context);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await fetchCircularApproval(
                                      date: selectedDate);
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: SvgPicture.asset(
                                        'assets/icons/Attendancepage_calendar_icon.svg',
                                        fit: BoxFit.contain,
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      displayDate,
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        color: Color.fromRGBO(73, 73, 73, 1),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : Column(
              children: [
                //
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        //search container...
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: searchController,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    prefixIcon: Transform.translate(
                                      offset: Offset(
                                        MediaQuery.of(context).size.width *
                                            0.12, // Responsive X-axis (60)
                                        0,
                                      ),
                                      child: Icon(Icons.search,
                                          color:
                                              Color.fromRGBO(178, 178, 178, 1)),
                                    ),
                                    hintText: 'Search News by Heading',
                                    hintStyle: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 14,
                                        color:
                                            Color.fromRGBO(178, 178, 178, 1)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(245, 245, 245, 1),
                                          width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(245, 245, 245, 1),
                                          width: 2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(245, 245, 245, 1),
                                          width: 1.5),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    filterNews(value);
                                  },
                                ),
                              ),
                              //
                              GestureDetector(
                                onTapDown: (TapDownDetails details) {
                                  showNewsMenu(context, details.globalPosition);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/Filter_icon.svg',
                                    fit: BoxFit.contain,
                                    height: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //card section...
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredCircularList.length,
                      itemBuilder: (context, index) {
                        final e = filteredCircularList[index];
                        return Column(
                          children: [
                            //
                            Transform.translate(
                              offset: Offset(0, 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  if (e.status == 'schedule')
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(243, 236, 254, 1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Scheduled For  ${e.onDay} at ${e.onTime}',
                                        style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 10,
                                          color:
                                              Color.fromRGBO(131, 56, 236, 1),
                                        ),
                                      ),
                                    ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.08,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(252, 236, 196, 1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Requested For :',
                                              style: TextStyle(
                                                fontFamily: 'regular',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ${e.requestFor}',
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //
                            Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width *
                                    0.025, // 2.5% of screen width
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.04, // 4% of screen width
                                  ),
                                  child: Column(
                                    children: [
                                      //
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Text(
                                              '${e.headLine}',
                                              style: TextStyle(
                                                  fontFamily: 'semibold',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Divider(
                                          thickness: 1,
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                        ),
                                      ),
                                      //
                                      Transform.translate(
                                        offset: Offset(-5, 0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Html(
                                                data: e.circular,
                                                style: {
                                                  "body": Style(
                                                      fontFamily: 'semibold',
                                                      fontSize: FontSize(16),
                                                      textAlign:
                                                          TextAlign.justify)
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      //
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      //image....
                                      if (e.filePath.isNotEmpty)
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            //image
                                            if (e.filePath == 'image')
                                              SizedBox(
                                                height: 250,
                                                width: double.infinity,
                                                child: Opacity(
                                                  opacity: 0.6,
                                                  child: Image.network(
                                                    e.filePath,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),

                                            //
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent
                                                      .withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              height: 250,
                                              width: double.infinity,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                var imagePath = e.filePath;

                                                if (e.fileType == 'image') {
                                                  _showBottomSheet(
                                                      context, imagePath);
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  'View Image',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'semibold',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      //
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Created On : ${e.onDate}',
                                                  style: TextStyle(
                                                      fontFamily: 'regular',
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(
                                                          138, 138, 138, 1)),
                                                ),
                                                //
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    'Created By : ${e.createdByName}',
                                                    style: TextStyle(
                                                        fontFamily: 'regular',
                                                        fontSize: 12,
                                                        color: Color.fromRGBO(
                                                            138, 138, 138, 1)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    'Time : ${e.onTime}',
                                                    style: TextStyle(
                                                      fontFamily: 'regular',
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(
                                                          138, 138, 138, 1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            //alertdialaog...
                                            if (e.circularStatus == 'declined')
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          content: Text(
                                                            "Do you really want to Delete\n  this News?",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'regular',
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          actions: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        elevation:
                                                                            0,
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .black,
                                                                            width:
                                                                                1)),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'regular'),
                                                                    )),
                                                                //delete......
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                  child:
                                                                      ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: AppTheme
                                                                                  .textFieldborderColor,
                                                                              elevation:
                                                                                  0,
                                                                              side: BorderSide
                                                                                  .none),
                                                                          onPressed:
                                                                              () async {
                                                                            var dcirID =
                                                                                e.id;
                                                                            //
                                                                            Future<void> deletecirular(
                                                                                String id,
                                                                                String rollNumber,
                                                                                String userType) async {
                                                                              String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/DeleteCircular';

                                                                              final Map<String, String> headers = {
                                                                                'Content-Type': 'application/json',
                                                                                'Authorization': 'Bearer $authToken',
                                                                              };
                                                                              final Map<String, String> params = {
                                                                                'Id': dcirID.toString(),
                                                                                'RollNumber': UserSession().rollNumber ?? '',
                                                                                'UserType': UserSession().userType ?? ''
                                                                              };
                                                                              try {
                                                                                final uri = Uri.parse(url).replace(queryParameters: params);

                                                                                final response = await http.delete(uri, headers: headers);

                                                                                print('delete');
                                                                                print(url);

                                                                                if (response.statusCode == 200) {
                                                                                  print('News deleted successfully $dcirID');
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    backgroundColor: Colors.green,
                                                                                    content: Text('Circular deleted successfully'),
                                                                                  ));
                                                                                  //
                                                                                  Navigator.pop(context);
                                                                                  await fetchCircularApproval();
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    backgroundColor: Colors.red,
                                                                                    content: Text('Failed to delete Circular. Status code: ${response.statusCode}'),
                                                                                  ));
                                                                                  print('Failed to delete news. Status code: ${response.statusCode}');
                                                                                }
                                                                              } catch (e) {
                                                                                print('Error: $e');
                                                                              }
                                                                            }

                                                                            print('object');
                                                                            //
                                                                            await deletecirular(
                                                                                dcirID.toString(),
                                                                                UserSession().rollNumber ?? '',
                                                                                UserSession().userType ?? '');
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Delete',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'regular'),
                                                                          )),
                                                                ),
                                                              ],
                                                            )
                                                          ]);
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/delete_icons.svg',
                                                    fit: BoxFit.contain,
                                                    height: 35,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      //
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Divider(
                                          thickness: 1,
                                          color:
                                              Color.fromRGBO(243, 243, 243, 1),
                                        ),
                                      ),
                                      //
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            if (e.circularStatus != 'declined')
                                              DottedBorder(
                                                borderType: BorderType.RRect,
                                                radius: Radius.circular(5),
                                                color: Color.fromRGBO(
                                                    235, 130, 0, 1),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        251, 230, 204, 1),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '|',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'semibold',
                                                          fontSize: 20,
                                                          color: Color.fromRGBO(
                                                              235, 130, 0, 1),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          '${e.circularStatus}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      235,
                                                                      130,
                                                                      0,
                                                                      1)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            //declined button..
                                            if (e.circularStatus == 'declined')
                                              GestureDetector(
                                                onTap: () {
                                                  var decline = e.reason;
                                                  _showBottomSheetView(context,
                                                      decline.toString());
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Text(
                                                    'View Reason',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            Colors.black,
                                                        decorationThickness:
                                                            1.5),
                                                  ),
                                                ),
                                              ),
                                            if (e.circularStatus == 'declined')
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/Close_icon.svg',
                                                        fit: BoxFit.contain,
                                                        height: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Declined',
                                                      style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 14,
                                                          color: Color.fromRGBO(
                                                              255, 0, 0, 1)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),

                //top arrow..
                if (_scrollController.hasClients &&
                    _scrollController.offset > 50)
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_upward_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _scrollController.animateTo(
                              0,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ],
                  )
              ],
            ),
    );
  }

  //
  void _showBottomSheet(BuildContext context, String? imagePath) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Close icon
                Positioned(
                  top: -70,
                  left: MediaQuery.of(context).size.width / 2 - 28,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Color.fromRGBO(19, 19, 19, 0.475),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: imagePath != null
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.contain,
                          )
                        : const Text("No content available"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

///view reason bottomsheet

void _showBottomSheetView(BuildContext context, String reason) {
  TextEditingController reasoncontroller = TextEditingController(text: reason);
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Close icon
              Positioned(
                top: -70,
                left: MediaQuery.of(context).size.width / 2 - 28,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color.fromRGBO(19, 19, 19, 0.475),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Reason',
                                  style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          //
                          TextFormField(
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 14,
                                color: Colors.black),
                            readOnly: true,
                            controller: reasoncontroller,
                            maxLines: 6,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(202, 202, 202, 1),
                                    width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(202, 202, 202, 1),
                                    width: 1),
                              ),
                            ),
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 80),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                            color: Colors.black, width: 1.5)),
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black),
                                )),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          );
        },
      );
    },
  );
}
