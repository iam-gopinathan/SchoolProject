import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ImportantEvents_models/ImportantEvent_mainpage_model.dart';
import 'package:flutter_application_1/screens/ImportantEvents/Create_Event_calender.dart';
import 'package:flutter_application_1/screens/ImportantEvents/Edit_Event_calender.dart';
import 'package:flutter_application_1/services/ImportantEvents_Api/important_event_mainpage_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';

import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class ImportanteventsMainpage extends StatefulWidget {
  const ImportanteventsMainpage({super.key});

  @override
  State<ImportanteventsMainpage> createState() =>
      _ImportanteventsMainpageState();
}

class _ImportanteventsMainpageState extends State<ImportanteventsMainpage> {
  bool isswitched = false;
  DateTime? _startDate;
  DateTime? _endDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndDisplayEvents();
  }

  bool isLoading = true;

  late EventsResponsess events = EventsResponsess(
    todayEvents: [],
    upComingEvents: [],
    allEvents: [],
  );

  void fetchAndDisplayEvents({String date = ''}) async {
    try {
      final response = await fetchImportantEvents(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        date: date,
      );

      setState(() {
        isLoading = false;
        events = response;
      });
      print('Today Events: ${response.todayEvents.length}');
      print('Upcoming Events: ${response.upComingEvents.length}');
      print('All Events: ${response.allEvents.length}');
    } catch (e) {
      isLoading = false;
      print('Error fetching events: $e');
    }
  }

  // Check if the day is an event day
  bool isEventDay(DateTime day) {
    for (var event in events.allEvents) {
      if (day.isAfter(event.parsedFromDate.subtract(Duration(days: 1))) &&
          day.isBefore(event.parsedToDate.add(Duration(days: 1)))) {
        return true;
      }
    }
    return false;
  }

  DateTime? selectedDay;
  DateTime? focusedDay;

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
                              'Event Calender',
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
                  ],
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      color: Color.fromRGBO(254, 251, 250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IntrinsicWidth(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color:
                                                  Color.fromRGBO(219, 71, 0, 1),
                                            ),
                                            child: Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  content: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateEventCalender()),
                                      );
                                    },
                                    child: Text(
                                      'Add New Event',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'regular',
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
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
                              return day.isAfter(_startDate!
                                      .subtract(Duration(days: 1))) &&
                                  day.isBefore(
                                      _endDate!.add(Duration(days: 1)));
                            }
                            return false;
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              this.selectedDay = selectedDay;
                              this.focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: CalendarStyle(
                            todayTextStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'semibold',
                              fontSize: 16,
                            ),
                            rangeHighlightColor:
                                Colors.orangeAccent.withOpacity(0.5),
                            selectedDecoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Color.fromRGBO(252, 242, 237, 1),
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                          ),
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              if (isEventDay(day)) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
//today events....
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, bottom: 10),
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
                        Column(
                          children: [
                            ...events.todayEvents.map((e) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(254, 249, 247, 1)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                            shape: BoxShape.circle),
                                        child: Text(
                                          '${e.from}',
                                          style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  248, 248, 248, 1)),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          'to',
                                          style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              shape: BoxShape.circle),
                                          child: Text(
                                            '${e.to}',
                                            style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    248, 248, 248, 1)),
                                          ),
                                        ),
                                      ),

                                      //
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          '${e.headLine}',
                                          style: TextStyle(
                                              fontFamily: 'regular',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                          ],
                        ),
                      ],
                    ),
                  ),
                  //upcoming events...
                  Column(
                    children: [
                      //
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
                      ...events.upComingEvents.map((upcoming) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            top: 15,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(254, 249, 247, 1),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //fromdate
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: Colors.deepOrange,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                '${upcoming.from}',
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      248, 248, 248, 1),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                'To',
                                                style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            //
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepOrange,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${upcoming.to}',
                                                  style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        248, 248, 248, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: Text(
                                            '${upcoming.headLine}',
                                            style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
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
                                          padding: const EdgeInsets.only(
                                              top: 5, left: 10),
                                          child: Text(
                                            '${upcoming.description}',
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 14,
                                                color: Colors.black,
                                                height: 1.5),
                                          ),
                                        ),

                                        //delete
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      content: Text(
                                                        "Do you really want to Delete\n  to this Event?",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'regular',
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      elevation:
                                                                          0,
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'regular'),
                                                                  )),
                                                              //delete..
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: AppTheme
                                                                                .textFieldborderColor,
                                                                            elevation:
                                                                                0,
                                                                            side: BorderSide
                                                                                .none),
                                                                        onPressed:
                                                                            () async {
                                                                          var deleteevent =
                                                                              upcoming.id;

                                                                          print(
                                                                              deleteevent);
                                                                          String
                                                                              url =
                                                                              'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeEventCalender/DeleteEventCalender?Id=$deleteevent';

                                                                          try {
                                                                            final response =
                                                                                await http.delete(
                                                                              Uri.parse(url),
                                                                              headers: {
                                                                                'Content-Type': 'application/json',
                                                                                'Authorization': 'Bearer $authToken',
                                                                              },
                                                                            );

                                                                            if (response.statusCode ==
                                                                                200) {
                                                                              print('id has beeen deleted ${deleteevent}');

                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(backgroundColor: Colors.green, content: Text('Event deleted successfully!')),
                                                                              );
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete Event.')),
                                                                              );
                                                                            }
                                                                          } catch (e) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text('An error occurred: $e')),
                                                                            );
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Delete',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'regular'),
                                                                        )),
                                                              ),
                                                            ])
                                                      ]);
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, left: 10),
                                            child: SvgPicture.asset(
                                              'assets/icons/timetable_delete.svg',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      var image = upcoming.filePath;
                                      _PreviewBottomsheet(context, image);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Column(
                                        children: [
                                          Text(
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
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        content: Text(
                                                          "Do you really want to make\n changes to this Timetable?",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        actions: <Widget>[
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        elevation:
                                                                            0,
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .black,
                                                                            width:
                                                                                1)),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'regular'),
                                                                    )),
                                                                //edit...
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => EditEventCalender(
                                                                                      id: upcoming.id,
                                                                                    )));

                                                                        print(upcoming
                                                                            .id);
                                                                      },
                                                                      child: Text(
                                                                        'Edit',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'regular'),
                                                                      )),
                                                                ),
                                                              ])
                                                        ]);
                                                  });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'regular'),
                                              ),
                                            ),
                                          )
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
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  ///image bottomsheeet

//preview bottomsheet...
  void _PreviewBottomsheet(BuildContext context, String image) {
    showModalBottomSheet(
      isDismissible: false,
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(clipBehavior: Clip.none, children: [
              // Close icon
              Positioned(
                top: -70,
                left: 180,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(modalContext);
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
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Center(
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((_) {
                                  setModalState(() {
                                    isLoading = false;
                                  });
                                });
                                return child;
                              } else {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 150),
                                    child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: AppTheme.textFieldborderColor),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]);
          },
        );
      },
    );
  }
}
