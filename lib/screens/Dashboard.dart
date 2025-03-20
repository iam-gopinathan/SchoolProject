import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_StudentsAttendance.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_circularsection.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_teacherAttendance.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_teacherBirthday.dart';
import 'package:flutter_application_1/models/Dashboard_models/dashboard_Management_count.dart';
import 'package:flutter_application_1/models/Dashboard_models/dashboard_newsModel.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
import 'package:flutter_application_1/screens/ApprovalScreen/ApprovalMenu_Page.dart';
import 'package:flutter_application_1/screens/AttendencePage/Attendence_page.dart';
import 'package:flutter_application_1/screens/Communication.dart';
import 'package:flutter_application_1/screens/Feedback/feedback_mainpage.dart';
import 'package:flutter_application_1/screens/Myprojects_screens/Myproject_menu.dart';
import 'package:flutter_application_1/screens/News/NewsMainPage.dart';
import 'package:flutter_application_1/screens/Reset_Passwordscreen.dart';
import 'package:flutter_application_1/screens/circularPage/circular_mainPage.dart';
import 'package:flutter_application_1/screens/loginscreen.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_Newssection.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_StudentAttendance.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_TeacherAttendance.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_circularsection.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_teachersBirthday.dart';
import 'package:flutter_application_1/services/dashboard_API/dashboard_managementsection_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:speech_balloon/speech_balloon.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String userType;
  final String imagePath;
  final List<NewsArticle> newsArticles;

  Dashboard(
      {super.key,
      required this.username,
      required this.userType,
      required this.imagePath,
      required this.newsArticles});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardManagementCount? dashboardManagementCount;

  int _activeIndex = 0;

// firstsection menu...............
  final List<String> _menuItems = [
    'Dashboard',
    'Communication',
    'Transport',
    'ERP',
    'Academic',
  ];

  //birthday section..................
  String? selectedValue = 'Teaching';
  List<String> options = [
    'Teaching',
    'Support',
    'Administrative',
    'Operational',
    'ECA',
  ];
  List<Birthday> birthdayList = [];
  void _loadBirthdayData() async {
    List<Birthday> fetchedBirthdays = await fetchBirthdayData(selectedValue!);
    setState(() {
      birthdayList = fetchedBirthdays;
      print(birthdayList);
    });
  }

  List<List<Birthday>> _chunkList(List<Birthday> list, int chunkSize) {
    List<List<Birthday>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);

    selectedValue = options[0];
    widget.imagePath;
    widget.username;
    widget.imagePath;
    print(widget.imagePath);
    print(widget.username);
    print(widget.userType);
    fetchDashboardData();
    fetchNewsData();
    fetchCircular();
    _loadBirthdayData();
    _loadAttendanceData();
    _futureAttendanceData = fetchTeacherAttendance();

    fetchStudentsAttendanceData();

    studentAttendanceModel = StudentAttendanceModel(
      preKgAttendance: [],
      lkgAttendance: [],
      ukgAttendance: [],
      grade1Attendance: [],
      grade2Attendance: [],
      grade3Attendance: [],
      grade4Attendance: [],
      grade5Attendance: [],
      grade6Attendance: [],
      grade7Attendance: [],
      grade8Attendance: [],
      grade9Attendance: [],
      grade10Attendance: [],
    );

    _linearprogresscontroller.addListener(() {
      setState(() {
        double progress = _linearprogresscontroller.offset /
            (_linearprogresscontroller.position.maxScrollExtent);

        _progress = progress.clamp(0.0, 1.0);
      });
    });
  }

  void _scrollListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

