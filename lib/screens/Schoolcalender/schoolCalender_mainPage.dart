import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/School_calendar_model/Main_fetch_school_calendar_model.dart';
import 'package:flutter_application_1/screens/Schoolcalender/Create_school_calender.dart';
import 'package:flutter_application_1/screens/Schoolcalender/Edit_school_calender.dart';
import 'package:flutter_application_1/services/school_Calendar_Api/Main_fetch_schoolcalendar_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SchoolcalenderMainpage extends StatefulWidget {
  const SchoolcalenderMainpage({super.key});

  @override
  State<SchoolcalenderMainpage> createState() => _SchoolcalenderMainpageState();
}

class _SchoolcalenderMainpageState extends State<SchoolcalenderMainpage> {
  ScrollController _scrollController = ScrollController();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<String> studentCalendarImages = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchStudentCalendar();
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

  List<Event> todayEvents = [];

  List<Event> upcomingEvents = [];

  List<Event> allEvents = [];

//
  Future<void> fetchStudentCalendar({String date = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await fetchEvents(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        date: date,
      );

      if (response != null && response is EventsResponse) {
        setState(() {
          todayEvents = response.todayEvents;
          upcomingEvents = response.upcomingEvents;
          allEvents = response.allEvents;
          isLoading = false;

          print("Today's Events:");
          for (var event in todayEvents) {
            print(
                'ID: ${event.id}, Headline: ${event.headLine}, FromDate: ${event.fromDate}, ToDate: ${event.toDate}');
          }

          print("Today's Events: $todayEvents");

          print("Upcoming Events:");
          for (var event in upcomingEvents) {
            print(
                'ID: ${event.id}, Headline: ${event.headLine}, FromDate: ${event.fromDate}, ToDate: ${event.toDate}');
          }
        });
      } else {
        throw Exception("Invalid response format");
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  // Check if the day is an event day
  // bool isEventDay(DateTime day) {
  //   for (var event in allEvents) {
  //     if (day.isAfter(event.parsedFromDate.subtract(Duration(days: 1))) &&
  //         day.isBefore(event.parsedToDate.add(Duration(days: 1)))) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  bool isEventDay(DateTime day) {
    for (var event in allEvents) {
      DateTime fromDate = event.parsedFromDate;
      DateTime toDate = event.parsedToDate;

      if ((day.isAtSameMomentAs(fromDate) || day.isAtSameMomentAs(toDate)) ||
          (day.isAfter(fromDate) && day.isBefore(toDate))) {
        return true;
      }
    }
    return false;
  }

  DateTime? selectedDay;
  // DateTime? focusedDay;
  DateTime focusedDay = DateTime.now();

  // Function to handle month change
  void onMonthChanged(DateTime focusedDay) {
    DateTime firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);

    String formattedDate = DateFormat('01-MM-yyyy').format(firstDayOfMonth);

    fetchStudentCalendar(date: formattedDate);

    setState(() {
      this.focusedDay = focusedDay;
    });
  }

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
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text(
                                    'School Calender',
                                    style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      //add screen....
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'staff' ||
                          UserSession().userType == 'superadmin')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateSchoolCalender(
                                              fetchStudentCalendar:
                                                  fetchStudentCalendar)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.Addiconcolor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 30,
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
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  //table calender...
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.025),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: focusedDay,
                      calendarFormat: _calendarFormat,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          this.selectedDay = selectedDay;
                          this.focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          this.focusedDay = focusedDay;
                        });
                        onMonthChanged(focusedDay);
                      },
                      calendarStyle: CalendarStyle(
                        todayTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'semibold'),
                        todayDecoration: BoxDecoration(
                          color: Color.fromRGBO(252, 242, 237, 1),
                          shape: BoxShape.circle,
                        ),
                        defaultDecoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        outsideTextStyle: TextStyle(color: Colors.transparent),
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
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      onDayLongPressed: (selectedDay, focusedDay) {
                        if (UserSession().userType == "admin" ||
                            UserSession().userType == 'staff' ||
                            UserSession().userType == 'superadmin')
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
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IntrinsicWidth(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color:
                                                Color.fromRGBO(219, 71, 0, 1)),
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
                                content: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateSchoolCalender(
                                                fetchStudentCalendar:
                                                    fetchStudentCalendar,
                                              )),
                                    );
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
                            },
                          );
                      },
                    ),
                  ),
