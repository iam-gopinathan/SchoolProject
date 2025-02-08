import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Attendence_models/ClassSendGetSectionModel.dart';
import 'package:flutter_application_1/models/Attendence_models/IrRegularmodels.dart';

import 'package:flutter_application_1/services/Attendance_Api/ClassSendGetSectionApi.dart';
import 'package:flutter_application_1/services/Attendance_Api/IrRegularAttendence.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Irregularattendencies extends StatefulWidget {
  final String initialTab;
  final String selectedClass;
  final String selectedSection;
  const Irregularattendencies({
    super.key,
    required this.initialTab,
    required this.selectedClass,
    required this.selectedSection,
  });

  @override
  State<Irregularattendencies> createState() => _IrregularattendenciesState();
}

class _IrregularattendenciesState extends State<Irregularattendencies> {
  bool isleave = false;
  bool isabsent = false;
  bool islate = false;
  bool isLoading = false;
  late String selectedTab;

  TextEditingController _searchController = TextEditingController();
  List<Irregularmodels> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    isabsent = widget.initialTab == 'Absent';
    isleave = widget.initialTab == 'Leave';
    islate = widget.initialTab == 'Late';

    //initial selected
    String initialStatus = widget.initialTab ?? 'Absent';
    // _fetchIrregularAttendanceData(initialStatus);

    selectedTab = widget.initialTab;
    filteredStudents = students;
    futureSections = fetchSections('PreKG');

    _fetchIrregularAttendanceData(selectedClass, selectedSection, selectedTab);

    _initializeNotification();
  }

//sections show.............................
  late Future<List<Section>> futureSections;
  List<Section> sections = [];

//section function...

  void loadSections(String grade, StateSetter setModalState) async {
    try {
      setModalState(() {
        isLoading = true;
      });

      List<Section> sections = await fetchSections(grade);

      setModalState(() {
        isLoading = false;
        this.sections = sections;
      });

      print("Fetched Sections: $sections");
    } catch (e) {
      setModalState(() {
        this.sections = [];
        isLoading = false;
      });

      print('Error loading sections: $e');
    }
  }
  //section code end...

  final List<String> classes = [
    'overall',
    'PREKG',
    'LKG',
    'UKG',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
  ];

  List<Irregularmodels> students = [];

  String selectedClass = "overall";

  String selectedSection = 'overall';

  List<String> displayedTeachers = [];
  Future<void> _fetchIrregularAttendanceData(
      String selectedClass, String selectedSection, String status) async {
    // Get the current date in 'dd-MM-yyyy' format
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      setState(() {
        displayedTeachers.clear();
        isLoading = true;
      });

      List<Irregularmodels> fetchedStudents = await fetchAttendanceIrRegular(
        selectedClass,
        selectedSection,
        currentDate,
        status,
      );

      setState(() {
        students = fetchedStudents;
        filteredStudents = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        filteredStudents = [];
      });
      print('Error fetching data: $e');
    }
  }

  void filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStudents = students;
      });
    } else {
      setState(() {
        filteredStudents = students.where((student) {
          return student.studentName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              student.rollNumber.contains(query);
        }).toList();
      });
    }
  }

  //export to excelcode start.....
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _initializeNotification() {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationClick,
    );
  }

  void _onNotificationClick(NotificationResponse response) {
    if (response.payload != null) {
      OpenFile.open(response.payload!);
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
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
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      onlyAlertOnce: true,
      maxProgress: 100,
      progress: progress,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
        0, 'Exporting Excel...', '$progress% Complete', notificationDetails);
  }

  Future<void> _finishNotification(String filePath) async {
    const androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
        0, 'Export Complete', 'Excel download completed!', notificationDetails,
        payload: filePath);
  }

  Future<void> requestPermission(List<Irregularmodels> filteredStudents) async {
    PermissionStatus status;

    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      exportToExcel(filteredStudents);
    } else {
      status = await Permission.storage.request();
      if (status.isGranted) {
        exportToExcel(filteredStudents);
      } else {
        print("Permission denied. Please enable it from settings.");
        openAppSettings();
      }
    }
  }

  Future<void> exportToExcel(List<Irregularmodels> filteredStudents) async {
    await _showNotification('Export Started', 'Preparing to export data...');

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      TextCellValue('Index'),
      TextCellValue('Name'),
      TextCellValue('Roll Number'),
      TextCellValue('Class Teacher'),
      TextCellValue('Grade'),
      TextCellValue('Section'),
      TextCellValue('Current Status'),
    ]);

    for (int i = 0; i < filteredStudents.length; i++) {
      Irregularmodels student = filteredStudents[i];
      sheet.appendRow([
        TextCellValue((i + 1).toString()),
        TextCellValue(student.studentName),
        TextCellValue(student.rollNumber),
        TextCellValue(student.classTeacher),
        TextCellValue(student.grade),
        TextCellValue(student.section),
        TextCellValue(student.currentStatus),
      ]);
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

    final filePath =
        '${downloadDir.path}/${selectedClass}_${selectedSection}.xlsx';

    final file = File(filePath);
    final bytes = excel.encode();

    if (bytes != null) {
      for (int progress = 0; progress <= 100; progress += 25) {
        await Future.delayed(Duration(milliseconds: 500));
        _updateProgressNotification(progress);
      }

      await file.writeAsBytes(bytes, flush: true);
      print('File saved at $filePath');

      await _finishNotification(filePath);
    } else {
      print('Failed to save file.');
    }
  }
