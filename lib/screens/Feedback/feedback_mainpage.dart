import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/parent_feedback_fetch_model.dart';
import 'package:flutter_application_1/screens/Feedback/MyQuestions_page.dart';
import 'package:flutter_application_1/screens/Feedback/create_feedback.dart';
import 'package:flutter_application_1/services/Feedback_Api/Parent_feedback_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'dart:ui' as ui;

class FeedbackMainpage extends StatefulWidget {
  const FeedbackMainpage({super.key});

  @override
  State<FeedbackMainpage> createState() => _FeedbackMainpageState();
}

class _FeedbackMainpageState extends State<FeedbackMainpage> {
  String? selectedOption;

  ScrollController _scrollController = ScrollController();
  //
  Map<String, bool> _expandedQuestions = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {});
  }

  List<String> options = ['Suggestions', 'Complaints', 'Others'];
  String? selectedOptions;

  @override
  void initState() {
    // TODO: implement initState
    selectedOptions = options.first;
    _parentfetch(type: selectedOptions!);
    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);
  }

//fetch parent...
  List<FeedbackData> feedbackList = [];
  bool isLoading = true;
  Future<void> _parentfetch({String type = ''}) async {
    try {
      final fetchedData = await fetchParentFeedback(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        type: type,
      );

      if (fetchedData is List<FeedbackData>) {
        setState(() {
          feedbackList = fetchedData;
          isLoading = false;
        });
      } else {
        throw Exception(
            "Expected a List<FeedbackData> but got ${fetchedData.runtimeType}");
      }
    } catch (e) {
      print("Error fetching feedback: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  //

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
                    top: MediaQuery.of(context).size.height * 0.04,
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

                      Spacer(),
                      //questions....
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyquestionsPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
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
                                  'Questions',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'medium',
                                      color: Color.fromRGBO(217, 78, 11, 1)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.025),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateFeedback()));
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
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  //filter icon...
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              hintText: 'Select',
                              hintStyle: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 14,
                                  color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                            ),
                            dropdownColor: Colors.black,
                            menuMaxHeight: 150,
                            items: options
                                .map((option) => DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? value) async {
                              setState(() {
                                selectedOptions = value;
                                isLoading = true;
                              });
                              await _parentfetch(type: value!);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            value: selectedOptions ?? options.first,
                            selectedItemBuilder: (BuildContext context) {
                              return options.map((option) {
                                return Text(
                                  option,
                                  style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //card sections..
                  ...feedbackList.map((feedbackData) {
                    return Column(
                      children: [
                        //postedon
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width *
                                0.05, // 5% of screen width
                            top: MediaQuery.of(context).size.height *
                                0.02, // 2% of screen height
                            right: MediaQuery.of(context).size.width *
                                0.04, // 4% of screen width
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Posted on ${feedbackData.postedOn}',
                                style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        ...feedbackData.parentsFeedBack.map((e) {
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

                          bool isExpanded =
                              _expandedQuestions[e.question] ?? false;
                          return Padding(
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
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Feedback From :${e.userType} | ${e.grade}-${e.section}',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      16, 16, 16, 1)),
                                            ),
                                            Text(
                                              'Date : ${feedbackData.postedOn}',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 12,
                                                  color: Color.fromRGBO(
                                                      16, 16, 16, 1)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: Color.fromRGBO(230, 230, 230, 1),
                                      thickness: 1,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                '${e.heading}',
                                                style: TextStyle(
                                                    fontFamily: 'medium',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Color.fromRGBO(230, 230, 230, 1),
                                      thickness: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          '${e.question}',
                                          style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 16,
                                              color: Colors.black),
                                          maxLines: isExpanded ? null : 4,
                                        ),
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
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _expandedQuestions[
                                                      e.question] = !isExpanded;
                                                });
                                              },
                                              child: Text(
                                                'Read More...',
                                                style: TextStyle(
                                                    fontFamily: 'regular',
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            ),
                                        ],
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
                  }).toList(),
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
      //
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
