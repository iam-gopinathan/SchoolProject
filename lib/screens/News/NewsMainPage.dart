import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/News_Models/NewsMainPage_model.dart';
import 'package:flutter_application_1/screens/News/Create_newsScreen.dart';
import 'package:flutter_application_1/screens/News/Edit_newsScreen.dart';
import 'package:flutter_application_1/services/News_Api/News_mainPage_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Newsmainpage extends StatefulWidget {
  final bool isswitched;
  const Newsmainpage({super.key, required this.isswitched});

  @override
  State<Newsmainpage> createState() => _NewsmainpageState();
}

class _NewsmainpageState extends State<Newsmainpage> {
  ScrollController _scrollController = ScrollController();
  //

  TextEditingController searchController = TextEditingController();
  //loading....
  bool isLoading = true;

  bool isDeleting = false;
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
  late bool isswitched;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isswitched = widget.isswitched;
    print("Newsmainpage opened with isswitched: $isswitched");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNewsData();
    });
    _scrollController.addListener(_scrollListener);
    print("Newsmainpage opened with isswitched: ${widget.isswitched}");
  }

  void _scrollListener() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

// Fetch the news data............
  List<NewsResponse> newsList = [];
  List<NewsResponse> filteredNewsList = [];

  Future<void> _fetchNewsData() async {
    try {
      setState(() {
        isLoading = true;
      });
      String isMyProject = isswitched ? 'Y' : 'N';
      final fetchedNews =
          await fetchMainNews(date: selectedDate, isMyProject: isMyProject);

      setState(() {
        newsList = fetchedNews ?? [];
        filteredNewsList = List.from(newsList);
        isLoading = false;
      });

      print("Fetched news data: $newsList");
      print("Selected Date: $selectedDate");
      print("Switch Status: ${widget.isswitched}");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching news: $e");
    }
  }

