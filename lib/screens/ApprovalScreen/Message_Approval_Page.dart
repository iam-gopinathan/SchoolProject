import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Message_models/Message_approval_model.dart';
import 'package:flutter_application_1/screens/ApprovalScreen/Edit_Approvals/MessageApprovalEdit.dart';
import 'package:flutter_application_1/services/Message_Api/Message_Approval_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Update_messageapprovalAction.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class MessageApprovalPage extends StatefulWidget {
  const MessageApprovalPage({super.key});

  @override
  State<MessageApprovalPage> createState() => _MessageApprovalPageState();
}

class _MessageApprovalPageState extends State<MessageApprovalPage> {
  bool isAccepted = false;

  void onAccept() {
    setState(() {
      isAccepted = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isAccepted = false;
      });
    });
  }

  bool isloading = true;

  //// fetch function..
  MessageApprovalModel? messageApprovalData;
  //
  List<MessageItem> schedule = [];
  List<MessageItem> post = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

//fetch fucntion...
  Future<void> fetchMessages() async {
    setState(() {
      isloading = true;
    });
    try {
      MessageApprovalModel? fetchedData = await fetchMessageApproval(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        date: '',
        status: '',
        screen: 'approver',
      );

      if (fetchedData != null) {
        setState(() {
          messageApprovalData = fetchedData;
          schedule = fetchedData.schedule;
          post = fetchedData.post;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
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
                  ), // 3% of screen height),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Message Approvals',
                          style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : (schedule.isEmpty && post.isEmpty)
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'No approved requests yet !',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'regular',
                        color: Color.fromRGBO(145, 145, 145, 1),
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      //
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 15, bottom: 10),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       ElevatedButton(
                      //         style: ElevatedButton.styleFrom(
                      //             backgroundColor:
                      //                 Color.fromRGBO(131, 56, 236, 1)),
                      //         onPressed: () {},
                      //         child: Text(
                      //           'Scheduled Message',
                      //           style: TextStyle(
                      //               fontFamily: 'medium',
                      //               fontSize: 14,
                      //               color: Colors.white),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      if (schedule
                          .any((smessage) => smessage.status == 'schedule'))
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.017,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10))),
                                      backgroundColor:
                                          Color.fromRGBO(131, 56, 236, 1)),
                                  onPressed: () {},
                                  child: Text(
                                    'Scheduled Message',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontFamily: 'medium'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      //scheduled
                      ...schedule.map((smessage) {
                        return Column(
                          children: [
                            //
                            if (smessage.createdByRollNumber !=
                                UserSession().rollNumber)
                              Transform.translate(
                                offset: Offset(0, 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (smessage.status == 'schedule')
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(243, 236, 254, 1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Scheduled For ${smessage.onDay} at ${smessage.onTime}',
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 10,
                                            color:
                                                Color.fromRGBO(131, 56, 236, 1),
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(252, 236, 196, 1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Requested For :',
                                              style: TextStyle(
                                                fontFamily: 'regular',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${smessage.requestFor}',
                                              style: TextStyle(
                                                fontFamily: 'medium',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            //
                            if (smessage.createdByRollNumber !=
                                UserSession().rollNumber)
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.025),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color.fromRGBO(238, 238, 238, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1),
                                        ),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        //
                                        Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                '${smessage.headLine}',
                                                style: TextStyle(
                                                    fontFamily: 'semibold',
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Divider(
                                            thickness: 1,
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                          ),
                                        ),
                                        //
                                        Transform.translate(
                                          offset: Offset(-5, 0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Html(
                                                  data: smessage.message,
                                                  style: {
                                                    "body": Style(
                                                        fontFamily: 'semibold',
                                                        fontSize: FontSize(16),
                                                        textAlign:
                                                            TextAlign.justify)
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        //
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        //
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Created On : ${smessage.onDate}',
                                                    style: TextStyle(
                                                        fontFamily: 'regular',
                                                        fontSize: 12,
                                                        color: Color.fromRGBO(
                                                            138, 138, 138, 1)),
                                                  ),
                                                  //
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                      'Created By : ${smessage.createdByUserType}',
                                                      style: TextStyle(
                                                          fontFamily: 'regular',
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(
                                                              138,
                                                              138,
                                                              138,
                                                              1)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(
                                                      'Time : ${smessage.onTime}',
                                                      style: TextStyle(
                                                          fontFamily: 'regular',
                                                          fontSize: 12,
                                                          color: Color.fromRGBO(
                                                              138,
                                                              138,
                                                              138,
                                                              1)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        //
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Divider(
                                            thickness: 1,
                                            color: Color.fromRGBO(
                                                243, 243, 243, 1),
                                          ),
                                        ),
                                        //
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            //
                                            if (smessage.requestFor != 'delete')
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        content: Text(
                                                          "Do you really want to make\n changes to this message?,",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
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
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'regular'),
                                                                  )),
                                                              //edit...
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                ),
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 40),
                                                                          backgroundColor:
                                                                              AppTheme.textFieldborderColor,
                                                                          elevation:
                                                                              0,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);

                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => Messageapprovaledit(Id: smessage.id, messageFetch: fetchMessages)));
                                                                        },
                                                                        child:
                                                                            Text(
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
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.110,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 15),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        ),
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'medium',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            //

                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: GestureDetector(
                                                onTap: () {
                                                  var id = smessage.id;
                                                  _declinebottomsheet(
                                                      context, id.toString());
                                                },
                                                child: Transform.translate(
                                                  offset: Offset(-20, 2),
                                                  child: Text(
                                                    'Decline',
                                                    style: TextStyle(
                                                      fontFamily: 'medium',
                                                      fontSize: 16,
                                                      color: Color.fromRGBO(
                                                          255, 0, 0, 1),
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationColor:
                                                          Color.fromRGBO(
                                                              255, 0, 0, 1),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: SizedBox(
                                                height: 40,
                                                child: isAccepted
                                                    ? Lottie.asset(
                                                        'assets/images/Accept.json',
                                                        fit: BoxFit.cover,
                                                        height: 40,
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          var id = smessage.id;
                                                          onAccept();
                                                          onAcceptedclick(
                                                              id.toString());
                                                          // Delay for 2 seconds before showing the Snackbar
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 3));
                                                          // Show Snackbar
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              content: Text(
                                                                "Accepted Successfully!",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'semibold',
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                          await fetchMessages();
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      20),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        150,
                                                                        60,
                                                                        1)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          child: Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'medium',
                                                              fontSize: 16,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      150,
                                                                      60,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            ////alertdialaog...
                                            if (smessage.requestFor == 'delete')
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          content: Text(
                                                            "Do you really want to Delete\n this Message?",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'regular',
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
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
                                                                        backgroundColor:
                                                                            Colors
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
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'regular'),
                                                                    )),
                                                                //delete......
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                  child:
                                                                      ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              backgroundColor: AppTheme
                                                                                  .textFieldborderColor,
                                                                              elevation:
                                                                                  0,
                                                                              side: BorderSide
                                                                                  .none),
                                                                          onPressed:
                                                                              () async {
                                                                            var messageId =
                                                                                smessage.id;
                                                                            //
                                                                            Future<void> DeleteMessage(
                                                                                String id,
                                                                                String rollNumber,
                                                                                String userType) async {
                                                                              String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeMessage/DeleteMessage?';

                                                                              final Map<String, String> headers = {
                                                                                'Content-Type': 'application/json',
                                                                                'Authorization': 'Bearer $authToken',
                                                                              };
                                                                              final Map<String, String> params = {
                                                                                'Id': messageId.toString(),
                                                                                'RollNumber': UserSession().rollNumber ?? '',
                                                                                'UserType': UserSession().userType ?? ''
                                                                              };
                                                                              try {
                                                                                final uri = Uri.parse(url).replace(queryParameters: params);

                                                                                final response = await http.delete(uri, headers: headers);

                                                                                print('delete');
                                                                                print(url);

                                                                                if (response.statusCode == 200) {
                                                                                  print('Message deleted successfully $messageId');
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    SnackBar(
                                                                                      content: Text('Message deleted successfully!'),
                                                                                      backgroundColor: Colors.green,
                                                                                      duration: Duration(seconds: 2),
                                                                                    ),
                                                                                  );
                                                                                  //
                                                                                  Navigator.pop(context);
                                                                                  //
                                                                                  await fetchMessages();
                                                                                } else {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    SnackBar(
                                                                                      content: Text('Failed to delete message. Try again.'),
                                                                                      backgroundColor: Colors.red,
                                                                                      duration: Duration(seconds: 2),
                                                                                    ),
                                                                                  );
                                                                                  print('Failed to delete Message. Status code: ${response.statusCode}');
                                                                                }
                                                                              } catch (e) {
                                                                                print('Error: $e');
                                                                              }
                                                                            }

                                                                            print('object');
                                                                            //
                                                                            await DeleteMessage(
                                                                                messageId.toString(),
                                                                                UserSession().rollNumber ?? '',
                                                                                UserSession().userType ?? '');
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Delete',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'regular'),
                                                                          )),
                                                                ),
                                                              ],
                                                            )
                                                          ]);
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/delete_icons.svg',
                                                    fit: BoxFit.contain,
                                                    height: 35,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                      //
                      ///
                      ///
                      //post....
                      ...post.map(
                        (e) {
                          return Column(
                            children: [
                              //
                              if (e.createdByRollNumber !=
                                  UserSession().rollNumber)
                                Transform.translate(
                                  offset: Offset(0, 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      if (e.status == 'schedule')
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                243, 236, 254, 1),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            'Scheduled For ${e.onDay} at ${e.onTime}',
                                            style: TextStyle(
                                              fontFamily: 'regular',
                                              fontSize: 10,
                                              color: Color.fromRGBO(
                                                  131, 56, 236, 1),
                                            ),
                                          ),
                                        ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                252, 236, 196, 1),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Requested For :',
                                                  style: TextStyle(
                                                    fontFamily: 'regular',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${e.requestFor}',
                                                  style: TextStyle(
                                                    fontFamily: 'medium',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              //
                              if (e.createdByRollNumber !=
                                  UserSession().rollNumber)
                                Padding(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width *
                                        0.030, // 2.5% of screen width
                                  ),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  238, 238, 238, 1),
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            //
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: Text(
                                                    '${e.headLine}',
                                                    style: TextStyle(
                                                        fontFamily: 'semibold',
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Divider(
                                                thickness: 1,
                                                color: Color.fromRGBO(
                                                    243, 243, 243, 1),
                                              ),
                                            ),
                                            //
                                            Transform.translate(
                                              offset: Offset(-5, 0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Html(
                                                      data: e.message,
                                                      style: {
                                                        "body": Style(
                                                            fontFamily:
                                                                'semibold',
                                                            color: Colors.black,
                                                            fontSize:
                                                                FontSize(16),
                                                            textAlign: TextAlign
                                                                .justify)
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //

                                            //
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Created On : ${e.onDate}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'regular',
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    138,
                                                                    138,
                                                                    138,
                                                                    1)),
                                                      ),
                                                      //
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Text(
                                                          'Created By : ${e.createdByUserType}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'regular',
                                                              fontSize: 12,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      138,
                                                                      138,
                                                                      138,
                                                                      1)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Text(
                                                          'Time : ${e.onTime}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'regular',
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    138,
                                                                    138,
                                                                    138,
                                                                    1),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Divider(
                                                thickness: 1,
                                                color: Color.fromRGBO(
                                                    243, 243, 243, 1),
                                              ),
                                            ),
                                            //editt..

                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      content: Text(
                                                        "Do you really want to make\n changes to this Message?,",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'regular',
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    elevation:
                                                                        0,
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'regular'),
                                                                )),
                                                            //edit...
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.025,
                                                              ),
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 40),
                                                                        backgroundColor:
                                                                            AppTheme.textFieldborderColor,
                                                                        elevation:
                                                                            0,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);

                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => Messageapprovaledit(Id: e.id, messageFetch: fetchMessages)));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Edit',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'regular'),
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
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    if (e.requestFor !=
                                                        'delete')

                                                      ///edit icon
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.110,
                                                        ),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
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
                                                    //
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        if (e.requestFor !=
                                                            'delete')
                                                          Container(
                                                            width: 80,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                var id = e.id;
                                                                //
                                                                _declinebottomsheet(
                                                                    context,
                                                                    id.toString());
                                                              },
                                                              child: Transform
                                                                  .translate(
                                                                offset: Offset(
                                                                    -20, 2),
                                                                child: Text(
                                                                  'Decline',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'medium',
                                                                    fontSize:
                                                                        16,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    decorationColor:
                                                                        Color.fromRGBO(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        if (e.requestFor !=
                                                            'delete')
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10),
                                                            child: SizedBox(
                                                              height: 40,
                                                              child: isAccepted
                                                                  ? Lottie
                                                                      .asset(
                                                                      'assets/images/Accept.json',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          40,
                                                                    )
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        var id =
                                                                            e.id;
                                                                        onAccept();
                                                                        onAcceptedclick(
                                                                            id.toString());

                                                                        // Delay for 2 seconds before showing the Snackbar
                                                                        await Future.delayed(Duration(
                                                                            seconds:
                                                                                3));

                                                                        // Show Snackbar
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            content:
                                                                                Text(
                                                                              "Accepted Successfully!",
                                                                              style: TextStyle(fontFamily: 'semibold', fontSize: 16, color: Colors.white),
                                                                            ),
                                                                            duration:
                                                                                Duration(seconds: 2),
                                                                          ),
                                                                        );
                                                                        await fetchMessages();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8,
                                                                            horizontal:
                                                                                20),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(color: Color.fromRGBO(0, 150, 60, 1)),
                                                                          borderRadius:
                                                                              BorderRadius.circular(30),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          'Accept',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'medium',
                                                                            fontSize:
                                                                                16,
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                150,
                                                                                60,
                                                                                1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ////alertdialaog...
                                                        if (e.requestFor ==
                                                            'delete')
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
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "Do you really want to Delete\n this Message?",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'regular',
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.black),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                                          //delete......
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textFieldborderColor, elevation: 0, side: BorderSide.none),
                                                                                onPressed: () async {
                                                                                  var dMessageID = e.id;
                                                                                  //
                                                                                  Future<void> DeleteMessage(String id, String rollNumber, String userType) async {
                                                                                    String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeMessage/DeleteMessage?';

                                                                                    final Map<String, String> headers = {
                                                                                      'Content-Type': 'application/json',
                                                                                      'Authorization': 'Bearer $authToken',
                                                                                    };
                                                                                    final Map<String, String> params = {
                                                                                      'Id': dMessageID.toString(),
                                                                                      'RollNumber': UserSession().rollNumber ?? '',
                                                                                      'UserType': UserSession().userType ?? ''
                                                                                    };
                                                                                    try {
                                                                                      final uri = Uri.parse(url).replace(queryParameters: params);

                                                                                      final response = await http.delete(uri, headers: headers);

                                                                                      print('delete');
                                                                                      print(url);

                                                                                      if (response.statusCode == 200) {
                                                                                        print('Message deleted successfully $dMessageID');

                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text('Message deleted successfully!'),
                                                                                            backgroundColor: Colors.green,
                                                                                            duration: Duration(seconds: 2),
                                                                                          ),
                                                                                        );
                                                                                        //
                                                                                        Navigator.pop(context);
                                                                                        //
                                                                                        await fetchMessages();
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            content: Text('Failed to delete message please try again!'),
                                                                                            backgroundColor: Colors.red,
                                                                                            duration: Duration(seconds: 2),
                                                                                          ),
                                                                                        );

                                                                                        print('Failed to delete Message. Status code: ${response.statusCode}');
                                                                                      }
                                                                                    } catch (e) {
                                                                                      print('Error: $e');
                                                                                    }
                                                                                  }

                                                                                  print('object');
                                                                                  //
                                                                                  await DeleteMessage(dMessageID.toString(), UserSession().rollNumber ?? '', UserSession().userType ?? '');
                                                                                },
                                                                                child: Text(
                                                                                  'Delete',
                                                                                  style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10),
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
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                )
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
    );
  }

  //decline bottomsheeet..
  void _declinebottomsheet(BuildContext context, String messageId) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
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
                  left: MediaQuery.of(context).size.width / 2 - 28,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
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
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 10, bottom: 15),
                        child: Row(
                          children: [
                            Text(
                              'Add Reason',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLines: 5,
                          controller: _declinereason,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(202, 202, 202, 1),
                                  width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(202, 202, 202, 1),
                                  width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(202, 202, 202, 1),
                                  width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 70),
                              backgroundColor: AppTheme.textFieldborderColor),
                          onPressed: () {
                            ///
                            String reason = _declinereason.text.trim();
                            if (reason.isNotEmpty) {
                              onDeclineclick(messageId, reason);
                              Navigator.of(context).pop();
                            } else {
                              print("Please enter a reason for decline");
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
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

  TextEditingController _declinereason = TextEditingController();
  //accept...
  void onAcceptedclick(String messgeId) async {
    await updateMessageApprovalAction(
      id: messgeId,
      rollNumber: UserSession().rollNumber ?? '',
      userType: UserSession().userType ?? '',
      action: 'accept',
      reason: '',
    );
    print('News accepted successfully!');
  }

// declined reason....
  void onDeclineclick(String messageId, String reason) async {
    await updateMessageApprovalAction(
      id: messageId,
      rollNumber: UserSession().rollNumber ?? '',
      userType: UserSession().userType ?? '',
      action: 'decline',
      reason: reason,
    );
    print('News declined with reason: $reason');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Declined successfully!'),
        backgroundColor: Colors.green, // Change color if needed
        duration: Duration(seconds: 2),
      ),
    );
    //
    await fetchMessages();
  }
}
