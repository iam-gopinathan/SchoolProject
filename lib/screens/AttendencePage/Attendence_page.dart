import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/models/Attendence_models/First_student_attendence_model.dart';
import 'package:flutter_application_1/models/Attendence_models/Sectionwise_barchart.dart';
import 'package:flutter_application_1/models/Attendence_models/Studentscounts_piechart.dart';
import 'package:flutter_application_1/models/Attendence_models/show_studentDetails.dart';
import 'package:flutter_application_1/screens/AttendencePage/Add_Attendence_page.dart';
import 'package:flutter_application_1/screens/AttendencePage/IrregularAttendencies.dart';
import 'package:flutter_application_1/services/Attendance_Api/First_student_Attendence.dart';
import 'package:flutter_application_1/services/Attendance_Api/Sectionwise_Barchart.dart';
import 'package:flutter_application_1/services/Attendance_Api/Show_student_details.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/Attendance_Api/studentscount_piechart.dart';

class AttendencePage extends StatefulWidget {
  final String username;
  final String userType;
  final String imagePath;
  AttendencePage(
      {super.key,
      required this.imagePath,
      required this.username,
      required this.userType});

  @override
  State<AttendencePage> createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {
  bool isLoading = true;
  //date picker....for total attendence....
  DateTime _selectedDate = DateTime.now();

  String getFormattedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM').format(date);
  }

