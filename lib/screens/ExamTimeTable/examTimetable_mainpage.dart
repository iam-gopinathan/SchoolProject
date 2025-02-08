import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Exam_Timetable/Exam_timetable_Main_Model.dart';
import 'package:flutter_application_1/screens/ExamTimeTable/Create_exam_timetables.dart';
import 'package:flutter_application_1/screens/ExamTimeTable/Edit_ExamTimeTable.dart';
import 'package:flutter_application_1/services/ExamTimetables_Api/examTimetable_main_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExamtimetableMainpage extends StatefulWidget {
  const ExamtimetableMainpage({super.key});

  @override
  State<ExamtimetableMainpage> createState() => _ExamtimetableMainpageState();
}

class _ExamtimetableMainpageState extends State<ExamtimetableMainpage> {
  ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  int initiallyExpandedIndex = 0;
  late Future<List<ExamTimetableMainModel>> ExamtimeTableFuture =
      Future.value([]);

  final GradeController gradeController = Get.put(GradeController());
  bool isswitched = false;

  Future<void> _fetchExamMaintimetable(
      {String gradeId = '131', String exam = ''}) async {
    try {
      final fetchedData = await fetchExamTimetable(
        rollNumber: UserSession().rollNumber.toString(),
        userType: UserSession().userType.toString(),
        grade: gradeId,
        isMyProject: isswitched ? 'Y' : 'N',
        exam: exam,
      );
      setState(() {
        isLoading = false;
        ExamtimeTableFuture = Future.value(fetchedData);
      });
    } catch (e) {
      print('Error fetching timetable: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchExamMaintimetable();
    gradeController.fetchGrades();

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

//bottom sheet code.
  void _showFilterBottomSheet(BuildContext context) {
    String selectedGrade = '';

    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
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
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Select Class ',
                                style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 0,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                // Select Class
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 30, left: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Select Class',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'regular',
                                          color: Color.fromRGBO(53, 53, 53, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Classes
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                        gradeController.gradeList.length,
                                        (index) {
                                          var grade =
                                              gradeController.gradeList[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedGrade =
                                                      grade['id'].toString();
                                                });
                                              },
                                              child: Container(
                                                width: 100,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: selectedGrade ==
                                                          grade['id'].toString()
                                                      ? AppTheme
                                                          .textFieldborderColor
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        223, 223, 223, 1),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    grade['sign'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.textFieldborderColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _fetchExamMaintimetable(gradeId: selectedGrade);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontFamily: 'semibold',
                                    fontSize: 16,
                                    color: Colors.black,
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
            );
          },
        );
      },
    );
  }

  //
  final GradeController _gradeController = Get.put(GradeController());
  String _getClassSignByGradeId(String gradeId) {
    final grade = _gradeController.gradeList.firstWhere(
      (grade) => grade['id'].toString() == gradeId,
      orElse: () => {'sign': 'Not Found'},
    );
    return grade['sign'] ?? 'Unknown';
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
                              'Exam Timetable',
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
                    Spacer(),
                    if (UserSession().userType == 'admin')
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
                                  isLoading = true;

                                  print(
                                      'Switch is: ${isswitched ? "ON (Y)" : "OFF (N)"}');
                                });
                                _fetchExamMaintimetable();
                              },
                            ),
                          ],
                        ),
                      ),
                    //filter icon..
                    if (UserSession().userType == 'admin' ||
                        UserSession().userType == 'teacher')
                      GestureDetector(
                        onTap: () {
                          _showFilterBottomSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: SvgPicture.asset(
                            'assets/icons/Filter_icon.svg',
                            fit: BoxFit.contain,
                            height: 30,
                          ),
                        ),
                      ),
                    if (UserSession().userType == 'admin')
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateExamTimetables(
                                        fetchmainexam: _fetchExamMaintimetable,
                                      )));
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
          : FutureBuilder(
              future: ExamtimeTableFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No Exam Timetable available.'));
                } else {
                  var data = snapshot.data!;
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        ...data.map((e) {
                          var classSign =
                              _getClassSignByGradeId(e.gradeId.toString());
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Transform.translate(
                                      offset: Offset(20, 16),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(48, 126, 185, 1),
                                              Color.fromRGBO(0, 70, 123, 1),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          '$classSign',
                                          style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  gradeController.fetchGrades();
                                  showMenu(
                                    context: context,
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    position:
                                        RelativeRect.fromLTRB(100, 180, 0, 0),
                                    items: [
                                      PopupMenuItem<String>(
                                        enabled: false,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 150,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: gradeController.examList
                                                  .map((exam) {
                                                return PopupMenuItem<String>(
                                                  value: exam,
                                                  child: Text(
                                                    exam,
                                                    style: const TextStyle(
                                                      fontFamily: 'regular',
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    elevation: 8.0,
                                  ).then((value) {
                                    if (value != null) {
                                      print('Selected: $value');
                                      _fetchExamMaintimetable(exam: value);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/Filter_icon.svg',
                                        fit: BoxFit.contain,
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          'by Exams',
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 12,
                                            color:
                                                Color.fromRGBO(47, 47, 47, 1),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Posted on : ${e.postedOn} | ${e.day}',
                                                style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        ExpansionTile(
                                          initiallyExpanded:
                                              data.indexOf(e) == 0,
                                          shape: Border(),
                                          title: Row(
                                            children: [
                                              Text(
                                                '${e.exam}',
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Center(
                                                  child: Opacity(
                                                    opacity: 0.6,
                                                    child: Image.network(
                                                      '${e.filePath}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                //
                                                GestureDetector(
                                                  onTap: () {
                                                    var imagePath = e.filePath;
                                                    _showBottomSheetss(
                                                        context, imagePath);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Text(
                                                      'View Image',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'semibold',
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 25),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Posted by : ${e.postedBy}',
                                                        style: TextStyle(
                                                          fontFamily: 'regular',
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(
                                                              138, 138, 138, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  if (UserSession().userType ==
                                                      'admin')
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
                                                                    "Do you really want to make\n changes to this ExamTimetable?",
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
                                                                          //edit...
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                          builder: (context) => EditExamtimetable(
                                                                                                id: e.id,
                                                                                                fetchmainexam: _fetchExamMaintimetable,
                                                                                              )));
                                                                                },
                                                                                child: Text(
                                                                                  'Edit',
                                                                                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                )),
                                                                          ),
                                                                        ])
                                                                  ]);
                                                            });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                                'assets/icons/timetable_upload.svg'),
                                                            Text(
                                                              'Reupload',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'medium',
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  // delete icon
                                                  if (UserSession().userType ==
                                                      'admin')
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
                                                                    "Do you really want to Delete\n  to this ExamTimetable?",
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
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                onPressed: () async {
                                                                                  var examtimetableId = e.id;
                                                                                  final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeExamTimetable/DeleteExamTimeTable?Id=$examtimetableId';

                                                                                  try {
                                                                                    final response = await http.delete(
                                                                                      Uri.parse(url),
                                                                                      headers: {
                                                                                        'Content-Type': 'application/json',
                                                                                        'Authorization': 'Bearer $authToken',
                                                                                      },
                                                                                    );

                                                                                    if (response.statusCode == 200) {
                                                                                      print('id has beeen deleted ${examtimetableId}');

                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(backgroundColor: Colors.green, content: Text('Examtimetable deleted successfully!')),
                                                                                      );

                                                                                      // Refresh the news data after deletion
                                                                                      Navigator.pop(context);
                                                                                      //
                                                                                      await _fetchExamMaintimetable();
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete examtimetable.')),
                                                                                      );
                                                                                    }
                                                                                  } catch (e) {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(content: Text('An error occurred: $e')),
                                                                                    );
                                                                                  }
                                                                                  _fetchExamMaintimetable();

                                                                                  Navigator.pop(context);
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
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/timetable_delete.svg',
                                                          fit: BoxFit.contain,
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),

                                                  //
                                                  //download
                                                  if (UserSession().userType ==
                                                      'student')
                                                    GestureDetector(
                                                      onTap: () {
                                                        var imageUrl =
                                                            e.filePath;
                                                        downloadImage(imageUrl);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 20),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.5)),
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icons/Dwnl_icon.svg',
                                                              fit: BoxFit
                                                                  .contain,
                                                              height: 20,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: Text(
                                                                'Download',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'medium',
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
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
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }
              },
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

  ///image bottomsheeet.....
  void _showBottomSheet(BuildContext context, String imagePath) {
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
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: Image.network(
                        '${imagePath}',
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                  ),
                  //dwnl
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.textFieldborderColor),
                        onPressed: () {
                          downloadImage(imagePath);
                        },
                        child: Text(
                          'Download',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 16,
                              color: Colors.black),
                        )),
                  )
                ],
              ),
            ),
          ]);
        });
      },
    );
  }

  //show image bottomsheet code end....
//show image bottomsheet code end....
  Future<void> downloadImage(String imageUrl) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        print("Failed to get external storage directory.");
        return;
      }
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }
      final filePath =
          '${downloadsDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Image downloaded to: $filePath');
        showDownloadNotification(filePath);
      } else {
        print('Failed to download image');
      }
    } catch (e) {
      print('Error occurred while downloading image: $e');
    }
  }

// Function to show download notification
  void showDownloadNotification(String filePath) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel',
      'Download Notifications',
      channelDescription: 'Notifications related to downloads',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      10,
      'Download Complete',
      'Image downloaded successfully to $filePath',
      platformDetails,
      payload: filePath,
    );
  }

//
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          print("Notification clicked! Opening file: ${response.payload}");
          openFile(response.payload!);
        } else {
          print("Notification clicked, but no payload received.");
        }
      },
    );
  }

  void openFile(String filePath) {
    print("Opening file: $filePath");
    OpenFile.open(filePath);
  }

  //
  void _showBottomSheetss(BuildContext context, String? imagePath) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Close icon
                Positioned(
                  top: -70,
                  left: MediaQuery.of(context).size.width / 2 - 28,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
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
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Image.network(
                      imagePath ?? '',
                      fit: BoxFit.contain,
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
