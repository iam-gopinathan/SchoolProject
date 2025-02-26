import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Approval_Status/Approval_Status_menu.dart';
import 'package:flutter_application_1/screens/Messages/Message_mainPage.dart';
import 'package:flutter_application_1/screens/News/NewsMainPage.dart';
import 'package:flutter_application_1/screens/circularPage/circular_mainPage.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

class MyprojectMenu extends StatefulWidget {
  const MyprojectMenu({super.key});

  @override
  State<MyprojectMenu> createState() => _MyprojectMenuState();
}

class _MyprojectMenuState extends State<MyprojectMenu> {
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
        isswitched: true,
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
      "page": MessageMainpage(isswitched: true),
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
      "page": CircularMainpage(isswitched: true),
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
                          'My Project',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      Spacer(),
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.07,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApprovalStatusMenu()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color.fromRGBO(253, 247, 239, 1)),
                              child: Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(216, 70, 0, 1)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Approval Status',
                                      style: TextStyle(
                                          fontFamily: 'medium',
                                          fontSize: 16,
                                          color: Color.fromRGBO(216, 70, 0, 1)),
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
