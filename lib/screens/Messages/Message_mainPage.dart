import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Message_models/Message_mainPage_model.dart';
import 'package:flutter_application_1/screens/Messages/CreateMessagePage.dart';
import 'package:flutter_application_1/screens/Messages/EditMessagePage.dart';
import 'package:flutter_application_1/services/Message_Api/Message_mainPage_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MessageMainpage extends StatefulWidget {
  final bool isswitched;
  const MessageMainpage({super.key, required this.isswitched});

  @override
  State<MessageMainpage> createState() => _MessageMainpageState();
}

class _MessageMainpageState extends State<MessageMainpage> {
  TextEditingController searchcontroller = TextEditingController();
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
    isswitched = widget.isswitched;
    print("Newsmainpage opened with isswitched: $isswitched");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPosts();
    });

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

  //
  late bool isswitched;

  bool isLoading = true;
  List<Post> posts = [];
  List<Post> filteredMessageList = [];
  String errorMessage = '';

  ///
  Future<void> _fetchPosts() async {
    String isMyProject = isswitched ? 'Y' : 'N';

    setState(() {
      isLoading = true;
      posts = [];
      filteredMessageList = [];
    });

    try {
      List<Post> fetchedPosts = await fetchPosts(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        isMyProject: isMyProject,
        date: selectedDate,
      );

      print('Fetched posts count: ${fetchedPosts.length}');
      fetchedPosts.forEach((post) {
        print('Post Date: ${post.postedOnDate}');
        print('Messages Count: ${post.messages.length}');
        if (post.messages.isNotEmpty) {
          post.messages.forEach((message) {
            print('Headline: ${message.headLine}');
          });
        }
      });

      setState(() {
        isLoading = false;
        posts = fetchedPosts;
        filteredMessageList = posts;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load posts: $e';
        isLoading = false;
      });
      print('Error fetching posts: $e');
    }
  }

  // Search logic to filter posts
  void filterPosts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMessageList = posts;
      } else {
        filteredMessageList = posts
            .where((post) => post.messages.any((message) =>
                message.headLine.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          titleSpacing: 0,
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
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Messages',
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
                                  _fetchPosts();
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
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
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
                                activeColor: Colors.white,
                                value: isswitched,
                                onChanged: (value) {
                                  setState(() {
                                    isswitched = value;
                                  });

                                  _fetchPosts();
                                },
                              ),
                            ],
                          ),
                        ),
                      //create mesages screen....
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Createmessagepage(
                                            messageFetch: _fetchPosts,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
            ),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
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
                          onChanged: (value) {
                            filterPosts(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppTheme.textFieldborderColor,
                  ))
                : posts.isEmpty
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
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredMessageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = filteredMessageList[index];
                          if (post.messages.isEmpty) {
                            return SizedBox();
                          }
                          if (index < post.messages.length) {
                            print(
                                'filteredMessageList length: ${filteredMessageList.length}');
                            return Column(
                              children: [
                                ////upcoming message
                                if (post.messages[index].status == 'schedule')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(131, 56, 236, 1)),
                                      onPressed: () {},
                                      child: Text(
                                        'Upcoming Messages',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontFamily: 'medium'),
                                      ),
                                    ),
                                  ),
                                //card
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: post.messages.length,
                                    itemBuilder: (context, innerIndex) {
                                      final message = post.messages[innerIndex];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Posted on : ${post.postedOnDate}',
                                                      style: TextStyle(
                                                          fontFamily: 'regular',
                                                          fontSize: 12,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                //
                                                if (message
                                                    .updatedOn!.isNotEmpty)
                                                  Row(
                                                    children: [
                                                      //updatedon
                                                      Transform.translate(
                                                        offset: Offset(1, 20),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    251,
                                                                    245,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Updated on ${message.updatedOn}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'medium',
                                                              fontSize: 10,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      49,
                                                                      49,
                                                                      49,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      //today
                                                      if (post.tag.isNotEmpty)
                                                        Transform.translate(
                                                          offset:
                                                              Offset(-30, 24),
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        20),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                              color: AppTheme
                                                                  .textFieldborderColor,
                                                            ),
                                                            child: Text(
                                                              '${post.tag}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'medium',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),

                                          //cardsection...
                                          Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color: Color.fromRGBO(
                                                        238, 238, 238, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              elevation: 0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.04),
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //heading.....
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 7),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Text(
                                                          '${message.headLine ?? ''}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'semibold',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    //
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Color.fromRGBO(
                                                            243, 243, 243, 1),
                                                      ),
                                                    ),
//
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: message.message !=
                                                                  null &&
                                                              message.message!
                                                                  .isNotEmpty
                                                          ? Html(
                                                              data:
                                                                  '${message.message}',
                                                              style: {
                                                                "body": Style(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              },
                                                            )
                                                          : const Text(''),
                                                    ),
                                                    //
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Color.fromRGBO(
                                                            243, 243, 243, 1),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Posted by : ${message.name}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'regular',
                                                                    fontSize:
                                                                        12,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            138,
                                                                            138,
                                                                            138,
                                                                            1)),
                                                              ),
                                                              Text(
                                                                'Time : ${message.time}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'regular',
                                                                    fontSize:
                                                                        12,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            138,
                                                                            138,
                                                                            138,
                                                                            1)),
                                                              )
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          //edit
                                                          if (UserSession()
                                                                      .userType ==
                                                                  'admin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'superadmin')
                                                            if (message.isAlterAvailable ==
                                                                    "Y" ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'superadmin')
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
                                                                            Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        content:
                                                                            Text(
                                                                          "Do you really want to make\n changes to this message?",
                                                                          style: TextStyle(
                                                                              fontFamily: 'regular',
                                                                              fontSize: 16,
                                                                              color: Colors.black),
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
                                                                              //edit...
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
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
                                                                                            builder: (context) => Editmessagepage(
                                                                                                  Id: message.id,
                                                                                                  messageFetch: _fetchPosts,
                                                                                                )));
                                                                                  },
                                                                                  child: Text(
                                                                                    'Edit',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
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
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            15),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20),
                                                                        border: Border.all(
                                                                            color:
                                                                                Colors.black)),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons
                                                                            .edit),
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
                                                          if (UserSession()
                                                                      .userType ==
                                                                  'admin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'superadmin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'staff')
                                                            if (message.isAlterAvailable ==
                                                                    "Y" ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'superadmin')
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
                                                                            Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        content:
                                                                            Text(
                                                                          "Are you sure you want to delete\n this item?",
                                                                          style: TextStyle(
                                                                              fontFamily: 'regular',
                                                                              fontSize: 16,
                                                                              color: Colors.black),
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
                                                                              //delete...
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                                                                    backgroundColor: AppTheme.textFieldborderColor,
                                                                                    elevation: 0,
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    var messageId = message.id;
                                                                                    final String url = 'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeMessage/DeleteMessage?Id=$messageId&RollNumber=${UserSession().rollNumber}&UserType=${UserSession().userType}';

                                                                                    try {
                                                                                      final response = await http.delete(
                                                                                        Uri.parse(url),
                                                                                        headers: {
                                                                                          'Content-Type': 'application/json',
                                                                                          'Authorization': 'Bearer $authToken',
                                                                                        },
                                                                                      );

                                                                                      if (response.statusCode == 200) {
                                                                                        print('id has beeen deleted $messageId');

                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.green, content: Text('Message deleted successfully!')),
                                                                                        );
                                                                                        //
                                                                                        Navigator.pop(context);
                                                                                        //
                                                                                        await _fetchPosts();
                                                                                      } else {
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(backgroundColor: Colors.red, content: Text('Failed to delete message.')),
                                                                                        );
                                                                                      }
                                                                                    } catch (e) {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(content: Text('An error occurred: $e')),
                                                                                      );
                                                                                    }
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    'Delete',
                                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'regular'),
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
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      SvgPicture
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
                                            ),
                                          ),
                                          ////scheduled on  code.....
                                          if (post.messages[index].status ==
                                              'schedule')
                                            Transform.translate(
                                              offset: Offset(65, -20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        color: Color.fromRGBO(
                                                            243, 236, 254, 1),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.circle,
                                                            size: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    131,
                                                                    56,
                                                                    236,
                                                                    1),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5),
                                                            child: Text(
                                                              'Scheduled For ${post.postedOnDay}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'medium',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      );
                                    }),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
          ),
          //
          //top arrow..
          if (_scrollController.hasClients && _scrollController.offset > 50)
            Transform.translate(
              offset: Offset(0, -20),
              child: Column(
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
              ),
            )
        ],
      ),
    );
  }
}
