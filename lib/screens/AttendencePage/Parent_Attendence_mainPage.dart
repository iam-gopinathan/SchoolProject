import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Attendence_models/Parent_Attendence_mainpage_model.dart';
import 'package:flutter_application_1/models/Attendence_models/Parent_IrregularAttendence_Model.dart';
import 'package:flutter_application_1/services/Attendance_Api/ParentAttendence_mainpage_API.dart';
import 'package:flutter_application_1/services/Attendance_Api/ParentIrregularAttendence_API.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';

class ParentAttendenceMainpage extends StatefulWidget {
  const ParentAttendenceMainpage({super.key});

  @override
  State<ParentAttendenceMainpage> createState() =>
      _ParentAttendenceMainpageState();
}

class _ParentAttendenceMainpageState extends State<ParentAttendenceMainpage> {
  ParentattendenceResponse? attendanceData;
  ScrollController _scrollController = ScrollController();

  bool isLoading = true;

  //fetch data..
  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });
    try {
      ParentattendenceResponse? data = await fetchParentmainAttendanceData(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        date: '',
      );
      if (data != null) {
        setState(() {
          print('Fetching attendance data...');
          print('UserType: ${UserSession().userType}');
          print('RollNumber: ${UserSession().rollNumber}');
          attendanceData = data;
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {
        print('error fetch $e');
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //
  @override
  void initState() {
    super.initState();
    fetch();
    //
    fetchIregular();
    //
    // Set the default selected month to the current month
    List<String> availableMonths = getAvailableMonths();
    selectedMonth = availableMonths.last; // Select the latest available month
    //
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

  //iregular attendence fetch...
  ParentIrregularattendenceModel? IrrData;

  Future<void> fetchIregular() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await fetchIrregularAttendance(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? "",
        date: '01-01-2025',
      );
      setState(() {
        IrrData = data;
      });
    } catch (error) {
      setState(() {});
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String? selectedMonth;

  List<String> getAvailableMonths() {
    int currentMonthIndex = DateTime.now().month - 1;
    return months.sublist(0, currentMonthIndex + 1);
  }

  // bottomsheeet.....
  void _showBottomSheet(BuildContext context) {
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
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Irregular Days',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        Spacer(),
                        //dropdown code
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.black,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(169, 169, 169, 1)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(169, 169, 169, 1)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(169, 169, 169, 1)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                            ),
                            hint: Text(
                              'Select Month',
                              style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                            value: selectedMonth,
                            selectedItemBuilder: (BuildContext context) {
                              return months.map((String month) {
                                return Text(
                                  month,
                                  style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                );
                              }).toList();
                            },
                            icon: Icon(Icons.arrow_drop_down),
                            items: getAvailableMonths().map((String month) {
                              return DropdownMenuItem<String>(
                                value: month,
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            menuMaxHeight: 150,
                            onChanged: (String? newValue) {
                              setModalState(() {
                                selectedMonth = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          selectedMonth.toString(),
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 12,
                              color: Color.fromRGBO(73, 73, 73, 1)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            DateTime.now().year.toString(),
                            style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 12,
                              color: Color.fromRGBO(73, 73, 73, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color.fromRGBO(238, 238, 238, 1),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left purple indicator
                          Container(
                            width: 5,
                            height: 210,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                          ),
                          // Main content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        color:
                                            Color.fromRGBO(239, 222, 246, 1)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Days - ${IrrData?.irregularAttendanceStatus.monthTotalDays}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Attendance details
                                Transform.translate(
                                  offset: Offset(0, -17),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(250, 244, 252, 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        child: Row(
                                          children: [
                                            // Present and Absent
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor:
                                                            Color.fromRGBO(
                                                                0, 150, 601, 1),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Present - ${IrrData?.irregularAttendanceStatus.present}',
                                                        style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor:
                                                            Color.fromRGBO(
                                                                218, 0, 0, 1),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Absent - ${IrrData?.irregularAttendanceStatus.absent}',
                                                        style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Vertical Divider
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Container(
                                                height: 100,
                                                child: VerticalDivider(
                                                  color: Color.fromRGBO(
                                                      238, 219, 245, 1),
                                                  width: 20,
                                                  thickness: 2,
                                                  indent: 20,
                                                  endIndent: 20,
                                                ),
                                              ),
                                            ),

                                            // Leave and Late
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor:
                                                            Color.fromRGBO(
                                                                59, 72, 213, 1),
                                                      ),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Leave - ${IrrData?.irregularAttendanceStatus.leave}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'medium',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 5,
                                                        backgroundColor:
                                                            Color.fromRGBO(
                                                                134, 0, 187, 1),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Late - ${IrrData?.irregularAttendanceStatus.late}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'medium',
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Percentage Circle
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          0, 150, 601, 1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '${IrrData?.irregularAttendanceStatus.percentage}%',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily: 'medium',
                                                        color: Colors.white,
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.only(top: 25, left: 5),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          //absent
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10)),
                                color: Color.fromRGBO(243, 242, 242, 1)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 30),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor:
                                        Color.fromRGBO(218, 0, 0, 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Absent',
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //leave
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(249, 244, 252, 1)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 30),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor:
                                        Color.fromRGBO(59, 72, 213, 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Leave',
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //late
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10)),
                                color: Color.fromRGBO(245, 246, 253, 1)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 50),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor:
                                        Color.fromRGBO(134, 0, 187, 1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Late',
                                      style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 16,
                                        color: Colors.black,
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
                  ),
                  //absent data///////////////////////////////////////////////
                  Transform.translate(
                    offset: Offset(0, -23),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            border: Border.all(
                              color: Color.fromRGBO(238, 238, 238, 1),
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Absent..
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      if (IrrData == null ||
                                          IrrData!.absent.isEmpty)
                                        Padding(
                                            padding: EdgeInsets.only(left: 80)),
                                      //
                                      if (IrrData != null &&
                                          IrrData!.absent.isNotEmpty)
                                        ...IrrData!.absent.map((e) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10, top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${e.date}',
                                                  style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  '${e.day}',
                                                  style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                    ],
                                  ),
                                ),
                                // Vertical Divider
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    child: VerticalDivider(
                                      color: Color.fromRGBO(238, 219, 245, 1),
                                      width: 20,
                                      thickness: 2,
                                    ),
                                  ),
                                ),
                                if (IrrData == null || IrrData!.leave.isEmpty)
                                  Padding(padding: EdgeInsets.only(left: 80)),
                                // Leave..
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      if (IrrData != null &&
                                          IrrData!.absent.isNotEmpty)
                                        ...IrrData!.leave.map((e) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${e.date}',
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '${e.day}',
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                    ],
                                  ),
                                ),
                                // Vertical Divider
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                    child: VerticalDivider(
                                      color: Color.fromRGBO(238, 219, 245, 1),
                                      width: 20,
                                      thickness: 2,
                                    ),
                                  ),
                                ),
                                // late..
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      if (IrrData == null ||
                                          IrrData!.late.isEmpty)
                                        Padding(
                                            padding: EdgeInsets.only(left: 80)),
                                      if (IrrData != null &&
                                          IrrData!.absent.isNotEmpty)
                                        ...IrrData!.late.map((e) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${e.date}',
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '${e.day}',
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]);
        });
      },
    );
  }
  //iregular attendence fetch...

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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : attendanceData == null
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      //
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromRGBO(225, 225, 225, 1))),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.white),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Attendance Status',
                                        style: TextStyle(
                                            fontFamily: 'semibold',
                                            fontSize: 16,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                //

                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Color.fromRGBO(
                                                225, 225, 225, 1))),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          //
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Color.fromRGBO(
                                                      253, 248, 244, 1)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Today',
                                                    style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          //
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color
                                                                        .fromRGBO(
                                                                            1,
                                                                            133,
                                                                            53,
                                                                            1)),
                                                        onPressed: () {},
                                                        child: Text(
                                                          '${attendanceData?.attendanceStatus?.today ?? ''}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'semibold',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                    //
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Text(
                                                        '${attendanceData?.attendanceStatus?.date ?? ''}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromRGBO(
                                                                    76,
                                                                    76,
                                                                    76,
                                                                    1)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          //
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      253, 248, 244, 1)),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'This Month',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          254, 252, 250, 1),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 15),
                                                              child: Text(
                                                                'Total Days - ${attendanceData?.attendanceStatus?.monthTotalDays ?? ''}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'semibold',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        //
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 30,
                                                                  top: 20),
                                                          child: Row(
                                                            children: [
                                                              //present.
                                                              Container(
                                                                height: 10,
                                                                width: 10,
                                                                decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                        colors: [
                                                                          Color.fromRGBO(
                                                                              0,
                                                                              150,
                                                                              601,
                                                                              1),
                                                                          Color.fromRGBO(
                                                                              0,
                                                                              207,
                                                                              83,
                                                                              1)
                                                                        ],
                                                                        begin: Alignment
                                                                            .topCenter,
                                                                        end: Alignment
                                                                            .bottomCenter),
                                                                    shape: BoxShape
                                                                        .circle),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Present - ${attendanceData?.attendanceStatus?.present ?? ''}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'medium',
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              //leave
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            25),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 10,
                                                                  decoration: BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              59,
                                                                              72,
                                                                              213,
                                                                              1),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Leave - ${attendanceData?.attendanceStatus?.leave}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'medium'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 30,
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              //absent
                                                              Container(
                                                                height: 10,
                                                                width: 10,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            218,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    shape: BoxShape
                                                                        .circle),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child: Text(
                                                                  'Absent - ${attendanceData?.attendanceStatus?.absent}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'medium'),
                                                                ),
                                                              ),
                                                              //late
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            38),
                                                                child:
                                                                    Container(
                                                                  height: 10,
                                                                  width: 10,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              Color.fromRGBO(176, 93, 208, 1),
                                                                              Color.fromRGBO(134, 0, 187, 1),
                                                                            ],
                                                                            end:
                                                                                Alignment.bottomLeft,
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                          ),
                                                                          shape:
                                                                              BoxShape.circle),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8),
                                                                child: Text(
                                                                  'Late - ${attendanceData?.attendanceStatus?.late}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'medium'),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              15),
                                                                  child: Transform
                                                                      .translate(
                                                                    offset:
                                                                        Offset(
                                                                            5,
                                                                            -22),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(15),
                                                                          decoration: BoxDecoration(
                                                                              color: Color.fromRGBO(0, 150, 601, 1),
                                                                              shape: BoxShape.circle),
                                                                          child:
                                                                              Text(
                                                                            '${attendanceData?.attendanceStatus?.percentage}%',
                                                                            style: TextStyle(
                                                                                fontFamily: 'medium',
                                                                                fontSize: 20,
                                                                                color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //irregular attendencies..
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromRGBO(225, 225, 225, 1))),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Irregular Days',
                                        style: TextStyle(
                                            fontFamily: 'semibold',
                                            fontSize: 16,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                //irregular..
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 0, 4, 0.05),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    218, 0, 0, 1),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            width: 8,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                          ),
                                          Text(
                                            'Irregular Days',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'medium',
                                                color: Colors.black),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              size: 30,
                                              color:
                                                  Color.fromRGBO(218, 0, 0, 1),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
      //
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
}
