import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/consentFoms/Create_consentFormPage.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ReceivedConsentform extends StatefulWidget {
  const ReceivedConsentform({super.key});

  @override
  State<ReceivedConsentform> createState() => _ReceivedConsentformState();
}

class _ReceivedConsentformState extends State<ReceivedConsentform> {
  // Create a ScrollController to control the scroll position
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
        child: Column(
          children: [
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
                      //posted by
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text(
                              'Posted by : Admin-Latha | at : 10.45am',
                              style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 12,
                                  color: Color.fromRGBO(89, 89, 89, 1)),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(230, 230, 230, 1),
                        thickness: 1,
                      ),
                      //expansion tile..
                      ExpansionTile(
                        shape: Border(),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View Responses',
                              style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 16,
                                  color: Color.fromRGBO(230, 1, 84, 1)),
                            ),
                          ],
                        ),
                        children: [
                          Row(
                            children: [
                              IntrinsicWidth(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10)),
                                      border: Border.all(
                                          color: Color.fromRGBO(
                                              234, 234, 234, 1))),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10)),
                                            color: Color.fromRGBO(
                                                31, 106, 163, 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Text(
                                            'PreKG - A1',
                                            style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        child: Text(
                                          'Class Teacher - Premlatha M.',
                                          style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTapDown: (TapDownDetails details) {
                                  _showFilterMenu(context, details);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SvgPicture.asset(
                                    'assets/icons/Filter_icon.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            ],
                          ),
                          ListTile(
                            leading: Image.asset(
                                'assets/images/Dashboard_profileimage.png'),
                            title: Text(
                              'Kavin Kumar V.',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '562147',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  'PreKG-A1',
                                  style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 14,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            trailing: Text(
                              'Yes',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 150, 60, 1)),
                            ),
                          ),

                          ///
                          ListTile(
                            leading: Image.asset(
                                'assets/images/Dashboard_profileimage.png'),
                            title: Text(
                              'Kavin Kumar V.',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '562147',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  'PreKG-A1',
                                  style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 14,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            trailing: Text(
                              'No',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 20,
                                  color: Color.fromRGBO(218, 0, 0, 1)),
                            ),
                          ),
                          //nill
                          ListTile(
                            leading: Image.asset(
                                'assets/images/Dashboard_profileimage.png'),
                            title: Text(
                              'Kavin Kumar V.',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '562147',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                Text(
                                  'PreKG-A1',
                                  style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 14,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Nill',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                Transform.translate(
                                  offset: Offset(15, 8),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color.fromRGBO(255, 0, 4, 1)),
                                    child: Text(
                                      'Resend',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
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