  String getApiFormattedDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
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

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });

      await _loadAttendanceData();

      final String apiDate = getApiFormattedDate(_selectedDate);
      print('Formatted date for API: $apiDate');
    }
  }

  //total attendence graph...............................
  List<AttendanceModel> attendanceData = [];

  // Declare two separate scroll controllers
  final ScrollController _chartScrollController = ScrollController();
  final ScrollController _bottomLabelsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
    fetchsectionwiseData(selectedDate);

    _chartScrollController.addListener(() {
      if (_chartScrollController.offset !=
          _bottomLabelsScrollController.offset) {
        _bottomLabelsScrollController.jumpTo(_chartScrollController.offset);
      }
    });

    _bottomLabelsScrollController.addListener(() {
      if (_bottomLabelsScrollController.offset !=
          _chartScrollController.offset) {
        _chartScrollController.jumpTo(_bottomLabelsScrollController.offset);
      }
    });

    _attendanceData =
        fetchPiechartAttendanceData(widget.username, widget.userType);

    _initializeNotification();
  }
  //notification and excel convert code...

  //local notificationscode...
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

  Future<void> requestPermission(List<Student> filteredStudents) async {
    PermissionStatus status;

    if (await Permission.storage.isGranted) {
      status = PermissionStatus.granted;
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      exportToExcel(filteredStudents);
    } else if (await Permission.manageExternalStorage.isGranted) {
      exportToExcel(filteredStudents);
    } else {
      print("Permission denied. Please enable it from settings.");
      openAppSettings();
    }
  }

  Future<void> exportToExcel(List<Student> filteredStudents) async {
    await _showNotification('Export Started', 'Preparing to export data...');

    final excel = Excel.createExcel();

    // Create a new sheet named 'Sheet1'
    final sheet = excel['Sheet1'];

    // Add headers using TextCellValue
    sheet.appendRow([
      TextCellValue('Index'),
      TextCellValue('Name'),
      TextCellValue('Roll Number'),
      TextCellValue('Attendance %'),
      TextCellValue('Status'),
    ]);

    // Add student data using TextCellValue
    for (int i = 0; i < filteredStudents.length; i++) {
      Student student = filteredStudents[i];
      sheet.appendRow([
        TextCellValue((i + 1).toString()),
        TextCellValue(student.studentName),
        TextCellValue(student.rollNumber.toString()),
        TextCellValue('${student.attendancePercent}%'),
        TextCellValue(student.attendanceStatus),
      ]);
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
    String? selectedSection = 'A1';
    final filePath =
        '${downloadDir.path}/${selectedClass}_${selectedSection}.xlsx';
    // final fileName = '${selectedClass}_${selectedSection}_Data.xlsx';

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

//total attendence.......fetch.......
  Future<void> _loadAttendanceData() async {
    String rollNumber = widget.username;
    String userType = widget.userType;

    try {
      final response = await fetchAttendanceData(
        rollNumber,
        userType,
        _selectedDate,
      );
      setState(() {
        attendanceData = response.totalAttendanceGraph;
        print(attendanceData);
      });
    } catch (error) {
      print(error);
    }

    //progress bar
    // Add listener to update progress
    _chartScrollController.addListener(() {
      setState(() {
        double maxScroll = _chartScrollController.position.maxScrollExtent;
        double currentScroll = _chartScrollController.offset;

        // Calculate progress
        _progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      });
    });
  }

  ///linear progress indicator..
  double _progress = 0.0;

  @override
  void dispose() {
    _chartScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  //static left side...
  final List<String> leftTitles = ['100', '75', '50', '25', '0'];

  final List<Color> barColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.pink,
    Colors.brown,
    Colors.grey,
  ];

  //piechartsection...
  late Future<AttendanceData> _attendanceData;

  String displayedData = 'Tap a section to view details';

  String displayedCount = '';

  bool isTouched = false;

  bool isTouchedSecondary = false;

  String _getTitleForTouchedIndex(int touchedIndex) {
    switch (touchedIndex) {
      case 0:
        return "Overall Present";
      case 1:
        return "Overall Late";
      case 2:
        return "Overall Absent";
      case 3:
        return "Overall Leave";
      default:
        return "No Data Available";
    }
  }

  int touchedIndex = -1;

  int touchedIndexsecondary = -1;

  String displayedDatasecondary = '';
  String displayedCountsecondary = '';

  //dropdown select section code.........
  String? selectedClass;
  DateTime selectedDate = DateTime.now();
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

  ///section wise Api Date pass.......
  AttendanceDataModel? attendanceDataSections;

  Future<void> fetchsectionwiseData(DateTime selectedDate) async {
    if (selectedClass != null) {
      try {
        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

        String section = 'A1';

        final AttendanceDataModel data =
            await fetchsectionwise(formattedDate, selectedClass!, section);

        setState(() {
          attendanceDataSections = data;
        });

        print(
            "Fetched attendance data: ${attendanceDataSections?.detailedAttendance.map((e) => 'Section: ${e.section}, Percentage: ${e.percentage}')}");

        _showSectionBottomSheet();
      } catch (error) {
        print("Failed to fetch sectionwiseData: $error");
      }
    } else {
      print("Please select a class");
    }
  }

  ///section wise bottom sheetttttttttt................................................/////////////////////
  void _showSectionBottomSheet() {
    String? selectedSection = 'A1';
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      isScrollControlled: true,
      builder: (BuildContext context) {
        String? tempSelectedSection =
            selectedSection; // Local copy for BottomSheet
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
                height:
                    MediaQuery.of(context).size.height * 0.8, //overall height
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Detailed Attendance',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'semibold',
                              color: Colors.black),
                        ),
                      ),

                      /// Date picker.......
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary:
                                              AppTheme.textFieldborderColor,
                                          onPrimary: Colors.black,
                                          surface: Colors.black,
                                          onSurface: Colors.white,
                                        ),
                                        dialogBackgroundColor: Colors.black,
                                        textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ))),
                                    child: child!,
                                  );
                                });
                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              selectedDate = pickedDate;

                              final AttendanceDataModel data =
                                  await fetchsectionwise(
                                      DateFormat('dd-MM-yyyy')
                                          .format(selectedDate!),
                                      selectedClass!,
                                      'A1');
                              setModalState(() {
                                attendanceDataSections = data;
                              });
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
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  getFormattedDate(selectedDate),
                                  style: TextStyle(
                                    fontFamily: 'medium',
                                    color: Color.fromRGBO(73, 73, 73, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor:
                                        Color.fromRGBO(75, 75, 75, 1),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Section-wise bar chart
                      if (attendanceDataSections != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Card(
                            elevation: 1,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Total Attendance Graph',
                                          style: TextStyle(
                                              fontFamily: 'semibold',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        //section dropdown code......
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.black,
                                              menuMaxHeight: 150,
                                              value: selectedSection ?? 'A1',
                                              onChanged:
                                                  (String? newSection) async {
                                                if (newSection != null) {
                                                  setModalState(() {
                                                    selectedSection =
                                                        newSection;
                                                  });

                                                  final AttendanceDataModel
                                                      data =
                                                      await fetchsectionwise(
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate ??
                                                            DateTime.now()),
                                                    selectedClass!,
                                                    newSection,
                                                  );

                                                  setModalState(() {
                                                    attendanceDataSections =
                                                        data;
                                                  });
                                                }
                                              },
                                              items: attendanceDataSections
                                                      ?.detailedAttendance
                                                      .map((e) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: e.section,
                                                            child: Text(
                                                              e.section,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'regular',
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList() ??
                                                  [],
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        169, 169, 169, 1),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        169, 169, 169, 1),
                                                  ),
                                                ),
                                              ),
                                              hint: Text(
                                                'Select Section',
                                                style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black,
                                              ),
                                              selectedItemBuilder:
                                                  (BuildContext context) {
                                                return attendanceDataSections
                                                        ?.detailedAttendance
                                                        .map((e) {
                                                      return Text(
                                                        e.section,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'regular',
                                                          fontSize: 14,
                                                        ),
                                                      );
                                                    }).toList() ??
                                                    [];
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Attendance History',
                                      style: TextStyle(
                                          fontFamily: 'medium',
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25),
                                      child: Container(
                                        height: 150,
                                        child: BarChart(
                                          BarChartData(
                                            maxY: 100,
                                            gridData: FlGridData(
                                                horizontalInterval: 25,
                                                drawVerticalLine: false,
                                                show: true,
                                                drawHorizontalLine: true),
                                            titlesData: FlTitlesData(
                                              show: true,
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 30,
                                                  interval: 25,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return SideTitleWidget(
                                                      axisSide: meta.axisSide,
                                                      child: Text(
                                                        value
                                                            .toInt()
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(
                                                              85, 85, 85, 1),
                                                          fontFamily: 'medium',
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              rightTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    int index = value.toInt();
                                                    if (index <
                                                        attendanceDataSections!
                                                            .detailedAttendance
                                                            .length) {
                                                      return SideTitleWidget(
                                                        axisSide: meta.axisSide,
                                                        child: Text(
                                                          attendanceDataSections!
                                                              .detailedAttendance[
                                                                  index]
                                                              .section,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      );
                                                    }
                                                    return SizedBox.shrink();
                                                  },
                                                  reservedSize: 30,
                                                ),
                                              ),
                                            ),
                                            borderData:
                                                FlBorderData(show: false),
                                            barGroups: attendanceDataSections!
                                                .detailedAttendance
                                                .map((e) => BarChartGroupData(
                                                      x: attendanceDataSections!
                                                          .detailedAttendance
                                                          .indexOf(e),
                                                      barRods: [
                                                        BarChartRodData(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                          toY: e.percentage,
                                                          width: 25,
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color.fromRGBO(
                                                                  131,
                                                                  56,
                                                                  236,
                                                                  1),
                                                              Color.fromRGBO(74,
                                                                  32, 134, 1)
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${selectedClass}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'medium'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ///section details show details.......
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Card(
                          elevation: 1,
                          child: Container(
                            height: 250,
                            color: Colors.white,
                            child: Row(
                              children: [
                                //purple border....
                                Container(
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(176, 93, 208, 1),
                                        Color.fromRGBO(134, 0, 187, 1)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        //section..
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${selectedClass} -',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontFamily: 'medium',
                                                ),
                                              ),
                                              Text(
                                                '${selectedSection}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontFamily: 'medium',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //row section end...

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                        176, 93, 208, 1)
                                                    .withOpacity(0.2)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total Students - ${attendanceDataSections!.sectionDetails.totalStudents}',
                                                  style: TextStyle(
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(0, -10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      250, 245, 252, 1)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    'Male -${attendanceDataSections!.sectionDetails.male}',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    'Female -${attendanceDataSections!.sectionDetails.female}',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        //bullets points section....
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 20),
                                          child: Row(
                                            children: [
                                              //present
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromRGBO(
                                                        0, 150, 60, 1)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  'Present - ${attendanceDataSections!.sectionDetails.present}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'medium'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08,
                                              ),
                                              //leave
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromRGBO(
                                                              176, 93, 208, 1),
                                                          Color.fromRGBO(
                                                              134, 0, 187, 1),
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  'Leave - ${attendanceDataSections!.sectionDetails.leave}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'medium'),
                                                ),
                                              ),
                                              //present container...
                                              Transform.translate(
                                                offset: Offset(0, 10),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              Color.fromRGBO(0,
                                                                  150, 60, 1),
                                                              Color.fromRGBO(
                                                                  0, 130, 52, 1)
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter),
                                                      ),
                                                      child: Text(
                                                        '${(attendanceDataSections!.sectionDetails.presentPercentage ?? 0)}%',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 20),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        ///second row.....
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 20),
                                          child: Row(
                                            children: [
                                              //Absent
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromRGBO(
                                                        218, 0, 0, 1)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  'Absent - ${attendanceDataSections!.sectionDetails.absent}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'medium'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.09,
                                              ),
                                              //late....
                                              Container(
                                                height: 10,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromRGBO(
                                                        61, 73, 214, 1)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(
                                                  'Late - ${attendanceDataSections!.sectionDetails.late}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'medium'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //show students details.....
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(255, 179, 16, 1)),
                              onPressed: () {
                                var formattedDate = DateFormat('dd-MM-yyyy')
                                    .format(selectedDate);
                                _showStudentDetailsBottomSheet(
                                    context,
                                    selectedClass!,
                                    selectedSection!,
                                    selectedDate);

                                print(selectedSection);
                                print(selectedClass);
                                print(formattedDate);
                              },
                              child: Text(
                                'Show Student Details',
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 16,
                                    color: Colors.black),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ]);
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        selectedClass = null;
      });
    });
  }

  TextEditingController _searchController = TextEditingController();

  // Declare filteredStudents at the class level as well
  List<Student> filteredStudents = [];

  //showstudent bottom sheet section...............................................................

  void _showStudentDetailsBottomSheet(BuildContext context, String grade,
      String section, DateTime selectedDate) {
    var formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    //attendence bool........
    bool isoverall = true;
    bool isbelow75 = false;
    bool isabove75 = false;

    //selected color on show menu
    String _selectedFilter = "Overall";

    ////apicall code for overalll
    String percentage = "overall";
    String status = "overall";
//api calls
    ShowStudentdetails? showStudentdetails;

    bool isLoading = true;

    // Fetch initial data
    void fetchInitialData(Function setModalState) {
      fetchShowStudentDetails(
        date: formattedDate,
        grade: grade,
        section: section,
        percentage: "overall",
        status: "overall",
      ).then((data) {
        setModalState(() {
          showStudentdetails = data;
          filteredStudents = showStudentdetails?.data ?? [];
          isLoading = false;
        });
      }).catchError((error) {
        isLoading = false;
        print("Error fetching initial data: $error");
      });
    }

    ///menu item section end....
    Color _getContainerColor(String status) {
      switch (status) {
        case 'Present':
          return Color.fromRGBO(1, 133, 53, 1);
        case 'Absent':
          return Color.fromRGBO(216, 70, 0, 1);
        case 'Late':
          return Color.fromRGBO(61, 73, 214, 1);
        case 'Leave':
          return Color.fromRGBO(158, 53, 199, 1);
        default:
          return Colors.grey;
      }
    }

    //search
    // Filter students based on search query
    void _filterStudents(String query, Function setModalState) {
      final List<Student> allStudents = showStudentdetails?.data ?? [];

      if (query.isEmpty) {
        setModalState(() {
          filteredStudents = allStudents;
        });
      } else {
        final updatedFilteredStudents = allStudents
            .where((student) =>
                student.studentName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                student.rollNumber!.toLowerCase().contains(query.toLowerCase()))
            .toList();

        setModalState(() {
          filteredStudents = updatedFilteredStudents;
        });
      }
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            if (isoverall && showStudentdetails == null) {
              fetchInitialData(setModalState);
            }

            // Function to show the filter menu
            void _showFilterMenu(BuildContext context) {
              showMenu(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.black,
                context: context,
                position: RelativeRect.fromLTRB(100, 240, 20, 0),
                items: [
                  // Overall Filter
                  PopupMenuItem(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    height: 40,
                    child: SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _selectedFilter = "Overall";
                            status = "overall";
                            isLoading = true;

                            // Ensure the data is fetched again after filter change
                            print('Fetching data with status: $status');
                            print('heloooooo');
                            showStudentdetails = null;
                            fetchShowStudentDetails(
                              date: formattedDate,
                              grade: grade,
                              section: section,
                              percentage: percentage,
                              status: status,
                            ).then((data) {
                              setModalState(() {
                                isLoading = false;
                                showStudentdetails = data;
                                filteredStudents =
                                    showStudentdetails?.data ?? [];
                                print("Fetched data: $showStudentdetails");
                              });
                            }).catchError((error) {
                              isLoading = false;
                              print("Error fetching data: $error");
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedFilter == "Overall"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 12, color: Colors.orange),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Overall",
                                    style: TextStyle(
                                      color: _selectedFilter == "Overall"
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Present Filter
                  PopupMenuItem(
                    height: 40,
                    child: SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            isLoading = true;
                            showStudentdetails = null;
                            _selectedFilter = "Present";
                            status = 'present';

                            showStudentdetails = null;

                            fetchShowStudentDetails(
                              date: formattedDate,
                              grade: grade,
                              section: section,
                              percentage: percentage,
                              status: status,
                            ).then((data) {
                              setModalState(() {
                                isLoading = false;
                                showStudentdetails = data;
                                filteredStudents =
                                    showStudentdetails?.data ?? [];
                              });
                            }).catchError((error) {
                              isLoading = false;
                              print("Error fetching data: $error");
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: _selectedFilter == "Present"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 12, color: Colors.green),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Present",
                                    style: TextStyle(
                                      color: _selectedFilter == "Present"
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Absent Filter
                  PopupMenuItem(
                    height: 40,
                    child: SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            isLoading = true;
                            showStudentdetails = null;
                            _selectedFilter = "Absent";
                            status = 'absent';

                            fetchShowStudentDetails(
                              date: formattedDate,
                              grade: grade,
                              section: section,
                              percentage: percentage,
                              status: status,
                            ).then((data) {
                              setModalState(() {
                                isLoading = false;
                                showStudentdetails = data;
                                filteredStudents =
                                    showStudentdetails?.data ?? [];
                              });
                            }).catchError((error) {
                              isLoading = false;
                              print("Error fetching data: $error");
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: _selectedFilter == "Absent"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 12, color: Colors.red),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Absent",
                                    style: TextStyle(
                                      color: _selectedFilter == "Absent"
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Leave Filter
                  PopupMenuItem(
                    height: 40,
                    child: SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            isLoading = true;
                            showStudentdetails = null;
                            _selectedFilter = "Leave";
                            status = 'leave';

                            fetchShowStudentDetails(
                              date: formattedDate,
                              grade: grade,
                              section: section,
                              percentage: percentage,
                              status: status,
                            ).then((data) {
                              setModalState(() {
                                isLoading = false;
                                showStudentdetails = data;
                                filteredStudents =
                                    showStudentdetails?.data ?? [];
                              });
                            }).catchError((error) {
                              isLoading = false;
                              print("Error fetching data: $error");
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: _selectedFilter == "Leave"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 12, color: Colors.purple),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Leave",
                                    style: TextStyle(
                                      color: _selectedFilter == "Leave"
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Late Filter
                  PopupMenuItem(
                    height: 40,
                    child: SizedBox(
                      width: 150,
                      child: GestureDetector(
                        onTap: () {
                          setModalState(() {
                            isLoading = true;
                            showStudentdetails = null;
                            _selectedFilter = "Late";
                            status = 'late';

                            fetchShowStudentDetails(
                              date: formattedDate,
                              grade: grade,
                              section: section,
                              percentage: percentage,
                              status: status,
                            ).then((data) {
                              setModalState(() {
                                isLoading = false;
                                showStudentdetails = data;
                                filteredStudents =
                                    showStudentdetails?.data ?? [];
                              });
                            }).catchError((error) {
                              isLoading = false;
                              print("Error fetching data: $error");
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: _selectedFilter == "Late"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 12, color: Colors.blue),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "Late",
                                    style: TextStyle(
                                      color: _selectedFilter == "Late"
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                elevation: 8.0,
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //search container row...
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      hintText:
                                          'Student by Name or Roll Number',
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
                                          color:
                                              Color.fromRGBO(150, 150, 150, 1),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(150, 150, 150, 1),
                                        ),
                                      ),
                                    ),
                                    onChanged: (query) {
                                      _filterStudents(query, setModalState);
                                    }),
                              ),
                              //filter icons...
                              Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showFilterMenu(context);
                                    });
                                  },
                                  child: SvgPicture.asset(
                                      'assets/icons/Filter_icon.svg',
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
                                  requestPermission(filteredStudents);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 14),
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

                          ///nextsection.........
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Row(
                              children: [
                                Text(
                                  'Attendance',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(150, 150, 150, 1),
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        //overall
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(
                                              () {
                                                isoverall = true;
                                                isbelow75 = false;
                                                isabove75 = false;
                                                isLoading = true;

                                                percentage = "overall";
                                                status = "overall";

                                                // Fetch data for "Overall"
                                                fetchShowStudentDetails(
                                                  date: formattedDate,
                                                  grade: grade,
                                                  section: section,
                                                  percentage: percentage,
                                                  status: status,
                                                ).then((data) {
                                                  setModalState(() {
                                                    isLoading = false;
                                                    showStudentdetails = data;
                                                    // Reset filteredStudents to match the new data
                                                    filteredStudents =
                                                        showStudentdetails
                                                                ?.data ??
                                                            [];
                                                  });
                                                }).catchError((error) {
                                                  isLoading = false;
                                                  print(
                                                      "Error fetching data: $error");
                                                });
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: isoverall
                                                    ? Colors.black
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Text(
                                              'Overall',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: isoverall
                                                      ? Color.fromRGBO(
                                                          255, 247, 247, 1)
                                                      : Color.fromRGBO(
                                                          126, 126, 126, 1)),
                                            ),
                                          ),
                                        ),
                                        //below75
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              isoverall = false;
                                              isbelow75 = true;
                                              isabove75 = false;
                                              isLoading = true;
                                              // Set percentage and status for "below 75"
                                              percentage = "below75";
                                              status = "overall";

                                              // Fetch data for "Below 75"
                                              fetchShowStudentDetails(
                                                date: formattedDate,
                                                grade: grade,
                                                section: section,
                                                percentage: percentage,
                                                status: status,
                                              ).then((data) {
                                                setModalState(() {
                                                  isLoading = false;
                                                  showStudentdetails = data;
                                                  // Reset filteredStudents to match the new data
                                                  filteredStudents =
                                                      showStudentdetails
                                                              ?.data ??
                                                          [];
                                                });
                                              }).catchError((error) {
                                                isLoading = false;
                                                print(
                                                    "Error fetching data: $error");
                                              });
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: isbelow75
                                                    ? Colors.black
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Text(
                                              'Below 75%',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: isbelow75
                                                      ? Color.fromRGBO(
                                                          255, 247, 247, 1)
                                                      : Color.fromRGBO(
                                                          126, 126, 126, 1)),
                                            ),
                                          ),
                                        ),
                                        //above75
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              isLoading = true;
                                              isoverall = false;
                                              isbelow75 = false;
                                              isabove75 = true;
                                              // Set percentage and status for "above 75"
                                              percentage = "above75";
                                              status = "overall";

                                              // Fetch data for "Above 75"
                                              fetchShowStudentDetails(
                                                date: formattedDate,
                                                grade: grade,
                                                section: section,
                                                percentage: percentage,
                                                status: status,
                                              ).then((data) {
                                                setModalState(() {
                                                  isLoading = false;
                                                  showStudentdetails = data;
                                                  // Reset filteredStudents to match the new data
                                                  filteredStudents =
                                                      showStudentdetails
                                                              ?.data ??
                                                          [];
                                                });
                                              }).catchError((error) {
                                                isLoading = false;
                                                print(
                                                    "Error fetching data: $error");
                                              });
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                                color: isabove75
                                                    ? Colors.black
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Text(
                                              'Above 75%',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: isabove75
                                                      ? Color.fromRGBO(
                                                          255, 247, 247, 1)
                                                      : Color.fromRGBO(
                                                          126, 126, 126, 1)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          //listtile top sections...
                          Transform.translate(
                            offset: Offset(0, 12),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(234, 234, 234, 1))),
                                child: IntrinsicWidth(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (showStudentdetails != null)
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10)),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(
                                                        176, 93, 208, 1),
                                                    Color.fromRGBO(
                                                        134, 0, 187, 1)
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: Text(
                                            "${showStudentdetails!.grade} -${showStudentdetails!.section}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'medium'),
                                          ),
                                        ),
                                      if (showStudentdetails != null)
                                        //class teacher....
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 10),
                                          child: Text(
                                            'Class Teacher - ${showStudentdetails?.classTeacher}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'medium',
                                                fontSize: 14),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
//listtile code.....

                          Container(
                            child: isLoading
                                ? Container(
                                    height: 500,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: AppTheme.textFieldborderColor,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: filteredStudents.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      238, 238, 238, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          tileColor: Colors.white,
                                          leading: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                    '${filteredStudents[index].studentPicture}',
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
                                                '${filteredStudents[index].studentName}',
                                                style: TextStyle(
                                                    fontFamily: 'semibold',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${filteredStudents[index].rollNumber}',
                                                style: TextStyle(
                                                    fontFamily: 'semibold',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Student History',
                                                    style: TextStyle(
                                                        fontFamily: 'regular',
                                                        fontSize: 14,
                                                        color: Colors.black),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.27,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Attendance ${filteredStudents[index].attendancePercent}%',
                                                      style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(
                                                              54, 54, 54, 1)),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: _getContainerColor(
                                                          '${filteredStudents[index].attendanceStatus}'),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${filteredStudents[index].attendanceStatus}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

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
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: AppTheme.appBackgroundPrimaryColor,
        title: Text(
          'Attendance',
          style: TextStyle(
              fontFamily: 'semibold', fontSize: 16, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //student attendence first section..
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Student Attendence',
                      style: TextStyle(
                          fontFamily: 'semibold',
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAttendencePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppTheme.Addiconcolor,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //student icon section...
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        getFormattedDate(_selectedDate),
                        style: TextStyle(
                          fontFamily: 'medium',
                          color: Color.fromRGBO(73, 73, 73, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          decorationColor: Color.fromRGBO(75, 75, 75, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //total students graph.............
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Card(
                elevation: 1,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Total Attendance Graph',
                                      style: TextStyle(
                                          fontFamily: 'semibold',
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),

                                    ///dropdown code...
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 52, right: 10),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: DropdownButtonFormField<String>(
                                          value: selectedClass,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedClass = newValue;
                                              fetchsectionwiseData(
                                                  selectedDate!);
                                            });
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 25),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        169, 169, 169, 1))),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Color.fromRGBO(
                                                        169, 169, 169, 1))),
                                          ),
                                          dropdownColor: Colors.black,
                                          menuMaxHeight: 150,
                                          items: classes.map((className) {
                                            return DropdownMenuItem<String>(
                                              value: className,
                                              child: Text(
                                                className,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'regular'),
                                              ),
                                            );
                                          }).toList(),
                                          hint: Text(
                                            "Select Class",
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                          selectedItemBuilder:
                                              (BuildContext context) {
                                            return classes.map((className) {
                                              return Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                                  child: Text(
                                                    className,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'regular'),
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Attendance History',
                                      style: TextStyle(
                                          fontFamily: 'medium',
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(0, -15),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                width: 60,
                                child: Column(
                                  children: leftTitles.map((title) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _chartScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  height: 200,
                                  width: 700,
                                  color: Colors.white,
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceEvenly,
                                      barGroups: attendanceData.map((e) {
                                        int index = attendanceData.indexOf(e);
                                        Color barColor =
                                            barColors[index % barColors.length];
                                        return BarChartGroupData(
                                          x: index,
                                          barRods: [
                                            BarChartRodData(
                                              toY: double.parse(e.percentage),
                                              color: barColor,
                                              width: 25,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            interval: 1,
                                            showTitles: false,
                                            reservedSize: 45,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                value.toInt().toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 35,
                                            getTitlesWidget: (value, meta) {
                                              final index = value.toInt();
                                              if (index < 0 ||
                                                  index >=
                                                      attendanceData.length) {
                                                return const SizedBox.shrink();
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  attendanceData[index].grade,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'medium',
                                                      color: Colors.black),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                          showTitles: false,
                                        )),
                                        rightTitles: AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: FlGridData(
                                          show: true, horizontalInterval: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            color: Colors.white,
                            width: 60,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _bottomLabelsScrollController,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  //nursery...
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(131, 56, 236, 1),
                                          Color.fromRGBO(74, 32, 134, 1)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(fontFamily: 'medium'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Nursery',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  //primary
                                  SizedBox(
                                    width: 150,
                                  ),
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(176, 93, 208, 1),
                                          Color.fromRGBO(134, 0, 187, 1)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Primary',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  //secondary
                                  SizedBox(
                                    width: 150,
                                  ),
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(252, 170, 103, 1),
                                          Color.fromRGBO(206, 92, 0, 1)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(fontFamily: 'medium'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Secondary',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 150,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: 60,
                          height: 5,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Color.fromRGBO(225, 225, 225, 1),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            value: _progress,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
            //Irregular attendeessection....
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 15),
                        child: Row(
                          children: [
                            Text(
                              'Irregular attendees',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                'Overall',
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      //
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      //absent student...
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Irregularattendencies(
                                        initialTab: 'Absent',
                                        selectedClass: 'overall',
                                        selectedSection: 'overall',
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 0, 4, 0.05),
                                borderRadius: BorderRadius.circular(10)),
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(218, 0, 0, 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                  ),
                                  Text(
                                    'Absent Students',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'medium',
                                        color: Colors.black),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                      color: Color.fromRGBO(218, 0, 0, 1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //leave student...
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Irregularattendencies(
                                        initialTab: 'Leave',
                                        selectedClass: 'overall',
                                        selectedSection: 'overall',
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(89, 100, 219, 0.04),
                                borderRadius: BorderRadius.circular(10)),
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(59, 72, 213, 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                  ),
                                  Text(
                                    'Leave Students',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'medium',
                                        color: Colors.black),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                      color: Color.fromRGBO(59, 72, 213, 1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //late students..
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Irregularattendencies(
                                        initialTab: 'Late',
                                        selectedClass: 'overall',
                                        selectedSection: 'overall',
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(176, 93, 208, 0.05),
                                borderRadius: BorderRadius.circular(10)),
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(138, 9, 189, 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                  ),
                                  Text(
                                    'Late Students',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'medium',
                                        color: Colors.black),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                      color: Color.fromRGBO(138, 9, 189, 1),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.009,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //piechart sections......
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, top: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Students Counts',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                'Overall',
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                        FutureBuilder<AttendanceData>(
                          future: _attendanceData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: AppTheme.textFieldborderColor,
                              ));
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData) {
                              return Center(child: Text('No Data Available'));
                            }

                            final data = snapshot.data!;

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    // Nursery/Primary Pie Chart........
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 250,
                                            padding: EdgeInsets.all(10),
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (FlTouchEvent event,
                                                          pieTouchResponse) {
                                                    if (event is FlTapUpEvent) {
                                                      setState(() {
                                                        touchedIndexsecondary =
                                                            pieTouchResponse
                                                                    ?.touchedSection
                                                                    ?.touchedSectionIndex ??
                                                                -1;

                                                        if (touchedIndexsecondary ==
                                                            0) {
                                                          displayedData =
                                                              'Present Students: ';
                                                          displayedCount =
                                                              '${data.nurseryPrimary.overallPresent.count}';
                                                        } else if (touchedIndexsecondary ==
                                                            1) {
                                                          displayedData =
                                                              'Late Students: ';
                                                          displayedCount =
                                                              '${data.nurseryPrimary.overallLate.count}';
                                                        } else if (touchedIndexsecondary ==
                                                            2) {
                                                          displayedData =
                                                              'Absent Students: ';
                                                          displayedCount =
                                                              '${data.nurseryPrimary.overallAbsent.count}';
                                                        } else if (touchedIndexsecondary ==
                                                            3) {
                                                          displayedData =
                                                              'Leave Students: ';
                                                          displayedCount =
                                                              '${data.nurseryPrimary.overallLeave.count}';
                                                        } else {
                                                          displayedData =
                                                              'No data available';
                                                        }

                                                        isTouchedSecondary =
                                                            true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isTouchedSecondary =
                                                            false;
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 2),
                                                            () {
                                                          setState(() {
                                                            isTouchedSecondary =
                                                                false;
                                                          });
                                                        });
                                                      });
                                                    }
                                                  },
                                                  enabled: true,
                                                ),
                                                centerSpaceColor: Colors.white,
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 60,
                                                startDegreeOffset: 0,
                                                sections: [
                                                  PieChartSectionData(
                                                    showTitle: true,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            0, 150, 60, 1),
                                                        Color.fromRGBO(
                                                            0, 207, 83, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    value: double.parse(data
                                                        .nurseryPrimary
                                                        .overallPresent
                                                        .percentage),
                                                    color: Color.fromRGBO(
                                                        0, 150, 60, 1),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                  PieChartSectionData(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            138, 9, 189, 1),
                                                        Color.fromRGBO(
                                                            64, 4, 87, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    value: double.parse(data
                                                        .nurseryPrimary
                                                        .overallLate
                                                        .percentage),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                  PieChartSectionData(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            218, 0, 0, 1),
                                                        Color.fromRGBO(
                                                            116, 0, 0, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    value: double.parse(data
                                                        .nurseryPrimary
                                                        .overallAbsent
                                                        .percentage),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                  PieChartSectionData(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            59, 72, 213, 1),
                                                        Color.fromRGBO(
                                                            31, 38, 111, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    value: double.parse(data
                                                        .nurseryPrimary
                                                        .overallLeave
                                                        .percentage),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Center label for Nursery/Primary...
                                          Positioned(
                                            top: 120,
                                            child: Text(
                                              'Nursery & Primary',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Positioned(
                                            top: 140,
                                            child: Text(
                                              '(PreKG - Grade V)',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    71, 71, 71, 1),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),

//total students...
                                          Positioned(
                                            top: 90,
                                            child: Text(
                                              '${data.nurseryPrimary.overallPresent.totalStudents}',
                                              style: TextStyle(
                                                  fontFamily: 'semibold',
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          ),
//bar touch data code...
                                          Positioned(
                                            bottom: 80,
                                            child: isTouchedSecondary
                                                ? Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _getTitleForTouchedIndex(
                                                              touchedIndex),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'medium',
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 5,
                                                              height: 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 2),
                                                              child: Text(
                                                                "Total Students (${data.totalSchoolStudents})",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'medium',
                                                                ),
                                                              ),
                                                            ),
                                                            //round circle....
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            12),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            191,
                                                                            76,
                                                                            1)),
                                                                child: Text(
                                                                  displayedCount,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'medium',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 5,
                                                              height: 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: touchedIndex ==
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : touchedIndex ==
                                                                            1
                                                                        ? Color.fromRGBO(
                                                                            138,
                                                                            9,
                                                                            189,
                                                                            1)
                                                                        : touchedIndex ==
                                                                                2
                                                                            ? Color.fromRGBO(
                                                                                218,
                                                                                0,
                                                                                0,
                                                                                1)
                                                                            : touchedIndex == 3
                                                                                ? Color.fromRGBO(59, 72, 213, 1)
                                                                                : Colors.transparent,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 3),
                                                              child: Text(
                                                                displayedData,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'medium',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    // Secondary Pie Chart......
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 250,
                                            padding: EdgeInsets.all(10),
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (FlTouchEvent event,
                                                          pieTouchResponse) {
                                                    if (event is FlTapUpEvent) {
                                                      setState(() {
                                                        touchedIndex = pieTouchResponse
                                                                ?.touchedSection
                                                                ?.touchedSectionIndex ??
                                                            -1;

                                                        if (touchedIndex == 0) {
                                                          displayedDatasecondary =
                                                              'Present Students: ';
                                                          displayedCountsecondary =
                                                              '${data.secondary.overallPresent.count}';
                                                        } else if (touchedIndex ==
                                                            1) {
                                                          displayedDatasecondary =
                                                              'Late Students: ';
                                                          displayedCountsecondary =
                                                              '${data.secondary.overallLate.count}';
                                                        } else if (touchedIndex ==
                                                            2) {
                                                          displayedDatasecondary =
                                                              'Absent Students: ';
                                                          displayedCountsecondary =
                                                              '${data.secondary.overallAbsent.count}';
                                                        } else if (touchedIndex ==
                                                            3) {
                                                          displayedDatasecondary =
                                                              'Leave Students: ';
                                                          displayedCountsecondary =
                                                              '${data.secondary.overallLeave.count}';
                                                        } else {
                                                          displayedData =
                                                              'No data available';
                                                        }

                                                        isTouched = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isTouched = false;
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 2),
                                                            () {
                                                          setState(() {
                                                            isTouched = false;
                                                          });
                                                        });
                                                      });
                                                    }
                                                  },
                                                  enabled: true,
                                                ),
                                                centerSpaceColor: Colors.white,
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 60,
                                                sections: [
                                                  PieChartSectionData(
                                                    value: double.parse(data
                                                        .secondary
                                                        .overallPresent
                                                        .percentage),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            0, 150, 60, 1),
                                                        Color.fromRGBO(
                                                            0, 207, 83, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                  PieChartSectionData(
                                                    value: double.parse(data
                                                        .secondary
                                                        .overallLate
                                                        .percentage),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            138, 9, 189, 1),
                                                        Color.fromRGBO(
                                                            64, 4, 87, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                  PieChartSectionData(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            218, 0, 0, 1),
                                                        Color.fromRGBO(
                                                            116, 0, 0, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    value: double.parse(data
                                                        .secondary
                                                        .overallAbsent
                                                        .percentage),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                  PieChartSectionData(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            59, 72, 213, 1),
                                                        Color.fromRGBO(
                                                            31, 38, 111, 1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomLeft,
                                                    ),
                                                    value: double.parse(data
                                                        .secondary
                                                        .overallLeave
                                                        .percentage),
                                                    title: '',
                                                    radius: 35,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Center label for Secondary
                                          Text(
                                            'Secondary',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          Positioned(
                                            top: 85,
                                            child: Text(
                                              '${data.secondary.overallPresent.totalStudents}',
                                              style: TextStyle(
                                                  fontFamily: 'semibold',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          ),

                                          Positioned(
                                            top: 132,
                                            child: Text(
                                              '(Grade IV - Grade X)',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 10,
                                                  color: Color.fromRGBO(
                                                      71, 71, 71, 1)),
                                            ),
                                          ),

                                          ///bar touch data .......
                                          Positioned(
                                            bottom: 80,
                                            child: isTouched
                                                ? Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _getTitleForTouchedIndex(
                                                              touchedIndex),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'medium',
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 5,
                                                              height: 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 2),
                                                              child: Text(
                                                                "Total Students (${data.totalSchoolStudents})",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'medium',
                                                                ),
                                                              ),
                                                            ),
                                                            //round circle....
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            12),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            191,
                                                                            76,
                                                                            1)),
                                                                child: Text(
                                                                  displayedCountsecondary,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'medium',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 5,
                                                              height: 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: touchedIndex ==
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : touchedIndex ==
                                                                            1
                                                                        ? Color.fromRGBO(
                                                                            138,
                                                                            9,
                                                                            189,
                                                                            1)
                                                                        : touchedIndex ==
                                                                                2
                                                                            ? Color.fromRGBO(
                                                                                218,
                                                                                0,
                                                                                0,
                                                                                1)
                                                                            : touchedIndex == 3
                                                                                ? Color.fromRGBO(59, 72, 213, 1)
                                                                                : Colors.transparent,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 3),
                                                              child: Text(
                                                                displayedDatasecondary,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'medium',
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Total Students \n(Nursery,Primary & Secondary Classes) -${data.totalSchoolStudents ?? ''}',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),

                        ///

                        ///bullets points row...
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(0, 150, 601, 1),
                                            Color.fromRGBO(0, 207, 83, 1)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              Text(
                                'Present',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'medium'),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(218, 0, 0, 1),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              Text(
                                'Absent',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'medium'),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04),

                              ///leave
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(59, 72, 213, 1),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              Text(
                                'Leave',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'medium'),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04),

                              //late...
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(138, 9, 189, 1),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              Text(
                                'Late',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontFamily: 'medium'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
          ],
        ),
      ),
    );
  }
}