//
                  Column(
                    children: [
                      //today events..
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                          top: MediaQuery.of(context).size.height *
                              0.025, // 2.5% of screen height
                        ),
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
                      Column(
                        children: [
                          if (todayEvents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(
                                  UserSession().userType == 'student' ||
                                          UserSession().userType == 'teacher'
                                      ? "No messages from the school yet. Stay tuned for updates!"
                                      : "You haven’t made anything yet;\nstart creating now!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'regular',
                                    color: Color.fromRGBO(145, 145, 145, 1),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            ...todayEvents.map((e) {
                              final fromDay = e.fromDate.substring(0, 2);
                              final toDay = e.toDate.substring(0, 2);
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
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
                                            '${fromDay}',
                                            style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    248, 248, 248, 1)),
                                          ),
                                        ),
                                        if (e.from != e.to)
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
                                        if (e.from != e.to)
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
                                                '${toDay}',
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
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Text(
                                              '${e.headLine}',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                        ],
                      ),
                    ],
                  ),
                  //upcoming events...
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width *
                                0.05, // 5% of screen width
                            top: MediaQuery.of(context).size.height *
                                0.03, // 3% of screen height
                            bottom: MediaQuery.of(context).size.height *
                                0.03, // 3% of screen height
                          ),
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
                        if (upcomingEvents.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                UserSession().userType == 'student' ||
                                        UserSession().userType == 'teacher'
                                    ? "No messages from the school yet. Stay tuned for updates!"
                                    : "You haven’t made anything yet;\nstart creating now!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'regular',
                                  color: Color.fromRGBO(145, 145, 145, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        else
                          ...upcomingEvents.map((e) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.06, // 6% of screen width
                                    top: MediaQuery.of(context).size.height *
                                        0.02, // 2% of screen height
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.04, // 4% of screen width
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(254, 249, 247, 1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 7),
                                            child: Row(
                                              children: [
                                                //from
                                                Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 15),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.deepOrange,
                                                        shape: BoxShape.circle),
                                                    child: Text(
                                                      '${e.from}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'regular',
                                                          fontSize: 14),
                                                    )),
                                                if (e.from != e.to)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      'To',
                                                      style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                //
                                                if (e.from != e.to)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 15),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .deepOrange,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Text(
                                                          '${e.to}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 14),
                                                        )),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          //
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03, // 3% of screen width
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.012, // 1.2% of screen height
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Text(
                                                        '${e.headLine}',
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
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          child: Divider(
                                                            color:
                                                                Color.fromRGBO(
                                                                    218,
                                                                    218,
                                                                    218,
                                                                    1),
                                                            height: 10,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Text(
                                                          '${e.description}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              height: 1.5),
                                                        ),
                                                      ),
                                                    ),
                                                    //delete
                                                    if (UserSession().userType == 'admin' ||
                                                        UserSession()
                                                                .userType ==
                                                            'staff' ||
                                                        UserSession()
                                                                .userType ==
                                                            'superadmin')
                                                      GestureDetector(
                                                        onTap: () async {
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    content:
                                                                        Text(
                                                                      "Do you really want to Delete\n   this Event?",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'regular',
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    actions: <Widget>[
                                                                      Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, side: BorderSide(color: Colors.black, width: 1)),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text(
                                                                                  'Cancel',
                                                                                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                )),
                                                                            //delete...
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                  onPressed: () async {
                                                                                    var deleteUp = e.id;

                                                                                    final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeSchoolCalender/DeleteSchoolCalender?Id=$deleteUp';

                                                                                    try {
                                                                                      final response = await http.delete(
                                                                                        Uri.parse(url),
                                                                                        headers: {
                                                                                          'Content-Type': 'application/json',
                                                                                          'Authorization': 'Bearer $authToken',
                                                                                        },
                                                                                      );

                                                                                      if (response.statusCode == 200) {
                                                                                        print('id has beeen deleted ${deleteUp}');

                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.green, content: Text('Event deleted successfully!')),
                                                                                        );
                                                                                        //
                                                                                        Navigator.pop(context);
                                                                                        //
                                                                                        await fetchStudentCalendar();
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
                                                                                  },
                                                                                  child: Text(
                                                                                    'Delete',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                  )),
                                                                            ),
                                                                          ])
                                                                    ]);
                                                              });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/timetable_delete.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  var image = e.filePath;
                                                  var videoPath = e.filePath;

                                                  if (e.fileType == 'image') {
                                                    _PreviewBottomsheet(
                                                        context, image, null);
                                                  } else if (e.fileType ==
                                                      'link') {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            videoschoolv(
                                                                videoUrl:
                                                                    videoPath),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        e.fileType == 'image'
                                                            ? 'View Image'
                                                            : e.fileType ==
                                                                    'link'
                                                                ? 'View Video'
                                                                : '',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'regular',
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Colors.black,
                                                            decorationThickness:
                                                                2),
                                                      ),
                                                      //edit
                                                      if (UserSession().userType == 'admin' ||
                                                          UserSession()
                                                                  .userType ==
                                                              'staff' ||
                                                          UserSession()
                                                                  .userType ==
                                                              'superadmin')
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  content: Text(
                                                                    "Do you really want to make\n changes to this Event?",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'regular',
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  actions: <Widget>[
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.white,
                                                                                elevation: 0,
                                                                                side: BorderSide(color: Colors.black, width: 1)),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                            )),
                                                                        //edit...
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10),
                                                                          child:
                                                                              ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: AppTheme.textFieldborderColor,
                                                                                elevation: 0,
                                                                                side: BorderSide.none),
                                                                            onPressed:
                                                                                () {
                                                                              var calendarId = e.id;
                                                                              Navigator.pop(context);
                                                                              Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (context) => EditSchoolCalender(
                                                                                            Id: calendarId,
                                                                                            fetchStudentCalendar: fetchStudentCalendar,
                                                                                          )));
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Edit',
                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            child: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
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
                              ],
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

