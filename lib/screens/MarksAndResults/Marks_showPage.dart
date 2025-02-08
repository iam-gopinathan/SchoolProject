import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Marks_models/Showmarks_model.dart';
import 'package:flutter_application_1/services/Marks_Api/Showmarks_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MarksShowpage extends StatefulWidget {
  final int gradeId;
  const MarksShowpage({super.key, required this.gradeId});

  @override
  State<MarksShowpage> createState() => _MarksShowpageState();
}

class _MarksShowpageState extends State<MarksShowpage> {
  //fetch show data...
  late Future<MarksResponse> marksResponse;
  late int gradeId;

  MarksResponse? data;
  //fetch function.....
  void showw({String selectedSection = 'A1'}) async {
    try {
      marksResponse = fetchShowMarksData(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        gradeId: gradeId,
        section: selectedSection,
        exam: selectedExam.toString(),
      );

      data = await marksResponse;
      setState(() {});

      print('API Call Parameters:');
      print('Roll Number: ${UserSession().rollNumber}');
      print('User Type: ${UserSession().userType}');
      print('Grade ID: $gradeId');
      print('Section: $selectedSection');
      print('Exam: ${selectedExam.toString()}');
    } catch (e) {
      print('Error fetch showwwmraks$e');
    }
  }

  ///exam filter...
  String? selectedExam;
  final gradeController = Get.find<GradeController>();
  List<String> availableExams = [];
  void updateExams(String gradeId) {
    final selectedGrade = gradeController.gradeList.firstWhere(
      (grade) => grade['id'].toString() == gradeId,
      orElse: () => null,
    );
    if (selectedGrade != null) {
      setState(() {
        availableExams = List<String>.from(selectedGrade['exams'] ?? []);
        if (availableExams.isNotEmpty) {
          selectedExam = availableExams[0];
        } else {
          selectedExam = null;
        }
      });
    }
  }

//select section....
  void _showFilterBottomSheet(BuildContext context) {
    List<String> sections = [];
    final gradeController = Get.find<GradeController>();
//update sections..
    void updateSections(int gradeId) {
      final selectedGrade = gradeController.gradeList.firstWhere(
        (grade) => grade['id'] == gradeId,
        orElse: () => null,
      );
      if (selectedGrade != null) {
        sections = List<String>.from(selectedGrade['sections'] ?? []);
      }
    }

    updateSections(gradeId);
//section filter...
    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        String selectedSection = '';
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
                                'Select Section',
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

                                showw(selectedSection: selectedSection);

                                print(selectedSection);
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

  ScrollController _tableScrollController = ScrollController();
  double _progress = 0.0;

  @override
  void initState() {
    print("subjects $subjects"); // To ensure that subjects list has values

    // TODO: implement initState
    super.initState();
    _initializeNotification();
    gradeController.fetchGrades().then((_) {
      gradeController.filterSubjectsByGrade(widget.gradeId);
    });
    updateExams(widget.gradeId.toString());
    gradeId = widget.gradeId;
    gradeController.fetchGrades();
    showw();
    gradeController.fetchGrades();
    _scrollController.addListener(_scrollListener);
    //
    // Add listener to track horizontal scroll position
    _tableScrollController.addListener(() {
      double maxScrollExtent = _tableScrollController.position.maxScrollExtent;
      double currentScrollPosition = _tableScrollController.position.pixels;

      setState(() {
        _progress = currentScrollPosition / maxScrollExtent;
      });
    });
  }

  void _scrollListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tableScrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  TextEditingController _teachercommmentview = TextEditingController();
  //scroll
  ScrollController _scrollController = ScrollController();

  //view bottomsheeet...
  void _viewBottomsheet(BuildContext context, String teachercomment) {
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
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            Text(
                              'Teacher Comment',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromRGBO(202, 202, 202, 1),
                              )),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            maxLines: 9,
                            controller: _teachercommmentview
                              ..text = teachercomment,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 70, vertical: 5),
                                elevation: 0,
                                backgroundColor: Colors.white,
                                side:
                                    BorderSide(color: Colors.black, width: 1)),
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
              )
            ]);
          });
        });
  }

//notification and excel dwnl code......
  List<String> subjects = [];
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void _initializeNotification() {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          OpenFile.open(response.payload!);
        }
      },
    );
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'export_channel',
      'Export Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      onlyAlertOnce: true,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> _updateProgressNotification(int progress) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'export_channel',
      'Export Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      onlyAlertOnce: true,
      maxProgress: 100,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
        0, 'Exporting Excel...', '$progress% Complete', notificationDetails);
  }

  Future<void> _finishNotification(String filePath) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'export_channel',
      'Export Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, 'Export Complete',
        'Excel file saved successfully!', notificationDetails,
        payload: filePath);
  }