//export code end......

  //bottomsheet code....
  void _showFilterBottomSheet(BuildContext context) {
    String selectedClass = "overall";

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
              // Close icon
              Positioned(
                top: -70,
                left: 180,
                child: GestureDetector(
                  onTap: () {
                    setModalState(() {
                      selectedClass = "";
                      selectedSection = "";
                      selectedTab = '';
                      isLoading = false;
                    });
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
                height: MediaQuery.of(context).size.height *
                    0.4, //bottomsheet containner
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
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
                                  color: Colors.black),
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
                              //select class
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
                              //classes..
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: classes.map((className) {
                                      final isSelected =
                                          className == selectedClass;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppTheme.textFieldborderColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    223, 223, 223, 1)),
                                          ),
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedClass = className;
                                                  loadSections(
                                                      className, setModalState);
                                                  isLoading = true;
                                                });
                                              },
                                              child: Text(
                                                className,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'medium',
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              //sectionwise.....
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      'Select Section',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'regular',
                                        color: Color.fromRGBO(53, 53, 53, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Display sections below the classes
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: AppTheme.textFieldborderColor,
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            // Overall section
                                            if (selectedClass != "overall")
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setModalState(() {
                                                      selectedSection =
                                                          'overall';
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: selectedSection ==
                                                              'overall'
                                                          ? AppTheme
                                                              .textFieldborderColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            223, 223, 223, 1),
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'overall',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'medium',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            // Dynamic sections
                                            ...sections.map((section) {
                                              final isSelected =
                                                  section.sectionName ==
                                                      selectedSection;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setModalState(() {
                                                      selectedSection =
                                                          section.sectionName;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? AppTheme
                                                              .textFieldborderColor
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            223, 223, 223, 1),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        section.sectionName,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'medium',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.textFieldborderColor),
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });

                            _fetchIrregularAttendanceData(
                              selectedClass,
                              selectedSection,
                              selectedTab,
                            );
                            Navigator.pop(context);

                            print('Selected Class: $selectedClass');
                            print('Selected Section: $selectedSection');
                            print(selectedTab);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }
  //bottom sheet code end...

  //status color..
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'absent':
        return Color.fromRGBO(218, 0, 0, 1);
      case 'leave':
        return Color.fromRGBO(59, 72, 213, 1);
      case 'late':
        return Color.fromRGBO(138, 9, 189, 1);
      default:
        return Colors.grey;
    }
  }
