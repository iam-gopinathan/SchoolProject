import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Marks_models/AddMarks_model.dart';
import 'package:flutter_application_1/models/Marks_models/Students_fetch_model.dart';
import 'package:flutter_application_1/services/Marks_Api/Add_marks_Api.dart';
import 'package:flutter_application_1/services/Marks_Api/Students_fetch_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Addmarks extends StatefulWidget {
  const Addmarks({super.key});

  @override
  State<Addmarks> createState() => _AddmarksState();
}

class _AddmarksState extends State<Addmarks> {
  TextEditingController _Addcomment = TextEditingController();

  //notification and excel convert code...

  List<MarksDetails> marksList = [];
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

  Future<void> exportToExcel(List<MarksDetails> marksList,
      List<String> subjects, String selectedSection) async {
    await _showNotification('Export Started', 'Preparing to export data...');

    final excel = Excel.createExcel();

    // Create a new sheet named 'Sheet1'
    final sheet = excel['Sheet1'];

    // Add headers
    List<String> headers = [
      'Grade',
      'Section',
      'Student Name',
      'Roll Number',
      'Total Marks',
      'Marks Scored',
      'Percentage',
      'Remarks',
      'Teacher Notes',
      ...subjects,
    ];

    sheet.appendRow(headers.map((header) => TextCellValue(header)).toList());

    // Add student data
    for (MarksDetails marks in marksList) {
      List<dynamic> row = [
        marks.grade,
        marks.section,
        marks.studentName,
        marks.rollnumber,
        marks.totalMarks,
        marks.marksScored,
        marks.percentage.toStringAsFixed(2),
        marks.remarks,
        marks.teacherNotes,
        ...subjects.map((subject) => subject),
      ];

      sheet.appendRow(
          row.map((cell) => TextCellValue(cell.toString())).toList());
    }

    // Set 'Sheet1' as the default active sheet
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

    final filePath =
        '${downloadDir.path}/StudentData_${selectedSection}_${DateTime.now().toIso8601String()}.xlsx';

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
//notification and export code end......

  String? selectedExam;

  final gradeController = Get.find<GradeController>();

//view bottomsheeet...
  void _viewBottomsheet(BuildContext context) {
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
                          controller: _Addcomment,
                          maxLines: 9,
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
                              padding: EdgeInsets.symmetric(horizontal: 70),
                              elevation: 0,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black, width: 1)),
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
      },
    );
  }

  //add bottomsheet..
  void _addBottomsheet(BuildContext context) {
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
                            controller: _Addcomment,
                            maxLines: 9,
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
                              padding: EdgeInsets.symmetric(horizontal: 70),
                              elevation: 0,
                              backgroundColor: AppTheme.textFieldborderColor,
                            ),
                            onPressed: () {},
                            child: Text(
                              'Save',
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

  //filter bottomsheet..
  void _showFilterBottomSheet(BuildContext context) {
    List<String> sections = [];

    final gradeController = Get.find<GradeController>();

    void updateExams(String gradeId) {
      final selectedGrade = gradeController.gradeList.firstWhere(
        (grade) => grade['id'].toString() == gradeId,
        orElse: () => null,
      );
      if (selectedGrade != null) {
        setState(() {
          availableExams = List<String>.from(selectedGrade['exams'] ?? []);
          selectedExam = null;
        });
      }
    }

//class and section filter..
    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        String selectedGrade = '';
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

                                _updateGradeDataFuture(
                                  selectedGrade,
                                  selectedSection,
                                );

                                updateExams(selectedGrade);
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
  ScrollController _scrollController = ScrollController();

  //
  bool isLoading = true;

  List<int> totalMarksForStudents = [];
  List<double> percentageForStudents = [];
  List<String> statusForStudents = [];

  late Future<GradeMarkss> _gradeDataFuture;

  late List<TextEditingController> subjectControllers = [];

  late List<List<TextEditingController>> subjectControllersForStudents = [];

  ///calculate result....
  void calculateResults(int studentIndex) {
    setState(() {
      bool allMarksEntered = true;
      int totalMarks = 0;
      bool isFail = false;

      for (var subjectIndex = 0;
          subjectIndex < subjectControllersForStudents[studentIndex].length;
          subjectIndex++) {
        String value =
            subjectControllersForStudents[studentIndex][subjectIndex].text;

        if (value.isEmpty) {
          allMarksEntered = false;
        }

        int mark = int.tryParse(value) ?? 0;
        totalMarks += mark;

        if (mark < 35) {
          isFail = true;
        }
      }

      if (allMarksEntered) {
        totalMarksForStudents[studentIndex] = totalMarks;

        double percentage = (totalMarks /
                (subjectControllersForStudents[studentIndex].length * 100)) *
            100;
        percentageForStudents[studentIndex] = percentage;

        String status = isFail ? 'Fail' : 'Pass';
        statusForStudents[studentIndex] = status;
      } else {
        statusForStudents[studentIndex] = '';
      }
    });
  }

  ///calculate result....

  final ScrollController _horizontalScrollController = ScrollController();
  double _progress = 0;

  String selectedGrade = '131';
  String selectedSection = 'A1';

  //api pass..parameter...
  void _updateGradeDataFuture(String selectedGrade, String selectedSection) {
    // Clear any previously entered data for the new grade
    subjectControllersForStudents = [];
    totalMarksForStudents = [];
    percentageForStudents = [];
    statusForStudents = [];
    setState(() {
      _gradeDataFuture = fetchGradeData(
        UserType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        section: selectedSection,
        gradeId: selectedGrade,
      );
    });
  }

  @override
  void initState() {
    _initializeNotification();
    _updateGradeDataFuture(selectedGrade, selectedSection);
    print('selectedgradeeeeee :$selectedGrade');
    print('selected sectionnnnnn $selectedSection');
    super.initState();

    updateExams(selectedGrade);
    gradeController.fetchGrades();

    _gradeDataFuture = fetchGradeData(
        UserType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        section: selectedSection,
        gradeId: selectedGrade);

    _horizontalScrollController.addListener(() {
      setState(() {
        // Calculate progress based on the scroll position
        _progress = _horizontalScrollController.position.pixels /
            _horizontalScrollController.position.maxScrollExtent;
      });
    });
    //
    gradeController.fetchGrades();
    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);
  }

  //
  void _scrollListener() {
    setState(() {}); // Trigger UI update when scroll position changes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  List<String> availableExams = [];
  void updateExams(String gradeId) {
    final selectedGrade = gradeController.gradeList.firstWhere(
      (grade) => grade['id'].toString() == gradeId,
      orElse: () => null,
    );
    if (selectedGrade != null) {
      setState(() {
        availableExams = List<String>.from(selectedGrade['exams'] ?? []);
        selectedExam = null;
      });
    }
  }

  GradeMarkss? _gradeData;
  //

  //
  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return subjectControllers != initialHeading;
  }

  // Function to show the unsaved changes dialog
  Future<void> _showUnsavedChangesDialog() async {
    bool discard = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Unsaved Changes !",
                style: TextStyle(
                  fontFamily: 'semibold',
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "You have unsaved changes. Are you sure you want to discard them?",
                style: TextStyle(
                    fontFamily: 'medium', fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Discard",
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

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
                  onTap: () async {
                    if (hasUnsavedChanges()) {
                      await _showUnsavedChangesDialog();
                    }
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
              title: Text(
                'Add Marks',
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
                    Text(
                      'Add Exam Name',
                      style: TextStyle(
                          fontFamily: 'regular',
                          fontSize: 12,
                          color: Colors.black),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
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
                        _initializeNotification();
                        exportToExcel(marksList, subjects, selectedSection);
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
              FutureBuilder<GradeMarkss>(
                  future: _gradeDataFuture,
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
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No data available'));
                    } else {
                      _gradeData = snapshot.data!;
                      var gradeData = _gradeData!;

                      print('Subjects count: ${gradeData.subjects.length}');

                      print('Students List: ${gradeData.students[0].name}');

                      print('selectedGrade $selectedGrade');
                      print('selected section $selectedSection');

                      if (subjectControllersForStudents.isEmpty) {
                        subjectControllersForStudents = List.generate(
                          gradeData.students.length,
                          (studentIndex) => List.generate(
                            gradeData.subjects.length,
                            (subjectIndex) => TextEditingController(),
                          ),
                        );
                        totalMarksForStudents =
                            List.filled(gradeData.students.length, 0);
                        percentageForStudents =
                            List.filled(gradeData.students.length, 0);
                        statusForStudents =
                            List.filled(gradeData.students.length, '');
                      }
                      return Column(
                        children: [
                          Transform.translate(
                            offset: Offset(0, 15),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Row(children: [
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
                                              '${gradeData.gradeSection}',
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
                                            'Class Teacher - ${gradeData.classTeacher}',
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
                              ]),
                            ),
                          ),
                          for (var studentIndex = 0;
                              studentIndex < gradeData.students.length;
                              studentIndex++)
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    )),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '${studentIndex + 1}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'medium',
                                              color: Colors.black),
                                        ),
                                        CircleAvatar(
                                          radius: 30,
                                          child: Image.network(
                                            '${gradeData.students[studentIndex].profile}',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${gradeData.students[studentIndex].name}',
                                              style: TextStyle(
                                                  fontFamily: 'semibold',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${gradeData.students[studentIndex].rollNumber}',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Percentage',
                                                  style: TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(
                                                          54, 54, 54, 1)),
                                                ),
                                                Text(
                                                  "${percentageForStudents[studentIndex].toStringAsFixed(0)}%",
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
                                                  '${gradeData.subjects.length * 100}',
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
                                                  '${totalMarksForStudents[studentIndex]}',
                                                  style: TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            //pass..
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: statusForStudents[
                                                              studentIndex] ==
                                                          'Pass'
                                                      ? Color.fromRGBO(
                                                          1, 133, 53, 1)
                                                      : (statusForStudents[
                                                                  studentIndex] ==
                                                              'Fail'
                                                          ? Colors.red
                                                          : Colors.white),
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  '${statusForStudents[studentIndex]}',
                                                  style: TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                )),
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
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                        height: 5,
                                        thickness: 3,
                                      ),
                                    ),
                                    //table.......
                                    SingleChildScrollView(
                                      controller: _horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DataTable(
                                          headingRowColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (states) => Color.fromRGBO(
                                                255, 247, 247, 1),
                                          ),
                                          border: TableBorder.all(
                                              color: Colors.black
                                                  .withOpacity(0.1)),
                                          columns: [
                                            DataColumn(
                                                label: Text('Total Marks')),
                                            for (var subject
                                                in gradeData.subjects)
                                              DataColumn(label: Text(subject)),
                                          ],
                                          rows: [
                                            DataRow(cells: [
                                              DataCell(Text(
                                                  '${gradeData.subjects.length * 100}')),
                                              for (int subjectIndex = 0;
                                                  subjectIndex <
                                                      gradeData.subjects.length;
                                                  subjectIndex++)
                                                DataCell(
                                                  TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      LengthLimitingTextInputFormatter(
                                                          3),
                                                    ],
                                                    controller:
                                                        subjectControllersForStudents[
                                                                studentIndex]
                                                            [subjectIndex],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                    ),
                                                    onChanged: (value) {
                                                      int number = int.tryParse(
                                                              value) ??
                                                          0; // Convert input to an integer
                                                      if (number > 100) {
                                                        // If the number is greater than 100, restrict it
                                                        subjectControllersForStudents[
                                                                    studentIndex]
                                                                [subjectIndex]
                                                            .text = '100';

                                                        // Move the cursor to the end after update
                                                        subjectControllersForStudents[
                                                                        studentIndex]
                                                                    [subjectIndex]
                                                                .selection =
                                                            TextSelection
                                                                .fromPosition(
                                                          TextPosition(
                                                              offset: subjectControllersForStudents[
                                                                          studentIndex]
                                                                      [
                                                                      subjectIndex]
                                                                  .text
                                                                  .length),
                                                        );
                                                      }
                                                      print(
                                                          "Updated value for student $studentIndex, subject $subjectIndex: $value");
                                                      calculateResults(
                                                          studentIndex);
                                                    },
                                                  ),
                                                ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //
                                    Divider(
                                      color: Color.fromRGBO(245, 245, 245, 1),
                                      height: 5,
                                      thickness: 3,
                                    ),
                                    //linear indicator...
                                    Container(
                                      width: 60,
                                      height: 10,
                                      child: LinearProgressIndicator(
                                        borderRadius: BorderRadius.circular(10),
                                        backgroundColor:
                                            Color.fromRGBO(225, 225, 225, 1),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black),
                                        value: _progress,
                                      ),
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
                                            _addBottomsheet(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15, top: 10),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'regular',
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _viewBottomsheet(context);
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
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //draft
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black, width: 1.5)),
                  onPressed: () {
                    String status = 'draft';
                    addMarks(context, selectedExam!, _gradeData!, status,
                        selectedGrade);
                  },
                  child: Text(
                    'Save as Draft',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'semibold',
                        color: Colors.black),
                  ),
                ),

                ///publish
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: areAllMarksEntered()
                            ? AppTheme.textFieldborderColor
                            : Colors.grey),
                    onPressed: () {
                      if (areAllMarksEntered()) {
                        String status = 'post';
                        addMarks(context, selectedExam!, _gradeData!, status,
                            selectedGrade);
                        print('elevatedexaaaam${selectedExam}');
                        print('_gradeData!${selectedExam}');
                        print('ele status ${status}');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: AppTheme.textFieldborderColor,
                            content: Text(
                              'Please enter marks for all students!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'semibold',
                                  fontSize: 16),
                            )));
                      }
                    },
                    child: Text(
                      'Publish',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'semibold',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

  bool areAllMarksEntered() {
    if (_gradeData == null ||
        _gradeData!.students.isEmpty ||
        _gradeData!.subjects.isEmpty ||
        subjectControllersForStudents.isEmpty) {
      return false;
    }

    for (var studentIndex = 0;
        studentIndex < _gradeData!.students.length;
        studentIndex++) {
      for (var subjectIndex = 0;
          subjectIndex < _gradeData!.subjects.length;
          subjectIndex++) {
        if (subjectControllersForStudents[studentIndex][subjectIndex]
            .text
            .isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  /////addmarks........
  void addMarks(BuildContext context, String selectedExam,
      GradeMarkss gradeData, String status, String selectedGrade) {
    List<MarksDetails> marksList = [];
    print('GradeId:${gradeData.gradeId}');
    print('Grade Data: ${gradeData.gradeSection}');
    print('Students List: ${gradeData.students[0].name}');
    print('Subjects Count: ${gradeData.subjects.length}');
    print("GradeData$gradeData");

    for (int studentIndex = 0;
        studentIndex < gradeData.students.length;
        studentIndex++) {
      var student = gradeData.students[studentIndex];
      Map<String, int> subjectMarks = {};

      for (int subjectIndex = 0;
          subjectIndex < gradeData.subjects.length;
          subjectIndex++) {
        String subject = gradeData.subjects[subjectIndex];
        int marksScored = int.tryParse(
                subjectControllersForStudents[studentIndex][subjectIndex]
                    .text) ??
            0;
        subjectMarks[subject] = marksScored;
        print(
          'Student: ${student.name}, Subject: $subject, Marks: $marksScored, StudentGrade${student.grade},studentSection${student.section}',
        );
      }

      int totalMarks = gradeData.subjects.length * 100;
      int marksScoredTotal =
          subjectMarks.values.fold(0, (sum, mark) => sum + mark);

      int percentage = ((marksScoredTotal / totalMarks) * 100).toInt();

      marksList.add(MarksDetails(
        examName: selectedExam,
        rollnumber: student.rollNumber,
        studentName: student.name,
        grade: student.grade,
        section: student.section,
        profile: student.profile,
        totalMarks: totalMarks,
        marksScored: marksScoredTotal,
        percentage: percentage,
        remarks: statusForStudents[studentIndex],
        teacherNotes: _Addcomment.text,
        tamil: subjectMarks['tamil'] ?? 0,
        english: subjectMarks['english'] ?? 0,
        hindi: subjectMarks['hindi'] ?? 0,
        maths: subjectMarks['maths'] ?? 0,
        evs: subjectMarks['evs'] ?? 0,
        science: subjectMarks['science'] ?? 0,
        social: subjectMarks['social'] ?? 0,
        phonics: subjectMarks['phonics'] ?? 0,
      ));
    }

    MarksRequest marksRequest = MarksRequest(
      gradeId: selectedGrade,
      status: status,
      allMarksRequest: marksList,
    );

    postMarks(marksRequest, context);

    print("Marks List: ${marksList}");
  }
}
