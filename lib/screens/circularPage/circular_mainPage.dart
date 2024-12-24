import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/circularPage/create_circularPage.dart';
import 'package:flutter_application_1/screens/circularPage/edit_CircularPage.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CircularMainpage extends StatefulWidget {
  const CircularMainpage({super.key});

  @override
  State<CircularMainpage> createState() => _CircularMainpageState();
}

class _CircularMainpageState extends State<CircularMainpage> {
  TextEditingController searchcontroller = TextEditingController();
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

  ///image bottomsheeet.....
  void _showBottomSheet(
    BuildContext context,
  ) {
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
                    child: Image.asset(
                      'assets/images/Circular_page_img.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ]);
        });
      },
    );
  }
  //show image bottomsheet code end....

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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Circulars',
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
                      padding: const EdgeInsets.only(right: 30),
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
//create mesages screen....
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateCircularpage()));
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
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    //search container...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: searchcontroller,
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
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            ///updatedon code....
            Padding(
              padding: const EdgeInsets.only(left: 50, top: 20),
              child: Row(
                children: [
                  Text(
                    'Posted on : 09-12-2024|Monday',
                    style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 251, 245, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Updated on ',
                      style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 10,
                        color: Color.fromRGBO(49, 49, 49, 1),
                      ),
                    ),
                  ),
                  //today
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppTheme.textFieldborderColor,
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontFamily: 'medium',
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //card section........
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color.fromRGBO(238, 238, 238, 1),
                    ),
                    borderRadius: BorderRadius.circular(15)),
                elevation: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      //heading.....
                      Text(
                        '🪔 May the divine light of Diwali spread happiness, peace and prosperity 🎆. Happy Diwali! 🎇🎉',
                        style: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: 16,
                            color: Colors.black),
                      ),

                      Text(
                        '''அன்பார்ந்த பெற்றோர்களுக்கு வணக்கம்,\n
                      ஆறாம் வகுப்பு முதல் பத்தாம் வகுப்பு வரை பயிலும் மாணவர்களுக்கு உலக சுற்றுலா தினத்தை முன்னிட்டு ஓவியப் போட்டி தஞ்சை அருங்காட்சியகத்தில் நடைபெறஉள்ளது. இப்போட்டியை பற்றிய விரிவான விவரங்கள் கீழே இணைக்கப்பட்டுள்ளது. விருப்பம் உள்ள மாணவர்கள் போட்டியில் பங்குபெறுமாறு கேட்டுக்கொள்கின்றோம்.
                      இங்ஙனம்,பள்ளி நிர்வாகம்.''',
                        style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      //image section...
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/Circular_page_img.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
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
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
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
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Posted by : Admin - Nandhini M',
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
                            //edit
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
                                        "Do you really want to make\n changes to this message?",
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
                                                    backgroundColor:
                                                        Colors.white,
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
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 40),
                                                    backgroundColor: AppTheme
                                                        .textFieldborderColor,
                                                    elevation: 0,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditCircularpage()));
                                                  },
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
                                        "Are you sure you want to delete\n this item?",
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
                                                    backgroundColor:
                                                        Colors.white,
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
                                            //delete...
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
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
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'regular'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SvgPicture.asset(
                                  'assets/icons/delete_icons.svg',
                                  fit: BoxFit.contain,
                                  height: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
