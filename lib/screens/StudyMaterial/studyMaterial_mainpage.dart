import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/StudyMaterial/StudyMaterial_MainPage_model.dart';
import 'package:flutter_application_1/screens/StudyMaterial/Create_studyMaterial.dart';
import 'package:flutter_application_1/screens/StudyMaterial/Edit_StudymaterialPage.dart';
import 'package:flutter_application_1/services/StudyMaterial/StudyMaterial_mainPage_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StudymaterialMainpage extends StatefulWidget {
  const StudymaterialMainpage({super.key});

  @override
  State<StudymaterialMainpage> createState() => _StudymaterialMainpageState();
}

class _StudymaterialMainpageState extends State<StudymaterialMainpage> {
  final GradeController gradeController = Get.put(GradeController());
  ScrollController _scrollController = ScrollController();

  Future<List<StudyMaterialModel>>? futureStudyMaterials;

  int initiallyExpandedIndex = 0;
  bool isswitched = false;

  bool isloading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudyMaterial();
    gradeController.fetchGrades();
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

  Future<void> _fetchStudyMaterial(
      {String grade = '131',
      String section = "A1",
      String date = '',
      String subject = ''}) async {
    try {
      setState(() {
        isloading = true;
      });

      final int gradeInt = int.parse(grade);
      final response = await fetchStudyMaterials(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        grade: gradeInt,
        section: section,
        date: date,
        isMyProject: isswitched ? 'Y' : 'N',
        subject: subject,
      );
      print("Fetching homework with date: $date");
      print('gradId: $grade');
      print("Fetching study materials for:");
      print("Grade: $gradeInt, Section: $section");
      print("API Response: $response");
      final List<StudyMaterialModel> studyMaterials = response;

      setState(() {
        isloading = false;
        this.studyMaterials = studyMaterials;
        print('Fetching study materials with grade: $grade, section: $section');
      });
    } catch (error) {
      setState(() {
        isloading = false;
      });
      print("Error fetching study materials: $error");
    }
  }

  List<StudyMaterialModel> studyMaterials = [];

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
      displayDate = DateFormat('EE, dd MMMM').format(pickedDate);
    }
  }
  //selected date end

