import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Attendence_models/Add_Attendence_Get_Model.dart';
import 'package:flutter_application_1/models/Attendence_models/ClassSendGetSectionModel.dart';
import 'package:flutter_application_1/models/Attendence_models/Post_Add_attendence.dart';
import 'package:flutter_application_1/models/Attendence_models/Post_Update_Attendence.dart';
import 'package:flutter_application_1/services/Attendance_Api/Add_Attendence_Get_Api.dart';
import 'package:flutter_application_1/services/Attendance_Api/ClassSendGetSectionApi.dart';
import 'package:flutter_application_1/services/Attendance_Api/Post_Add_attendence.dart';
import 'package:flutter_application_1/services/Attendance_Api/Post_Update_Attendence.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAttendencePage extends StatefulWidget {
  const AddAttendencePage({super.key});

  @override
  State<AddAttendencePage> createState() => _AddAttendencePageState();
}

class _AddAttendencePageState extends State<AddAttendencePage> {
  // Global list to store imported data
  List<Map<String, String>> importedData = [];

  bool isoverall = false;
  bool isabsent = false;
  bool isleave = false;
  bool islate = false;

  String isUpdateAvailable = 'N';
  //date picker code..
  DateTime? selectedDate;

  Future<void> _selectDate(
      BuildContext context, String grade, String section) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
        print(formattedDate);
        _fetchAddgetAttendanceData(grade, section, formattedDate, status);
      });
    }
  }

  bool isLoading = false;

  late Future<AddAttendenceGetModel> _attendanceData;

  AddAttendenceGetModel? attendanceData;

  List<Details> filteredStudents = [];
  List<Details> Addstudents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeNotification();
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _fetchAddgetAttendanceData(
        selectedGrade, selectedGradeSection, formattedDate, status);
    futureSections = fetchSections('PreKG');
    isoverall = true;
    isabsent = false;
    isleave = false;
    islate = false;
  }

  String selectedGrade = "prekg";
  String selectedGradeSection = 'A1';
  String status = 'overall';

