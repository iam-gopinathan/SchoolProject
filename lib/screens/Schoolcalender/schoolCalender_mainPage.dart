import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/screens/Schoolcalender/Create_school_calender.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SchoolcalenderMainpage extends StatefulWidget {
  const SchoolcalenderMainpage({super.key});

  @override
  State<SchoolcalenderMainpage> createState() => _SchoolcalenderMainpageState();
}

class _SchoolcalenderMainpageState extends State<SchoolcalenderMainpage> {
  bool isswitched = false;

  DateTime? _startDate; // Start of the range
  DateTime? _endDate; // End of the range
  CalendarFormat _calendarFormat = CalendarFormat.month;
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
                Row(
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
                              'School Calender',
                              style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My \n Projects',
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
                            onChanged: (value) {
                              setState(() {
                                isswitched = value;
                              });
                            },
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                color: Color.fromRGBO(254, 251, 250, 1),
                child: TableCalendar(
                  onDayLongPressed: (selectedDay, focusedDay) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String formattedDate =
                              DateFormat('MMM dd').format(selectedDay);
                          return AlertDialog(
                            insetPadding: EdgeInsets.all(100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.black,
                            title: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color.fromRGBO(219, 71, 0, 1)),
                                      child: Text(
                                        formattedDate,
                                        style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 10,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            content: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateSchoolCalender()));
                              },
                              child: Text(
                                'Add New Event',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'regular',
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white),
                              ),
                            ),
                          );
                        });
                  },
                  pageAnimationEnabled: true,
                  headerVisible: true,
                  pageJumpingEnabled: true,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    if (_startDate != null && _endDate != null) {
                      return day.isAfter(
                              _startDate!.subtract(Duration(days: 1))) &&
                          day.isBefore(_endDate!.add(Duration(days: 1)));
                    }
                    return false;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      if (_startDate == null ||
                          (_startDate != null && _endDate != null)) {
                        _startDate = selectedDay;
                        _endDate = null;
                      } else if (_endDate == null) {
                        if (selectedDay.isAfter(_startDate!)) {
                          _endDate = selectedDay;
                        } else {
                          _endDate = _startDate;
                          _startDate = selectedDay;
                        }
                      }
                    });
                  },
                  calendarStyle: CalendarStyle(
                    rangeHighlightColor: Colors.orangeAccent.withOpacity(0.5),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                  ),
                ),
              ),
            ),

            //

            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    'Today Events',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 16,
                        color: Color.fromRGBO(97, 97, 97, 1)),
                  )
                ],
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration:
                    BoxDecoration(color: Color.fromRGBO(254, 249, 247, 1)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(219, 71, 0, 1),
                            shape: BoxShape.circle),
                        child: Text(
                          '1',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(248, 248, 248, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'to',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(219, 71, 0, 1),
                              shape: BoxShape.circle),
                          child: Text(
                            '10',
                            style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 14,
                                color: Color.fromRGBO(248, 248, 248, 1)),
                          ),
                        ),
                      ),

                      //
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          '1 Term Circular Test',
                          style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 25),
              child: Row(
                children: [
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 16,
                        color: Color.fromRGBO(97, 97, 97, 1)),
                  )
                ],
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(254, 249, 247, 1),
                              ),
                              child: Row(
                                children: [
                                  //1
                                  Transform.translate(
                                    offset: Offset(-12, 0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(219, 71, 0, 1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          fontFamily: 'medium',
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(248, 248, 248, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Children’s Day 2024-2025',
                                          style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              child: Divider(
                                                color: Color.fromRGBO(
                                                    218, 218, 218, 1),
                                                height: 10,
                                                thickness: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            'Children’s Day Celebration For\n Grade-1 to Grade - 10 Students',
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 14,
                                                color: Colors.black,
                                                height: 1.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _PreviewBottomsheet(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        'View Image',
                                        style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 12,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.black,
                                            decorationThickness: 2),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///image bottomsheeet
  void _PreviewBottomsheet(BuildContext context) {
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
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///image section...
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Center(child: Image.asset('')),
                      )
                    ],
                  ),
                ),
              )
            ]);
          });
        });
  }
}
