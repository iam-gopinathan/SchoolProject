import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/DraftModels/Feedback_fetch_draft_model.dart';
import 'package:flutter_application_1/services/Draft_Api/feedback_fetch_draft_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class Feedbackdraftmainpage extends StatefulWidget {
  const Feedbackdraftmainpage({super.key});

  @override
  State<Feedbackdraftmainpage> createState() => _FeedbackdraftmainpageState();
}

class _FeedbackdraftmainpageState extends State<Feedbackdraftmainpage> {
  //
  //select date
  String selectedDate = '';
  String displayDate = '';
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
  //
  bool isLoading = true;

  FeedBackDraftModel? feedbackDraftData;

  Future<void> fetchData() async {
    FeedbackDraftController controller = FeedbackDraftController();
    feedbackDraftData = await controller.fetchFeedbackDraft(
      rollNumber: UserSession().rollNumber.toString(),
      userType: UserSession().userType.toString(),
      date: selectedDate,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Map<String, bool> _expandedQuestions = {};

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
                    top: MediaQuery.of(context).size.height *
                        0.04, // 3% of screen height
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Feedback Draft',
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

                                  setState(() {
                                    isLoading = true;
                                  });
                                  await fetchData();
                                  setState(() {
                                    isLoading = false;
                                  });
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
                      //
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  content: Text(
                                    "Are you sure you want to delete\n all drafts you have created?",
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
                                        //delete...
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                          ),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 40),
                                                backgroundColor: AppTheme
                                                    .textFieldborderColor,
                                                elevation: 0,
                                              ),
                                              onPressed: () async {
                                                //
                                                Future<void> deleteAllDraft(
                                                    {required String rollNumber,
                                                    required String
                                                        module}) async {
                                                  // API Endpoint
                                                  String url =
                                                      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeNews/DeleteAllDraft";

                                                  // Parameters
                                                  final Map<String, String>
                                                      queryParams = {
                                                    "RollNumber": UserSession()
                                                            .rollNumber ??
                                                        '',
                                                    "Module": 'feedback',
                                                  };

                                                  // Construct the final URL with query parameters
                                                  final Uri uri = Uri.parse(url)
                                                      .replace(
                                                          queryParameters:
                                                              queryParams);

                                                  try {
                                                    final response =
                                                        await http.delete(
                                                      uri,
                                                      headers: {
                                                        "Authorization":
                                                            "Bearer $authToken",
                                                        "Content-Type":
                                                            "application/json",
                                                      },
                                                    );

                                                    if (response.statusCode ==
                                                        200) {
                                                      print(
                                                          "Response Status Code: ${response.statusCode}");
                                                      print(
                                                          "Response Body: ${response.body}");
                                                      // Show success Snackbar
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Draft feedBack deleted successfully!"),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                      print(
                                                          "Draft feedBack deleted successfully!");
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Failed to delete draft feedBack. Try again."),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      print(
                                                          "Failed to delete draft feedBack. Status: ${response.statusCode}");
                                                      print(
                                                          "Response: ${response.body}");
                                                    }
                                                  } catch (e) {
                                                    // Show error Snackbar
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Error deleting draft feedBack: $e"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    print(
                                                        "Error deleting draft feedBack: $e");
                                                  }
                                                }

                                                //
                                                await deleteAllDraft(
                                                    rollNumber: UserSession()
                                                        .rollNumber
                                                        .toString(),
                                                    module: 'feedback');

                                                await fetchData();

                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Delete',
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
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02,
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Text(
                                    'Delete All',
                                    style: TextStyle(
                                        fontFamily: 'medium',
                                        fontSize: 10,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppTheme.textFieldborderColor,
            ))
          : (feedbackDraftData == null ||
                  feedbackDraftData!.data == null ||
                  feedbackDraftData!.data!.isEmpty)
              ? Center(
                  child: Text(
                    "No draft Feedback available!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'regular',
                      color: Color.fromRGBO(145, 145, 145, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ...feedbackDraftData!.data!.map((e) {
                        return Column(
                          children: [
                            //
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.07,
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Drafted on: ${e.postedOnDate} | ${e.postedOnDay}',
                                    style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 12,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            //
                            ...e.feedBack!.map((detail) {
                              //
                              //
                              TextPainter textPainter = TextPainter(
                                text: TextSpan(
                                  text: detail.question,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'medium',
                                    color: Colors.white,
                                  ),
                                ),
                                maxLines: 4,
                                textDirection: ui.TextDirection.ltr,
                              )..layout(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8);

                              //
                              bool showReadMore = textPainter.didExceedMaxLines;

                              bool isExpanded =
                                  _expandedQuestions[detail.question] ?? false;
                              return Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.04),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                          width: 1.5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Feedback From:${detail.name}',
                                          style: TextStyle(
                                              fontFamily: 'regular',
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  16, 16, 16, 1)),
                                        ),
                                        Divider(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
                                          thickness: 1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              'Heading: ${detail.heading}',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Divider(
                                            color: Color.fromRGBO(
                                                230, 230, 230, 1),
                                            thickness: 1,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            detail.question ?? '',
                                            style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 16,
                                                color: Colors.black),
                                            maxLines: isExpanded ? null : 4,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Row(
                                            children: [
                                              // if (showReadMore)
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _expandedQuestions[
                                                        detail.question ??
                                                            ''] = !isExpanded;
                                                  });
                                                },
                                                child: Text(
                                                  isExpanded
                                                      ? 'Read Less'
                                                      : 'Read More',
                                                  style: TextStyle(
                                                      fontFamily: 'regular',
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Spacer(),
                                              //delete..
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            content: Text(
                                                              "Do you really want to Delete\n  this Feedback?",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 16,
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
                                                                            backgroundColor: Colors
                                                                                .white,
                                                                            elevation:
                                                                                0,
                                                                            side: BorderSide(
                                                                                color: Colors
                                                                                    .black,
                                                                                width:
                                                                                    1)),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 16,
                                                                              fontFamily: 'regular'),
                                                                        )),
                                                                    //edit...
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                      child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                          onPressed: () async {
                                                                            var deleteId =
                                                                                detail.questionId;
                                                                            final String
                                                                                url =
                                                                                'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBack/DeleteFeedBackForm?Id=$deleteId';

                                                                            try {
                                                                              final response = await http.delete(
                                                                                Uri.parse(url),
                                                                                headers: {
                                                                                  'Content-Type': 'application/json',
                                                                                  'Authorization': 'Bearer $authToken',
                                                                                },
                                                                              );

                                                                              if (response.statusCode == 200) {
                                                                                print('id has beeen deleted ${deleteId}');

                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(backgroundColor: Colors.green, content: Text('Feedback Question deleted successfully!')),
                                                                                );
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete question.')),
                                                                                );
                                                                              }
                                                                            } catch (e) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(content: Text('An error occurred: $e')),
                                                                              );
                                                                            }
                                                                            Navigator.pop(context);

                                                                            await fetchData();
                                                                          },
                                                                          child: Text(
                                                                            'Delete',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'regular'),
                                                                          )),
                                                                    ),
                                                                  ])
                                                            ]);
                                                      });
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/icons/timetable_delete.svg',
                                                  fit: BoxFit.contain,
                                                  height: 25,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
    );
  }
}
