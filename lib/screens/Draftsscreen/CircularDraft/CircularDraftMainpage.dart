import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/DraftModels/Circular_fetch_draft_model.dart';
import 'package:flutter_application_1/services/Draft_Api/Circular_fetch_draft_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Circulardraftmainpage extends StatefulWidget {
  const Circulardraftmainpage({super.key});

  @override
  State<Circulardraftmainpage> createState() => _CirculardraftmainpageState();
}

class _CirculardraftmainpageState extends State<Circulardraftmainpage> {
  //
  //select date
  String selectedDate = '';
  var displayDate = '';
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

  ///image bottomsheeet.....
  void _showBottomSheet(BuildContext context, String imagePath) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Stack(clipBehavior: Clip.none, children: [
            // Close icon
            Positioned(
              top: MediaQuery.of(context).size.height *
                  -0.08, // Adjust -70 dynamically
              left: MediaQuery.of(context).size.width * 0.45,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
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
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network(
                      '${imagePath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ]);
        });
      },
    );
  }

  bool isLoading = true;

  CircularFetchDraftModel? circularDraftData;
  final ApiService apiService = ApiService();
  //
  Future<void> _fetchDraftCircular() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await apiService.fetchDraftCirculars(
        rollNumber: UserSession().rollNumber.toString(),
        userType: UserSession().userType.toString(),
        date: selectedDate,
      );

      if (response != null) {
        setState(() {
          circularDraftData = response;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchDraftCircular();
  }

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
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
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
                                'Circulars Draft',
                                style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.007,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _selectDate(context);

                                  setState(() {
                                    isLoading = true;
                                  });
                                  await _fetchDraftCircular();
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
                      Spacer(),
                      //
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            //
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  content: Text(
                                    "Are you sure you want to delete\n all drafts you have created?",
                                    style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 16,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                elevation: 0,
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 1)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'regular'),
                                            )),
                                        //delete...
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                          ),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 40),
                                                backgroundColor: AppTheme
                                                    .textFieldborderColor,
                                                elevation: 0,
                                              ),
                                              onPressed: () async {
                                                //
                                                Future<void> deleteAllDraft(
                                                    {required String rollNumber,
                                                    required String
                                                        module}) async {
                                                  // API Endpoint
                                                  String url =
                                                      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeNews/DeleteAllDraft";

                                                  // Parameters
                                                  final Map<String, String>
                                                      queryParams = {
                                                    "RollNumber": UserSession()
                                                            .rollNumber ??
                                                        '',
                                                    "Module": 'circular',
                                                  };

                                                  // Construct the final URL with query parameters
                                                  final Uri uri = Uri.parse(url)
                                                      .replace(
                                                          queryParameters:
                                                              queryParams);

                                                  try {
                                                    final response =
                                                        await http.delete(
                                                      uri,
                                                      headers: {
                                                        "Authorization":
                                                            "Bearer $authToken",
                                                        "Content-Type":
                                                            "application/json",
                                                      },
                                                    );

                                                    if (response.statusCode ==
                                                        200) {
                                                      print(
                                                          "Response Status Code: ${response.statusCode}");
                                                      print(
                                                          "Response Body: ${response.body}");
                                                      // Show success Snackbar
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Draft Circular deleted successfully!"),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                      print(
                                                          "Draft Circular deleted successfully!");
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Failed to delete draft Circular. Try again."),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      print(
                                                          "Failed to delete draft Circular. Status: ${response.statusCode}");
                                                      print(
                                                          "Response: ${response.body}");
                                                    }
                                                  } catch (e) {
                                                    // Show error Snackbar
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Error deleting draft news: $e"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    print(
                                                        "Error deleting draft news: $e");
                                                  }
                                                }

                                                //
                                                await deleteAllDraft(
                                                    rollNumber: UserSession()
                                                        .rollNumber
                                                        .toString(),
                                                    module: 'circular');

                                                await _fetchDraftCircular();

                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'regular'),
                                              )),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Text(
                                    'Delete All',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 10,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
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
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppTheme.textFieldborderColor,
            ))
          : circularDraftData == null ||
                  circularDraftData!.data == null ||
                  circularDraftData!.data!.isEmpty
              ? Center(
                  child: Text(
                    "No draft circular available!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'regular',
                      color: Color.fromRGBO(145, 145, 145, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ...circularDraftData!.data!.map((e) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.07,
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Drafted on : ${e.postedOnDate} | ${e.postedOnDay}',
                                    style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 12,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            //
                            ...e.circular!.map((cir) {
                              return Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: EdgeInsets.all(15),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //heading.....
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            '${cir.headLine}',
                                            style: TextStyle(
                                                fontFamily: 'semibold',
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                        //
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Divider(
                                            thickness: 1,
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                          ),
                                        ),
                                        //description..
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: cir.circular != null &&
                                                  cir.circular!.isNotEmpty
                                              ? Html(
                                                  data: '${cir.circular}',
                                                  style: {
                                                    "body": Style(
                                                        color: Colors.black,
                                                        fontFamily: 'semibold',
                                                        fontSize: FontSize(16),
                                                        textAlign:
                                                            TextAlign.justify),
                                                  },
                                                )
                                              : const Text(''),
                                        ),
                                        //image section...
                                        if (cir.fileType == 'image')
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              //
                                              SizedBox(
                                                height: 250,
                                                width: double.infinity,
                                                child: Image.network(
                                                  '${cir.filePath}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                height: 250,
                                                width: double.infinity,
                                              ),
                                              // Centered Text
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    String? imagePath =
                                                        cir.filePath;
                                                    if (imagePath != null &&
                                                        imagePath.isNotEmpty) {
                                                      _showBottomSheet(
                                                          context, imagePath);
                                                    }
                                                    //  else {
                                                    //   _showBottomSheet(context,
                                                    //       'assets/images/default_image.png');
                                                    // }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
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
                                              ),
                                            ],
                                          ),
                                        ////
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Divider(
                                            thickness: 1,
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              //edit
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
                                                          "Do you really want to make\n changes to this circular?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                              //edit...
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 40),
                                                                          backgroundColor:
                                                                              AppTheme.textFieldborderColor,
                                                                          elevation:
                                                                              0,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          // Navigator.push(
                                                                          //     context,
                                                                          //     MaterialPageRoute(
                                                                          //         builder: (context) =>
                                                                          //             EditCircularpage(
                                                                          //               Id: circularModel
                                                                          //                   .id,
                                                                          //               fetchcircular:
                                                                          //                   _fetchCircular,
                                                                          //             )));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Edit',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'regular'),
                                                                        )),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 15),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        ),
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'medium',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //delete icon
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
                                                          "Are you sure you want to delete\n this circular?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            40),
                                                                    backgroundColor:
                                                                        AppTheme
                                                                            .textFieldborderColor,
                                                                    elevation:
                                                                        0,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    var cirId =
                                                                        cir.id;
                                                                    final String
                                                                        url =
                                                                        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/DeleteCircular?Id=${cirId}&RollNumber=${UserSession().rollNumber}&UserType=${UserSession().userType}';

                                                                    try {
                                                                      final response =
                                                                          await http
                                                                              .delete(
                                                                        Uri.parse(
                                                                            url),
                                                                        headers: {
                                                                          'Content-Type':
                                                                              'application/json',
                                                                          'Authorization':
                                                                              'Bearer $authToken',
                                                                        },
                                                                      );

                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        print(
                                                                            'id has beeen deleted ${cirId}');

                                                                        // ScaffoldMessenger.of(context).showSnackBar(
                                                                        //   SnackBar(backgroundColor: Colors.green, content: Text('Circular deleted successfully!')),
                                                                        // );
                                                                        // //
                                                                        // // Refresh the news data after deletion
                                                                        // Navigator.pop(context);

                                                                        // //
                                                                        // await _fetchCircular();
                                                                        if (mounted) {
                                                                          String
                                                                              message =
                                                                              'Circular deleted successfully!';

                                                                          // If user is admin or staff, change the message

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                                backgroundColor: Colors.green,
                                                                                content: Text(message)),
                                                                          );
                                                                        }

                                                                        Navigator.pop(
                                                                            context); // Close the dialog
                                                                        await _fetchDraftCircular(); // Refresh the data
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                              backgroundColor: Colors.red,
                                                                              content: Text('Failed to delete Circular.')),
                                                                        );
                                                                      }
                                                                    } catch (e) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                            content:
                                                                                Text('An error occurred: $e')),
                                                                      );
                                                                    }
                                                                    await _fetchDraftCircular();

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'regular'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/delete_icons.svg',
                                                    fit: BoxFit.contain,
                                                    height: 35,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