//filter bottomsheet..
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
                  height: MediaQuery.of(context).size.height * 0.5,
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
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: Card(
                          elevation: 0,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                // Select Class
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04, // 4% of screen width
                                    top: MediaQuery.of(context).size.height *
                                        0.006,
                                  ),
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
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.025,
                                  ),
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
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.04, // 4% of screen height
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
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
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.035,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.textFieldborderColor,
                              ),
                              onPressed: () {
                                print("Selected Grade: $selectedGrade");
                                print("Selected Section: $selectedSection");
                                _fetchStudyMaterial(
                                    grade: selectedGrade,
                                    section: selectedSection);
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
  String? _selectedSubject;
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Study Materials',
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

                                  if (selectedDate.isNotEmpty) {
                                    print("Selected Date: $selectedDate");
                                    _fetchStudyMaterial(date: selectedDate);
                                  } else {
                                    print("No date selected");
                                  }
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
                          UserSession().userType == 'teacher' ||
                          UserSession().userType == 'staff' ||
                          UserSession().userType == 'superadmin')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.04,
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
                                activeColor: Colors.white,
                                onChanged: (value) {
                                  setState(() {
                                    isloading = true;
                                    isswitched = value;
                                    print("Switch value changed: $isswitched");
                                  });
                                  _fetchStudyMaterial();
                                },
                              ),
                            ],
                          ),
                        ),
                      //filter icon..
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'teacher' ||
                          UserSession().userType == 'staff' ||
                          UserSession().userType == 'superadmin')
                        GestureDetector(
                          onTap: () {
                            _showFilterBottomSheet(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/Filter_icon.svg',
                              fit: BoxFit.contain,
                              height: 30,
                            ),
                          ),
                        ),
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'teacher' ||
                          UserSession().userType == 'staff' ||
                          UserSession().userType == 'superadmin')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateStudymaterial(
                                          fetchstudymaterial:
                                              _fetchStudyMaterial)));
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
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppTheme.textFieldborderColor,
            ))
          : studyMaterials.isEmpty
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
                        "You haven’t made anything yet \n start creating now!",
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            int selectedGradeId = 131;
                            //filter subject wise
                            Get.find<GradeController>()
                                .filterSubjectsByGrade(131);
                            showMenu(
                              context: context,
                              color: Colors.black,
                              position: RelativeRect.fromLTRB(100, 180, 0, 0),
                              items: Get.find<GradeController>()
                                  .filteredSubjects
                                  .map((subject) {
                                return PopupMenuItem<String>(
                                  value: subject,
                                  child: Text(
                                    subject,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: _selectedSubject == subject
                                            ? AppTheme.textFieldborderColor
                                            : Colors.white,
                                        fontFamily: 'regular'),
                                  ),
                                );
                              }).toList(),
                              elevation: 8.0,
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  _selectedSubject = value;
                                });
                                print('Selected subject: $value');
                              }
                              _fetchStudyMaterial(subject: value!);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.06,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //
                                if (UserSession().userType != 'student')
                                  SvgPicture.asset(
                                    'assets/icons/Filter_icon.svg',
                                    fit: BoxFit.contain,
                                    height: 20,
                                  ),
                                if (UserSession().userType != 'student')
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.012,
                                    ),
                                    child: Text(
                                      'by Subjects',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 12,
                                          color: Color.fromRGBO(47, 47, 47, 1)),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          ...studyMaterials.map((e) {
                            int index = studyMaterials.indexOf(e);
                            return Column(
                              children: [
                                //
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.025, // 2.5% of screen width
                                  ),
                                  child: Row(
                                    children: [
                                      //
                                      if (UserSession().userType != 'student')
                                        Transform.translate(
                                          offset: Offset(20, 16),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 10),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          48, 126, 185, 1),
                                                      Color.fromRGBO(
                                                          0, 70, 123, 1),
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                )),
                                            child: Text(
                                              '${e.gradeSection}',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      //
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.03, // 3% of screen width
                                  ),
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
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04, // 4% of screen width
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.006, // 0.6% of screen height
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Posted on: ${e.postedOn} | ${e.day}',
                                                  style: TextStyle(
                                                      fontFamily: 'regular',
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (e.updatedOn.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, top: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Updated on : ${e.updatedOn}',
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            49, 49, 49, 1),
                                                        fontFamily: 'medium',
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ExpansionTile(
                                            initiallyExpanded:
                                                initiallyExpandedIndex == index,
                                            shape: Border(),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${e.subject}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                ),
                                                //
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${e.heading}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Spacer(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            children: [
                                              //image section...
                                              if (e.fileType.isNotEmpty)
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // if (e.fileType == 'image')
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent
                                                              .withOpacity(
                                                                  0.6)),
                                                      child: Image.network(
                                                        e.filePath,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 250,
                                                      ),
                                                    ),
                                                    // PDF SECTION
                                                    // if (e.fileType == 'pdf')
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 250,
                                                          color: Colors
                                                              .transparent
                                                              .withOpacity(0.7),
                                                        ),
                                                        // PDF Viewer
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 250,
                                                          child: PDF(
                                                            swipeHorizontal:
                                                                false,
                                                            fitEachPage: true,
                                                            enableSwipe: false,
                                                            autoSpacing: false,
                                                            pageFling: false,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent
                                                                    .withOpacity(
                                                                        0.1),
                                                            onError: (error) {
                                                              print(error
                                                                  .toString());
                                                            },
                                                            onPageError:
                                                                (page, error) {
                                                              print(
                                                                  '$page: ${error.toString()}');
                                                            },
                                                          ).cachedFromUrl(
                                                              e.filePath),
                                                        ),
                                                      ],
                                                    ),
                                                    // VIEW BUTTON
                                                    Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (e.fileType ==
                                                              'image') {
                                                            _showBottomSheets(
                                                                context,
                                                                e.filePath,
                                                                null);
                                                          } else {
                                                            _showBottomSheets(
                                                                context,
                                                                null,
                                                                e.filePath);
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 7),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .transparent
                                                                .withOpacity(
                                                                    0.3),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          child: Text(
                                                            e.fileType ==
                                                                    'image'
                                                                ? 'View Image'
                                                                : e.fileType ==
                                                                        'pdf'
                                                                    ? 'View PDF'
                                                                    : 'Unknown File Type',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'semibold',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (UserSession()
                                                                .userType !=
                                                            'student')
                                                          if (e.postedBy
                                                              .isNotEmpty)
                                                            Text(
                                                              'Posted by : ${e.postedBy}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          138,
                                                                          138,
                                                                          138,
                                                                          1)),
                                                            ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    if (UserSession().userType == 'admin' ||
                                                        UserSession()
                                                                .userType ==
                                                            'teacher' ||
                                                        UserSession()
                                                                .userType ==
                                                            'staff' ||
                                                        UserSession()
                                                                .userType ==
                                                            'superadmin')
                                                      // if (e.isAlterAvailable ==
                                                      //     'Y')
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
                                                                    content:
                                                                        Text(
                                                                      "Do you really want to make\n changes to this StudyMaterial?",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'regular',
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
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
                                                                            //edit...
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (context) => EditStudymaterialpage(
                                                                                                  id: e.id,
                                                                                                  fetchstudymaterial: _fetchStudyMaterial,
                                                                                                )));
                                                                                  },
                                                                                  child: Text(
                                                                                    'Edit',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                  )),
                                                                            ),
                                                                          ])
                                                                    ]);
                                                              });
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      8),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black)),
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  'assets/icons/timetable_upload.svg'),
                                                              Text(
                                                                'Reupload',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'medium',
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    if (UserSession().userType == 'admin' ||
                                                        UserSession()
                                                                .userType ==
                                                            'teacher' ||
                                                        UserSession()
                                                                .userType ==
                                                            'staff' ||
                                                        UserSession()
                                                                .userType ==
                                                            'superadmin')
                                                      // if (e.isAlterAvailable ==
                                                      //     'Y')
                                                      //delete icon
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
                                                                    content:
                                                                        Text(
                                                                      "Are you sure you want to delete\n this StudyMaterial?",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'regular',
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
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
                                                                            //edit...
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                  onPressed: () async {
                                                                                    var studydelete = e.id;
                                                                                    final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeStudyMaterial/DeleteStudyMaterial?Id=$studydelete';

                                                                                    try {
                                                                                      final response = await http.delete(
                                                                                        Uri.parse(url),
                                                                                        headers: {
                                                                                          'Content-Type': 'application/json',
                                                                                          'Authorization': 'Bearer $authToken',
                                                                                        },
                                                                                      );

                                                                                      if (response.statusCode == 200) {
                                                                                        print('id has beeen deleted ${studydelete}');

                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.green, content: Text('Studymaterial deleted successfully!')),
                                                                                        );
                                                                                        //
                                                                                        Navigator.pop(context);
                                                                                        //
                                                                                        await _fetchStudyMaterial();
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete .')),
                                                                                        );
                                                                                      }
                                                                                    } catch (e) {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text('An error occurred: $e')),
                                                                                      );
                                                                                    }
                                                                                    _fetchStudyMaterial();
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
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/timetable_delete.svg',
                                                            fit: BoxFit.contain,
                                                            height: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    //
                                                    if (UserSession()
                                                            .userType ==
                                                        'student')
                                                      //download
                                                      if (UserSession()
                                                              .userType ==
                                                          'student')
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (e.filePath
                                                                .isNotEmpty) {
                                                              await downloadFile(
                                                                  e.filePath);
                                                            } else {
                                                              print(
                                                                  "Invalid file path");
                                                            }
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        20),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        1.5)),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  'assets/icons/Dwnl_icon.svg',
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 20,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    'Download',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'medium',
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
      //top arrow..
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 50
              ? Container(
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
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //download bottomsheeet...
  void _showBottomSheet(
      BuildContext context, String? imagePath, String? pdf) async {
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        imagePath != null
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.contain,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * 5,
                                    child: Transform.translate(
                                      offset: Offset(0, -200),
                                      child: PDF(
                                        swipeHorizontal: false,
                                        fitEachPage: true,
                                        enableSwipe: true,
                                        autoSpacing: false,
                                        pageFling: false,
                                        backgroundColor: Colors.white,
                                        onError: (error) {
                                          print(error.toString());
                                        },
                                        onPageError: (page, error) {
                                          print('$page: ${error.toString()}');
                                        },
                                      ).cachedFromUrl(pdf.toString()),
                                    ),
                                  ),
                                ],
                              ),
                        //dwnl
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.textFieldborderColor),
                          onPressed: () {
                            downloadFile(pdf != null
                                ? pdf.toString()
                                : imagePath.toString());
                          },
                          child: Text(
                            'Download',
                            style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

//show image bottomsheet code end....
  // Future<void> downloadImage(String imageUrl) async {
  //   try {
  //     final directory = await getExternalStorageDirectory();
  //     if (directory == null) {
  //       print("Failed to get external storage directory.");
  //       return;
  //     }
  //     final downloadsDirectory = Directory('/storage/emulated/0/Download');
  //     if (!await downloadsDirectory.exists()) {
  //       await downloadsDirectory.create(recursive: true);
  //     }
  //     final filePath =
  //         '${downloadsDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //     final response = await http.get(Uri.parse(imageUrl));
  //     if (response.statusCode == 200) {
  //       File file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //       print('Image downloaded to: $filePath');
  //       showDownloadNotification(filePath);
  //     } else {
  //       print('Failed to download image');
  //     }
  //   } catch (e) {
  //     print('Error occurred while downloading image: $e');
  //   }
  // }

  Future<void> downloadFile(String fileUrl) async {
    try {
      //
      await requestStoragePermission();
      //
      // final directory = await getExternalStorageDirectory();
      // if (directory == null) {
      //   print("Failed to get external storage directory.");
      //   return;
      // }
      // Step 2: Get storage directory
      final directory = await getDownloadDirectory();
      if (directory == null) {
        print("⚠️ Failed to get storage directory.");
        return;
      }

      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      // Determine file type based on the URL
      String extension = fileUrl.split('.').last.toLowerCase();
      String fileType =
          (extension == 'jpg' || extension == 'png' || extension == 'jpeg')
              ? 'image'
              : 'pdf';
      String filePath =
          '${downloadsDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.$extension';

      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('$fileType downloaded to: $filePath');
        showDownloadNotification(filePath);
        await Future.delayed(Duration(seconds: 3));
        openFile(filePath);
      } else {
        print('Failed to download $fileType');
      }
    } catch (e) {
      print('Error occurred while downloading file: $e');
    }
  }