// Search news...
  void _filterNews(String query) {
    setState(() {
      if (newsList.isNotEmpty) {
        filteredNewsList = newsList
            .map((response) => NewsResponse(
                  postedOnDate: response.postedOnDate,
                  postedOnDay: response.postedOnDay,
                  tag: response.tag,
                  news: response.news.where((newsItem) {
                    final headlineLower = newsItem.headline.toLowerCase();
                    final queryLower = query.toLowerCase();
                    return headlineLower.contains(queryLower);
                  }).toList(),
                ))
            .where((response) => response.news.isNotEmpty)
            .toList();
      } else {
        filteredNewsList = [];
      }
    });
  }

  ///show bottomsheet.......
  void _showBottomSheet(
      BuildContext context, String? imagePath, String? videoPath) {
    // Lock orientation to portrait mode while showing the bottom sheet
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  top: MediaQuery.of(context).size.height * -0.08,
                  left: MediaQuery.of(context).size.width / 2 - 28,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
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
                  height: MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: imagePath != null
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.contain,
                          )
                        : videoPath != null
                            ? SizedBox(
                                width: double.infinity,
                                child: YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId:
                                        YoutubePlayer.convertUrlToId(videoPath)
                                            .toString(),
                                    flags: const YoutubePlayerFlags(
                                      autoPlay: true,
                                      mute: false,
                                    ),
                                  ),
                                  showVideoProgressIndicator: true,
                                  aspectRatio: 16 / 9,
                                ),
                              )
                            : const Text("No content available"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //

  Set<String> displayedDates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          titleSpacing: 0,
          // backgroundColor: AppTheme.appBackgroundPrimaryColor,
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
                                'News',
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
                                  await _fetchNewsData();
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
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
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
                                    isLoading = true;
                                    newsList = [];
                                    filteredNewsList = [];
                                  });
                                  _fetchNewsData();
                                },
                              ),
                            ],
                          ),
                        ),
                      //add screen....
                      if (UserSession().userType == 'admin' ||
                          UserSession().userType == 'superadmin' ||
                          UserSession().userType == 'staff')
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateNewsscreen(
                                        onCreateNews: _fetchNewsData)),
                              );
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
            ))
          : newsList.isEmpty
              ? (UserSession().userType == 'student' ||
                      UserSession().userType == 'teacher')
                  ? Center(
                      child: Text(
                        "No messages from the school yet. Stay tuned for updates!",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'regular',
                          color: Color.fromRGBO(145, 145, 145, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Center(
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
              : Column(
                  children: [
                    ///nextsection
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                        bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            //search container...
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'medium'),
                                controller: searchController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    prefixIcon: Transform.translate(
                                      offset: Offset(
                                        MediaQuery.of(context).size.width *
                                            0.16, // Responsive X-axis (60)
                                        0, // Y-axis remains the same (no change)
                                      ),
                                      child: Icon(Icons.search,
                                          color:
                                              Color.fromRGBO(178, 178, 178, 1)),
                                    ),
                                    hintText: 'Search News by Heading',
                                    hintStyle: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 14,
                                        color:
                                            Color.fromRGBO(178, 178, 178, 1)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(245, 245, 245, 1),
                                          width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(245, 245, 245, 1),
                                          width: 2),
                                    )),
                                onChanged: (value) {
                                  _filterNews(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredNewsList.length,
                          itemBuilder: (context, index) {
                            final newsResponse = filteredNewsList[index];
                            if (newsResponse.news.isEmpty) {
                              return SizedBox.shrink();
                            }
                            if (index < newsResponse.news.length) {
                              final news = newsResponse.news[index];
                              return Column(
                                children: [
                                  //schedule
                                  if (news.status == 'schedule')
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.017,
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      10))),
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          131, 56, 236, 1)),
                                              onPressed: () {},
                                              child: Text(
                                                'Upcoming News',
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
                                  //
                                  if (newsResponse.news.isNotEmpty)
                                    ...newsResponse.news.map((news) {
                                      return Column(
                                        children: [
                                          if (news.status != 'schedule')
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                          //postedondate
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                            child: Row(
                                              children: [
                                                if (newsResponse
                                                    .postedOnDate.isNotEmpty)
                                                  Text(
                                                    'Posted on : ${newsResponse.postedOnDate ?? ''} | ${newsResponse.postedOnDay ?? ''}',
                                                    style: TextStyle(
                                                        fontFamily: 'regular',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          //updatedon
                                          Transform.translate(
                                            offset: Offset(0, 16),
                                            child: Row(
                                              children: [
                                                if (news.updatedOn != null &&
                                                    news.updatedOn!.isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.08, // Adjust 0.08 as needed
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 6),
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 251, 245, 1),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Updated on ${news.updatedOn}',
                                                        style: TextStyle(
                                                          fontFamily: 'medium',
                                                          fontSize: 10,
                                                          color: Color.fromRGBO(
                                                              49, 49, 49, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                Spacer(),
                                                //today
                                                if (newsResponse.tag.isNotEmpty)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                    ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        color: AppTheme
                                                            .textFieldborderColor,
                                                      ),
                                                      child: Text(
                                                        '${newsResponse.tag ?? ''}',
                                                        style: TextStyle(
                                                          fontFamily: 'medium',
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),

                                          ///
                                          Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03),
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
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          238, 238, 238, 1),
                                                    ),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 7),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            child: Text(
                                                              '${news.headline ?? ''}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'semibold',
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Divider(
                                                        thickness: 2,
                                                        color: Color.fromRGBO(
                                                            243, 243, 243, 1),
                                                      ),
                                                    ),

                                                    ///textparagraph...
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: news.news !=
                                                                      null &&
                                                                  news.news!
                                                                      .isNotEmpty
                                                              ? Html(
                                                                  data:
                                                                      '${news.news}',
                                                                  style: {
                                                                    "body": Style(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'semibold',
                                                                        fontSize:
                                                                            FontSize(
                                                                                16),
                                                                        textAlign:
                                                                            TextAlign.justify),
                                                                  },
                                                                )
                                                              : const Text(''),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    //image....
                                                    if (news.filePath
                                                            ?.isNotEmpty ??
                                                        false)
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          //image
                                                          SizedBox(
                                                            height: 250,
                                                            width:
                                                                double.infinity,
                                                            child: Opacity(
                                                              opacity: 0.5,
                                                              child:
                                                                  Image.network(
                                                                '${news.filePath}',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          //video
                                                          if (news.fileType ==
                                                              'link')
                                                            SizedBox(
                                                              height: 250,
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  YoutubePlayer(
                                                                progressIndicatorColor:
                                                                    AppTheme
                                                                        .textFieldborderColor,
                                                                controller:
                                                                    YoutubePlayerController(
                                                                  initialVideoId:
                                                                      YoutubePlayer.convertUrlToId(news.filePath ??
                                                                              '')
                                                                          .toString(),
                                                                  flags:
                                                                      YoutubePlayerFlags(
                                                                    autoPlay:
                                                                        false,
                                                                    mute: false,
                                                                  ),
                                                                ),
                                                                showVideoProgressIndicator:
                                                                    true,
                                                                width: 150,
                                                                aspectRatio:
                                                                    16 / 9,
                                                              ),
                                                            ),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            height: 250,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                          // Centered Text
                                                          Center(
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                //imagepath
                                                                String?
                                                                    imagePath =
                                                                    news.filePath;
                                                                //videopath
                                                                String
                                                                    videopath =
                                                                    news.filePath
                                                                        .toString();

                                                                if (news.fileType ==
                                                                    'image') {
                                                                  _showBottomSheet(
                                                                      context,
                                                                      imagePath,
                                                                      null);
                                                                } else if (news
                                                                        .fileType ==
                                                                    'link') {
                                                                  // _showBottomSheet(
                                                                  //     context,
                                                                  //     null,
                                                                  //     videopath);
                                                                  // Navigate to VideoScreen when clicked
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          VideoScreen(
                                                                              videoUrl: videopath),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .transparent,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          1.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                ),
                                                                child: Text(
                                                                  news.fileType ==
                                                                          'image'
                                                                      ? 'View Image'
                                                                      : news.fileType ==
                                                                              'link'
                                                                          ? 'View Video'
                                                                          : '',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'semibold',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    //
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.005,
                                                      ),
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Color.fromRGBO(
                                                            243, 243, 243, 1),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              //
                                                              if (UserSession()
                                                                      .userType !=
                                                                  'student')
                                                                Text(
                                                                  'Posted by : ${news.name ?? ''}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'regular',
                                                                      fontSize:
                                                                          12,
                                                                      color: Color.fromRGBO(
                                                                          138,
                                                                          138,
                                                                          138,
                                                                          1)),
                                                                ),
                                                              if (UserSession()
                                                                      .userType !=
                                                                  'student')
                                                                Text(
                                                                  'Time : ${news.time ?? ''}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'regular',
                                                                      fontSize:
                                                                          12,
                                                                      color: Color.fromRGBO(
                                                                          138,
                                                                          138,
                                                                          138,
                                                                          1)),
                                                                )
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          if (UserSession()
                                                                      .userType ==
                                                                  'admin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'superadmin' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'staff')
                                                            //edit icon
                                                            if (newsResponse
                                                                        .news[
                                                                            index]
                                                                        .isAlterAvailable ==
                                                                    'Y' ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'superadmin')
                                                              //
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
                                                                          "Do you really want to make\n changes to this News?,",
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
                                                                                padding: EdgeInsets.only(
                                                                                  left: MediaQuery.of(context).size.width * 0.025,
                                                                                ),
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
                                                                                              builder: (context) => EditNewsscreen(
                                                                                                    newsId: news.id,
                                                                                                    onCreateNews: _fetchNewsData,
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
                                                                      EdgeInsets
                                                                          .only(
                                                                    right: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.025,
                                                                  ),
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
                                                                        Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
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
                                                          //
                                                          if (newsResponse
                                                                      .news[
                                                                          index]
                                                                      .isAlterAvailable ==
                                                                  'Y' ||
                                                              UserSession()
                                                                      .userType ==
                                                                  'superadmin')
                                                            //
                                                            if (UserSession()
                                                                        .userType ==
                                                                    'admin' ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'superadmin' ||
                                                                UserSession()
                                                                        .userType ==
                                                                    'staff')
                                                              //delete icon
                                                              GestureDetector(
                                                                onTap: () {
                                                                  final int
                                                                      newsId =
                                                                      news.id;

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
                                                                          "Are you sure you want to delete\n this news?",
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
                                                                                padding: EdgeInsets.only(
                                                                                  left: MediaQuery.of(context).size.width * 0.025,
                                                                                ),
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                                                                    backgroundColor: AppTheme.textFieldborderColor,
                                                                                    elevation: 0,
                                                                                  ),
                                                                                  onPressed: isDeleting
                                                                                      ? null
                                                                                      : () async {
                                                                                          try {
                                                                                            setState(() {
                                                                                              isDeleting = true;
                                                                                            });
                                                                                            final response = await http.delete(
                                                                                              Uri.parse('https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeNews/DeleteNews?Id=$newsId&RollNumber=${UserSession().rollNumber}&UserType=${UserSession().userType ?? ''}'),
                                                                                              headers: {
                                                                                                'Authorization': 'Bearer $authToken',
                                                                                                'Content-Type': 'application/json',
                                                                                              },
                                                                                            );

                                                                                            if (response.statusCode == 200) {
                                                                                              //

                                                                                              // if (mounted) {
                                                                                              //   ScaffoldMessenger.of(context).showSnackBar(
                                                                                              //     SnackBar(
                                                                                              //       backgroundColor: Colors.green,
                                                                                              //       content: Text('News item deleted successfully!'),
                                                                                              //     ),
                                                                                              //   );
                                                                                              //   //
                                                                                              //   if (UserSession().userType == 'admin' || UserSession().userType == 'staff') {
                                                                                              //     ScaffoldMessenger.of(context).showSnackBar(
                                                                                              //       SnackBar(
                                                                                              //         backgroundColor: Colors.green,
                                                                                              //         content: Text('News item Delete request sent successfully!'),
                                                                                              //       ),
                                                                                              //     );
                                                                                              //   }
                                                                                              // }
                                                                                              if (mounted) {
                                                                                                String message = 'News item deleted successfully!';

                                                                                                // Show different message for admin or staff
                                                                                                if (UserSession().userType == 'admin' || UserSession().userType == 'staff') {
                                                                                                  message = 'News item delete request sent successfully!';
                                                                                                }

                                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                                  SnackBar(
                                                                                                    backgroundColor: Colors.green,
                                                                                                    content: Text(message),
                                                                                                  ),
                                                                                                );
                                                                                              }
                                                                                              print('News item with ID $newsId has been successfully deleted.');
                                                                                              setState(() {
                                                                                                newsResponse.news.removeWhere((item) => item.id == newsId);
                                                                                              });

                                                                                              // Refresh the news data after deletion
                                                                                              Navigator.pop(context);
                                                                                              //
                                                                                              await _fetchNewsData();
                                                                                            } else {
                                                                                              print('Failed to delete news. Status code: ${response.statusCode}');
                                                                                              print('Response body: ${response.body}');

                                                                                              if (mounted) {
                                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                                  SnackBar(
                                                                                                    backgroundColor: Colors.red,
                                                                                                    content: Text(
                                                                                                      'Failed to delete news item. Status code: ${response.statusCode}',
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }
                                                                                            }
                                                                                          } catch (error) {
                                                                                            print('Error during deletion: $error');
                                                                                            if (mounted) {
                                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                                SnackBar(
                                                                                                  backgroundColor: Colors.red,
                                                                                                  content: Text('Error: Unable to delete news item.'),
                                                                                                ),
                                                                                              );
                                                                                            }
                                                                                          } finally {
                                                                                            isLoading = false;
                                                                                            _fetchNewsData();
                                                                                            setState(() {
                                                                                              isDeleting = false;
                                                                                            });

                                                                                            Navigator.pop(context);
                                                                                          }
                                                                                        },
                                                                                  child: isDeleting
                                                                                      ? CircularProgressIndicator(
                                                                                          color: Colors.white,
                                                                                          strokeWidth: 4.0,
                                                                                        )
                                                                                      : Text(
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
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/icons/delete_icons.svg',
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  height: 35,
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
                                          ////scheduled on  code.....
                                          if (news.status == 'schedule')
                                            Transform.translate(
                                              offset: Offset(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15, // Responsive X-axis (65)
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    -0.02,
                                              ),
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
                                                              'Scheduled For ${newsResponse.postedOnDay} ',
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
                                    }).toList(),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          }),
                    ),

                    //top arrow..
                    if (_scrollController.hasClients &&
                        _scrollController.offset > 50)
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

class VideoScreen extends StatefulWidget {
  final String videoUrl;

  const VideoScreen({super.key, required this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Reset to portrait mode when exiting fullscreen
    _controller.addListener(() {
      if (!_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6), // Apply same opacity color
        ),
        child: Center(
          child: YoutubePlayerBuilder(
            onEnterFullScreen: () {
              // Allow rotation in fullscreen only
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
            onExitFullScreen: () {
              // Lock back to portrait when exiting fullscreen
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            },
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              aspectRatio: 16 / 9,
            ),
            builder: (context, player) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  player, // Video Player centered
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
