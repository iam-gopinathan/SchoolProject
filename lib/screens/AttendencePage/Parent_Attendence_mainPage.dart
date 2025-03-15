import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Attendence_models/Parent_Attendence_mainpage_model.dart';
import 'package:flutter_application_1/models/Attendence_models/Parent_IrregularAttendence_Model.dart';
import 'package:flutter_application_1/services/Attendance_Api/ParentAttendence_mainpage_API.dart';
import 'package:flutter_application_1/services/Attendance_Api/ParentIrregularAttendence_API.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:intl/intl.dart';

class ParentAttendenceMainpage extends StatefulWidget {
  const ParentAttendenceMainpage({super.key});

  @override
  State<ParentAttendenceMainpage> createState() =>
      _ParentAttendenceMainpageState();
}

class _ParentAttendenceMainpageState extends State<ParentAttendenceMainpage> {
  ParentattendenceResponse? attendanceData;
  ScrollController _scrollController = ScrollController();

  ScrollController _linearprogresscontroller = ScrollController();
  double _progress = 0.0;

  bool isLoading = true;

  //fetch data..
  Future<void> fetch() async {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    setState(() {
      isLoading = true;
    });
    try {
      ParentattendenceResponse? data = await fetchParentmainAttendanceData(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        date: currentDate,
      );
      if (data != null) {
        setState(() {
          print('Fetching attendance data...');
          print('UserType: ${UserSession().userType}');
          print('RollNumber: ${UserSession().rollNumber}');
          print('Date ${currentDate}');
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
    //
    _linearprogresscontroller.addListener(() {
      setState(() {
        double progress = _linearprogresscontroller.offset /
            (_linearprogresscontroller.position.maxScrollExtent);

        _progress = progress.clamp(0.0, 1.0);
      });
    });
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
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    setState(() {
      isLoading = true;
    });
    try {
      final data = await fetchIrregularAttendance(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? "",
        date: currentDate,
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
                top: MediaQuery.of(context).size.height *
                    -0.08, // -8% of screen height
                left: MediaQuery.of(context).size.width *
                    0.45, // 45% of screen width

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
                padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                    0.025), // 2.5% of screen width

                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width *
                              0.02), // 2% of screen width

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
                                    horizontal: 12, vertical: 0),
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
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
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
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width *
                            0.025, // 2.5% of screen width
                      ),
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
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width *
                                  0.01, // 1% of screen width
                            ),
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
                              width: MediaQuery.of(context).size.width *
                                  0.014, // 1.2% of screen width
                              height: MediaQuery.of(context).size.height *
                                  0.25, // 25% of screen height

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
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.025), // 2.5% of screen width
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
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
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                250, 244, 252, 1)),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025, // 2.5% of screen height
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          child: Row(
                                            children: [
                                              // Present and Absent
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
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
                                                              Color.fromRGBO(0,
                                                                  150, 601, 1),
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.015), // 1.5% of screen width

                                                        Text(
                                                          'Present - ${IrrData?.irregularAttendanceStatus.present}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.012),
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 5,
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  218, 0, 0, 1),
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.015), // 1.5% of screen width

                                                        Text(
                                                          'Absent - ${IrrData?.irregularAttendanceStatus.absent}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'medium',
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
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of screen width
                                                ),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.12, // 12% of screen height

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
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of screen width
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
                                                              Color.fromRGBO(59,
                                                                  72, 213, 1),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          'Leave - ${IrrData?.irregularAttendanceStatus.leave}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'medium',
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.012),
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 5,
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  134,
                                                                  0,
                                                                  187,
                                                                  1),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Late - ${IrrData?.irregularAttendanceStatus.late}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'medium',
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
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05, // 5% of screen width
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.15, // 15% of screen width
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height *
                                                          0.08, // 8% of screen height
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            0, 150, 601, 1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        '${IrrData?.irregularAttendanceStatus.percentage}%',
                                                        style: TextStyle(
                                                          fontSize: 18,
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
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height *
                            0.03, // 3% of screen height
                        left: MediaQuery.of(context).size.width *
                            0.010, // 1.2% of screen width
                      ),
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
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.06, // 6% of screen width
                                  right: MediaQuery.of(context).size.width *
                                      0.08, // 8% of screen width
                                ),
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
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.06, // 6% of screen width
                                  right: MediaQuery.of(context).size.width *
                                      0.08, // 8% of screen width
                                ),
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
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.08, // 6% of screen width
                                  right: MediaQuery.of(context).size.width *
                                      0.10, // 8% of screen width
                                ),
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
                      offset: Offset(-2, -23),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width *
                                  0.02), // 2% of screen width

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
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.03, // 4% of screen width
                                    ),
                                    child: Column(
                                      children: [
                                        if (IrrData == null ||
                                            IrrData!.absent.isEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2, // 20% of screen width
                                            ),
                                          ),

                                        //
                                        if (IrrData != null &&
                                            IrrData!.absent.isNotEmpty)
                                          ...IrrData!.absent.map((e) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.012, // 1.2% of screen height
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.012, // 1.2% of screen height
                                              ),
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
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.05, // 5% of screen width
                                    ),
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
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.025, // 2.5% of screen width
                                    ),
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
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.05, // 5% of screen width
                                    ),
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
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.025, // 2.5% of screen width
                                    ),
                                    child: Column(
                                      children: [
                                        if (IrrData == null ||
                                            IrrData!.late.isEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2, // 20% of screen width
                                            ),
                                          ),
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
          },
        );
      },
    );
  }
  //iregular attendence fetch...

  //
  final List<Map<String, dynamic>> terms = [
    {'term': '1 Mid Term', 'totalDays': 80, 'present': 80},
    {
      'term': '2 Mid Term',
      'totalDays': 90,
      'present': 90,
    },
    {'term': '3 Mid Term', 'totalDays': 90, 'present': 90},
  ];

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
                    top: MediaQuery.of(context).size.height *
                        0.04, // 3% of screen height
                  ),
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
                      Text(
                        'Attendance',
                        style: TextStyle(
                          fontFamily: 'semibold',
                          fontSize: 16,
                          color: Colors.black,
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
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Color.fromRGBO(225, 225, 225, 1))),
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.015),
                            decoration: BoxDecoration(color: Colors.white),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.015, // 1.5% of screen height
                                    left: MediaQuery.of(context).size.width *
                                        0.025, // 2.5% of screen width
                                  ),
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
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
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
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025),
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
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.012, // 1.2% of screen height
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.006, // 0.6% of screen height
                                            ),
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
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.025),
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
                                                              EdgeInsets.only(
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.08, // 8% of screen width
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.025, // 2.5% of screen height
                                                          ),
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
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025, // 2.5% of screen width
                                                                ),
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
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.060, // 2.5% of screen width
                                                                ),
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
                                                              //
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
                                                        //
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.080, // 2.5% of screen width
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
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.070, // 2.5% of screen width
                                                                ),
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
                                                                              EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
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
                      //
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width *
                                0.03), // 2% of screen width
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
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.007, // 0.7% of screen height
                                    bottom: MediaQuery.of(context).size.height *
                                        0.025, // 2.5% of screen height
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Attendance Graph',
                                            style: TextStyle(
                                                fontFamily: 'semibold',
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          //
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              'Academic Year ${DateTime.now().year}-${DateTime.now().year + 1}',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          for (int i = 100; i >= 0; i -= 25)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.02),
                                              child: Text(
                                                "$i",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    //
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: _linearprogresscontroller,
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Transform.translate(
                                            offset: Offset(0, 10),
                                            child: Container(
                                              height: 240,
                                              width: 750,
                                              child: LineChart(
                                                LineChartData(
                                                  gridData: FlGridData(
                                                    show: false,
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    topTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                    leftTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                    rightTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                            showTitles: false)),
                                                    bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        interval: 1,
                                                        showTitles: true,
                                                        getTitlesWidget:
                                                            (value, meta) {
                                                          List<String> months =
                                                              [
                                                            'Jan',
                                                            'Feb',
                                                            'Mar',
                                                            'Apr',
                                                            'May',
                                                            'Jun',
                                                            'Jul',
                                                            'Aug',
                                                            'Sep',
                                                            'Oct',
                                                            'Nov',
                                                            'Dec'
                                                          ];

                                                          if (value.toInt() >=
                                                                  0 &&
                                                              value.toInt() <
                                                                  months
                                                                      .length) {
                                                            return SideTitleWidget(
                                                              axisSide:
                                                                  meta.axisSide,
                                                              space:
                                                                  2, // Adjust spacing
                                                              child: Text(
                                                                  months[value
                                                                      .toInt()],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'semibold',
                                                                      color: Colors
                                                                          .black)),
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                        reservedSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  borderData:
                                                      FlBorderData(show: false),
                                                  lineBarsData: [
                                                    LineChartBarData(
                                                      spots: [
                                                        FlSpot(
                                                            0,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.january ??
                                                                0.0.toDouble()),
                                                        FlSpot(
                                                            1,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.february ??
                                                                0.0.toDouble()),
                                                        FlSpot(
                                                            2,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.march ??
                                                                0.0.toDouble()),
                                                        FlSpot(
                                                            3,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.april ??
                                                                0.0),
                                                        FlSpot(
                                                            4,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.may ??
                                                                0.0),
                                                        FlSpot(
                                                            5,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.june ??
                                                                0.0),
                                                        FlSpot(
                                                            6,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.july ??
                                                                0.0),
                                                        FlSpot(
                                                            7,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.august ??
                                                                0.0),
                                                        FlSpot(
                                                            8,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.september ??
                                                                0.0),
                                                        FlSpot(
                                                            9,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.october ??
                                                                0.0),
                                                        FlSpot(
                                                            10,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.november ??
                                                                0.0),
                                                        FlSpot(
                                                            11,
                                                            attendanceData
                                                                    ?.attendanceGraph
                                                                    ?.december ??
                                                                0.0),
                                                      ],
                                                      isCurved: false,
                                                      color: Color.fromRGBO(
                                                          0, 30, 224, 1),
                                                      barWidth: 1,
                                                      isStrokeCapRound: true,
                                                      belowBarData: BarAreaData(
                                                          show: true,
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Color.fromRGBO(
                                                                  249,
                                                                  250,
                                                                  255,
                                                                  1),
                                                              Color.fromRGBO(
                                                                  249,
                                                                  250,
                                                                  255,
                                                                  1),
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          )),
                                                      dotData:
                                                          FlDotData(show: true),
                                                    ),
                                                  ],
                                                  lineTouchData: LineTouchData(
                                                    touchTooltipData:
                                                        LineTouchTooltipData(
                                                      tooltipRoundedRadius: 10,
                                                      fitInsideHorizontally:
                                                          true,
                                                      fitInsideVertically: true,
                                                      getTooltipColor:
                                                          (group) =>
                                                              Colors.black,
                                                      getTooltipItems:
                                                          (List<LineBarSpot>
                                                              touchedSpots) {
                                                        List<String> months = [
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

                                                        return touchedSpots
                                                            .map((spot) {
                                                          int monthIndex =
                                                              spot.x.toInt();
                                                          String monthName = months[
                                                              monthIndex]; // Get correct month name

                                                          return LineTooltipItem(
                                                            '$monthName\n${spot.y.toInt()}%',
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          );
                                                        }).toList();
                                                      },
                                                    ),
                                                    touchCallback:
                                                        (FlTouchEvent event,
                                                            LineTouchResponse?
                                                                response) {},
                                                    handleBuiltInTouches: true,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      //linear progress
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        height: MediaQuery.sizeOf(context).height * 0.01,
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Color.fromRGBO(225, 225, 225, 1),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                          value: _progress,
                        ),
                      ),
//irregular attendencies..
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width *
                                0.03), // 2% of screen width
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
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.007, // 0.7% of screen height
                                    bottom: MediaQuery.of(context).size.height *
                                        0.025, // 2.5% of screen height
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
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
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04, // 4% of screen width
                                            ),
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
