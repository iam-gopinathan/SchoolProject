import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/News/Create_newsScreen.dart';
import 'package:flutter_application_1/utils/theme.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Newsmainpage extends StatefulWidget {
  const Newsmainpage({super.key});

  @override
  State<Newsmainpage> createState() => _NewsmainpageState();
}

class _NewsmainpageState extends State<Newsmainpage> {
  //select date
  String selectedDate = '';

  void _selectDate(BuildContext context) async {
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
        selectedDate = DateFormat('EEEE, dd MMMM').format(pickedDate);
      });
    }
  }
  //selected date end

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateFormat('EEEE, dd MMMM').format(DateTime.now());
  }

  bool isswitched = false;

  ///image bottomsheeet
  void _showBottomSheet(BuildContext context) {
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
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Center(
                        child: Image.asset(
                          'assets/images/NewsPage_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          });
        });
  }
  //show image bottomsheet code end....

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: AppTheme.appBackgroundPrimaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'News',
                                  style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
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
                                        selectedDate,
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
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Column(
                                children: [
                                  Text(
                                    'My \n Projects',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Switch(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeTrackColor:
                                          AppTheme.textFieldborderColor,
                                      inactiveTrackColor: Colors.white,
                                      inactiveThumbColor: Colors.black,
                                      value: isswitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isswitched = value;
                                        });
                                      })
                                ],
                              ),
                            ),
                            //addicon
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateNewsscreen()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppTheme.Addiconcolor,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //firstsection....
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                color: Color.fromRGBO(253, 253, 253, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [],
                ),
              ),
            ),

            ///nextsection
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    //search container...
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            prefixIcon: Transform.translate(
                              offset: Offset(75, 0),
                              child: Icon(Icons.search,
                                  color: Color.fromRGBO(178, 178, 178, 1)),
                            ),
                            hintText: 'Search News by Heading',
                            hintStyle: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Color.fromRGBO(178, 178, 178, 1)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 245, 245, 1),
                                  width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(245, 245, 245, 1),
                                  width: 2),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //nextsection..
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    'Posted on : 14.11.2024 | Tuesday',
                    style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),

            ///nextsection...
            Transform.translate(
              offset: Offset(0, 5),
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 30),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 251, 245, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Text(
                        'Updated on 15.11.2024',
                        style: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 10,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      ),
                    ),
                    //today
                    Padding(
                      padding: const EdgeInsets.only(left: 110),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppTheme.textFieldborderColor,
                        ),
                        child: Text(
                          'Today',
                          style: TextStyle(
                              fontFamily: 'medium',
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //cardsection..
            Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  borderRadius: BorderRadius.circular(15)),
              elevation: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(238, 238, 238, 1),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
                width: 370,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            '🪔 May the divine light of Diwali spread happiness, peace and prosperity 🎆. Happy Diwali! 🎇🎉',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Divider(
                        thickness: 2,
                        color: Color.fromRGBO(243, 243, 243, 1),
                      ),
                    ),

                    ///textparagraph...
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            '''அன்பார்ந்த பெற்றோர்களுக்கு வணக்கம்,
                        ஆறாம் வகுப்பு முதல் பத்தாம் வகுப்பு வரை பயிலும் மாணவர்களுக்கு உலக சுற்றுலா தினத்தை முன்னிட்டு ஓவியப் போட்டி தஞ்சை அருங்காட்சியகத்தில் நடைபெறஉள்ளது. இப்போட்டியை பற்றிய விரிவான விவரங்கள் கீழே இணைக்கப்பட்டுள்ளது. விருப்பம் உள்ள மாணவர்கள் போட்டியில் பங்குபெறுமாறு கேட்டுக்கொள்கின்றோம்.
                        இங்ஙனம்,பள்ளி நிர்வாகம்.''',
                            style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 12,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    //image....
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Image
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/NewsPage_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          height: 250,
                          width: double.infinity,
                        ),
                        // Centered Text
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showBottomSheet(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(30),
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
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15),
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
                                    color: Color.fromRGBO(138, 138, 138, 1)),
                              ),
                              Text(
                                'Time : 10.45 Am',
                                style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 12,
                                    color: Color.fromRGBO(138, 138, 138, 1)),
                              )
                            ],
                          ),
                          Spacer(),
                          //edit icon
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                      "Do you really want to make\n changes to this news?",
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 16,
                                          color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 0,
                                                  side: BorderSide(
                                                      color: Colors.black,
                                                      width: 1)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'regular'),
                                              )),
                                          //edit...
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 40),
                                                  backgroundColor: AppTheme
                                                      .textFieldborderColor,
                                                  elevation: 0,
                                                ),
                                                onPressed: () {},
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'regular'),
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black)),
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          fontFamily: 'medium',
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //delete icon
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              'assets/icons/delete_icons.svg',
                              fit: BoxFit.contain,
                              height: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
