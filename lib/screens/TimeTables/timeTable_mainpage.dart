import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/TimeTable_models/Main_timetable_model.dart';
import 'package:flutter_application_1/screens/TimeTables/Create_timeTables.dart';
import 'package:flutter_application_1/screens/TimeTables/Edit_timetable.dart';
import 'package:flutter_application_1/services/Timetables/Main_timetable_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TimetableMainpage extends StatefulWidget {
  const TimetableMainpage({super.key});

  @override
  State<TimetableMainpage> createState() => _TimetableMainpageState();
}

class _TimetableMainpageState extends State<TimetableMainpage> {
  bool isLoading = true;
  int initiallyExpandedIndex = 0;
  late Future<List<MainTimetableModel>> timeTableFuture = Future.value([]);

  final GradeController gradeController = Get.put(GradeController());

//fetch main  api...
  Future<void> _fetchMaintimetable({String gradeId = ''}) async {
    try {
      final fetchedData = await fetchTimeTableData(
        rollNumber: UserSession().rollNumber.toString(),
        userType: UserSession().userType.toString(),
        grade: gradeId,
        isMyProject: isswitched ? 'Y' : 'N',
      );
      setState(() {
        timeTableFuture = Future.value(fetchedData);
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      print('Error fetching timetable: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchMaintimetable();
    });
    gradeController.fetchGrades();
  }

  bool isswitched = false;

  //selected date end
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
                                _fetchMaintimetable(gradeId: selectedGrade);
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
                                'Timetables',
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

                                  print(
                                      'Switch is: ${isswitched ? "ON (Y)" : "OFF (N)"}');
                                });
                                _fetchMaintimetable();
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
                                  builder: (context) => CreateTimetables(
                                        fetchMaintimetable: _fetchMaintimetable,
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
                  color: AppTheme.textFieldborderColor,
                  strokeWidth: 4,
                ),
              )
            : FutureBuilder<List<MainTimetableModel>>(
                future: timeTableFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: AppTheme.textFieldborderColor,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final timetableList = snapshot.data!;

                  // Check if the list is empty
                  if (timetableList.isEmpty) {
                    return Center(
                      child: Text(
                        "You haven’t made anything yet; start creating now!",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'regular',
                          color: Color.fromRGBO(145, 145, 145, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(timetableList.length, (index) {
                          final e = timetableList[index];
                          return Column(
                            children: [
                              Transform.translate(
                                offset: Offset(30, 18),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(48, 126, 185, 1),
                                              Color.fromRGBO(0, 70, 123, 1)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          )),
                                      child: Text(
                                        '${e.gradeSection}',
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
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
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                            width: 1.5)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'PostedOn: ${e.postedOn} | ${e.day}',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                        ExpansionTile(
                                          initiallyExpanded:
                                              index == initiallyExpandedIndex,
                                          shape: Border(),
                                          title: Row(
                                            children: [
                                              Text(
                                                '${e.gradeSection}',
                                                style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Spacer(),
                                              if (e.updatedOn != null &&
                                                  e.updatedOn!.isNotEmpty)
                                                Text(
                                                  '${e.updatedOn}',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          49, 49, 49, 1),
                                                      fontFamily: 'medium',
                                                      fontSize: 10),
                                                )
                                              else
                                                SizedBox(),
                                            ],
                                          ),
                                          children: [
                                            Divider(
                                              color: Color.fromRGBO(
                                                  230, 230, 230, 1),
                                              thickness: 1,
                                            ),
                                            Center(
                                              child: Image.network(
                                                '${e.filePath}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 25),
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
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
                                                                  "Do you really want to make\n changes to this Timetable?",
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
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.white,
                                                                                elevation: 0,
                                                                                side: BorderSide(color: Colors.black, width: 1)),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                            )),
                                                                        //edit...
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10),
                                                                          child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => EditTimetable(
                                                                                              id: e.id,
                                                                                              fetchMaintimetable: _fetchMaintimetable,
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black)),
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
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //delete icon
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
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
                                                                  "Do you really want delete \n to this Timetable?",
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
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.white,
                                                                                elevation: 0,
                                                                                side: BorderSide(color: Colors.black, width: 1)),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text(
                                                                              'Cancel',
                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                            )),
                                                                        //delete...
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10),
                                                                          child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                              onPressed: () async {
                                                                                var timesheetid = e.id;
                                                                                final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeTimetable/DeleteTimeTable?Id=$timesheetid';

                                                                                try {
                                                                                  final response = await http.delete(
                                                                                    Uri.parse(url),
                                                                                    headers: {
                                                                                      'Content-Type': 'application/json',
                                                                                      'Authorization': 'Bearer $authToken',
                                                                                    },
                                                                                  );

                                                                                  if (response.statusCode == 200) {
                                                                                    print('id has beeen deleted ${timesheetid}');

                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(backgroundColor: Colors.green, content: Text('Timetable deleted successfully!')),
                                                                                    );
                                                                                  } else {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                                      SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete .')),
                                                                                    );
                                                                                  }
                                                                                } catch (e) {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    SnackBar(content: Text('An error occurred: $e')),
                                                                                  );
                                                                                }
                                                                                _fetchMaintimetable();
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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/timetable_delete.svg',
                                                        fit: BoxFit.contain,
                                                        height: 25,
                                                      ),
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
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }));
  }
}
