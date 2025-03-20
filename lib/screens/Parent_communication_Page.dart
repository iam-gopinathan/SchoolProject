import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
import 'package:flutter_application_1/screens/ApprovalScreen/ApprovalMenu_Page.dart';
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
import 'package:flutter_application_1/screens/Myprojects_screens/Myproject_menu.dart';
import 'package:flutter_application_1/screens/News/NewsMainPage.dart';
import 'package:flutter_application_1/screens/Reset_Passwordscreen.dart';
import 'package:flutter_application_1/screens/Schoolcalender/schoolCalender_mainPage.dart';
import 'package:flutter_application_1/screens/StudyMaterial/studyMaterial_mainpage.dart';
import 'package:flutter_application_1/screens/TimeTables/timeTable_mainpage.dart';
import 'package:flutter_application_1/screens/circularPage/circular_mainPage.dart';
import 'package:flutter_application_1/screens/consentFoms/ParentYesOrNo_page.dart';
import 'package:flutter_application_1/screens/consentFoms/consentForm_mainpage.dart';
import 'package:flutter_application_1/screens/loginscreen.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentCommunicationPage extends StatefulWidget {
  final String username;
  final String userType;
  final String imagePath;
  final List<NewsArticle> newsArticles;
  ParentCommunicationPage(
      {super.key,
      required this.imagePath,
      required this.username,
      required this.userType,
      required this.newsArticles});

  @override
  State<ParentCommunicationPage> createState() => _CommunicationState();
}

class _CommunicationState extends State<ParentCommunicationPage> {
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
      "page": UserSession().userType == 'admin' ||
              UserSession().userType == 'superadmin' ||
              UserSession().userType == 'staff' ||
              UserSession().userType == 'teacher'
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
              UserSession().userType == 'teacher' ||
              UserSession().userType == 'staff' ||
              UserSession().userType == 'superadmin'
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
        "page": UserSession().userType == 'admin' ||
                UserSession().userType == 'staff' ||
                UserSession().userType == 'superadmin'
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
              UserSession().userType == 'teacher' ||
              UserSession().userType == 'superadmin' ||
              UserSession().userType == 'staff'
          ? AttendencePage(
              imagePath: '',
              userType: '',
              username: '',
            )
          : ParentAttendenceMainpage(),
    },
  ];

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
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1,
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
              //password section..
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordscreen(),
                            ),
                          );
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
              )
            ],
          ),
        ),
      ),
    );
  }
  //

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
}