//export to excel..
  Future<void> exportToExcel(
      MarksResponse data, List<String> subjects, String selectedSection) async {
    await _showNotification('Export Started', 'Preparing to export data...');
    final excel = Excel.createExcel();
    // Create a new sheet named 'Sheet1'
    final sheet = excel['Sheet1'];
    // Add headers
    List<String> headers = [
      'S.No',
      'Student Name',
      'Roll Number',
      'Total Marks',
      'Scored Marks',
      'Percentage',
      'Remarks',
      'Teacher Notes',
      ...subjects,
    ];
    sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());
    for (int i = 0; i < data.prekgRequest.length; i++) {
      var e = data.prekgRequest[i];

      List<dynamic> subjectMarks = subjects.map((subject) {
        var value = getSubjectValue(e, subject);
        print(
            'Subject: $subject, Value: $value'); // Debug: Check the value for each subject
        return value;
      }).toList();

      List<dynamic> row = [
        i + 1,
        e.studentName,
        e.rollnumber,
        e.totalMarks,
        e.marksScored,
        "${e.percentage}%",
        e.teacherNotes,
        e.remarks,
        ...subjectMarks,
      ];
      sheet.appendRow(
          row.map((cell) => TextCellValue(cell.toString())).toList());
    }
    excel.setDefaultSheet('Sheet1');
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Failed to get external directory");
      return;
    }
    final downloadDir = Directory('${directory.path}/Download');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final formattedTimestamp =
        DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final filePath =
        '${downloadDir.path}/StudentData_${selectedSection}_$formattedTimestamp.xlsx';
    final file = File(filePath);
    final bytes = excel.encode();
    if (bytes != null) {
      for (int progress = 0; progress <= 100; progress += 25) {
        await Future.delayed(Duration(milliseconds: 500));
        _updateProgressNotification(progress);
      }
      await file.writeAsBytes(bytes, flush: true);
      print('File saved at $filePath');
      // Finish notification
      await _finishNotification(filePath);
    } else {
      print('Failed to save file.');
    }
  }
  ////export to excel..

  //individual student export...
  Future<void> exportIndividualStudentToExcel(MarksResponse data,
      List<String> subjects, String selectedSection, String rollNumber) async {
    var studentData = data.prekgRequest.firstWhere(
      (student) => student.rollnumber == rollNumber,
      orElse: () => StudentMark.empty(),
    );
    if (studentData.rollnumber.isEmpty) {
      print('Student with roll number $rollNumber not found');
      return;
    }
    await _showNotification('Export Started',
        'Preparing to export data for student $rollNumber...');
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    // Add headers
    List<String> headers = [
      'S.No',
      'Student Name',
      'Roll Number',
      'Total Marks',
      'Scored Marks',
      'Percentage',
      'Remarks',
      'Teacher Notes',
      ...subjects,
    ];
    sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());
    // Add the individual student row
    List<dynamic> row = [
      1,
      studentData.studentName,
      studentData.rollnumber,
      studentData.totalMarks,
      studentData.marksScored,
      "${studentData.percentage}%",
      studentData.remarks,
      studentData.teacherNotes,
      // ...subjects.map((subject) => subject),
      // Map over the subjects and fetch the corresponding marks for each subject
      ...subjects.map((subject) {
        var value = getSubjectValue(studentData, subject);
        print(
            'Subject: $subject, Value: $value'); // Debug: Check the value for each subject
        return value; // Return the mark for the subject
      }).toList(),
    ];
    sheet.appendRow(row.map((cell) => TextCellValue(cell.toString())).toList());
    excel.setDefaultSheet('Sheet1');
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Failed to get external directory");
      return;
    }
    final downloadDir = Directory('${directory.path}/Download');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    final formattedTimestamp =
        DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final filePath =
        '${downloadDir.path}/${studentData.studentName}_$formattedTimestamp.xlsx';
    final file = File(filePath);
    final bytes = excel.encode();
    if (bytes != null) {
      for (int progress = 0; progress <= 100; progress += 25) {
        await Future.delayed(Duration(milliseconds: 500));
        _updateProgressNotification(progress);
      }
      await file.writeAsBytes(bytes, flush: true);
      print('File saved at $filePath');
      // Finish notification
      await _finishNotification(filePath);
    } else {
      print('Failed to save file.');
    }
  }
  //individual student export end...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(251, 251, 251, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: AppTheme.appBackgroundPrimaryColor,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
              title: Text(
                'Marks / Results',
                style: TextStyle(
                  fontFamily: 'semibold',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //exam dropdownfield..
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.black,
                        menuMaxHeight: 150,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(203, 203, 203, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(203, 203, 203, 1),
                            ),
                          ),
                        ),
                        value: selectedExam,
                        hint: Text(
                          "Select Exam",
                          style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            selectedExam = value;
                          });
                          showw();
                        },
                        items: availableExams.map((exam) {
                          return DropdownMenuItem<String>(
                            value: exam,
                            child: Text(
                              exam,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'regular',
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return availableExams.map((exam) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                exam,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'regular',
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    //filter icon..
                    GestureDetector(
                      onTap: () {
                        _showFilterBottomSheet(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/Filter_icon.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    //export icon..
                    GestureDetector(
                      onTap: () async {
                        String selectedSection = 'A1';
                        _initializeNotification();
                        exportToExcel(data!, gradeController.filteredSubjects,
                            selectedSection);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/export_icon.svg',
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              //
              FutureBuilder<MarksResponse>(
                future: marksResponse,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: AppTheme.textFieldborderColor,
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.prekgRequest.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    MarksResponse data = snapshot.data!;
                    return Column(
                      children: [
                        //
                        Transform.translate(
                          offset: Offset(0, 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Row(
                              children: [
                                IntrinsicWidth(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10)),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                234, 234, 234, 1))),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10)),
                                              color: Color.fromRGBO(
                                                  31, 106, 163, 1)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                              '${data.gradeSection}',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Text(
                                            'Class Teacher - ${data.classTeacher}',
                                            style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        //card sections...
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              ...data.prekgRequest.map((e) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                      )),
                                  child: Column(
                                    children: [
                                      //individual export.......
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                _initializeNotification();

                                                String selectedSection =
                                                    e.section;
                                                String rollNumber =
                                                    e.rollnumber;
                                                await exportIndividualStudentToExcel(
                                                    data,
                                                    gradeController
                                                        .filteredSubjects,
                                                    selectedSection,
                                                    rollNumber);
                                              },
                                              child: SvgPicture.asset(
                                                'assets/icons/IndividualExport_icons.svg',
                                                fit: BoxFit.contain,
                                                height: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${data.prekgRequest.indexOf(e) + 1}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'medium',
                                                color: Colors.black),
                                          ),
                                          CircleAvatar(
                                            radius: 30,
                                            child: Image.network(
                                              '${e.profile}',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${e.studentName}',
                                                style: TextStyle(
                                                    fontFamily: 'semibold',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${e.rollnumber}',
                                                style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Percentage-',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 12,
                                                        color: Color.fromRGBO(
                                                            54, 54, 54, 1)),
                                                  ),
                                                  Text(
                                                    "${e.percentage}%",
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          //
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Total Marks ',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 10,
                                                        color: Color.fromRGBO(
                                                            54, 54, 54, 1)),
                                                  ),
                                                  Text(
                                                    '${e.totalMarks}',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Scored Marks ',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 10,
                                                        color: Color.fromRGBO(
                                                            54, 54, 54, 1)),
                                                  ),
                                                  Text(
                                                    '${e.marksScored}',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                              //pass..
                                              if (e.remarks.isNotEmpty)
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              e.remarks ==
                                                                      'Pass'
                                                                  ? Color
                                                                      .fromRGBO(
                                                                          1,
                                                                          133,
                                                                          53,
                                                                          1)
                                                                  : Colors.red),
                                                  onPressed: () {},
                                                  child: Text(
                                                    '${e.remarks}',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      //
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 25,
                                            right: 25),
                                        child: Divider(
                                          color:
                                              Color.fromRGBO(245, 245, 245, 1),
                                          height: 5,
                                          thickness: 3,
                                        ),
                                      ),
                                      //marks table.............
                                      Obx(
                                        () {
                                          if (gradeController
                                              .filteredSubjects.isEmpty) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 4,
                                                color: AppTheme
                                                    .textFieldborderColor,
                                              ),
                                            );
                                          }
                                          return SingleChildScrollView(
                                            controller: _tableScrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DataTable(
                                                headingRowColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                  (states) =>
                                                      const Color.fromRGBO(
                                                          255, 247, 247, 1),
                                                ),
                                                border: TableBorder.all(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                ),
                                                columns: [
                                                  const DataColumn(
                                                      label:
                                                          Text('Total Marks')),
                                                  ...gradeController
                                                      .filteredSubjects
                                                      .map((subject) {
                                                    return DataColumn(
                                                        label: Text(subject));
                                                  }).toList(),
                                                ],
                                                rows: [
                                                  DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '${e.totalMarks}')),
                                                      ...gradeController
                                                          .filteredSubjects
                                                          .map(
                                                        (subject) {
                                                          final value =
                                                              getSubjectValue(
                                                                  e, subject);

                                                          return DataCell(
                                                              Text(value));
                                                        },
                                                      ).toList(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      //
                                      Divider(
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                        height: 5,
                                        thickness: 3,
                                      ),

                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10),
                                            child: Text(
                                              'Teacher Comment',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              var teachercomment =
                                                  e.teacherNotes;
                                              _viewBottomsheet(
                                                  context, teachercomment);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15, top: 10),
                                              child: Text(
                                                'View',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'regular',
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // Linear progress bar
                                      Container(
                                        width: 60,
                                        height: 10,
                                        child: LinearProgressIndicator(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          backgroundColor:
                                              Color.fromRGBO(225, 225, 225, 1),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                          value: _progress,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  String getSubjectValue(dynamic e, String subject) {
    switch (subject.toLowerCase()) {
      case 'tamil':
        return '${e.tamil}';
      case 'english':
        return '${e.english}';
      case 'hindi':
        return '${e.hindi}';
      case 'maths':
        return '${e.maths}';
      case 'evs':
        return '${e.evs}';
      case 'phonics':
        return '${e.phonics}';
      case 'science':
        return '${e.science}';
      case 'social':
        return '${e.social}';
      default:
        return '-';
    }
  }
}
