import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ImportanteventsMainpage extends StatefulWidget {
  const ImportanteventsMainpage({super.key});

  @override
  State<ImportanteventsMainpage> createState() =>
      _ImportanteventsMainpageState();
}

class _ImportanteventsMainpageState extends State<ImportanteventsMainpage> {
  ScrollController _scrollController = ScrollController();

  bool isswitched = false;
  DateTime? _startDate;
  DateTime? _endDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndDisplayEvents();

    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);
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

  bool isLoading = true;

  late EventsResponsess events = EventsResponsess(
    todayEvents: [],
    upComingEvents: [],
    allEvents: [],
  );

  Future<void> fetchAndDisplayEvents({String date = ''}) async {
    try {
      isLoading = true;
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
  // bool isEventDay(DateTime day) {
  //   for (var event in events.allEvents) {
  //     if (day.isAfter(event.parsedFromDate.subtract(Duration(days: 1))) &&
  //         day.isBefore(event.parsedToDate.add(Duration(days: 1)))) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
  bool isEventDay(DateTime day) {
    for (var event in events.allEvents) {
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

    fetchAndDisplayEvents(date: formattedDate);

    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100),
      //   child: AppBar(
      //     backgroundColor: Colors.white,
      //     iconTheme: IconThemeData(color: Colors.black),
      //     automaticallyImplyLeading: false,
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         color: AppTheme.appBackgroundPrimaryColor,
      //         borderRadius: BorderRadius.only(
      //             bottomLeft: Radius.circular(30),
      //             bottomRight: Radius.circular(30)),
      //       ),
      //       padding: EdgeInsets.all(10),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Row(
      //             children: [
      //               GestureDetector(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: Icon(
      //                   Icons.arrow_back,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //               SizedBox(width: MediaQuery.of(context).size.width * 0.01),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 children: [
      //                   Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Event Calender',
      //                         style: TextStyle(
      //                           fontFamily: 'semibold',
      //                           fontSize: 16,
      //                           color: Colors.black,
      //                         ),
      //                       ),
      //                       SizedBox(height: 10),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //               Spacer(),
      //               //add screen....
      //               if (UserSession().userType == 'admin' ||
      //                   UserSession().userType == 'staff' ||
      //                   UserSession().userType == 'superadmin')
      //                 Padding(
      //                   padding: const EdgeInsets.only(right: 30),
      //                   child: GestureDetector(
      //                     onTap: () {
      //                       Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) => CreateEventCalender(
      //                                   fetchAndDisplayEvents:
      //                                       fetchAndDisplayEvents)));
      //                     },
      //                     child: Container(
      //                       padding: EdgeInsets.all(10),
      //                       decoration: BoxDecoration(
      //                         color: AppTheme.Addiconcolor,
      //                         shape: BoxShape.circle,
      //                       ),
      //                       child: Icon(
      //                         Icons.add,
      //                         color: Colors.black,
      //                         size: 30,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
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
                                    'Event Calender',
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
                            right: MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateEventCalender(
                                          fetchAndDisplayEvents:
                                              fetchAndDisplayEvents)));
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      color: Color.fromRGBO(254, 251, 250, 1),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: TableCalendar(
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                                color: Color.fromRGBO(
                                                    219, 71, 0, 1),
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
                                                  CreateEventCalender(
                                                    fetchAndDisplayEvents:
                                                        fetchAndDisplayEvents,
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
                          focusedDay: focusedDay,
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
                          onPageChanged: (focusedDay) {
                            setState(() {
                              this.focusedDay = focusedDay;
                            });
                            onMonthChanged(focusedDay);
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
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width *
                                0.05, // 5% of screen width
                            top: MediaQuery.of(context).size.height *
                                0.025, // 2.5% of screen height
                            bottom: MediaQuery.of(context).size.height *
                                0.012, // 1.2% of screen height
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
                        Column(
                          children: [
                            if (events.todayEvents.isEmpty)
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                          top: MediaQuery.of(context).size.height *
                              0.025, // 2.5% of screen height
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
                      if (events.upComingEvents.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Text(
                              UserSession().userType == 'student' ||
                                      UserSession().userType == 'teacher'
                                  ? "No messages from the school yet. Stay tuned for updates!"
                                  : "You haven’t made anything yet;\nstart creating now!",
                              style: TextStyle(
                                fontSize: 16, //
                                fontFamily: 'regular',
                                color: Color.fromRGBO(145, 145, 145, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        ...events.upComingEvents.map((upcoming) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              top: 15,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.04),
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
                                                    vertical: 10,
                                                    horizontal: 15),
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
                                              if (upcoming.from != upcoming.to)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                              if (upcoming.from != upcoming.to)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                          if (UserSession().userType == 'admin' ||
                                              UserSession().userType ==
                                                  'staff' ||
                                              UserSession().userType ==
                                                  'superadmin')
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
                                                        "Do you really want to Delete\n  this Event?",
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
                                                                      backgroundColor:
                                                                          AppTheme
                                                                              .textFieldborderColor,
                                                                      elevation:
                                                                          0,
                                                                      side: BorderSide
                                                                          .none),
                                                                  onPressed:
                                                                      () async {
                                                                    var deleteevent =
                                                                        upcoming
                                                                            .id;

                                                                    print(
                                                                        deleteevent);
                                                                    String url =
                                                                        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeEventCalender/DeleteEventCalender?Id=$deleteevent';

                                                                    try {
                                                                      final response =
                                                                          await http
                                                                              .delete(
                                                                        Uri.parse(
                                                                            url),
                                                                        headers: {
                                                                          'Content-Type':
                                                                              'application/json',
                                                                          'Authorization':
                                                                              'Bearer $authToken',
                                                                        },
                                                                      );

                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        print(
                                                                            'id has beeen deleted ${deleteevent}');

                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                              backgroundColor: Colors.green,
                                                                              content: Text('Event deleted successfully!')),
                                                                        );

                                                                        Navigator.pop(
                                                                            context);
                                                                        //
                                                                        await fetchAndDisplayEvents();
                                                                      } else {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                              backgroundColor: Colors.red,
                                                                              content: Text('Failed to delete Event.')),
                                                                        );
                                                                      }
                                                                    } catch (e) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                            content:
                                                                                Text('An error occurred: $e')),
                                                                      );
                                                                    }
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'regular'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ])
                                                      ],
                                                    );
                                                  },
                                                );
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
                                        var video = upcoming.filePath;
                                        if (upcoming.fileType == 'image') {
                                          _PreviewBottomsheet(
                                              context, image, null);
                                        } else if (upcoming.fileType ==
                                            'link') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  videoimportantv(
                                                      videoUrl: video),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        child: Column(
                                          children: [
                                            Text(
                                              upcoming.fileType == 'image'
                                                  ? 'View Image'
                                                  : upcoming.fileType == 'link'
                                                      ? 'View Video'
                                                      : '',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.black,
                                                  decorationThickness: 2),
                                            ),
                                            //
                                            if (UserSession().userType == 'admin' ||
                                                UserSession().userType ==
                                                    'staff' ||
                                                UserSession().userType ==
                                                    'superadmin')
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            content: Text(
                                                              "Do you really want to make\n changes to this Event?",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 16,
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
                                                                            backgroundColor: Colors
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
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'regular'),
                                                                        )),
                                                                    //edit...
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                      child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => EditEventCalender(
                                                                                          id: upcoming.id,
                                                                                          fetchAndDisplayEvents: fetchAndDisplayEvents,
                                                                                        )));

                                                                            print(upcoming.id);
                                                                          },
                                                                          child: Text(
                                                                            'Edit',
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
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
  void _PreviewBottomsheet(BuildContext context, String? image, String? video) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext modalContext) {
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
                                : video != null
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: YoutubePlayer(
                                          controller: YoutubePlayerController(
                                            initialVideoId:
                                                YoutubePlayer.convertUrlToId(
                                                        video)
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
              ],
            );
          },
        );
      },
    );
  }
}

class videoimportantv extends StatefulWidget {
  final String videoUrl;

  const videoimportantv({super.key, required this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<videoimportantv> {
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