//api call functions....
  Future<void> _fetchAddgetAttendanceData(
      String grade, String section, String formattedDate, String status) async {
    try {
      setState(() {
        isLoading = true;
      });

      AddAttendenceGetModel fetchedData = await fetchADDGETAttendanceData(
        grade,
        section,
        formattedDate,
        status,
      );

      setState(() {
        _attendanceData = Future.value(fetchedData);
        attendanceData = fetchedData;
        Addstudents = fetchedData.details;

        for (var student in Addstudents) {
          if (student.attendanceAction == null ||
              student.attendanceAction.isEmpty ||
              student.attendanceAction == "no data") {
            student.attendanceAction = 'Present';
          }
        }
        filteredStudents = List.from(Addstudents);
        isUpdateAvailable = fetchedData.isUpdateAvailable ?? 'N';

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching attendance data: $e');
    }
  }

  TextEditingController _searchController = TextEditingController();
  void filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStudents = List.from(Addstudents);
      });
    } else {
      setState(() {
        filteredStudents = Addstudents.where((addstu) {
          return (addstu.studentName != null &&
                  addstu.studentName!
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              addstu.rollNumber.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  //color change
  Color _getBackgroundColor(String? action) {
    switch (action) {
      case 'present':
      case 'no data':
        return Color.fromRGBO(1, 133, 53, 1);
      case 'absent':
        return Color.fromRGBO(218, 0, 0, 1);
      case 'leave':
        return Color.fromRGBO(59, 72, 213, 1);
      case 'late':
        return Color.fromRGBO(138, 9, 189, 1);
      default:
        return Color.fromRGBO(1, 133, 53, 1);
    }
  }

  List<Details> originalStudents = [];

  //bottomsheet code....
  final List<String> classes = [
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

//export to excel code...
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
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.max,
      priority: Priority.high,
      showProgress: true,
      onlyAlertOnce: true,
      maxProgress: 100,
      progress: progress,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
        0, 'Exporting Excel...', '$progress% Complete', notificationDetails);
  }

  Future<void> _finishNotification(String filePath) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
        0, 'Export Complete', 'Excel Download completed!', notificationDetails,
        payload: filePath);
  }

  Future<void> requestPermission(
      List<AddAttendenceGetModel> filteredStudents) async {
    PermissionStatus status;

    if (await Permission.storage.isGranted) {
      status = PermissionStatus.granted;
      print("Storage permission granted.");
    } else {
      status = await Permission.storage.request();
      print("Storage permission request status: $status");
    }

    if (status.isGranted) {
      // Pass correct type
      exportAttendanceToExcel(filteredStudents);
    } else if (await Permission.manageExternalStorage.isGranted) {
      exportAttendanceToExcel(filteredStudents);
    } else {
      print("Permission denied. Please enable it from settings.");
      openAppSettings();
    }
  }

  Future<void> exportAttendanceToExcel(
      List<AddAttendenceGetModel> filteredStudents) async {
    await _showNotification('Export Started', 'Preparing to export data...');

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      TextCellValue('Index'),
      TextCellValue('Grade'),
      TextCellValue('Section'),
      TextCellValue('Class Teacher'),
      TextCellValue('Student Name'),
      TextCellValue('Roll Number'),
      TextCellValue('Attendance %'),
      TextCellValue('Attendance Status'),
    ]);

    int index = 1;

    // Loop through filteredStudents
    for (var student in filteredStudents) {
      for (var detail in student.details) {
        // Check if attendance status is empty or null and set it to "Present"
        String attendanceStatus = (detail.currentStatus == null ||
                detail.currentStatus.toLowerCase() == 'no data' ||
                detail.currentStatus.isEmpty)
            ? "Present"
            : detail.currentStatus;

        sheet.appendRow([
          TextCellValue(index.toString()),
          TextCellValue(student.grade),
          TextCellValue(student.section),
          TextCellValue(student.classTeacher ?? 'N/A'),
          TextCellValue(detail.studentName),
          TextCellValue(detail.rollNumber),
          TextCellValue('${detail.attendancePercent}%'),
          TextCellValue(attendanceStatus),
        ]);
        index++;
      }
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
        '${downloadDir.path}/attendance_${filteredStudents.first.grade}_${filteredStudents.first.section}.xlsx';

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

  ///export data...
  List<AddAttendenceGetModel> convertDetailsToAttendanceModels(
      List<Details> detailsList) {
    // Group details by grade and section
    Map<String, List<Details>> groupedByGradeSection = {};

    for (var detail in detailsList) {
      String key = '${detail.grade}_${detail.section}';
      if (!groupedByGradeSection.containsKey(key)) {
        groupedByGradeSection[key] = [];
      }
      groupedByGradeSection[key]!.add(detail);
    }

    return groupedByGradeSection.entries.map((entry) {
      final keys = entry.key.split('_');
      return AddAttendenceGetModel(
        classTeacher: 'Unknown',
        grade: keys[0],
        section: keys[1],
        isAttendanceAdded: 'No',
        isUpdateAvailable: 'No',
        details: entry.value,
      );
    }).toList();
  }
//excel notification code end....

//bottom sheet code...
  void _showFilterBottomSheet(BuildContext context) {
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
                    setModalState(() {});
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
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  left: 20,
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
                              //classes..
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: classes.map((className) {
                                      final isSelected =
                                          className == selectedGrade;
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
                                                  selectedGrade = className;
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
                                            // Dynamic sections
                                            ...sections.map((section) {
                                              final isSelected =
                                                  section.sectionName ==
                                                      selectedGradeSection;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setModalState(() {
                                                      selectedGradeSection =
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
                              // isLoading = true;
                            });

                            Navigator.pop(context);

                            status = 'overall';

                            print('Selected Class: $selectedGrade');
                            print('Selected Section: $selectedGradeSection');

                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(DateTime.now());

                            _fetchAddgetAttendanceData(selectedGrade,
                                selectedGradeSection, formattedDate, status);
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
              ),
            ],
          );
        });
      },
    );
  }
  //bottomsheet code end...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: AppTheme.appBackgroundPrimaryColor,
        title: Text(
          'Add Attendance',
          style: TextStyle(
              fontFamily: 'semibold', fontSize: 16, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //search container..
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
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
                        onChanged: filterStudents),
                  ),
                  //calendericon.....
                  GestureDetector(
                    onTap: () {
                      _selectDate(context, selectedGrade, selectedGradeSection);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/Attendancepage_calendar_icon.svg',
                      fit: BoxFit.contain,
                      height: 25,
                    ),
                  ),
                  //filter icons...
                  GestureDetector(
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
                  //import icon
                  GestureDetector(
                    onTap: () async {
                      print('Import clicked');
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx'],
                      );
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        var bytes = await file.readAsBytes();
                        var excel = Excel.decodeBytes(bytes);

                        importedData.clear();

                        for (var table in excel.tables.keys) {
                          print('Sheet: $table');
                          var rows = excel.tables[table]?.rows;

                          for (var row in rows!) {
                            if (row.isNotEmpty) {
                              String rollNumber =
                                  row[0]?.value.toString() ?? 'N/A';
                              String status = row[1]?.value.toString() ?? 'N/A';

                              importedData.add({
                                'rollNumber': rollNumber,
                                'status': status,
                              });

                              print(
                                  'Roll Number: $rollNumber, Status: $status');

                              for (var student in filteredStudents) {
                                if (student?.rollNumber == rollNumber) {
                                  setState(() {
                                    student?.attendanceAction = status;
                                  });
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/icons/Import_icon.svg',
                      fit: BoxFit.contain,
                      height: 20,
                      width: 20,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            //overall tab section...
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          border: Border.all(
                            color: Color.fromRGBO(150, 150, 150, 1),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //overall
                          GestureDetector(
                            onTap: () {
                              var formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now());
                              setState(() {
                                isoverall = true;
                                isabsent = false;
                                isleave = false;
                                islate = false;
                                status = 'overall';
                                _fetchAddgetAttendanceData(
                                    selectedGrade,
                                    selectedGradeSection,
                                    formattedDate,
                                    status);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color:
                                      isoverall ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                'Overall',
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 14,
                                    color: isoverall
                                        ? Color.fromRGBO(255, 247, 247, 1)
                                        : Color.fromRGBO(126, 126, 126, 1)),
                              ),
                            ),
                          ),
                          //absent
                          GestureDetector(
                            onTap: () {
                              var formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now());

                              setState(() {
                                isabsent = true;
                                isleave = false;
                                islate = false;
                                isoverall = false;
                                status = 'absent';
                                _fetchAddgetAttendanceData(
                                    selectedGrade,
                                    selectedGradeSection,
                                    formattedDate,
                                    status);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: isabsent ? Colors.black : Colors.white,
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
                              var formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now());
                              setState(() {
                                isoverall = false;
                                isabsent = false;
                                isleave = true;
                                islate = false;
                                status = 'leave';
                                _fetchAddgetAttendanceData(
                                    selectedGrade,
                                    selectedGradeSection,
                                    formattedDate,
                                    status);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: isleave ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
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
                          //late
                          GestureDetector(
                            onTap: () {
                              var formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now());
                              setState(() {
                                isoverall = false;
                                isabsent = false;
                                isleave = false;
                                islate = true;
                                status = 'late';
                                _fetchAddgetAttendanceData(
                                    selectedGrade,
                                    selectedGradeSection,
                                    formattedDate,
                                    status);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: islate ? Colors.black : Colors.white,
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
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  //export icons....
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () async {
                        print('export clicked');
                        _initializeNotification();

                        List<AddAttendenceGetModel> attendanceModels =
                            convertDetailsToAttendanceModels(filteredStudents);

                        exportAttendanceToExcel(attendanceModels);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/export_icon.svg',
                        fit: BoxFit.contain,
                        height: 24,
                        width: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //next section.....
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 250),
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: AppTheme.textFieldborderColor,
                    )),
                  )
                : FutureBuilder<AddAttendenceGetModel>(
                    future: _attendanceData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: AppTheme.textFieldborderColor,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No data available'));
                      }
                      var attendanceData = snapshot.data;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 15),
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
                                        color: Color.fromRGBO(234, 234, 234, 1),
                                      ),
                                    ),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      48, 126, 185, 1),
                                                  Color.fromRGBO(0, 70, 123, 1)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Text(
                                              "${attendanceData!.grade} - ${attendanceData.section}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'medium',
                                              ),
                                            ),
                                          ),
                                          // Grade and Section Info
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Class Teacher - ',
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          // Class Teacher Name
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 10),
                                            child: Text(
                                              attendanceData.classTeacher ??
                                                  'N/A',
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
                        ],
                      );
                    },
                  ),
            //listtile section.......
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.white,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      // var student = attendanceData?.details?[index];

                      var student = filteredStudents[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Card(
                          elevation: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Color.fromRGBO(238, 238, 238, 1))),
                            child: Column(
                              children: [
                                ListTile(
                                  horizontalTitleGap: 1,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
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
                                        padding: const EdgeInsets.only(left: 5),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            '${filteredStudents[index].studentPicture ?? ''}',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${filteredStudents[index].studentName ?? ''}',
                                        style: TextStyle(
                                          fontFamily: 'semibold',
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${filteredStudents[index].rollNumber ?? ''}',
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
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Attendance - ${filteredStudents[index].attendancePercent ?? ''}%',
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    54, 54, 54, 1),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              color: _getBackgroundColor(student
                                                  ?.attendanceAction
                                                  ?.toLowerCase()),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Text(
                                                student?.attendanceAction
                                                            ?.toLowerCase() ==
                                                        'no data'
                                                    ? 'Present'
                                                    : student
                                                            ?.attendanceAction ??
                                                        'Present',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'medium',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 5,
                                  color: Color.fromRGBO(245, 245, 245, 1),
                                  thickness: 1,
                                ),
                                //radio button...
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Radio(
                                              activeColor:
                                                  Color.fromRGBO(0, 106, 42, 1),
                                              value: 'Present',
                                              groupValue:
                                                  student?.attendanceAction,
                                              onChanged: (value) {
                                                if (student != null)
                                                  setState(() {
                                                    student!.attendanceAction =
                                                        value!;
                                                  });
                                              },
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Present',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      //absent
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Radio(
                                          activeColor:
                                              Color.fromRGBO(218, 0, 0, 1),
                                          value: 'Absent',
                                          groupValue: student?.attendanceAction,
                                          onChanged: (value) {
                                            setState(() {
                                              student?.attendanceAction =
                                                  value!;
                                            });
                                          },
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      Text(
                                        'Absent',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      //leave
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Radio(
                                          activeColor:
                                              Color.fromRGBO(59, 72, 213, 1),
                                          value: 'Leave',
                                          groupValue: student?.attendanceAction,
                                          onChanged: (value) {
                                            setState(() {
                                              student?.attendanceAction =
                                                  value!;
                                            });
                                          },
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      Text(
                                        'Leave',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                      //late
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Radio(
                                          activeColor:
                                              Color.fromRGBO(138, 9, 189, 1),
                                          value: 'Late',
                                          groupValue: student?.attendanceAction,
                                          onChanged: (value) {
                                            setState(() {
                                              student?.attendanceAction =
                                                  value!;
                                            });
                                          },
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      Text(
                                        'Late',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
      //save and cancel button....
      bottomNavigationBar: Card(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(120, 40),
                        backgroundColor: AppTheme.textFieldborderColor),
                    onPressed: () async {
                      var formattedDate =
                          DateFormat('dd-MM-yyyy').format(DateTime.now());

                      List<PostAddAttendence> addAttendanceData =
                          filteredStudents.map((student) {
                        return PostAddAttendence(
                          rollNumber: student.rollNumber!,
                          status: student.attendanceAction ?? 'present',
                        );
                      }).toList();

                      if (isUpdateAvailable == 'Y') {
                        List<PostUpdateAttendence> updateAttendanceData =
                            filteredStudents.map((student) {
                          return PostUpdateAttendence(
                            rollNumber: student.rollNumber!,
                            status: student.attendanceAction ?? 'present',
                          );
                        }).toList();

                        try {
                          await updateAttendance(
                            attendanceData!.grade!,
                            attendanceData!.section!,
                            formattedDate,
                            updateAttendanceData,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Attendance updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          //
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error updating attendance: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // Add attendance
                        try {
                          await postAttendance(
                            attendanceData!.grade!,
                            attendanceData!.section!,
                            formattedDate,
                            addAttendanceData,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Attendance Added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          //
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error adding attendance: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      isUpdateAvailable == 'Y' ? 'Update' : 'Save',
                      style: TextStyle(
                          fontFamily: 'semibold',
                          fontSize: 16,
                          color: Colors.black),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          fixedSize: Size(120, 40),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: 16,
                            color: Colors.black),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
