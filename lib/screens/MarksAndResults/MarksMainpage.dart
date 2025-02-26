import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/screens/MarksAndResults/AddMarks.dart';
import 'package:flutter_application_1/screens/MarksAndResults/Marks_showPage.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Marksmainpage extends StatefulWidget {
  const Marksmainpage({super.key});

  @override
  State<Marksmainpage> createState() => _MarksmainpageState();
}

class _MarksmainpageState extends State<Marksmainpage> {
  ScrollController _scrollController = ScrollController();

  bool isswitched = false;

  final gradeController = Get.find<GradeController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gradeController.fetchGrades();

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
                    top: MediaQuery.of(context).size.height * 0.04,
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Marks/Results',
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
                      //add screen....
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.04),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Addmarks()));
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Nursery ExpansionTile
              Theme(
                data: Theme.of(context).copyWith(
                  expansionTileTheme: ExpansionTileThemeData(
                    iconColor: Colors.black,
                    collapsedIconColor: Colors.black,
                    collapsedBackgroundColor: Color.fromRGBO(253, 250, 254, 1),
                  ),
                ),
                child: Obx(() {
                  var nurseryGrades = gradeController.gradeList
                      .where((grade) => grade['category'] == 'Nursery')
                      .toList();

                  String categoryTitle = nurseryGrades.isNotEmpty
                      ? nurseryGrades[0]['category']
                      : '';

                  return ExpansionTile(
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Color.fromRGBO(253, 250, 254, 1),
                    shape: Border(),
                    title: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Color.fromRGBO(134, 0, 187, 1),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${categoryTitle} Results',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'medium',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textColor: Colors.black,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.025),
                        child: nurseryGrades.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: AppTheme.textFieldborderColor,
                              ))
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5 / 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: nurseryGrades.length,
                                itemBuilder: (context, index) {
                                  var grade = nurseryGrades[
                                      index]; // Use grade inside GridView
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MarksShowpage(
                                              gradeId: grade['id']),
                                        ),
                                      );
                                      print(grade['id']);
                                    },
                                    child: Card(
                                      color: Color.fromRGBO(253, 251, 254, 1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      176, 93, 208, 1),
                                                  Color.fromRGBO(
                                                      134, 0, 187, 1),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/marks_calender.svg',
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Text(
                                                    grade['sign'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }),
              ),

              //primary grades...
              Theme(
                data: Theme.of(context).copyWith(
                  expansionTileTheme: ExpansionTileThemeData(
                    iconColor: Colors.black,
                    collapsedIconColor: Colors.black,
                    collapsedBackgroundColor: Color.fromRGBO(253, 250, 254, 1),
                  ),
                ),
                child: Obx(() {
                  var PrimaryGrades = gradeController.gradeList
                      .where((grade) => grade['category'] == 'Primary')
                      .toList();

                  String categoryTitle = PrimaryGrades.isNotEmpty
                      ? PrimaryGrades[0]['category']
                      : '';

                  return ExpansionTile(
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Color.fromRGBO(253, 250, 254, 1),
                    shape: Border(),
                    title: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Color.fromRGBO(206, 92, 0, 1),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${categoryTitle} Results',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'medium',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textColor: Colors.black,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: PrimaryGrades.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: AppTheme.textFieldborderColor,
                              ))
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5 / 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: PrimaryGrades.length,
                                itemBuilder: (context, index) {
                                  var grade = PrimaryGrades[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MarksShowpage(
                                              gradeId: grade['id']),
                                        ),
                                      );
                                      print(grade['id']);
                                    },
                                    child: Card(
                                      color: Color.fromRGBO(254, 253, 251, 1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      252, 170, 103, 1),
                                                  Color.fromRGBO(206, 92, 0, 1),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/marks_calender.svg',
                                                    fit: BoxFit.contain,
                                                    color: Color.fromRGBO(
                                                        206, 92, 0, 1),
                                                  ),
                                                  Text(
                                                    grade['sign'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }),
              ),

              //secondary...
              Theme(
                data: Theme.of(context).copyWith(
                  expansionTileTheme: ExpansionTileThemeData(
                    iconColor: Colors.black,
                    collapsedIconColor: Colors.black,
                    collapsedBackgroundColor: Color.fromRGBO(253, 250, 254, 1),
                  ),
                ),
                child: Obx(() {
                  var secondaryGrades = gradeController.gradeList
                      .where((grade) => grade['category'] == 'Secondary')
                      .toList();

                  String categoryTitle = secondaryGrades.isNotEmpty
                      ? secondaryGrades[0]['category']
                      : '';

                  return ExpansionTile(
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Color.fromRGBO(253, 250, 254, 1),
                    shape: Border(),
                    title: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Color.fromRGBO(141, 1, 117, 1),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${categoryTitle} Results',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'medium',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textColor: Colors.black,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: secondaryGrades.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: AppTheme.textFieldborderColor,
                              ))
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5 / 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: secondaryGrades.length,
                                itemBuilder: (context, index) {
                                  var grade = secondaryGrades[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MarksShowpage(
                                              gradeId: grade['id']),
                                        ),
                                      );
                                      print(grade['id']);
                                    },
                                    child: Card(
                                      color: Color.fromRGBO(253, 250, 252, 1),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromRGBO(
                                                      243, 2, 201, 1),
                                                  Color.fromRGBO(
                                                      141, 1, 117, 1),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/marks_calender.svg',
                                                    fit: BoxFit.contain,
                                                    color: Color.fromRGBO(
                                                        141, 1, 117, 1),
                                                  ),
                                                  Text(
                                                    grade['sign'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
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