//status color end..

  @override
  Widget build(BuildContext context) {
    //mediaquery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: AppTheme.appBackgroundPrimaryColor,
        title: Text(
          'Irregular attendees',
          style: TextStyle(
              fontFamily: 'semibold', fontSize: 16, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              //search container row...
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: screenWidth * 0.7,
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            hintText: 'Student by Name or Roll Number',
                            hintStyle: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(94, 94, 94, 1)),
                            prefixIcon: Icon(Icons.search,
                                color: Color.fromRGBO(94, 94, 94, 1)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(150, 150, 150, 1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(150, 150, 150, 1),
                              ),
                            ),
                          ),
                          onChanged: filterStudents,
                        ),
                      ),
                    ),
                    //filter icons...
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFilterBottomSheet(context);
                          });
                        },
                        child: SvgPicture.asset('assets/icons/Filter_icon.svg',
                            fit: BoxFit.contain,
                            height: 24,
                            width: 24,
                            color: Colors.black),
                      ),
                    ),
                    //export icons....
                    GestureDetector(
                      onTap: () {
                        print('export clicked');
                        _initializeNotification();
                        // requestPermission(filteredStudents);
                        exportToExcel(filteredStudents);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(
                          'assets/icons/export_icon.svg',
                          fit: BoxFit.contain,
                          height: 24,
                          width: 24,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ///nextsection.........
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Notify All',
                      style: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppTheme.appBackgroundPrimaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //ABsent
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isabsent = true;
                                  isleave = false;
                                  islate = false;
                                  selectedTab = 'Absent';

                                  displayedTeachers.clear();

                                  _fetchIrregularAttendanceData(
                                      selectedClass, selectedSection, 'absent');
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                    color: isabsent
                                        ? Colors.black
                                        : Color.fromRGBO(250, 246, 252, 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  'Absent',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 14,
                                      color: isabsent
                                          ? Color.fromRGBO(255, 247, 247, 1)
                                          : Color.fromRGBO(126, 126, 126, 1)),
                                ),
                              ),
                            ),
                            //Leave
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isabsent = false;
                                  isleave = true;
                                  islate = false;
                                  selectedTab = 'Leave';
                                  displayedTeachers.clear();
                                  _fetchIrregularAttendanceData(
                                      selectedClass, selectedSection, 'leave');
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                    color: isleave
                                        ? Colors.black
                                        : Color.fromRGBO(250, 246, 252, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  'Leave',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 14,
                                      color: isleave
                                          ? Color.fromRGBO(255, 247, 247, 1)
                                          : Color.fromRGBO(126, 126, 126, 1)),
                                ),
                              ),
                            ),
                            //Late
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isabsent = false;
                                  isleave = false;
                                  islate = true;
                                  selectedTab = 'Late';
                                  displayedTeachers.clear();

                                  _fetchIrregularAttendanceData(
                                      selectedClass, selectedSection, 'late');
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                    color: islate
                                        ? Colors.black
                                        : Color.fromRGBO(250, 246, 252, 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  'Late',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 14,
                                      color: islate
                                          ? Color.fromRGBO(255, 247, 247, 1)
                                          : Color.fromRGBO(126, 126, 126, 1)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //content shows...
              isLoading
                  ? Container(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: AppTheme.textFieldborderColor,
                        ),
                      ),
                    )
                  : Column(
                      children: filteredStudents.asMap().entries.map((entry) {
                        int index = entry.key;
                        Irregularmodels student = entry.value;

                        // Check if the teacher has already been displayed for this grade/section
                        String teacherKey =
                            '${student.grade}-${student.section}-${student.classTeacher}';
                        bool isTeacherAlreadyDisplayed =
                            displayedTeachers.contains(teacherKey);

                        // If teacher has not been displayed yet, add it to the displayedTeachers list
                        if (!isTeacherAlreadyDisplayed) {
                          displayedTeachers.add(teacherKey);
                        }

                        return Column(
                          children: [
                            if (!isTeacherAlreadyDisplayed)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                234, 234, 234, 1),
                                          ),
                                        ),
                                        child: IntrinsicWidth(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                  ),
                                                  color: _getStatusColor(
                                                      student.currentStatus),
                                                ),
                                                child: Text(
                                                  "$selectedTab",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'medium',
                                                  ),
                                                ),
                                              ),
                                              // Grade
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  '${student.grade} - ${student.section}',
                                                  style: TextStyle(
                                                    fontFamily: 'medium',
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              // Class Teacher
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 10),
                                                child: Text(
                                                  student.classTeacher,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'medium',
                                                    fontSize: 14,
                                                  ),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Color.fromRGBO(238, 238, 238, 1)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tileColor: Colors.white,
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          student.studentPicture,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.studentName,
                                      style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      student.rollNumber,
                                      style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Student History',
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.27,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                                student.currentStatus),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              student.currentStatus,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'medium',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
      //notifie absentiees...

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor),
                onPressed: () {},
                child: Text(
                  'Notify Absentees',
                  style: TextStyle(
                      fontFamily: 'semibold',
                      fontSize: 16,
                      color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }
}