//management section count.......
  Future<void> fetchDashboardData() async {
    try {
      String rollNumber = widget.username;
      String userType = widget.userType;
      dashboardManagementCount =
          await fetchDashboardCount(rollNumber, userType);

      print(fetchDashboardCount(rollNumber, userType));
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      setState(() {});
    }
  }

  //newssection.........
  int _currentIndex = 0;
  List<News> newsList = [];
  Future<void> fetchNewsData() async {
    try {
      String rollNumber = widget.username;
      String userType = widget.userType;
      final data = await fetchDashboardNews(rollNumber, userType);
      setState(() {
        newsList = data;
      });
    } catch (e) {
      print("Failed to fetch news: $e");
    }
  }

  //circular section..........
  int _circulars_currentindex = 0;
  List<Circular> circularList = [];
  Future<void> fetchCircular() async {
    try {
      String rollNumber = widget.username;
      String userType = widget.userType;
      final data = await fetchCirculars(rollNumber, userType);
      setState(() {
        circularList = data;
      });
      print("Updated circularList: $circularList");
    } catch (e) {
      print("Failed to fetch circular: $e");
    }
  }

  //graph section teacher attendance....
  String selectedButton = "Students";
  late Future<List<TeacherAttendance>> _futureAttendanceData;
  List<TeacherAttendance> attendanceData = [];
  Future<void> _loadAttendanceData() async {
    try {
      attendanceData = await fetchTeacherAttendance();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {});
    }
  }

  ///students chart section......
  int selectedTab = 0;
  late StudentAttendanceModel studentAttendanceModel;

  final List<String> leftTitles = ['100', '75', '50', '25', '0'];

  List<StudentAttendanceModel> studentAttendance = [];

  Future<void> fetchStudentsAttendanceData() async {
    try {
      StudentAttendanceModel model = await FetchStudentsAttendance();
      setState(() {
        studentAttendanceModel = model;
      });
    } catch (e) {
      print("Failed to load data: $e");
    }
  }

  List<BarChartGroupData> getBarGroups() {
    List<BarChartGroupData> barGroups = [];
    Map<String, List<StudentAttendance>> attendanceData = {
      'pre_kg_attendance': studentAttendanceModel.preKgAttendance,
      'lkg_attendance': studentAttendanceModel.lkgAttendance,
      'ukg_attendance': studentAttendanceModel.ukgAttendance,
      'grade1_attendance': studentAttendanceModel.grade1Attendance,
      'grade2_attendance': studentAttendanceModel.grade2Attendance,
      'grade3_attendance': studentAttendanceModel.grade3Attendance,
      'grade4_attendance': studentAttendanceModel.grade4Attendance,
      'grade5_attendance': studentAttendanceModel.grade5Attendance,
      'grade6_attendance': studentAttendanceModel.grade6Attendance,
      'grade7_attendance': studentAttendanceModel.grade7Attendance,
      'grade8_attendance': studentAttendanceModel.grade8Attendance,
      'grade9_attendance': studentAttendanceModel.grade9Attendance,
      'grade10_attendance': studentAttendanceModel.grade10Attendance,
    };

    Map<String, List<Color>> colorMapping = {
      'pre_kg_attendance': [
        Color.fromRGBO(74, 32, 134, 1),
        Color.fromRGBO(131, 56, 236, 1)
      ],
      'lkg_attendance': [
        Color.fromRGBO(0, 132, 125, 1),
        Color.fromRGBO(0, 173, 164, 1)
      ],
      'ukg_attendance': [
        Color.fromRGBO(216, 70, 0, 1),
        Color.fromRGBO(251, 85, 6, 1)
      ],
      'grade1_attendance': [
        Color.fromRGBO(74, 32, 134, 1),
        Color.fromRGBO(131, 56, 236, 1)
      ],
      'grade2_attendance': [
        Color.fromRGBO(0, 132, 125, 1),
        Color.fromRGBO(0, 173, 164, 1)
      ],
      'grade3_attendance': [
        Color.fromRGBO(216, 70, 0, 1),
        Color.fromRGBO(251, 85, 6, 1)
      ],
      'grade4_attendance': [Colors.teal, Colors.greenAccent],
      'grade5_attendance': [Colors.pink, Colors.pinkAccent],
      'grade6_attendance': [Colors.brown, Colors.deepPurple],
      'grade7_attendance': [Colors.cyan, Colors.lightBlue],
      'grade8_attendance': [Colors.indigo, Colors.blueAccent],
      'grade9_attendance': [Colors.lime, Colors.green],
      'grade10_attendance': [Colors.amber, Colors.orangeAccent],
    };

    if (selectedTab == 0) {
      List<String> levels = [
        'pre_kg_attendance',
        'lkg_attendance',
        'ukg_attendance'
      ];
      for (int i = 0; i < levels.length; i++) {
        String level = levels[i];
        List<StudentAttendance> sections = attendanceData[level] ?? [];

        print(level);
        for (var section in sections) {
          print(
              'Section: ${section.section}, Present: ${section.present}, Total: ${section.total}, Percentage: ${section.percentage}');
        }
        barGroups.add(
          BarChartGroupData(
            barsSpace: 10,
            x: i,
            barRods: sections.map((section) {
              return BarChartRodData(
                toY: section.present.toDouble(),
                borderRadius: BorderRadius.zero,
                width: 20,
                color: null,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: colorMapping[level] ?? [Colors.black, Colors.black],
                ),
              );
            }).toList(),
          ),
        );
      }
    } else if (selectedTab == 1) {
      // Primary (1st to 5th grade)
      List<String> levels = [
        'grade1_attendance',
        'grade2_attendance',
        'grade3_attendance',
        'grade4_attendance',
        'grade5_attendance'
      ];
      for (int i = 0; i < levels.length; i++) {
        String level = levels[i];
        List<StudentAttendance> sections = attendanceData[level] ?? [];

        barGroups.add(BarChartGroupData(
          x: i,
          barRods: sections.map((section) {
            return BarChartRodData(
              toY: section.present.toDouble(),
              borderRadius: BorderRadius.zero,
              width: 20,
              color: null,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: colorMapping[level] ?? [Colors.black, Colors.black],
              ),
            );
          }).toList(),
        ));
      }
    } else if (selectedTab == 2) {
      // Secondary (6th to 10th grade)
      List<String> levels = [
        'grade6_attendance',
        'grade7_attendance',
        'grade8_attendance',
        'grade9_attendance',
        'grade10_attendance'
      ];
      for (int i = 0; i < levels.length; i++) {
        String level = levels[i];
        List<StudentAttendance> sections = attendanceData[level] ?? [];
        barGroups.add(BarChartGroupData(
          x: i,
          barRods: sections.map((section) {
            print('sectionnnnnnnnnnnnnnnnnnnnn $section');
            return BarChartRodData(
              toY: section.present.toDouble(),
              borderRadius: BorderRadius.zero,
              width: 20,
              color: null,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: colorMapping[level] ?? [Colors.black, Colors.black],
              ),
            );
          }).toList(),
        ));
      }
    }
    return barGroups;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (selectedTab == 0) {
      final titles = ['Pre-KG', 'LKG', 'UKG'];
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(
          titles[value.toInt()],
          style: TextStyle(color: Colors.black),
        ),
      );
    } else if (selectedTab == 1) {
      final titles = ['1st', '2nd', '3rd', '4th', '5th'];
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(
          titles[value.toInt()],
          style: TextStyle(color: Colors.black),
        ),
      );
    } else if (selectedTab == 2) {
      final titles = ['6th', '7th', '8th', '9th', '10th'];
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(
          titles[value.toInt()],
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
      child: Text(''),
    );
  }

  ///linear progress indicator..
  ScrollController _linearprogresscontroller = ScrollController();
  double _progress = 0.0;

  String _getLimitedHtmlContent(String content) {
    // You can set the character limit to simulate the first 3 lines.
    final maxCharacters =
        30; // Adjust the number of characters for 3 lines of text
    return content.length > maxCharacters
        ? content.substring(0, maxCharacters) + '...'
        : content;
  }

  //
  String _getLimitedHtmlContentsss(String content) {
    // You can set the character limit to simulate the first 3 lines.
    final maxCharacterss =
        115; // Adjust the number of characters for 3 lines of text
    return content.length > maxCharacterss
        ? content.substring(0, maxCharacterss) + '...'
        : content;
  }

  String _getLimitedHtmlContentcircular(String content) {
    // You can set the character limit to simulate the first 3 lines.
    final maxCharacterss =
        40; // Adjust the number of characters for 3 lines of text
    return content.length > maxCharacterss
        ? content.substring(0, maxCharacterss) + '...'
        : content;
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: Colors.white,
            contentTextStyle: TextStyle(
                fontFamily: 'semibold', fontSize: 16, color: Colors.black),
            title: Text(
              "Exit App",
              style: TextStyle(
                  fontFamily: 'semibold', fontSize: 16, color: Colors.black),
            ),
            content: Text(
              "Are you sure you want to exit?",
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            actions: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              //
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppTheme.textFieldborderColor),
                child: TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 1),
                    child: Text(
                      "Exit",
                      style: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  //news details sheet..
  void _showNewsDetailBottomSheet(BuildContext context, newsItem) {
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
                Positioned(
                  top: MediaQuery.of(context).size.height * -0.08,
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

                // Bottom Sheet Content
                Container(
                  padding: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Close Button inside the modal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preview Screen',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'semibold',
                                color: Colors.black),
                          ),
                        ],
                      ),

                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(
                          thickness: 2,
                          color: Color.fromRGBO(243, 243, 243, 1),
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    newsItem.headline,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'semibold',
                                        color: Colors.black),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                              //

                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              // Video or Image Display
                              (newsItem.filePath.contains('youtube.com') ||
                                      newsItem.filePath.contains('youtu.be'))
                                  ? YoutubePlayer(
                                      controller: YoutubePlayerController(
                                        initialVideoId:
                                            YoutubePlayer.convertUrlToId(
                                                newsItem.filePath)!,
                                        flags: YoutubePlayerFlags(
                                            autoPlay: false, mute: false),
                                      ),
                                      showVideoProgressIndicator: true,
                                      width: double.infinity,
                                      aspectRatio: 16 / 9,
                                    )
                                  : Image.network(
                                      newsItem.filePath,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container();
                                      },
                                    ),

                              // News Content
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Html(
                                    data: newsItem.newsContent,
                                    style: {
                                      "body": Style(
                                          fontFamily: 'semibold',
                                          fontSize: FontSize(14),
                                          color: Colors.black,
                                          textAlign: TextAlign.justify,
                                          lineHeight: LineHeight(1.5)),
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  //carousel details bottomsheet...
  void _showCarouselDetailBottomSheet(BuildContext context, circulartem) {
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
                Positioned(
                  top: MediaQuery.of(context).size.height * -0.08,
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
                // Bottom Sheet Content
                Container(
                  padding: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Close Button inside the modal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preview Screen',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'semibold',
                                color: Colors.black),
                          ),
                        ],
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(
                          thickness: 2,
                          color: Color.fromRGBO(243, 243, 243, 1),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    circulartem.headline,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'semibold',
                                        color: Colors.black),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                              //
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              // Video or Image Display

                              Image.network(
                                circulartem.filePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              ),
                              // News Content
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Html(
                                    data: circulartem.circularcontent,
                                    style: {
                                      "body": Style(
                                        fontFamily: 'semibold',
                                        fontSize: FontSize(14),
                                        color: Colors.black,
                                        textAlign: TextAlign.justify,
                                        lineHeight: LineHeight(1.5),
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.appBackgroundPrimaryColor,
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
              top: MediaQuery.of(context).size.height * 0.04,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              color: Color.fromRGBO(255, 253, 247, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    //profile..
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.imagePath),
                      maxRadius: 35,
                    ),
                    // Name Column
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back,',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'medium',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.username,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'bold'),
                          ),
                          Text(
                            widget.userType,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'medium',
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      size: 32,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Render the menu section based on the active index
              if (_activeIndex == 0 || _activeIndex == 1) _buildMenuSection(),
              //
              //managementsection....
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'teacher')
                if (_activeIndex == 0)
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        top: MediaQuery.sizeOf(context).height * 0.02,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Management',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'semibold',
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
              //heading end.....
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'teacher')
                if (_activeIndex == 0)
                  //
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              if (_activeIndex == 0)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> categories = [
                        {
                          'title': 'Curriculum \nManagement',
                          'count': dashboardManagementCount
                                  ?.curriculamManagementCount ??
                              0,
                          'color': Color.fromRGBO(229, 31, 103, 1),
                          'gradient': [
                            Color.fromRGBO(229, 31, 103, 1),
                            Color.fromRGBO(255, 0, 93, 1),
                          ],
                          'bgcolor': Color.fromRGBO(253, 244, 247, 1),
                        },
                        //
                        {
                          'title': 'Facilities \nManagement',
                          'count': dashboardManagementCount
                                  ?.facilitiesManagementCount ??
                              0,
                          'color': Color.fromRGBO(12, 149, 62, 1),
                          'gradient': [
                            Color.fromRGBO(12, 149, 62, 1),
                            Color.fromRGBO(0, 141, 52, 1)
                          ],
                          'bgcolor': Color.fromRGBO(244, 251, 247, 1),
                        },
                        //
                        {
                          'title': 'Performance \n Metrics',
                          'count': dashboardManagementCount
                                  ?.performanceMetricsCount ??
                              0,
                          'color': Color.fromRGBO(113, 19, 165, 1),
                          'gradient': [
                            Color.fromRGBO(113, 19, 165, 1),
                            Color.fromRGBO(100, 0, 156, 1)
                          ],
                          'bgcolor': Color.fromRGBO(250, 246, 252, 1),
                        },
                        {
                          'title': 'Parent \nFeedback',
                          'count':
                              dashboardManagementCount?.parentsFeedbackCount ??
                                  0,
                          'color': Color.fromRGBO(238, 141, 19, 1),
                          'gradient': [
                            Color.fromRGBO(229, 153, 31, 1),
                            Color.fromRGBO(255, 123, 0, 1)
                          ],
                          'bgcolor': Color.fromRGBO(254, 250, 245, 1),
                        },
                      ];
                      return GestureDetector(
                        onTap: () {
                          if (categories[index]['count'] <= 2) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppTheme.textFieldborderColor,
                                content: Text(
                                  'No data available!',
                                  style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else if (categories[index]['count'] == 3) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackMainpage()),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: categories[index]['bgcolor'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              //left side
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.02,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: categories[index]['gradient'],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                              // Content
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02),
                                      //
                                      Text(
                                        categories[index]['title'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'medium',
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: categories[index]['title'] ==
                                                'Parent \nFeedback'
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                      ),
                                      if (dashboardManagementCount != null)
                                        //count
                                        Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.gradientStartColor,
                                                AppTheme.gradientEndColor
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            categories[index]['count']
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'semibold',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      //arrow..
                                      Icon(
                                        Icons.arrow_forward,
                                        color: categories[index]['color'],
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              //news section carosuel....
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'student')
                if (_activeIndex == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.sizeOf(context).width *
                          0.05, // 5% of screen width
                      right: MediaQuery.sizeOf(context).width *
                          0.05, // 5% of screen width
                      top: MediaQuery.sizeOf(context).height *
                          0.03, // 3% of screen height
                      bottom: MediaQuery.sizeOf(context).height *
                          0.015, // 1.5% of screen height
                    ),
                    child: Row(
                      children: [
                        Text(
                          'News',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          'Latest Update',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 12,
                              color: Color.fromRGBO(101, 101, 101, 1)),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Newsmainpage(
                                          isswitched: false,
                                        )));
                          },
                          child: Row(
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'semibold',
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              //news carousel section...
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'student')
                if (_activeIndex == 0)
                  Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.sizeOf(context).width * 0.03,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(204, 204, 204, 0.3),
                            spreadRadius: -10,
                            blurRadius: 20,
                            offset: Offset(-4, 1),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: CarouselSlider(
                        items: newsList.map((newsItem) {
                          return GestureDetector(
                            onTap: () {
                              _showNewsDetailBottomSheet(context, newsItem);
                            },
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                      child: (newsItem.filePath
                                                  .contains('youtube.com') ||
                                              newsItem.filePath
                                                  .contains('youtu.be'))
                                          ? YoutubePlayer(
                                              controller:
                                                  YoutubePlayerController(
                                                initialVideoId: YoutubePlayer
                                                    .convertUrlToId(
                                                        newsItem.filePath)!,
                                                flags: YoutubePlayerFlags(
                                                  autoPlay: false,
                                                  mute: false,
                                                ),
                                              ),
                                              showVideoProgressIndicator: true,
                                              width: 120,
                                              aspectRatio: 16 / 9,
                                            )
                                          : Image.network(
                                              newsItem.filePath,
                                              fit: BoxFit.cover,
                                              width: 120,
                                              height: 150,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container();
                                              },
                                            ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  child: Text(
                                                    newsItem.headline,
                                                    style: TextStyle(
                                                      fontFamily: 'bold',
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppTheme
                                                              .gradientStartColor,
                                                          AppTheme
                                                              .gradientEndColor,
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      newsItem.count.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'semibold',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              DateFormat('yyyy-MM-dd').format(
                                                  DateTime.parse(newsItem
                                                      .postedOn
                                                      .toString())),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'regular',
                                                color: Color.fromRGBO(
                                                    104, 104, 104, 1),
                                              ),
                                            ),
                                            //
                                            if (newsItem.filePath.isNotEmpty)
                                              Transform.translate(
                                                offset: Offset(-5, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Html(
                                                    data:
                                                        _getLimitedHtmlContent(
                                                            newsItem
                                                                .newsContent),
                                                    style: {
                                                      "body": Style(
                                                        color: Colors.black,
                                                        fontSize: FontSize(16),
                                                        fontFamily: 'semibold',
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    },
                                                  ),
                                                ),
                                              ),
                                            //
                                            if (newsItem.filePath.isEmpty)
                                              Container(
                                                width: double.infinity,
                                                child: Html(
                                                  data:
                                                      _getLimitedHtmlContentsss(
                                                          newsItem.newsContent),
                                                  style: {
                                                    "body": Style(
                                                      color: Colors.black,
                                                      fontSize: FontSize(16),
                                                      fontFamily: 'semibold',
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200,
                          padEnds: false,
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
              //dots indicator........
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'student')
                if (_activeIndex == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(newsList.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        height: 8,
                        width: _currentIndex == index ? 20 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppTheme.carouselDotActiveColor
                              : AppTheme.carouselDotUnselectColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

              ///circular heading sections..
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'student')
                if (_activeIndex == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.sizeOf(context).width *
                          0.05, // 5% of screen width
                      right: MediaQuery.sizeOf(context).width *
                          0.05, // 5% of screen width
                      top: MediaQuery.sizeOf(context).height *
                          0.02, // 2% of screen height
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Circulars',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 18,
                              color: Colors.black),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CircularMainpage(
                                          isswitched: false,
                                        )));
                          },
                          child: Row(
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'semibold',
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              //circular carousel..
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'student')
                if (_activeIndex == 0)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(204, 204, 204, 0.3),
                            spreadRadius: -10,
                            blurRadius: 20,
                            offset: Offset(-4, 1),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      child: CarouselSlider(
                        items: circularList.map((Circular circular) {
                          return GestureDetector(
                            onTap: () {
                              _showCarouselDetailBottomSheet(context, circular);
                            },
                            child: Container(
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    if (circular.filePath.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                        child: Image.network(
                                          circular.filePath,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 150,
                                        ),
                                      ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12, left: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  child: Text(
                                                    circular.headline,
                                                    style: TextStyle(
                                                      fontFamily: 'bold',
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppTheme
                                                              .gradientStartColor,
                                                          AppTheme
                                                              .gradientEndColor,
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      circular.count.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'semibold',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              DateFormat('yyyy-MM-dd').format(
                                                  DateTime.parse(circular
                                                      .postedOn
                                                      .toString())),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'regular',
                                                color: Color.fromRGBO(
                                                    104, 104, 104, 1),
                                              ),
                                            ),
                                            //
                                            if (circular.filePath.isNotEmpty)
                                              Container(
                                                  width: double.infinity,
                                                  child: Html(
                                                    data: _getLimitedHtmlContent(
                                                        circular
                                                            .circularcontent),
                                                    style: {
                                                      "body": Style(
                                                        color: Colors.black,
                                                        fontSize: FontSize(16),
                                                        fontFamily: 'semibold',
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    },
                                                  )),
                                            //
                                            if (circular.filePath.isEmpty)
                                              Container(
                                                width: double.infinity,
                                                child: Html(
                                                  data:
                                                      _getLimitedHtmlContentcircular(
                                                          circular
                                                              .circularcontent),
                                                  style: {
                                                    "body": Style(
                                                      color: Colors.black,
                                                      fontSize: FontSize(16),
                                                      fontFamily: 'semibold',
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200,
                          padEnds: false,
                          aspectRatio: 16 / 9,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _circulars_currentindex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
              //dots indicator
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff' ||
                  UserSession().userType == 'student')
                if (_activeIndex == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(circularList.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        height: 8,
                        width: _circulars_currentindex == index ? 20 : 8,
                        decoration: BoxDecoration(
                          color: _circulars_currentindex == index
                              ? AppTheme.carouselDotActiveColor
                              : AppTheme.carouselDotUnselectColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

              ///attendance chart section....
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                if (_activeIndex == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.sizeOf(context).width *
                          0.05, // 5% of screen width
                      right: MediaQuery.sizeOf(context).width *
                          0.05, // 5% of screen width
                      top: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance Graph',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            Text(
                              DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                              style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 12,
                                  color: Color.fromRGBO(104, 104, 104, 1)),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AttendencePage(
                                          imagePath: widget.imagePath,
                                          userType: widget.userType,
                                          username: widget.username,
                                        )));
                          },
                          child: Row(
                            children: [
                              Text(
                                'Detailed View',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'semibold',
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              //graph section..button code........
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                if (_activeIndex == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // //students button.......
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedButton = "Students";
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: selectedButton == "Students"
                                        ? AppTheme.textFieldborderColor
                                        : AppTheme.textFieldborderColor,
                                    width: 1.5)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SpeechBalloon(
                                nipLocation: NipLocation.bottomRight,
                                color: selectedButton == "Students"
                                    ? AppTheme.textFieldborderColor
                                    : Colors.white ?? Colors.white,
                                height: MediaQuery.sizeOf(context).height *
                                    0.05, // 5% of screen height
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                offset: Offset(-10, 0),
                                nipHeight:
                                    selectedButton == "Students" ? 15 : 0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Students",
                                        style: TextStyle(
                                            color: AppTheme.menuTextColor,
                                            fontSize: 16.0,
                                            fontFamily: 'medium'),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        //staffs button..........
                        if (UserSession().userType == 'admin' ||
                            UserSession().userType == 'superadmin' ||
                            UserSession().userType == 'staff')
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedButton = "Staffs";
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 50),
                              decoration: BoxDecoration(
                                  color: selectedButton == "Staffs"
                                      ? AppTheme.textFieldborderColor
                                      : Colors.white ?? Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppTheme.textFieldborderColor,
                                      width: 1.5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Staffs",
                                    style: TextStyle(
                                        color: AppTheme.menuTextColor,
                                        fontSize: 16.0,
                                        fontFamily: 'medium'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

              ///student graph section........
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                if (_activeIndex == 0)
                  if (selectedButton == 'Students')

                    ///nursery secondary primary text......
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.03,
                        right: MediaQuery.sizeOf(context).width * 0.03,
                        top: MediaQuery.sizeOf(context).height * 0.02,
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Color.fromRGBO(225, 225, 225, 1),
                            width: 1,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: Color.fromRGBO(225, 225, 225, 1),
                              //   width: 1,
                              // ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.005,
                              bottom: MediaQuery.sizeOf(context).height * 0.005,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTab = 0;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: selectedTab == 0
                                        ? AppTheme.textFieldborderColor
                                        : Colors.white,
                                    foregroundColor: selectedTab == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  child: Text(
                                    'Nursery',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.menuTextColor,
                                        fontFamily: 'medium'),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTab = 1;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: selectedTab == 1
                                        ? AppTheme.textFieldborderColor
                                        : Colors.white,
                                    foregroundColor: selectedTab == 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  child: Text(
                                    'Primary',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.menuTextColor,
                                        fontFamily: 'medium'),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTab = 2;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: selectedTab == 2
                                        ? AppTheme.textFieldborderColor
                                        : Colors.white,
                                    foregroundColor: selectedTab == 2
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  child: Text(
                                    'Secondary',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.menuTextColor,
                                        fontFamily: 'medium'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

              ///student graph start......
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                if (_activeIndex == 0)
                  if (selectedButton == 'Students')
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.sizeOf(context).width * 0.02),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Color.fromRGBO(225, 225, 225, 1))),
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color.fromRGBO(225, 225, 225, 1))),
                          child: Row(
                            children: [
                              // Static Left Titles...
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                width: MediaQuery.sizeOf(context).width * 0.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: leftTitles.map((title) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'medium',
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              ///student graph here start.....
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.sizeOf(context).height *
                                          0.02,
                                      bottom:
                                          MediaQuery.sizeOf(context).height *
                                              0.01,
                                    ),
                                    child: SingleChildScrollView(
                                      controller: _linearprogresscontroller,
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: 550,
                                        child: BarChart(
                                          BarChartData(
                                            borderData:
                                                FlBorderData(show: false),
                                            barGroups: getBarGroups(),
                                            titlesData: FlTitlesData(
                                              topTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false)),
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              bottomTitles: AxisTitles(
                                                drawBelowEverything: true,
                                                sideTitles: SideTitles(
                                                  reservedSize: 30,
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      bottomTitleWidgets,
                                                ),
                                              ),
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  interval: 1,
                                                  showTitles: false,
                                                  reservedSize: 45,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                      value.toInt().toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'regular'),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            gridData: FlGridData(
                                                drawHorizontalLine: true,
                                                drawVerticalLine: true,
                                                getDrawingVerticalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    strokeWidth: 1,
                                                    dashArray: [5, 5],
                                                  );
                                                },
                                                getDrawingHorizontalLine:
                                                    (value) {
                                                  return FlLine(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    strokeWidth: 1,
                                                    dashArray: [5, 5],
                                                  );
                                                },
                                                show: true,
                                                horizontalInterval: 25),
                                            backgroundColor: Color.fromRGBO(
                                                254, 247, 255, 1),
                                            barTouchData: BarTouchData(
                                              touchTooltipData:
                                                  BarTouchTooltipData(
                                                tooltipRoundedRadius: 10,
                                                getTooltipColor: (group) {
                                                  return Colors.black;
                                                },
                                                maxContentWidth: 180,
                                                fitInsideVertically: true,
                                                fitInsideHorizontally: true,
                                                tooltipHorizontalOffset: 50.0,
                                                getTooltipItem: (group,
                                                    groupIndex, rod, rodIndex) {
                                                  String level = '';
                                                  List<StudentAttendance>
                                                      sections = [];

                                                  if (selectedTab == 0) {
                                                    level = [
                                                      'pre_kg_attendance',
                                                      'lkg_attendance',
                                                      'ukg_attendance'
                                                    ][groupIndex];

                                                    if (level ==
                                                        'pre_kg_attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .preKgAttendance;
                                                    } else if (level ==
                                                        'lkg_attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .lkgAttendance;
                                                    } else if (level ==
                                                        'ukg_attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .ukgAttendance;
                                                    }
                                                  } else if (selectedTab == 1) {
                                                    level = [
                                                      'grade1Attendance',
                                                      'grade2Attendance',
                                                      'grade3Attendance',
                                                      'grade4Attendance',
                                                      'grade5Attendance'
                                                    ][groupIndex];

                                                    if (level ==
                                                        'grade1Attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .grade1Attendance;
                                                    } else if (level ==
                                                        'grade2Attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .grade2Attendance;
                                                    } else if (level ==
                                                        'grade3Attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .grade3Attendance;
                                                    } else if (level ==
                                                        'grade4Attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .grade4Attendance;
                                                    } else if (level ==
                                                        'grade5Attendance') {
                                                      sections =
                                                          studentAttendanceModel
                                                              .grade5Attendance;
                                                    }
                                                  } else if (selectedTab == 2) {
                                                    level = [
                                                      'grade6Attendance',
                                                      'grade7Attendance',
                                                      'grade8Attendance',
                                                      'grade9Attendance',
                                                      'grade10Attendance'
                                                    ][groupIndex];

                                                    Map<
                                                            String,
                                                            List<
                                                                StudentAttendance>>
                                                        gradeSections = {
                                                      'grade6Attendance':
                                                          studentAttendanceModel
                                                              .grade6Attendance,
                                                      'grade7Attendance':
                                                          studentAttendanceModel
                                                              .grade7Attendance,
                                                      'grade8Attendance':
                                                          studentAttendanceModel
                                                              .grade8Attendance,
                                                      'grade9Attendance':
                                                          studentAttendanceModel
                                                              .grade9Attendance,
                                                      'grade10Attendance':
                                                          studentAttendanceModel
                                                              .grade10Attendance,
                                                    };

                                                    sections =
                                                        gradeSections[level] ??
                                                            [];
                                                  }

                                                  StudentAttendance
                                                      sectionData =
                                                      sections[rodIndex];

                                                  return BarTooltipItem(
                                                    '',
                                                    TextStyle(),
                                                    textAlign: TextAlign.left,
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${level.replaceAll('_', ' ').toUpperCase()} - ${sectionData.section}\n',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'medium',
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '• ',
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              99, 42, 179, 1),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'medium',
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'Total Students: (${sectionData.total})\n',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                      TextSpan(
                                                        text: '• ',
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              0, 150, 60, 1),
                                                          fontSize: 18,
                                                          fontFamily: 'medium',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'Present: (${sectionData.present})\n',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                      TextSpan(
                                                        text: '• ',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    212,
                                                                    0,
                                                                    1),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'Late: (${sectionData.late})\n',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                      TextSpan(
                                                        text: '• ',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    0,
                                                                    4,
                                                                    1),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'Leave: (${sectionData.leave})\n',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '• ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'medium'),
                                                      ),
                                                      TextSpan(
                                                        text: 'Percentage: ',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${sectionData.percentage.toStringAsFixed(2)}%',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          background: Paint()
                                                            ..strokeWidth = 25
                                                            ..color =
                                                                Colors.green
                                                            ..style =
                                                                PaintingStyle
                                                                    .fill,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              touchCallback: (event, response) {
                                                if (event
                                                        .isInterestedForInteractions &&
                                                    response != null &&
                                                    response.spot != null) {
                                                  print(
                                                      'Tapped bar at index: ${response.spot!.touchedBarGroupIndex}');
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              if (_activeIndex == 0)
                if (UserSession().userType == 'admin' ||
                    UserSession().userType == 'superadmin' ||
                    UserSession().userType == 'staff')
                  if (selectedButton == 'Students')
                    Container(
                      width: MediaQuery.sizeOf(context).width *
                          0.15, // 15% of screen width
                      height: MediaQuery.sizeOf(context).height * 0.01,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Color.fromRGBO(225, 225, 225, 1),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        value: _progress,
                      ),
                    ),
              //student graph end.........
              //...................///staff section Graph.................................................................
              if (UserSession().userType == 'admin')
                if (_activeIndex == 0)
                  SizedBox(
                    height: 10,
                  ),
              if (_activeIndex == 0)
                if (UserSession().userType == 'admin' ||
                    UserSession().userType == 'superadmin' ||
                    UserSession().userType == 'staff')
                  if (UserSession().userType != 'teachers')
                    if (selectedButton == 'Staffs')
                      //
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.sizeOf(context).width * 0.02),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(225, 225, 225, 1)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(5, (index) {
                                    final value = (4 - index) * 25;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'medium',
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                // Scrollable bar chart....................
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: MediaQuery.sizeOf(context).width *
                                            0.04,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: attendanceData.length * 90,
                                            child: BarChart(
                                              BarChartData(
                                                backgroundColor: Color.fromRGBO(
                                                    254, 247, 255, 1),
                                                maxY: 100,
                                                barTouchData: BarTouchData(
                                                  enabled: true,
                                                  touchTooltipData:
                                                      BarTouchTooltipData(
                                                    tooltipRoundedRadius: 10,
                                                    tooltipPadding:
                                                        EdgeInsets.only(
                                                            left: 45,
                                                            right: 45),
                                                    fitInsideHorizontally: true,
                                                    fitInsideVertically: true,
                                                    getTooltipItem: (group,
                                                        groupIndex,
                                                        rod,
                                                        rodIndex) {
                                                      String presentText =
                                                          'Present: ${attendanceData[groupIndex].present}';
                                                      String absentText =
                                                          'Absent: ${attendanceData[groupIndex].absent}';
                                                      String lateText =
                                                          'Late: ${attendanceData[groupIndex].late}';
                                                      String leaveText =
                                                          'Leave: ${attendanceData[groupIndex].leave}';
                                                      String percentageText =
                                                          '${attendanceData[groupIndex].percentage}%';
                                                      return BarTooltipItem(
                                                        '',
                                                        TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'medium',
                                                          fontSize: 10,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                        children: [
                                                          TextSpan(
                                                            text: '• ',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        99,
                                                                        42,
                                                                        179,
                                                                        1),
                                                                fontSize: 18),
                                                          ),
                                                          TextSpan(
                                                            text: presentText +
                                                                '\n',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          TextSpan(
                                                            text: '• ',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        150,
                                                                        60,
                                                                        1),
                                                                fontSize: 18),
                                                          ),
                                                          TextSpan(
                                                            text: absentText +
                                                                '\n',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          TextSpan(
                                                            text: '• ',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                  255,
                                                                  212,
                                                                  0,
                                                                  1,
                                                                ),
                                                                fontSize: 18),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                lateText + '\n',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          TextSpan(
                                                            text: '• ',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                255,
                                                                0,
                                                                4,
                                                                1,
                                                              ),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: leaveText +
                                                                '\n',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                percentageText,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                backgroundColor:
                                                                    Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            150,
                                                                            60,
                                                                            1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    1.5,
                                                                height: 1.5),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    getTooltipColor: (group) {
                                                      return Colors.black;
                                                    },
                                                  ),
                                                ),
                                                titlesData: FlTitlesData(
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      reservedSize: 25,
                                                      showTitles: true,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        return Text(
                                                          attendanceData[
                                                                  value.toInt()]
                                                              .subUserType,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        );
                                                      },
                                                      interval: 1,
                                                    ),
                                                  ),
                                                  rightTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false),
                                                  ),
                                                  topTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false),
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                barGroups: attendanceData
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  int index = entry.key;
                                                  TeacherAttendance data =
                                                      entry.value;
                                                  return BarChartGroupData(
                                                    x: index,
                                                    barsSpace: 15,
                                                    barRods: [
                                                      BarChartRodData(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                        toY: data.percentage,
                                                        gradient:
                                                            getGradientForSubUserType(
                                                                data.subUserType),
                                                        width: 25,
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawHorizontalLine: false,
                                                  getDrawingVerticalLine:
                                                      (value) {
                                                    return FlLine(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      strokeWidth: 1,
                                                      dashArray: [5, 5],
                                                    );
                                                  },
                                                ),
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
                        ),
                      ),

              ///staff birthday section heading..
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'teacher' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                if (_activeIndex == 0)
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.015,
                      left: MediaQuery.sizeOf(context).width * 0.05,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Staffs Birthday',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                            Text(
                              DateFormat('dd-MMMM-yyyy').format(DateTime.now()),
                              style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 12,
                                  color: Color.fromRGBO(104, 104, 104, 1)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/dashboard_teaching.png',
                                  height: 20,
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                    selectedValue ?? "",
                                    style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        //dropdownformfield.......
                        if (_activeIndex == 0)
                          Padding(
                            padding: EdgeInsets.only(
                              right: MediaQuery.sizeOf(context).width * 0.04,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              margin: EdgeInsets.zero,
                              height: 35,
                              child: DropdownButtonFormField<String>(
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 14,
                                    color: Colors.black),
                                dropdownColor: Colors.white,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.sizeOf(context).width *
                                            0.04, // 4% of screen width
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppTheme.textFieldborderColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppTheme.textFieldborderColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppTheme.textFieldborderColor,
                                    ),
                                  ),
                                ),
                                value: selectedValue,
                                isExpanded: true,
                                items: options.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.01,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selectedValue == option
                                              ? AppTheme.textFieldborderColor
                                              : Colors.white,
                                        ),
                                        child: Text(
                                          option,
                                        )),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue = newValue;
                                  });
                                  _loadBirthdayData();
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return options.map((String option) {
                                    return Container(
                                      width: double.infinity,
                                      child: Text(
                                        option,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList();
                                },
                                icon: Image.asset(
                                  'assets/images/Dashboard_dropdownicon.png',
                                  height: 8,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              //birthday shows text...
              if (_activeIndex == 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.03,
                    left: MediaQuery.sizeOf(context).width * 0.06,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _chunkList(birthdayList, 4)
                          .asMap()
                          .entries
                          .map((entry) {
                        int rowIndex = entry.key;
                        List<Birthday> chunk = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.sizeOf(context).height * 0.02,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: chunk.asMap().entries.map((entry) {
                                int index = entry.key;
                                Birthday birthday = entry.value;
                                return Row(
                                  children: [
                                    // CircleAvatar(
                                    //   backgroundImage:
                                    //       NetworkImage(birthday.filepath ?? ''),
                                    // ),
                                    CircleAvatar(
                                      backgroundImage: birthday.filepath !=
                                                  null &&
                                              birthday.filepath!.isNotEmpty
                                          ? NetworkImage(birthday.filepath!)
                                          : AssetImage(
                                                  'assets/images/Dashboard_profileimage.png')
                                              as ImageProvider,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: MediaQuery.sizeOf(context).width *
                                            0.03,
                                      ),
                                      child: SizedBox(
                                        width: 65,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              birthday.name,
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              birthday.subject ?? 'No Subject',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontFamily: 'medium',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // if (index < chunk.length - 1)
                                    //   SizedBox(
                                    //     width: rowIndex == 1 ? 45 : 18,
                                    //   ),
                                    // if (index < chunk.length - 1)
                                    VerticalDivider(
                                      thickness: 2,
                                      width: 20,
                                      color: Color.fromRGBO(255, 239, 205, 1),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              if (_activeIndex == 0)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
              //////////////////////////////////////////////////communication section...................................
              if (_activeIndex == 1)
                Communication(
                  imagePath: widget.imagePath,
                  userType: widget.userType,
                  username: widget.username,
                ),
            ],
          ),
        ),
        endDrawer: Drawer(
          backgroundColor: Colors.white,
          elevation: 10,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: AppTheme.appBackgroundPrimaryColor),
                currentAccountPicture: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(widget.imagePath),
                ),
                accountEmail: Text(
                  widget.userType,
                  style: TextStyle(
                      fontFamily: 'semibold',
                      fontSize: 20,
                      color: Colors.black),
                ),
                accountName: Transform.translate(
                  offset: Offset(0, 10),
                  child: Text(
                    widget.username,
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
              //
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                ListTile(
                  title: Text(
                    'My Projects',
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  subtitle: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyprojectMenu()));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * 0.02,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: AppTheme.textFieldborderColor,
                                width: 1.5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text(
                              'Add / Manage',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 16,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              //
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin')
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  child: Divider(
                    color: Color.fromRGBO(202, 202, 202, 202),
                    thickness: 1.0,
                  ),
                ),
              //
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                ListTile(
                  title: Text(
                    'ERP',
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.02,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/enddawer_lockicon.svg',
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.02,
                                  ),
                                  child: Text(
                                    'Student Management',
                                    style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //
                      Opacity(
                        opacity: 0.5,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.02,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/staffmanagement.svg',
                                  fit: BoxFit.contain,
                                ),
                                //
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.02,
                                  ),
                                  child: Text(
                                    'Staff Management',
                                    style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //
                      Opacity(
                        opacity: 0.5,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.02,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/staffmanagement.svg',
                                  fit: BoxFit.contain,
                                ),
                                //
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * 0.02,
                                  ),
                                  child: Text(
                                    'Academic',
                                    style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 16,
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
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin' ||
                  UserSession().userType == 'staff')
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  child: Divider(
                    color: Color.fromRGBO(202, 202, 202, 202),
                    thickness: 1.0,
                  ),
                ),
              //
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin')
                ListTile(
                  title: Text(
                    'Manage',
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ApprovalmenuPage()));
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/enddawer_lockicon.svg',
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.sizeOf(context).width * 0.02,
                                ),
                                child: Text(
                                  'Approvals',
                                  style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (UserSession().userType == 'admin' ||
                            UserSession().userType == 'superadmin')
                          Opacity(
                            opacity: 0.5,
                            child: AbsorbPointer(
                              absorbing: true,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.sizeOf(context).height * 0.02,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/Accesscontrol.svg',
                                      fit: BoxFit.contain,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: MediaQuery.sizeOf(context).width *
                                            0.02,
                                      ),
                                      child: Text(
                                        'Access Control',
                                        style: TextStyle(
                                            fontFamily: 'semibold',
                                            fontSize: 16,
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
                ),
              //

              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.01,
                ),
                child: Divider(
                  color: Color.fromRGBO(202, 202, 202, 202),
                  thickness: 1.0,
                ),
              ),
              ListTile(
                title: Text(
                  'Password',
                  style: TextStyle(
                      fontFamily: 'semibold',
                      fontSize: 18,
                      color: Colors.black),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('usersession : ${UserSession().userType}');
                          if (UserSession().userType == 'student') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordscreen(),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/enddawer_lockicon.svg',
                              fit: BoxFit.contain,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.sizeOf(context).width * 0.02,
                              ),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontFamily: 'semibold',
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //
              if (UserSession().userType == 'admin' ||
                  UserSession().userType == 'superadmin')
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  child: Divider(
                    color: Color.fromRGBO(202, 202, 202, 202),
                    thickness: 1.0,
                  ),
                ),
              Spacer(),
              //logout button..
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height * 0.02,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textFieldborderColor),
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        //top arrow..
        floatingActionButton:
            _scrollController.hasClients && _scrollController.offset > 50
                ? Transform.translate(
                    offset: Offset(0, -15),
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
      ),
    );
  }

/////staff bar color widgets...
  LinearGradient getGradientForSubUserType(String subUserType) {
    switch (subUserType) {
      case 'Teaching':
        return LinearGradient(
          colors: [
            Color.fromRGBO(253, 122, 255, 1),
            Color.fromRGBO(185, 0, 188, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Support':
        return LinearGradient(
          colors: [
            Color.fromRGBO(176, 93, 208, 1),
            Color.fromRGBO(134, 0, 187, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Administrative':
        return LinearGradient(
          colors: [
            Color.fromRGBO(184, 57, 64, 1),
            Color.fromRGBO(94, 18, 23, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Operational':
        return LinearGradient(
          colors: [
            Color.fromRGBO(57, 255, 137, 1),
            Color.fromRGBO(39, 186, 98, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'Extracurricular':
        return LinearGradient(
          colors: [
            Color.fromRGBO(252, 170, 103, 1),
            Color.fromRGBO(206, 92, 0, 1)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [Colors.red, Colors.grey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  ///logout function...
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: Navigator.of(context, rootNavigator: true).context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Logout Confirmation',
              style: TextStyle(
                  fontFamily: 'semibold', fontSize: 16, color: Colors.black),
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
                fontFamily: 'medium', fontSize: 16, color: Colors.black),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black, width: 1)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: 'regular'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textFieldborderColor),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                //
                UserSession().clearSession();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Loginpage(newsArticles: widget.newsArticles),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: 'regular'),
              ),
            ),
          ],
        );
      },
    );
  }

  //
  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.02,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(204, 204, 204, 0.3),
              spreadRadius: -10,
              blurRadius: 20,
              offset: Offset(-4, 1),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color.fromRGBO(225, 225, 225, 1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    ...List.generate(
                      _menuItems.length,
                      (index) {
                        bool isActive = _activeIndex == index;
                        // return GestureDetector(
                        //   onTap: () {
                        //     // Allow only admins to change the active index
                        //     if (UserSession().userType == 'admin' ||
                        //         UserSession().userType == 'teacher' ||
                        //         UserSession().userType == 'superadmin' ||
                        //         UserSession().userType == 'staff' ||
                        //         UserSession().userType == 'student') {
                        //       setState(() {
                        //         _activeIndex = index;
                        //       });
                        //     }
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 5, horizontal: 18),
                        //     decoration: BoxDecoration(
                        //       color: isActive
                        //           ? AppTheme.textFieldborderColor
                        //           : Colors.white,
                        //       borderRadius: BorderRadius.circular(18),
                        //     ),
                        //     child: Text(
                        //       _menuItems[index],
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         fontFamily: 'medium',
                        //         color: AppTheme.menuTextColor,
                        //       ),
                        //     ),
                        //   ),
                        // );
                        return GestureDetector(
                          onTap: () {
                            // Allow only "Dashboard" and "Communication" to be clicked
                            if (_menuItems[index] == 'Dashboard' ||
                                _menuItems[index] == 'Communication') {
                              setState(() {
                                _activeIndex = index;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 18),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.textFieldborderColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              _menuItems[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'medium',
                                color: (_menuItems[index] == 'Dashboard' ||
                                        _menuItems[index] == 'Communication')
                                    ? AppTheme
                                        .menuTextColor // Normal color for clickable items
                                    : Colors
                                        .grey, // Grey color for non-clickable items
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
