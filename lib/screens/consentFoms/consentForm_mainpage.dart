import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/ConsentForm/Consentform_main_model.dart';
import 'package:flutter_application_1/screens/consentFoms/Create_consentFormPage.dart';
import 'package:flutter_application_1/screens/consentFoms/Received_consentForm.dart';
import 'package:flutter_application_1/services/ConsentForm/Consent_form_main_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class ConsentformMainpage extends StatefulWidget {
  const ConsentformMainpage({super.key});

  @override
  State<ConsentformMainpage> createState() => _ConsentformMainpageState();
}

class _ConsentformMainpageState extends State<ConsentformMainpage> {
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  final GradeController gradeController = Get.put(GradeController());

  //
  Map<String, bool> _expandedQuestions = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  bool isswitched = false;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gradeController.fetchGrades();
    _fetchconsentform();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {});
  }

  @override

  //fetchdata..
  Future<void> _fetchconsentform(
      {String grade = '131', String section = "A1", String date = ''}) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await fetchConsentData(
          rollNumber: UserSession().rollNumber ?? '',
          userType: UserSession().userType ?? '',
          isMyProject: isswitched ? 'Y' : 'N',
          date: date);

      setState(() {
        isLoading = false;
        consentData = response.data;
      });
    } catch (error) {
      print('Error fetching consent data: $error');
    }
  }

  List<ConsentData> consentData = [];

  void _showFilterBottomSheet(BuildContext context) {
    String selectedGrade = '';
    List<String> sections = [];
    String selectedSection = '';
    final gradeController = Get.find<GradeController>();

    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
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
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Select Class and Section',
                                style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                // Select Class
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 30, left: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Select Class',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'regular',
                                          color: Color.fromRGBO(53, 53, 53, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Classes
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        gradeController.gradeList.length,
                                        (index) {
                                          var grade =
                                              gradeController.gradeList[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedGrade =
                                                      grade['id'].toString();
                                                  sections = List<String>.from(
                                                      grade['sections'] ?? []);
                                                });
                                              },
                                              child: Container(
                                                width: 100,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: selectedGrade ==
                                                          grade['id'].toString()
                                                      ? AppTheme
                                                          .textFieldborderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        223, 223, 223, 1),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    grade['sign'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Select Section
                                if (sections.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Select Section',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'regular',
                                            color:
                                                Color.fromRGBO(53, 53, 53, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(sections.length,
                                            (index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedSection =
                                                      sections[index];
                                                });
                                              },
                                              child: Container(
                                                width: 100,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: selectedSection ==
                                                          sections[index]
                                                      ? AppTheme
                                                          .textFieldborderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        223, 223, 223, 1),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    sections[index],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.textFieldborderColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontFamily: 'semibold',
                                    fontSize: 16,
                                    color: Colors.black,
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
              ],
            );
          },
        );
      },
    );
  }
  //

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
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.025,
            ),
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Consent Form',
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
                                  await _fetchconsentform(date: selectedDate);
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
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                              right:
                                  MediaQuery.of(context).size.width * 0.0833),
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
                                activeColor: Colors.white,
                                onChanged: (value) {
                                  setState(() {
                                    isswitched = value;
                                    isLoading = true;
                                  });
                                  _fetchconsentform();
                                },
                              ),
                            ],
                          ),
                        ),

                      //
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                              right:
                                  MediaQuery.of(context).size.width * 0.0500),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateConsentformpage(
                                            fetch: _fetchconsentform,
                                          )));
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
                color: AppTheme.textFieldborderColor,
                strokeWidth: 4,
              ),
            )
          : consentData.isEmpty
              ? (UserSession().userType == 'student' ||
                      UserSession().userType == 'teacher')
                  ? Center(
                      child: Text(
                        "No messages from the school yet. Stay tuned for updates!",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'regular',
                          color: Color.fromRGBO(145, 145, 145, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Center(
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
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      //recieved..
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.04,
                            top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReceivedConsentform(
                                              fetch: _fetchconsentform,
                                            )));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromRGBO(251, 247, 245, 1)),
                                child: Row(
                                  children: [
                                    Text(
                                      '•',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'medium',
                                          color: Color.fromRGBO(216, 70, 0, 1)),
                                    ),
                                    Text(
                                      'Received',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'medium',
                                          color:
                                              Color.fromRGBO(217, 78, 11, 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //card sections..
                      Column(
                        children: [
                          ...consentData.map((e) {
                            return Column(
                              children: [
                                //postedon date...
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05, // 5% of screen width
                                    top: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Posted on : ${e.postedOnDate} | ${e.postedOnDay}',
                                        style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                      if (e.tag.isNotEmpty)
                                        Transform.translate(
                                          offset: Offset(57, 16),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: AppTheme
                                                    .textFieldborderColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            child: Text(
                                              '${e.tag}',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                ...e.consentForm.map((consent) {
                                  TextPainter textPainter = TextPainter(
                                    text: TextSpan(
                                      text: consent.question,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'medium',
                                        color: Colors.white,
                                      ),
                                    ),
                                    maxLines: 4,
                                    textDirection: ui.TextDirection.ltr,
                                  )..layout(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.8);

                                  //
                                  bool showReadMore =
                                      textPainter.didExceedMaxLines;

//
                                  bool isExpanded =
                                      _expandedQuestions[consent.question] ??
                                          false;
                                  return Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    238, 238, 238, 1),
                                                width: 1.5)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //heading
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      '${consent.heading}',
                                                      style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: Color.fromRGBO(
                                                  230, 230, 230, 1),
                                              thickness: 1,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Text(
                                                      '${consent.question}',
                                                      style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                      maxLines:
                                                          isExpanded ? null : 4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //readmore button...
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 5),
                                              child: Row(
                                                children: [
                                                  if (showReadMore)
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          backgroundColor:
                                                              Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _expandedQuestions[
                                                                    consent
                                                                        .question] =
                                                                !isExpanded;
                                                          });
                                                        },
                                                        child: Text(
                                                          isExpanded
                                                              ? 'Read Less'
                                                              : 'Read More',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  Spacer(),
                                                  //delete
                                                  if (UserSession().userType ==
                                                          'admin' ||
                                                      UserSession().userType ==
                                                          'superadmin' ||
                                                      UserSession().userType ==
                                                          'staff')
                                                    GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  content: Text(
                                                                    "Are you sure you want to delete\n  this Consent Question?",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'regular',
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
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
                                                                          //delete...
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                onPressed: () async {
                                                                                  var consentDel = consent.questionId;
                                                                                  final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/Consent/DeleteConsentForm?Id=$consentDel';

                                                                                  try {
                                                                                    final response = await http.delete(
                                                                                      Uri.parse(url),
                                                                                      headers: {
                                                                                        'Content-Type': 'application/json',
                                                                                        'Authorization': 'Bearer $authToken',
                                                                                      },
                                                                                    );

                                                                                    if (response.statusCode == 200) {
                                                                                      print('id has beeen deleted ${consentDel}');

                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(backgroundColor: Colors.green, content: Text('Consent Form deleted successfully!')),
                                                                                      );
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete ConsentForm.')),
                                                                                      );
                                                                                    }
                                                                                  } catch (e) {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(content: Text('An error occurred: $e')),
                                                                                    );
                                                                                  }
                                                                                  _fetchconsentform();

                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text(
                                                                                  'Delete',
                                                                                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                )),
                                                                          ),
                                                                        ])
                                                                  ]);
                                                            });
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/icons/timetable_delete.svg',
                                                        fit: BoxFit.contain,
                                                        height: 25,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      //
                    ],
                  ),
                ),
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 50
              ? Transform.translate(
                  offset: Offset(0, -20),
                  child: Container(
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
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
