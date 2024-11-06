import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_circularsection.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_teacherAttendance.dart';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_teacherBirthday.dart';
import 'package:flutter_application_1/models/Dashboard_models/dashboard_Management_count.dart';
import 'package:flutter_application_1/models/Dashboard_models/dashboard_newsModel.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_Newssection.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_TeacherAttendance.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_circularsection.dart';
import 'package:flutter_application_1/services/dashboard_API/Dashboard_teachersBirthday.dart';
import 'package:flutter_application_1/services/dashboard_API/dashboard_managementsection_Api.dart';
import 'package:intl/intl.dart';
import 'package:speech_bubble/speech_bubble.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String userType;
  final String imagePath;

  Dashboard(
      {super.key,
      required this.username,
      required this.userType,
      required this.imagePath});

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

  //scroll controller for birthay section
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  //graph section teacher attendance..
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

  ///students chart section...
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: EdgeInsets.only(left: 30, top: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            color: Color.fromRGBO(255, 253, 247, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    padding: const EdgeInsets.only(left: 10),
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
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.add_circle_outline_outlined,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //firstsection
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_menuItems.length, (index) {
                            bool isActive = _activeIndex == index;
                            return Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.04,
                                right: MediaQuery.of(context).size.width * 0.04,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 18),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Color.fromRGBO(252, 190, 58, 1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    _menuItems[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                      color: Color.fromRGBO(24, 24, 24, 1),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //managementsection
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 20),
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
            //heading end...
            Row(
              children: [
                //curriculam title..
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(229, 31, 103, 1),
                                    Color.fromRGBO(255, 0, 93, 1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(229, 31, 103, 0.1),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Text(
                                    'Curriculum \nManagement',
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  if (dashboardManagementCount != null)
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(251, 174, 78, 1),
                                            Color.fromRGBO(235, 130, 0, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        dashboardManagementCount!
                                            .curriculamManagementCount
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'semibold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromRGBO(229, 31, 103, 1),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //facilities management..
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(12, 149, 62, 1),
                                    Color.fromRGBO(0, 141, 52, 1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(50, 174, 96, 0.1),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Text(
                                    'Facilities \nManagement',
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  //count..
                                  if (dashboardManagementCount != null)
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(251, 174, 78, 1),
                                            Color.fromRGBO(235, 130, 0, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        dashboardManagementCount!
                                            .facilitiesManagementCount
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'semibold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromRGBO(12, 149, 62, 1),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //performance metrics.....
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 10),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(113, 19, 165, 1),
                                    Color.fromRGBO(100, 0, 156, 1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(113, 19, 165, 0.1),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Text(
                                    'Performance \nMetrics',
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.04,
                                  ),
                                  if (dashboardManagementCount != null)
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(251, 174, 78, 1),
                                            Color.fromRGBO(235, 130, 0, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        dashboardManagementCount!
                                            .performanceMetricsCount
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'semibold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromRGBO(113, 19, 165, 1),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //parent feedback..
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(100, 0, 156, 1),
                                    Color.fromRGBO(158, 88, 197, 1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(245, 159, 52, 0.06),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Text(
                                    'Parents \nFeedback',
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.09,
                                  ),
                                  if (dashboardManagementCount != null)
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(251, 174, 78, 1),
                                            Color.fromRGBO(235, 130, 0, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        dashboardManagementCount!
                                            .parentsFeedbackCount
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'semibold',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromRGBO(238, 141, 19, 1),
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //news section carosuel....
            Padding(
              padding: const EdgeInsets.only(
                  left: 25, top: 25, right: 25, bottom: 10),
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
                  Row(
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
                  )
                ],
              ),
            ),
            //news carousel section...
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
                  items: newsList.map((newsItem) {
                    return Container(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                newsItem.filePath,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      251, 174, 78, 1),
                                                  Color.fromRGBO(
                                                      235, 130, 0, 1),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              newsItem.count.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'semibold',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      newsItem.postedOn.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'regular',
                                        color: Color.fromRGBO(104, 104, 104, 1),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          newsItem.newsContent,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'medium',
                                            color: Colors.black,
                                          ),
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
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    padEnds: false,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
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
            //dots indicator
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
                        ? Color.fromRGBO(252, 190, 58, 1)
                        : Color.fromRGBO(252, 190, 58, 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            ///circular heading sections..
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 15, right: 25),
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
                  Row(
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
                  )
                ],
              ),
            ),
            //circular carousel..
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
                    return Container(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                circular.filePath,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      251, 174, 78, 1),
                                                  Color.fromRGBO(
                                                      235, 130, 0, 1),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              circular.count.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'semibold',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      circular.postedOn.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'regular',
                                        color: Color.fromRGBO(104, 104, 104, 1),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          circular.circularcontent,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'medium',
                                            color: Colors.black,
                                          ),
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
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    padEnds: false,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                        ? Color.fromRGBO(252, 190, 58, 1)
                        : Color.fromRGBO(252, 190, 58, 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            ///attendance chart section....
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25, right: 25),
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
                  Row(
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
                  )
                ],
              ),
            ),
            //graph section..button code........
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //students button.......
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = "Students";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedButton == "Students"
                                  ? Color.fromRGBO(252, 190, 58, 1)
                                  : Color.fromRGBO(252, 190, 58, 1),
                              width: 1.5)),
                      child: SpeechBubble(
                        color: selectedButton == "Students"
                            ? Color.fromRGBO(252, 190, 58, 1)
                            : Colors.white ?? Colors.white,
                        height: 37,
                        width: 160,
                        offset: Offset(-10, 0),
                        nipLocation: NipLocation.BOTTOM_RIGHT,
                        nipHeight: selectedButton == "Students" ? 15 : 0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Students",
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 24, 24, 1),
                                    fontSize: 16.0,
                                    fontFamily: 'medium'),
                              )
                            ]),
                      ),
                    ),
                  ),
                  //staffs button..........
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButton = "Staffs";
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: selectedButton == "Staffs"
                                  ? Color.fromRGBO(252, 190, 58, 1)
                                  : Color.fromRGBO(252, 190, 58, 1),
                              width: 1.5)),
                      child: SpeechBubble(
                        color: selectedButton == "Staffs"
                            ? Color.fromRGBO(252, 190, 58, 1)
                            : Colors.white ?? Colors.white,
                        nipHeight: 0,
                        height: 37,
                        width: 160,
                        offset: Offset(-10, 0),
                        nipLocation: NipLocation.BOTTOM_RIGHT,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Staffs",
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 24, 24, 1),
                                    fontSize: 16.0,
                                    fontFamily: 'medium'),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ///student graph section........
            if (selectedButton == 'Students')
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Color.fromRGBO(225, 225, 225, 1),
                      width: 1,
                    ),
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
                        border: Border.all(
                          color: Color.fromRGBO(225, 225, 225, 1),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                                  ? Color.fromRGBO(252, 190, 58, 1)
                                  : Colors.white,
                              foregroundColor: selectedTab == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Text(
                              'Nursery',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(24, 24, 24, 1),
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
                                  ? Color.fromRGBO(252, 190, 58, 1)
                                  : Colors.white,
                              foregroundColor: selectedTab == 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Text(
                              'Primary',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(24, 24, 24, 1),
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
                                  ? Color.fromRGBO(252, 190, 58, 1)
                                  : Colors.white,
                              foregroundColor: selectedTab == 2
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Text(
                              'Secondary',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(24, 24, 24, 1),
                                  fontFamily: 'medium'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ///student graph end.......

//...................///staff section Graph.................................................................
            SizedBox(
              height: 10,
            ),
            if (selectedButton == 'Staffs')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          final value = (4 - index) * 25;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'medium',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
                      ),
                      // Scrollable bar chart....................
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                width: attendanceData.length * 90,
                                child: BarChart(
                                  BarChartData(
                                    backgroundColor: Colors.white,
                                    maxY: 100,
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipRoundedRadius: 10,
                                        tooltipPadding: EdgeInsets.only(
                                            left: 45, right: 45),
                                        fitInsideHorizontally: true,
                                        fitInsideVertically: true,
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
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
                                            textAlign: TextAlign.left,
                                            children: [
                                              TextSpan(
                                                text: '• ',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        99, 42, 179, 1),
                                                    fontSize: 18),
                                              ),
                                              TextSpan(
                                                text: presentText + '\n',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text: '• ',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 150, 60, 1),
                                                    fontSize: 18),
                                              ),
                                              TextSpan(
                                                text: absentText + '\n',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text: '• ',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                      255,
                                                      212,
                                                      0,
                                                      1,
                                                    ),
                                                    fontSize: 18),
                                              ),
                                              TextSpan(
                                                text: lateText + '\n',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text: '• ',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                    255,
                                                    0,
                                                    4,
                                                    1,
                                                  ),
                                                  fontSize: 18,
                                                ),
                                              ),
                                              TextSpan(
                                                text: leaveText + '\n',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              TextSpan(
                                                text: percentageText,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            0, 150, 60, 1),
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.5,
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
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              attendanceData[value.toInt()]
                                                  .subUserType,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'medium',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                          interval: 1,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    barGroups: attendanceData
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      TeacherAttendance data = entry.value;
                                      return BarChartGroupData(
                                        x: index,
                                        barsSpace: 15,
                                        barRods: [
                                          BarChartRodData(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            toY: data.percentage,
                                            gradient: getGradientForSubUserType(
                                                data.subUserType),
                                            width: 25,
                                          ),
                                        ],
                                      );
                                    }).toList(),
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
              ),

            ///stafff graph end...
            ///staff birthday section heading..
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
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
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
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
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(252, 190, 58, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(252, 190, 58, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(252, 190, 58, 1),
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
                                  top: 10,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedValue == option
                                      ? Color.fromRGBO(252, 190, 58, 1)
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
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _chunkList(birthdayList, 4).asMap().entries.map((entry) {
                    int rowIndex = entry.key;
                    List<Birthday> chunk = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: chunk.asMap().entries.map((entry) {
                            int index = entry.key;
                            Birthday birthday = entry.value;
                            return Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(birthday.filepath ?? ''),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
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
                                if (index < chunk.length - 1)
                                  SizedBox(
                                    width: rowIndex == 1 ? 38 : 10,
                                  ),
                                if (index < chunk.length - 1)
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

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Text('data'),
          ],
        ),
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
}
