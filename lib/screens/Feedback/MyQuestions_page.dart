import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/Questions_feedback_model.dart';
import 'package:flutter_application_1/screens/Feedback/create_feedback.dart';
import 'package:flutter_application_1/screens/Feedback/received_feedback.dart';
import 'package:flutter_application_1/services/Feedback_Api/Question_feedback_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MyquestionsPage extends StatefulWidget {
  const MyquestionsPage({super.key});

  @override
  State<MyquestionsPage> createState() => _MyquestionsPageState();
}

class _MyquestionsPageState extends State<MyquestionsPage> {
  //select date
  String selectedDate = '';
  String displayDate = '';
  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
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

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
      displayDate = DateFormat('EEEE, dd MMMM').format(pickedDate);
    }
  }
  //selected date end

  bool isLoading = true;
  bool isswitched = false;

  @override
  void initState() {
    super.initState();
    fetchParentFeedback();
  }

  List<FeedbackDataQuestion> feedbackListQuestion = [];

  //fetch functions.......
  Future<void> fetchParentFeedback({
    String date = '',
  }) async {
    setState(() {
      isLoading = true;
    });
    final response = await fetchFeedback(
      rollNumber: UserSession().rollNumber ?? '',
      userType: UserSession().userType ?? '',
      date: date,
      isMyProject: isswitched ? 'Y' : 'N',
    );

    if (response != null) {
      setState(() {
        feedbackListQuestion = response.data;
        isLoading = false;
      });
      print('Feedback fetched successfully: ${response.data.length} items');
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch feedback.');
    }
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
                              'My Questions',
                              style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                await _selectDate(context);

                                await fetchParentFeedback(date: selectedDate);
                                setState(() {
                                  isLoading = true;
                                });
                                setState(() {
                                  isLoading = false;
                                });
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
                                  Text(
                                    displayDate,
                                    style: TextStyle(
                                      fontFamily: 'medium',
                                      color: Color.fromRGBO(73, 73, 73, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      decorationColor:
                                          Color.fromRGBO(75, 75, 75, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
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
                              isLoading = true;
                            });
                            fetchParentFeedback();
                          },
                        ),
                      ],
                    ),
                    //recieved..
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReceivedFeedback()));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromRGBO(251, 247, 245, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '•',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'medium',
                                  color: Color.fromRGBO(216, 70, 0, 1)),
                            ),
                            Text(
                              'Responses',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'medium',
                                  color: Color.fromRGBO(217, 78, 11, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateFeedback()));
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
                children: feedbackListQuestion.map((feedback) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 10, right: 15),
                        child: Text(
                          'Posted on: ${feedback.postedOnDate} | ${feedback.postedOnDay}',
                          style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ),
                      ...feedback.feedbackList.map((detail) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                border: Border.all(
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                    width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Feedback From: ${detail.name}',
                                    style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 12,
                                        color: Color.fromRGBO(16, 16, 16, 1)),
                                  ),
                                  Divider(
                                    color: Color.fromRGBO(230, 230, 230, 1),
                                    thickness: 1,
                                  ),
                                  Text(
                                    'Heading: ${detail.heading}',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Divider(
                                    color: Color.fromRGBO(230, 230, 230, 1),
                                    thickness: 1,
                                  ),
                                  Text(
                                    detail.question,
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            'Read More...',
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Spacer(),
                                        //delete..
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
                                                        "Do you really want to Delete\n  to this Feedback?",
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
                                                                          var deleteId =
                                                                              detail.questionId;
                                                                          final String
                                                                              url =
                                                                              'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBack/DeleteFeedBackForm?Id=$deleteId';

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
                                                                              print('id has beeen deleted ${deleteId}');

                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(backgroundColor: Colors.green, content: Text('Question deleted successfully!')),
                                                                              );
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete question.')),
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
                                          child: SvgPicture.asset(
                                            'assets/icons/timetable_delete.svg',
                                            fit: BoxFit.contain,
                                            height: 25,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
