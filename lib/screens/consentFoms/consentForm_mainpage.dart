import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/consentFoms/Create_consentFormPage.dart';
import 'package:flutter_application_1/screens/consentFoms/Received_consentForm.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ConsentformMainpage extends StatefulWidget {
  const ConsentformMainpage({super.key});

  @override
  State<ConsentformMainpage> createState() => _ConsentformMainpageState();
}

class _ConsentformMainpageState extends State<ConsentformMainpage> {
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
  //bottom sheet code end..

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                              'Consent Form',
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
                            });
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
                                builder: (context) => ReceivedConsentform()));
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
                              'Recieved',
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
                                builder: (context) => CreateConsentformpage()));
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
        controller: _scrollController,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showFilterBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [SvgPicture.asset('assets/icons/Filter_icon.svg')],
                ),
              ),
            ),

            //postedon date...
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Text(
                    'Posted on : 13.11.2024 | Tuesday',
                    style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            //card sections..
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'நான்காம் வகுப்பு மாணவர்களுக்கான ஓவியப்போட்டி குறித்த சுற்றறிக்கை (G4)',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(230, 230, 230, 1),
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'அன்பார்ந்த பெற்றோர்களுக்கு வணக்கம்.நமது பள்ளியில் பயிலும் நான்காம் வகுப்பு மாணவர்களுக்கான ஓவியப்போட்டி வருகின்ற நவம்பர் மாதம் (16.11.2024) சனிக்கிழமை அன்று நடைபெறவிருக்கின்றது....',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      //readmore button...
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
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
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

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
