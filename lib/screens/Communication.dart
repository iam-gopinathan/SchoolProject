import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/AttendencePage/Attendence_page.dart';
import 'package:flutter_application_1/screens/AttendencePage/Parent_Attendence_mainPage.dart';
import 'package:flutter_application_1/screens/ExamTimeTable/examTimetable_mainpage.dart';
import 'package:flutter_application_1/screens/Feedback/ParentFeedback_Mainpage.dart';

import 'package:flutter_application_1/screens/Feedback/feedback_mainpage.dart';
import 'package:flutter_application_1/screens/Homeworks/Homework_Mainpage.dart';
import 'package:flutter_application_1/screens/ImportantEvents/ImportantEvents_mainpage.dart';
import 'package:flutter_application_1/screens/MarksAndResults/MarksMainpage.dart';
import 'package:flutter_application_1/screens/MarksAndResults/Parent_MarksandResults.dart';
import 'package:flutter_application_1/screens/Messages/Message_mainPage.dart';
import 'package:flutter_application_1/screens/News/NewsMainPage.dart';
import 'package:flutter_application_1/screens/Schoolcalender/schoolCalender_mainPage.dart';
import 'package:flutter_application_1/screens/StudyMaterial/studyMaterial_mainpage.dart';
import 'package:flutter_application_1/screens/TimeTables/Teacher_timetable_create.dart';
import 'package:flutter_application_1/screens/TimeTables/timeTable_mainpage.dart';
import 'package:flutter_application_1/screens/circularPage/circular_mainPage.dart';
import 'package:flutter_application_1/screens/consentFoms/ParentYesOrNo_page.dart';

import 'package:flutter_application_1/screens/consentFoms/consentForm_mainpage.dart';
import 'package:flutter_application_1/user_Session.dart';

import 'package:flutter_svg/flutter_svg.dart';

class Communication extends StatefulWidget {
  final String username;
  final String userType;
  final String imagePath;
  Communication(
      {super.key,
      required this.imagePath,
      required this.username,
      required this.userType});