// Function to show download notification
  void showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Notifications related to downloads',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      10,
      'Download Complete',
      'Image downloaded successfully to $filePath',
      platformDetails,
      payload: filePath,
    );
  }

//
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print("Notification clicked! Opening file: ${response.payload}");
          openFile(response.payload!);
        } else {
          print("Notification clicked, but no payload received.");
        }
      },
    );
  }

//
  void openFile(String filePath) {
    print("Opening file: $filePath");
    OpenFile.open(filePath);
  }

  //
  //
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print("✅ Storage permission granted");
    } else {
      print("❌ Storage permission denied");
    }
  }
  //

  Future<Directory?> getDownloadDirectory() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      directory = await getApplicationDocumentsDirectory(); // Fallback
    }
    return directory;
  }
//

  //preview bottomsheet..
  void _showBottomSheets(
      BuildContext context, String? imagePath, String? pdf) async {
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
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 5,
                                  child: Transform.translate(
                                    offset: Offset(0, -200),
                                    child: PDF(
                                      swipeHorizontal: false,
                                      fitEachPage: true,
                                      enableSwipe: true,
                                      autoSpacing: false,
                                      pageFling: false,
                                      backgroundColor: Colors.white,
                                      onError: (error) {
                                        print(error.toString());
                                      },
                                      onPageError: (page, error) {
                                        print('$page: ${error.toString()}');
                                      },
                                    ).cachedFromUrl(pdf.toString()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                //
              ],
            );
          },
        );
      },
    );
  }
}
