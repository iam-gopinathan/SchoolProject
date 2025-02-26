import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/circular_models/Circular_mainpage_model.dart';
import 'package:flutter_application_1/screens/circularPage/create_circularPage.dart';
import 'package:flutter_application_1/screens/circularPage/edit_CircularPage.dart';
import 'package:flutter_application_1/services/Circular_Api/circular_mainPage_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CircularMainpage extends StatefulWidget {
  final bool isswitched;
  const CircularMainpage({super.key, required this.isswitched});

  @override
  State<CircularMainpage> createState() => _CircularMainpageState();
}

class _CircularMainpageState extends State<CircularMainpage> {
  //loading....
  bool isLoading = true;
  TextEditingController searchcontroller = TextEditingController();

  late bool isswitched;

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
              top: -70,
              left: 180,
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

  //show image bottomsheet code end....
  @override
  void initState() {
    super.initState();
    isswitched = widget.isswitched;
    print("Newsmainpage opened with isswitched: $isswitched");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCircular();
    });
    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {}); // Trigger UI update when scroll position changes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  List<CircularResponse> circulars = [];

  List<CircularResponse> filteredCircularList = [];

  Future<List<CircularResponse>> _fetchCircular() async {
    String rollNumber = UserSession().rollNumber ?? '';
    String userType = UserSession().userType ?? '';
    String isMyProject = isswitched ? 'Y' : 'N';
    String date = selectedDate;

    setState(() {
      isLoading = true;
    });

    try {
      List<CircularResponse> fetchedCirculars = await fetchCirculars(
        rollNumber,
        userType,
        isMyProject,
        date,
      );

      setState(() {
        isLoading = false;
        circulars = fetchedCirculars;
        filteredCircularList = fetchedCirculars;
      });

      fetchedCirculars.forEach((circularResponse) {
        print(circularResponse);
      });

      return fetchedCirculars;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching circularsssss: $e');
      return [];
    }
  }

