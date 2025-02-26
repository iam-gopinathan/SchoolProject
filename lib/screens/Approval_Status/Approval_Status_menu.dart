import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Approval_Status/Approval_Message_StatusPage.dart';
import 'package:flutter_application_1/screens/Approval_Status/Approval_circular_statusPage.dart';
import 'package:flutter_application_1/screens/Approval_Status/Approval_news_StatusPage.dart';
import 'package:flutter_application_1/user_Session.dart';

import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

class ApprovalStatusMenu extends StatefulWidget {
  const ApprovalStatusMenu({super.key});

  @override
  State<ApprovalStatusMenu> createState() => _ApprovalStatusMenuState();
}

class _ApprovalStatusMenuState extends State<ApprovalStatusMenu> {
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
      "page": ApprovalNewsStatuspage(),
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
      "page": ApprovalMessageStatuspage(),
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
      "page": ApprovalCircularStatuspage(),
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('usertype:${UserSession().userType}');
    print('rollnumber:${UserSession().rollNumber}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(251, 251, 251, 1),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(30),
      //       bottomRight: Radius.circular(30),
      //     ),
      //     child: AppBar(
      //       iconTheme: IconThemeData(color: Colors.black),
      //       backgroundColor: AppTheme.appBackgroundPrimaryColor,
      //       leading: GestureDetector(
      //           onTap: () async {
      //             Navigator.pop(context);
      //           },
      //           child: Icon(Icons.arrow_back)),
      //       title: Text(
      //         'Approvals Status',
      //         style: TextStyle(
      //           fontFamily: 'semibold',
      //           fontSize: 16,
      //           color: Colors.black,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
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
                    top: MediaQuery.of(context).size.height * 0.04,
                  ), // 3% of screen height),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Approvals Status',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
    );
  }
}
