import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/DraftModels/Consent_fetch_draft_model.dart';
import 'package:flutter_application_1/services/Draft_Api/consent_fetch_draft_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class Consentdraftmainpage extends StatefulWidget {
  const Consentdraftmainpage({super.key});

  @override
  State<Consentdraftmainpage> createState() => _ConsentdraftmainpageState();
}

class _ConsentdraftmainpageState extends State<Consentdraftmainpage> {
  ScrollController _scrollController = ScrollController();
  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    //
    _fetchConsentDraft();
  }

  bool isLoading = true;
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

  ConsentFetchDraftModel? consentDraftData;
  final ApiServiceconsent apiService = ApiServiceconsent();
  //
  Future<void> _fetchConsentDraft() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await apiService.fetchConsentDraft(
        rollNumber: UserSession().rollNumber.toString(),
        userType: UserSession().userType.toString(),
        date: selectedDate,
      );

      if (response != null) {
        setState(() {
          consentDraftData = response;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //
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
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.025,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
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
                                'Consent Form Draft',
                                style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.007,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _selectDate(context);
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await _fetchConsentDraft();
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
                                                    "Module": 'consentform',
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
                                                              "Draft consent question deleted successfully!"),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                      print(
                                                          "Draft consent question deleted successfully!");
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Failed to delete draft consent question. Try again."),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      print(
                                                          "Failed to delete draft consent question. Status: ${response.statusCode}");
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
                                                            "Error deleting draft consent question: $e"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    print(
                                                        "Error deleting draft consent question: $e");
                                                  }
                                                }

                                                //
                                                await deleteAllDraft(
                                                    rollNumber: UserSession()
                                                        .rollNumber
                                                        .toString(),
                                                    module: 'consentform');

                                                await _fetchConsentDraft();

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
          : (consentDraftData == null ||
                  consentDraftData!.data == null ||
                  consentDraftData!.data!.isEmpty)
              ? Center(
                  child: Text(
                    "No draft Consent questions \n available!",
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
                      ...consentDraftData!.data!.map((e) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.07,
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Drafted on : ${e.postedOnDate} | ${e.postedOnDay}',
                                    style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 12,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            ...e.consentForm!.map((consent) {
                              //
                              TextPainter textPainter = TextPainter(
                                text: TextSpan(
                                  text: consent.question,
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

//
                              bool isExpanded =
                                  _expandedQuestions[consent.question] ?? false;
                              return Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //heading
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Text(
                                                  '${consent.heading}',
                                                  style: TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
                                          thickness: 1,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Text(
                                                  '${consent.question}',
                                                  style: TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                  maxLines:
                                                      isExpanded ? null : 4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //readmore button...
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 5),
                                          child: Row(
                                            children: [
                                              if (showReadMore)
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      backgroundColor:
                                                          Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _expandedQuestions[
                                                            consent.question ??
                                                                ''] = !isExpanded;
                                                      });
                                                    },
                                                    child: Text(
                                                      isExpanded
                                                          ? 'Read Less'
                                                          : 'Read More',
                                                      style: TextStyle(
                                                          fontFamily: 'regular',
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    )),
                                              Spacer(),
                                              //delete
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
                                                              "Are you sure you want to delete\n  this Consent Question?",
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
                                                                    //delete...
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                      child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                          onPressed: () async {
                                                                            var consentDel =
                                                                                consent.questionId;
                                                                            final String
                                                                                url =
                                                                                'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/Consent/DeleteConsentForm?Id=$consentDel';

                                                                            try {
                                                                              final response = await http.delete(
                                                                                Uri.parse(url),
                                                                                headers: {
                                                                                  'Content-Type': 'application/json',
                                                                                  'Authorization': 'Bearer $authToken',
                                                                                },
                                                                              );

                                                                              if (response.statusCode == 200) {
                                                                                print('id has beeen deleted ${consentDel}');

                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(backgroundColor: Colors.green, content: Text('Consent Form deleted successfully!')),
                                                                                );
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete ConsentForm.')),
                                                                                );
                                                                              }
                                                                            } catch (e) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(content: Text('An error occurred: $e')),
                                                                              );
                                                                            }
                                                                            _fetchConsentDraft();

                                                                            Navigator.pop(context);
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
                                              ),
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
                      }).toList(),
                    ],
                  ),
                ),
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 50
              ? Transform.translate(
                  offset: Offset(0, -20),
                  child: Container(
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
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
