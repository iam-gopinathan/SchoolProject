import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/ParentFeedback_main_model.dart';
import 'dart:ui' as ui;
import 'package:flutter_application_1/screens/Feedback/Parent_feedback_CreatePage.dart';
import 'package:flutter_application_1/screens/Feedback/Parent_feedback_editPage.dart';
import 'package:flutter_application_1/services/Feedback_Api/ParentFeedback_Main_Api.dart';
import 'package:flutter_application_1/services/Feedback_Api/Parent_FeedbackEmoji_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class ParentfeedbackMainpage extends StatefulWidget {
  const ParentfeedbackMainpage({super.key});

  @override
  State<ParentfeedbackMainpage> createState() => _ParentfeedbackMainpageState();
}

class _ParentfeedbackMainpageState extends State<ParentfeedbackMainpage> {
  //
  Map<String, bool> _expandedQuestions = {};
  //
  bool _isExpanded = false;

  bool isswitched = false;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('usertype ${UserSession().userType}');
    print('rollnumber ${UserSession().rollNumber}');
    fetchparentData();
    //
    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);
  }

  ScrollController _scrollController = ScrollController();
  void _scrollListener() {
    setState(() {}); // Trigger UI update when scroll position changes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  ParentFeedbackResponse? res;

  ParentFeedbackYResponse? y;

  //
  void updateIsMyProject(String value) {
    setState(() {
      isswitched = value == 'Y';
    });
    fetchparentData();
  }

//fetch function...
  Future<void> fetchparentData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await fetchParentFeedbackMain(
          rollNumber: UserSession().rollNumber ?? '',
          userType: UserSession().userType ?? '',
          isMyFeedback: isswitched ? 'Y' : 'N',
          context: context);

      setState(() {
        if (isswitched) {
          y = response as ParentFeedbackYResponse;
        } else {
          res = response as ParentFeedbackResponse;
        }
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
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
                      Text(
                        'Feedback',
                        style: TextStyle(
                          fontFamily: 'semibold',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'My Projects',
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
                              activeColor: Colors.white,
                              onChanged: (value) {
                                setState(() {
                                  isswitched = value;
                                });
                                fetchparentData();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ParentFeedbackCreatepage(
                                          fetchparentData: fetchparentData,
                                          updateparent: updateIsMyProject,
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
              ),
            )
          // : res == null || res!.data.isEmpty
          : ((res == null || res!.data.isEmpty) &&
                  (y == null || y!.feedbackList.isEmpty))
              ? Center(
                  child: Text(
                    "You haven’t made anything yet;\nstart creating now!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'regular',
                      color: Color.fromRGBO(145, 145, 145, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: res!.data.map<Widget>((e) {
                      if (!isswitched) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width *
                                    0.05, // 5% of screen width
                                top: MediaQuery.of(context).size.height *
                                    0.015, // 1.5% of screen height
                                right: MediaQuery.of(context).size.width *
                                    0.04, // 4% of screen width
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Posted on ${e.postedOnDate} | ${e.postedOnDay}',
                                    style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //
                            ...e.fromParents.map((parent) {
                              return Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.04),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                parent.heading,
                                                style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              parent.question,
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        //emoji feedback.......
                                        if (parent.answer == null)
                                          Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03),
                                            child: EmojiFeedback(
                                              maxRating: 4,
                                              enableFeedback: true,
                                              inactiveElementBlendColor:
                                                  Colors.amber,
                                              showLabel: true,
                                              labelTextStyle: TextStyle(
                                                  fontFamily: 'semibold',
                                                  fontSize: 12,
                                                  color: Colors.black),
                                              animDuration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.bounceInOut,
                                              inactiveElementScale: .6,
                                              onChanged: (value) async {
                                                print(value);
                                                print(
                                                    'Feedback for Parent ID: ${parent.id}, Emoji Rating: $value');
                                                // await fetchparentData();
                                                await sendEmojiFeedback(
                                                    parent.id,
                                                    value.toString(),
                                                    context);

                                                await fetchparentData();
                                              },
                                              onChangeWaitForAnimation: true,
                                            ),
                                          ),
                                        //
                                        if (parent.answer != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            child: Text(
                                              'Thank You for your Response 😊 !',
                                              style: TextStyle(
                                                  fontFamily: 'semibold',
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }
                      /////ismyfeedback Y
                      else {
                        return Column(
                          children: [
                            ...y!.feedbackList.map((e) {
                              TextPainter textPainter = TextPainter(
                                text: TextSpan(
                                  text: e.question,
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
                                  _expandedQuestions[e.question] ?? false;
                              return Column(
                                children: [
                                  //createdon date..
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.06, // 6% of screen width
                                      top: MediaQuery.of(context).size.height *
                                          0.025,
                                    ), // 2.5% of screen height),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Posted On ${e.createdOnDate} | ${e.day}',
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      elevation: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            //
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 5),
                                            //   child: Container(
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width *
                                            //         0.8,
                                            //     child: Text(
                                            //       '${e.heading}',
                                            //       style: TextStyle(
                                            //         fontFamily: 'medium',
                                            //         fontSize: 16,
                                            //         color: Colors.black,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${e.question}',
                                                      style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                      maxLines:
                                                          isExpanded ? null : 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Divider(
                                                color: Color.fromRGBO(
                                                    230, 230, 230, 1),
                                                thickness: 1,
                                              ),
                                            ),

                                            //readmore button...
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, top: 5),
                                              child: Row(
                                                children: [
                                                  if (showReadMore)
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _isExpanded =
                                                                !_isExpanded;
                                                          });
                                                        },
                                                        child: Text(
                                                          isExpanded
                                                              ? 'Read Less'
                                                              : 'Read More',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  //
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        //edit
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
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
                                                                    "Do you really want to make\n changes to this Feedback",
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
                                                                              style: ElevatedButton.styleFrom(
                                                                                padding: EdgeInsets.symmetric(horizontal: 40),
                                                                                backgroundColor: AppTheme.textFieldborderColor,
                                                                                elevation: 0,
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                        builder: (context) => ParentFeedbackEditpage(
                                                                                              Id: e.Id,
                                                                                              fetchparentData: fetchparentData,
                                                                                              updateparent: updateIsMyProject,
                                                                                            )));
                                                                              },
                                                                              child: Text(
                                                                                'Edit',
                                                                                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          15),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black)),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  Text(
                                                                    'Edit',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'medium',
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //delete
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      content:
                                                                          Text(
                                                                        "Do you really want to Delete\n this Feedback?",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'regular',
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      actions: <Widget>[
                                                                        Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, side: BorderSide(color: Colors.black, width: 1)),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Cancel',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                  )),
                                                                              //Delete...
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                    onPressed: () async {
                                                                                      var delfeedback = e.Id;
                                                                                      final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/postParentsFeedBack/DeleteParentsFeedBack?Id=$delfeedback';

                                                                                      try {
                                                                                        final response = await http.delete(
                                                                                          Uri.parse(url),
                                                                                          headers: {
                                                                                            'Content-Type': 'application/json',
                                                                                            'Authorization': 'Bearer $authToken',
                                                                                          },
                                                                                        );

                                                                                        if (response.statusCode == 200) {
                                                                                          print('id has beeen deleted ${delfeedback}');

                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(backgroundColor: Colors.green, content: Text('FeedBack deleted successfully!')),
                                                                                          );
                                                                                        } else {
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete FeedBack.')),
                                                                                          );
                                                                                        }
                                                                                      } catch (e) {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(content: Text('An error occurred: $e')),
                                                                                        );
                                                                                      }

                                                                                      Navigator.pop(context);
                                                                                      fetchparentData();
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
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/icons/delete_icons.svg',
                                                              fit: BoxFit
                                                                  .contain,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      }
                    }).toList(),
                  ),
                ),

      //top arrow..
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 50
              ? Container(
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
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