//preview bottomsheet...
  void _PreviewBottomsheet(
      BuildContext context, String? image, String? videoPath) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext modalContext) {
        print('preview $videoPath');
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(clipBehavior: Clip.none, children: [
              // Close icon
              Positioned(
                top: MediaQuery.of(context).size.height *
                    -0.08, // Adjust -70 relative to screen height
                left: MediaQuery.of(context).size.width *
                    0.45, // Adjust 180 relative to screen width

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
                      //
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: image != null
                              ? Image.network(
                                  image,
                                  fit: BoxFit.contain,
                                )
                              : videoPath != null
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: YoutubePlayer(
                                        controller: YoutubePlayerController(
                                          initialVideoId:
                                              YoutubePlayer.convertUrlToId(
                                                      videoPath)
                                                  .toString(),
                                          flags: const YoutubePlayerFlags(
                                            autoPlay: true,
                                            mute: false,
                                          ),
                                        ),
                                        showVideoProgressIndicator: true,
                                        aspectRatio: 16 / 9,
                                      ),
                                    )
                                  : const Text("No content available"),
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
//

class videoschoolv extends StatefulWidget {
  final String videoUrl;

  const videoschoolv({super.key, required this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<videoschoolv> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Reset to portrait mode when exiting fullscreen
    _controller.addListener(() {
      if (!_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6), // Apply same opacity color
        ),
        child: Center(
          child: YoutubePlayerBuilder(
            onEnterFullScreen: () {
              // Allow rotation in fullscreen only
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
            onExitFullScreen: () {
              // Lock back to portrait when exiting fullscreen
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
            ),
            builder: (context, player) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  player, // Video Player centered
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
