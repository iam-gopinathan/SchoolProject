import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/ExamTimeTable/Create_exam_timetables.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ExamtimetableMainpage extends StatefulWidget {
  const ExamtimetableMainpage({super.key});

  @override
  State<ExamtimetableMainpage> createState() => _ExamtimetableMainpageState();
}

class _ExamtimetableMainpageState extends State<ExamtimetableMainpage> {
  bool isswitched = false;
  //select date
  String selectedDate = '';
  var displayDate = '';
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

  final List<String> classes = [
    'PREKG',
    'LKG',
    'UKG',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
  ];

  //filter bottom sheet

  ///filter bottomsheeet
  void _showFilterBottomSheet(BuildContext context) {
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
              // Close icon
              Positioned(
                top: -70,
                left: 180,
                child: GestureDetector(
                  onTap: () {
                    setModalState(() {});
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
                height: MediaQuery.of(context).size.height *
                    0.4, //bottomsheet containner
                width: double.infinity,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'Select Class and Section',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
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
                            //select class
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 20),
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
                            //classes..
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: classes.map((className) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Container(
                                        width: 100,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  223, 223, 223, 1)),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {});
                                            },
                                            child: Text(
                                              className,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'medium',
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            //sectionwise.....
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Select Section',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'regular',
                                      color: Color.fromRGBO(53, 53, 53, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Display sections below the classes
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    // Dynamic sections
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() {});
                                        },
                                        child: Container(
                                          width: 100,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  223, 223, 223, 1),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'medium',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.textFieldborderColor),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'OK',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              )
            ],
          );
        });
      },
    );
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
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                await _selectDate(context);
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
                                      fontSize: 12,
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
                    Spacer(),
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
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    //filter icon..
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

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateExamTimetables()));
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Transform.translate(
                    offset: Offset(20, 16),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(48, 126, 185, 1),
                                Color.fromRGBO(0, 70, 123, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                          )),
                      child: Text(
                        'PreKG',
                        style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showMenu(
                  context: context,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  position: RelativeRect.fromLTRB(100, 180, 0, 0),
                  items: [
                    PopupMenuItem<String>(
                      value: 'exam1',
                      child: Text(
                        '3rd midterm Text 2024-2025',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'exam2',
                      child: Text(
                        '3rd midterm Text 2024-2025',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'exam3',
                      child: Text(
                        '3rd midterm Text 2024-2025',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ),
                  ],
                  elevation: 8.0,
                ).then((value) {
                  if (value != null) {
                    print('Selected: $value');
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
                            color: Color.fromRGBO(47, 47, 47, 1)),
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
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromRGBO(238, 238, 238, 1), width: 1.5)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 5),
                        child: Row(
                          children: [
                            Text(
                              'Posted on : 13.11.2024 | Tuesday',
                              style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 12,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      ExpansionTile(
                        shape: Border(),
                        title: Row(
                          children: [
                            Text(
                              '3rd Mid Term Test  2024- 2025',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            //today text...

                            Transform.translate(
                              offset: Offset(5, 17),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    color: AppTheme.textFieldborderColor),
                                child: Text(
                                  'Today',
                                  style: TextStyle(
                                      color: Color.fromRGBO(49, 49, 49, 1),
                                      fontFamily: 'medium',
                                      fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/Exam_timetable.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Posted by : Admin - Nandhini M.',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(138, 138, 138, 1)),
                                    ),
                                    Text(
                                      'Time : 10.45 Am',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(138, 138, 138, 1)),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/timetable_upload.svg'),
                                      Text(
                                        'Reupload',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                //delete icon
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/timetable_delete.svg',
                                    fit: BoxFit.contain,
                                    height: 25,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
