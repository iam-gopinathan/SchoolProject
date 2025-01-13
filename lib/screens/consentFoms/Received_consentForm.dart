import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/ConsentForm/receivedConsent_model.dart';

import 'package:flutter_application_1/screens/consentFoms/Create_consentFormPage.dart';
import 'package:flutter_application_1/services/ConsentForm/Received_consentform_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReceivedConsentform extends StatefulWidget {
  final Function fetch;
  const ReceivedConsentform({super.key, required this.fetch});

  @override
  State<ReceivedConsentform> createState() => _ReceivedConsentformState();
}

class _ReceivedConsentformState extends State<ReceivedConsentform> {
  ScrollController _scrollController = ScrollController();
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

  //show filter
  String _selectedFilter = "All Responses";

  void _showFilterMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      color: Colors.black,
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'All Responses',
          child: Text(
            'All Responses',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Yes',
          child: Text(
            'Yes',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
        PopupMenuItem<String>(
          value: 'No',
          child: Text(
            'No',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Nil',
          child: Text(
            'Nil',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );

    if (result != null) {
      setState(() {
        _selectedFilter = result;
      });
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    String selectedGrade = '';
    List<String> sections = [];
    String selectedSection = '';
    final gradeController = Get.find<GradeController>();

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
                                'Select Class and Section',
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
                                                  sections = List<String>.from(
                                                      grade['sections'] ?? []);
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

                                // Select Section
                                if (sections.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Select Section',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'regular',
                                            color:
                                                Color.fromRGBO(53, 53, 53, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(sections.length,
                                            (index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  selectedSection =
                                                      sections[index];
                                                });
                                              },
                                              child: Container(
                                                width: 100,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: selectedSection ==
                                                          sections[index]
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
                                                    sections[index],
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
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.textFieldborderColor,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();

                                _recievedconsent(
                                    grade: selectedGrade,
                                    section: selectedSection);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recievedconsent();
  }

  List<ReceivedconsentModel> consentData = [];
  void _recievedconsent(
      {String grade = '131', String section = "A1", String date = ''}) async {
    try {
      final response = await fetchReceivedStudents(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        date: date,
        gradeId: grade,
        section: section,
      );
      setState(() {
        consentData = response;
      });
    } catch (e) {
      print('Error fetching consent data: $e');
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
                        widget.fetch();
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
                              'Received Consent Form',
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
                                _recievedconsent(date: selectedDate);
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
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 20),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'My \n Projects',
                    //         style: TextStyle(
                    //           fontFamily: 'medium',
                    //           fontSize: 12,
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       Switch(
                    //         materialTapTargetSize:
                    //             MaterialTapTargetSize.shrinkWrap,
                    //         activeTrackColor: AppTheme.textFieldborderColor,
                    //         inactiveTrackColor: Colors.white,
                    //         inactiveThumbColor: Colors.black,
                    //         value: isswitched,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isswitched = value;
                    //           });
                    //           _recievedconsent()
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                                builder: (context) => CreateConsentformpage(
                                      fetch: _recievedconsent,
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
      body: consentData.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Loop through consentData and handle each item
                  ...List.generate(consentData.length, (i) {
                    var currentConsentData = consentData[i];

                    return Column(
                      children: [
                        //posted on date...
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Row(
                            children: [
                              Text(
                                '${currentConsentData.postedOnDate}| ${currentConsentData.postedOnDay}',
                                style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        // card sections..
                        if (currentConsentData.consentForms.isNotEmpty)
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
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                        width: 1.5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        '${currentConsentData.consentForms[0].question}',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                    //posted by
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Posted by : ${currentConsentData.consentForms[0].name} | at : ${currentConsentData.consentForms[0].time}',
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    89, 89, 89, 1)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: Color.fromRGBO(230, 230, 230, 1),
                                      thickness: 1,
                                    ),
                                    // expansion tile..
                                    ExpansionTile(
                                      shape: Border(),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'View Responses',
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 16,
                                                color: Color.fromRGBO(
                                                    230, 1, 84, 1)),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            ...List.generate(
                                                currentConsentData
                                                    .consentForms[0]
                                                    .section
                                                    .length, (index) {
                                              String sectionName =
                                                  currentConsentData
                                                      .consentForms[0]
                                                      .section[index];

                                              String classname =
                                                  currentConsentData
                                                      .consentForms[0]
                                                      .responseAnswers[0]
                                                      .className;

                                              // Find the responses for the section
                                              var responsesForSection =
                                                  currentConsentData
                                                      .consentForms[0]
                                                      .responseAnswers
                                                      .where((response) =>
                                                          response.section ==
                                                          sectionName)
                                                      .toList();

                                              Set<String> displayedSections =
                                                  {};

                                              // Display the section header only once
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      IntrinsicWidth(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              border: Border.all(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          234,
                                                                          234,
                                                                          234,
                                                                          1))),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10)),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            31,
                                                                            106,
                                                                            163,
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  child: Text(
                                                                    '${classname}-${sectionName}',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'medium',
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTapDown:
                                                            (TapDownDetails
                                                                details) {
                                                          _showFilterMenu(
                                                              context, details);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/Filter_icon.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  // List all responses for the section
                                                  Column(
                                                    children:
                                                        responsesForSection
                                                            .map((response) {
                                                      String className =
                                                          response.className;
                                                      String studentName =
                                                          response.studentName;
                                                      String rollNumber =
                                                          response.rollNumber;
                                                      String profileImage =
                                                          response.profile;
                                                      var responses =
                                                          response.responses;

                                                      return ListTile(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                        shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        234,
                                                                        234,
                                                                        234,
                                                                        1),
                                                                width: 0.5)),
                                                        leading: Image.network(
                                                            '$profileImage'),
                                                        title: Text(
                                                          '$studentName',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'semibold',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '$rollNumber',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'medium',
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                              '$className-$sectionName',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          ],
                                                        ),
                                                        trailing: Text(
                                                          '$responses',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'medium',
                                                              fontSize: 20,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      150,
                                                                      60,
                                                                      1)),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  //top arrow..
                  Column(
                    children: [
                      Container(
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
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