//filter
  void filterPosts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCircularList = List.from(circulars);
      } else {
        filteredCircularList = circulars
            .where((circular) => circular.circulars.any((message) =>
                message.headLine.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  //
  ScrollController _scrollController = ScrollController();
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
                                'Circulars',
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
                                  await _fetchCircular();
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
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'My Projects',
                                style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Switch(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeTrackColor: AppTheme.textFieldborderColor,
                                inactiveTrackColor: Colors.white,
                                inactiveThumbColor: Colors.black,
                                value: isswitched,
                                onChanged: (value) {
                                  setState(() {
                                    isswitched = value;
                                    print(isswitched);
                                  });
                                  _fetchCircular();
                                },
                              ),
                            ],
                          ),
                        ),
                      //create mesages screen....
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateCircularpage(
                                    fetchcircular: _fetchCircular,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.Addiconcolor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 30,
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
          : circulars.isEmpty
              ? Center(
                  child: Text(
                    "You haven’t made anything yet;\nstart creating now!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'regular',
                      color: Color.fromRGBO(145, 145, 145, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            //search container...
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    controller: searchcontroller,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        prefixIcon: Transform.translate(
                                          offset: Offset(75, 0),
                                          child: Icon(Icons.search,
                                              color: Color.fromRGBO(
                                                  178, 178, 178, 1)),
                                        ),
                                        hintText: 'Search News by Heading',
                                        hintStyle: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 14,
                                            color: Color.fromRGBO(
                                                178, 178, 178, 1)),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  245, 245, 245, 1),
                                              width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  245, 245, 245, 1),
                                              width: 2),
                                        )),
                                    onChanged: (value) {
                                      filterPosts(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: filteredCircularList.length,
                          itemBuilder: (context, index) {
                            final circular = filteredCircularList[index];
                            return Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.04,
                              ),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: circular.circulars.length,
                                      itemBuilder: (context, index) {
                                        final circularModel =
                                            circular.circulars[index];
                                        return Column(
                                          children: [
                                            ///postedon code....
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                              ),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.015,
                                                          top: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                        ),
                                                        child: Text(
                                                          'Posted on : ${circular.postedOnDate} | ${circular.postedOnDay}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      //updatedon
                                                      if (circularModel
                                                              .updatedOn !=
                                                          null)
                                                        Transform.translate(
                                                          offset: Offset(0, 6),
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      251,
                                                                      245,
                                                                      1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Updated on ${circularModel.updatedOn}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'medium',
                                                                fontSize: 10,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        49,
                                                                        49,
                                                                        49,
                                                                        1),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  //today tag...
                                                  if (circular.tag.isNotEmpty)
                                                    Transform.translate(
                                                      offset: Offset(50, 6),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        20),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                              color: AppTheme
                                                                  .textFieldborderColor,
                                                            ),
                                                            child: Text(
                                                              '${circular.tag}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'medium',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
//
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              elevation: 0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                padding: EdgeInsets.all(15),
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //heading.....
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: Text(
                                                        '${circularModel.headLine}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'semibold',
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    //
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Color.fromRGBO(
                                                            243, 243, 243, 1),
                                                      ),
                                                    ),
//description..
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: circularModel
                                                                      .circular !=
                                                                  null &&
                                                              circularModel
                                                                  .circular!
                                                                  .isNotEmpty
                                                          ? Html(
                                                              data:
                                                                  '${circularModel.circular}',
                                                              style: {
                                                                "body": Style(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              },
                                                            )
                                                          : const Text(''),
                                                    ),
                                                    //image section...
                                                    if (circularModel
                                                            .fileType ==
                                                        'image')
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          //
                                                          SizedBox(
                                                            height: 250,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                Image.network(
                                                              '${circularModel.filePath}',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            height: 250,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                          // Centered Text
                                                          Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                String?
                                                                    imagePath =
                                                                    circularModel
                                                                        .filePath;
                                                                if (imagePath !=
                                                                        null &&
                                                                    imagePath
                                                                        .isNotEmpty) {
                                                                  _showBottomSheet(
                                                                      context,
                                                                      imagePath);
                                                                } else {
                                                                  _showBottomSheet(
                                                                      context,
                                                                      'assets/images/default_image.png');
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .transparent,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                ),
                                                                child: Text(
                                                                  'View Image',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'semibold',
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
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Color.fromRGBO(
                                                            243, 243, 243, 1),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Posted by : ${circularModel.name}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'regular',
                                                                    fontSize:
                                                                        12,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            138,
                                                                            138,
                                                                            138,
                                                                            1)),
                                                              ),
                                                              Text(
                                                                'Time : ${circularModel.time}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'regular',
                                                                    fontSize:
                                                                        12,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            138,
                                                                            138,
                                                                            138,
                                                                            1)),
                                                              )
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          if (UserSession()
                                                                      .userType ==
                                                                  'admin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'superadmin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'staff')
                                                            if (circularModel
                                                                        .isAlterAvailable ==
                                                                    "Y" ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'superadmin')
                                                              //edit
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                    barrierDismissible:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        content:
                                                                            Text(
                                                                          "Do you really want to make\n changes to this message?",
                                                                          style: TextStyle(
                                                                              fontFamily: 'regular',
                                                                              fontSize: 16,
                                                                              color: Colors.black),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        actions: <Widget>[
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, side: BorderSide(color: Colors.black, width: 1)),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                  )),
                                                                              //edit...
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      padding: EdgeInsets.symmetric(horizontal: 40),
                                                                                      backgroundColor: AppTheme.textFieldborderColor,
                                                                                      elevation: 0,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) => EditCircularpage(
                                                                                                    Id: circularModel.id,
                                                                                                    fetchcircular: _fetchCircular,
                                                                                                  )));
                                                                                    },
                                                                                    child: Text(
                                                                                      'Edit',
                                                                                      style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
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
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            15),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.black)),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons
                                                                            .edit),
                                                                        Text(
                                                                          'Edit',
                                                                          style: TextStyle(
                                                                              fontFamily: 'medium',
                                                                              fontSize: 12,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          //delete icon
                                                          if (UserSession()
                                                                      .userType ==
                                                                  'admin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'superadmin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'staff')
                                                            if (circularModel
                                                                        .isAlterAvailable ==
                                                                    'Y' ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'superadmin')
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                    barrierDismissible:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        content:
                                                                            Text(
                                                                          "Are you sure you want to delete\n this item?",
                                                                          style: TextStyle(
                                                                              fontFamily: 'regular',
                                                                              fontSize: 16,
                                                                              color: Colors.black),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        actions: <Widget>[
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, side: BorderSide(color: Colors.black, width: 1)),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                  )),
                                                                              //delete......
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                                                                    backgroundColor: AppTheme.textFieldborderColor,
                                                                                    elevation: 0,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    var cirId = circularModel.id;
                                                                                    final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/DeleteCircular?Id=${cirId}&RollNumber=${UserSession().rollNumber}&UserType=${UserSession().userType}';

                                                                                    try {
                                                                                      final response = await http.delete(
                                                                                        Uri.parse(url),
                                                                                        headers: {
                                                                                          'Content-Type': 'application/json',
                                                                                          'Authorization': 'Bearer $authToken',
                                                                                        },
                                                                                      );

                                                                                      if (response.statusCode == 200) {
                                                                                        print('id has beeen deleted ${cirId}');

                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.green, content: Text('Circular deleted successfully!')),
                                                                                        );
                                                                                        //
                                                                                        // Refresh the news data after deletion
                                                                                        Navigator.pop(context);

                                                                                        //
                                                                                        await _fetchCircular();
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete Circular.')),
                                                                                        );
                                                                                      }
                                                                                    } catch (e) {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text('An error occurred: $e')),
                                                                                      );
                                                                                    }
                                                                                    await _fetchCircular();

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Delete',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
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
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/icons/delete_icons.svg',
                                                                    fit: BoxFit
                                                                        .contain,
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
                                          ],
                                        );
                                      }),
                                  //
                                ],
                              ),
                            );
                          }),
                    ),
                    //
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
}