  @override
  State<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("rollll${UserSession().rollNumber}");
  }

  final List<Map<String, dynamic>> items = [
    {
      "svg": 'assets/icons/Attendancepage_news.svg',
      "label": "News",
      "color": [
        Color.fromRGBO(176, 93, 208, 0.1),
        Color.fromRGBO(134, 0, 187, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 248, 251, 1),
        Color.fromRGBO(250, 248, 251, 1)
      ],
      "page": Newsmainpage(
        isswitched: false,
      ),
    },
    {
      "svg": 'assets/icons/Attendancepage_message.svg',
      "label": "Messages",
      "color": [
        Color.fromRGBO(252, 170, 103, 0.1),
        Color.fromRGBO(206, 92, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 252, 251, 1),
        Color.fromRGBO(254, 252, 251, 1),
      ],
      "page": MessageMainpage(
        isswitched: false,
      ),
    },
    {
      "svg": 'assets/icons/Attendancepage_notesoutline.svg',
      "label": "Circulars",
      "color": [
        Color.fromRGBO(125, 195, 83, 0.1),
        Color.fromRGBO(66, 177, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(252, 253, 250, 1),
        Color.fromRGBO(252, 253, 250, 1)
      ],
      "page": CircularMainpage(
        isswitched: false,
      ),
    },
    {
      "svg": 'assets/icons/Attendencepage_form.svg',
      "label": "Consent\n Forms",
      "color": [
        Color.fromRGBO(216, 70, 0, 0.1),
        Color.fromRGBO(219, 71, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 251, 250, 1),
        Color.fromRGBO(254, 251, 250, 1),
      ],
      "page": UserSession().userType == 'admin'
          ? ConsentformMainpage()
          : ParentyesornoPage(),
    },
    {
      "svg": 'assets/icons/Attendencepage_time.svg',
      "label": "Time Tables",
      "color": [
        Color.fromRGBO(255, 212, 0, 0.1),
        Color.fromRGBO(224, 186, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 253, 250, 1),
        Color.fromRGBO(254, 253, 250, 1),
      ],
      "page": TimetableMainpage(),
    },
    {
      "svg": 'assets/icons/Attendancepage_homework.svg',
      "label": "Homeworks",
      "color": [
        Color.fromRGBO(230, 1, 84, 0.1),
        Color.fromRGBO(223, 0, 81, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 250, 251, 1),
        Color.fromRGBO(254, 250, 251, 1),
      ],
      "page": HomeworkMainpage(),
    },
    {
      "svg": 'assets/icons/Attendencepage_examhomework.svg',
      "label": "Exam\n Timetables",
      "color": [
        Color.fromRGBO(105, 57, 184, 0.1),
        Color.fromRGBO(57, 0, 149, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(251, 250, 253, 1),
        Color.fromRGBO(251, 250, 253, 1),
      ],
      "page": ExamtimetableMainpage(),
    },
    {
      "svg": 'assets/icons/Attendencepage_book.svg',
      "label": "Study\n Materials",
      "color": [
        Color.fromRGBO(31, 115, 194, 0.1),
        Color.fromRGBO(0, 78, 152, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 251, 253, 1),
        Color.fromRGBO(250, 251, 253, 1)
      ],
      "page": StudymaterialMainpage(),
    },
    {
      "svg": 'assets/icons/Attendencepage_audit.svg',
      "label": "Marks /\n Results",
      "color": [
        Color.fromRGBO(0, 65, 166, 0.1),
        Color.fromRGBO(11, 46, 100, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 251, 252, 1),
        Color.fromRGBO(250, 251, 252, 1),
      ],
      "page": UserSession().userType == 'admin' ||
              UserSession().userType == 'teacher'
          ? Marksmainpage()
          : ParentMarksandresults(),
    },
    {
      "svg": 'assets/icons/Attendencepage_calendar.svg',
      "label": "School\n Calendar",
      "color": [
        Color.fromRGBO(31, 200, 219, 0.1),
        Color.fromRGBO(0, 118, 131, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 252, 252, 1),
        Color.fromRGBO(250, 252, 252, 1),
      ],
      "page": SchoolcalenderMainpage(),
    },
    {
      "svg": 'assets/icons/Attendancepage_microphone.svg',
      "label": "Important\n Events",
      "color": [
        Color.fromRGBO(72, 81, 166, 0.1),
        Color.fromRGBO(0, 16, 169, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 250, 253, 1),
        Color.fromRGBO(250, 250, 253, 1),
      ],
      "page": ImportanteventsMainpage(),
    },
    if (UserSession().userType != 'teacher')
      {
        "svg": 'assets/icons/Attendencepage_comment.svg',
        "label": "Feedback",
        "color": [
          Color.fromRGBO(250, 90, 42, 0.1),
          Color.fromRGBO(204, 47, 0, 0.1)
        ],
        "cardcolor": [
          Color.fromRGBO(254, 251, 250, 1),
          Color.fromRGBO(254, 251, 250, 1),
        ],
        "page": UserSession().userType == 'admin'
            ? FeedbackMainpage()
            : ParentfeedbackMainpage(),
      },
    {
      "svg": 'assets/icons/Attendencepage_timeline.svg',
      "label": "Attendance",
      "color": [
        Color.fromRGBO(243, 2, 201, 0.1),
        Color.fromRGBO(141, 1, 117, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(253, 250, 252, 1),
        Color.fromRGBO(253, 250, 252, 1),
      ],
      "page": UserSession().userType == 'admin' ||
              UserSession().userType == 'teacher'
          ? AttendencePage(
              imagePath: '',
              userType: '',
              username: '',
            )
          : ParentAttendenceMainpage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              color: Colors.white,
              child: GridView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => item['page'],
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: null,
                          gradient: LinearGradient(
                            colors: item['cardcolor'],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: item['color'],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  item['svg'],
                                  fit: BoxFit.contain,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['label'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'medium',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
