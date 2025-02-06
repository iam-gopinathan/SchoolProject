import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ConsentForm/Parent_Answer_model.dart';

import 'package:flutter_application_1/models/ConsentForm/Parentscreen_formResponse_model.dart';
import 'package:flutter_application_1/services/ConsentForm/ParentAnswer_Api.dart';
import 'package:flutter_application_1/services/ConsentForm/Parentscreen_Formanswering_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';

import 'package:intl/intl.dart';

class ParentyesornoPage extends StatefulWidget {
  const ParentyesornoPage({super.key});

  @override
  State<ParentyesornoPage> createState() => _ParentyesornoPageState();
}

class _ParentyesornoPageState extends State<ParentyesornoPage> {
  //
  ScrollController _scrollController = ScrollController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchparentForm();
    print('usertype ${UserSession().rollNumber}');
    // Add a listener to the ScrollController to monitor scroll changes.
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {}); // Trigger UI update when scroll position changes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  List<ConsentDataParent> fetchedConsentDataParentForm = [];
// Fetch function
  Future<void> fetchparentForm() async {
    try {
      setState(() {
        isLoading = true;
      });

      final res = await fetchConsentParentFormData(
        UserSession().rollNumber ?? '',
        UserSession().userType ?? '',
      );

      setState(() {
        isLoading = false;
        fetchedConsentDataParentForm = res.data;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching parent form data: $e');
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
                            // GestureDetector(
                            //   onTap: () async {
                            //     await _selectDate(context);
                            //     setState(() {
                            //       isLoading = true;
                            //     });
                            //     fetchparentForm();
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Align(
                            //         alignment: Alignment.topLeft,
                            //         child: SvgPicture.asset(
                            //           'assets/icons/Attendancepage_calendar_icon.svg',
                            //           fit: BoxFit.contain,
                            //           height: 20,
                            //         ),
                            //       ),
                            //       Text(
                            //         displayDate,
                            //         style: TextStyle(
                            //           fontFamily: 'medium',
                            //           color: Color.fromRGBO(73, 73, 73, 1),
                            //           fontSize: 12,
                            //           fontWeight: FontWeight.bold,
                            //           decoration: TextDecoration.underline,
                            //           decorationThickness: 2,
                            //           decorationColor:
                            //               Color.fromRGBO(75, 75, 75, 1),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
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
                  strokeWidth: 4, color: AppTheme.textFieldborderColor),
            )
          : fetchedConsentDataParentForm.isEmpty
              ? Center(
                  child: Text(
                    "You haven’t made anything yet\nstart creating now!",
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
                    children: [
                      ...fetchedConsentDataParentForm.map((e) {
                        //postedon date...
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Posted on : ${e.postedOnDate} | ${e.postedOnDay}',
                                    style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 12,
                                        color: Colors.black),
                                  ),
                                  if (e.tag.isNotEmpty)
                                    Transform.translate(
                                      offset: Offset(40, 15),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color:
                                                AppTheme.textFieldborderColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        child: Text(
                                          '${e.tag}',
                                          style: TextStyle(
                                              fontFamily: 'regular',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            //card section
                            ...e.fromParents.map((consent) {
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
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                            width: 1.5)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '${consent.heading}',
                                            style: TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Divider(
                                          color:
                                              Color.fromRGBO(230, 230, 230, 1),
                                          thickness: 1,
                                        ),
                                        ExpansionTile(
                                          backgroundColor: Colors.white,
                                          shape: Border(),
                                          title: Center(
                                              child: Text(
                                            'View More',
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    230, 1, 84, 1)),
                                          )),
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Text(
                                                      '${consent.question}',
                                                      style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //yes or no
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Row(
                                                children: [
                                                  //yes
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              side: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          150,
                                                                          60,
                                                                          1),
                                                                  width: 1)),
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors.white),
                                                      onPressed: () {
                                                        final model =
                                                            ParentAnswerModel(
                                                                id: consent.id
                                                                    .toString(),
                                                                answer: 'Y');
                                                        // Call the API
                                                        updateConsentAnswer(
                                                            model, context);
                                                      },
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 20,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    150,
                                                                    60,
                                                                    1)),
                                                      )),
                                                  //no
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              side: BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          216,
                                                                          70,
                                                                          0,
                                                                          1),
                                                                  width: 1)),
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors.white),
                                                      onPressed: () {
                                                        final model =
                                                            ParentAnswerModel(
                                                                id: consent.id
                                                                    .toString(),
                                                                answer: 'N');
                                                        // Call the API
                                                        updateConsentAnswer(
                                                            model, context);
                                                      },
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'medium',
                                                            fontSize: 20,
                                                            color:
                                                                Color.fromRGBO(
                                                                    216,
                                                                    70,
                                                                    0,
                                                                    1)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
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
