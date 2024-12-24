import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/MarksAndResults/AddMarks.dart';
import 'package:flutter_application_1/screens/MarksAndResults/Marks_showPage.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

class Marksmainpage extends StatefulWidget {
  const Marksmainpage({super.key});

  @override
  State<Marksmainpage> createState() => _MarksmainpageState();
}

class _MarksmainpageState extends State<Marksmainpage> {
  bool isswitched = false;

//nursery..
  final List<Map<String, String>> nurseryLevels = [
    {'label': 'PreKG'},
    {'label': 'LKG'},
    {'label': 'UKG'}
  ];

//primary..
  final List<Map<String, String>> primaryLevels = [
    {'label': 'Grade 1'},
    {'label': 'Grade 2'},
    {'label': 'Grade 3'},
    {'label': 'Grade 4'},
    {'label': 'Grade 5'}
  ];
  //secondary..
  final List<Map<String, String>> secondaryLevels = [
    {'label': 'Grade 6'},
    {'label': 'Grade 7'},
    {'label': 'Grade 8'},
    {'label': 'Grade 9'},
    {'label': 'Grade 10'}
  ];

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
//add screen....
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
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
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //nursery....
                Theme(
                  data: Theme.of(context).copyWith(
                    expansionTileTheme: ExpansionTileThemeData(
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      collapsedBackgroundColor:
                          Color.fromRGBO(253, 250, 254, 1),
                    ),
                  ),
                  child: ExpansionTile(
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
                          'Nursery Results',
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
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5 / 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: nurseryLevels.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MarksShowpage()));
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
                                              Color.fromRGBO(176, 93, 208, 1),
                                              Color.fromRGBO(134, 0, 187, 1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/icons/marks_calender.svg',
                                                fit: BoxFit.contain),
                                            Text(
                                              nurseryLevels[index]['label']!,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'medium',
                                                  color: Colors.black),
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
                  ),
                ),
                //nursery....
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      expansionTileTheme: ExpansionTileThemeData(
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        collapsedBackgroundColor:
                            Color.fromRGBO(253, 250, 254, 1),
                      ),
                    ),
                    child: ExpansionTile(
                      collapsedBackgroundColor:
                          Color.fromRGBO(253, 250, 254, 1),
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
                            'Primary Results',
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
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 5 / 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: primaryLevels.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color.fromRGBO(254, 253, 251, 1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    //vertical height..
                                    Container(
                                      width: 10,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(252, 170, 103, 1),
                                              Color.fromRGBO(206, 92, 0, 1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/marks_calender.svg',
                                              fit: BoxFit.contain,
                                              color:
                                                  Color.fromRGBO(206, 92, 0, 1),
                                            ),
                                            Text(
                                              primaryLevels[index]['label']!,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'medium',
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //secondary..
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      expansionTileTheme: ExpansionTileThemeData(
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.black,
                        collapsedBackgroundColor:
                            Color.fromRGBO(253, 250, 254, 1),
                      ),
                    ),
                    child: ExpansionTile(
                      collapsedBackgroundColor:
                          Color.fromRGBO(253, 250, 254, 1),
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
                            'Secondary Results',
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
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 5 / 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: secondaryLevels.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color.fromRGBO(253, 250, 252, 1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    //vertical height..
                                    Container(
                                      width: 10,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(243, 2, 201, 1),
                                              Color.fromRGBO(141, 1, 117, 1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/marks_calender.svg',
                                              fit: BoxFit.contain,
                                              color: Color.fromRGBO(
                                                  141, 1, 117, 1),
                                            ),
                                            Text(
                                              secondaryLevels[index]['label']!,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'medium',
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
