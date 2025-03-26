import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/DraftModels/news_fetch_draft_model.dart';
import 'package:flutter_application_1/screens/Draftsscreen/NewsDraft/EditNewsDraft.dart';
import 'package:flutter_application_1/services/Draft_Api/news_fetch_draft_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class Newsdraftmainpage extends StatefulWidget {
  const Newsdraftmainpage({super.key});

  @override
  State<Newsdraftmainpage> createState() => _NewsdraftmainpageState();
}

class _NewsdraftmainpageState extends State<Newsdraftmainpage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _fetchdraft();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {});
  }

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
  List<NewsData> draftNews = []; // Store fetched data

  Future<void> _fetchdraft() async {
    try {
      setState(() {
        isLoading = true;
      });
      NewsDraftApi newsApi = NewsDraftApi();
      NewsFetchDraftModel? response = await newsApi.fetchNews(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
        date: selectedDate,
      );

      if (response != null) {
        setState(() {
          draftNews = response.data;
          isLoading = false;
        });
        print("News fetched successfully!");
      } else {
        print("Failed to fetch news.");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching draft news: $e");
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
                                'News Draft',
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
                                  await _fetchdraft();
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
                                                    "Module": 'news',
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
                                                              "Draft news deleted successfully!"),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                      print(
                                                          "Draft news deleted successfully!");
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "Failed to delete draft news. Try again."),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      print(
                                                          "Failed to delete draft news. Status: ${response.statusCode}");
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
                                                            "Error deleting draft news: $e"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    print(
                                                        "Error deleting draft news: $e");
                                                  }
                                                }

                                                //
                                                await deleteAllDraft(
                                                    rollNumber: UserSession()
                                                        .rollNumber
                                                        .toString(),
                                                    module: 'news');

                                                await _fetchdraft();

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
                //
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
          : draftNews.isEmpty
              ? Center(
                  child: Text(
                    "No draft news available!",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'regular',
                      color: Color.fromRGBO(145, 145, 145, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: draftNews.length,
                      itemBuilder: (context, index) {
                        NewsData newsItem = draftNews[index];
                        return Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.07,
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Drafted on : ${newsItem.postedOnDate} | ${newsItem.postedOnDay}',
                                        style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                //card section
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: newsItem.news.length,
                                    itemBuilder: (context, subIndex) {
                                      NewsItem newsDetail =
                                          newsItem.news[subIndex];
                                      return Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.03),
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
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
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
                                                          '${newsDetail.headLine ?? ' '}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'semibold',
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: newsDetail.news !=
                                                                  null &&
                                                              newsDetail.news!
                                                                  .isNotEmpty
                                                          ? Html(
                                                              data:
                                                                  '${newsDetail.news}',
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
                                                                        TextAlign
                                                                            .justify),
                                                              },
                                                            )
                                                          : const Text(''),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                // image....
                                                if (newsDetail
                                                        .filePath?.isNotEmpty ??
                                                    false)
                                                  Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      //image
                                                      SizedBox(
                                                        height: 250,
                                                        width: double.infinity,
                                                        child: Opacity(
                                                          opacity: 0.5,
                                                          child: Image.network(
                                                            '${newsDetail.filePath}',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      //video
                                                      if (newsDetail.fileType ==
                                                          'link')
                                                        SizedBox(
                                                          height: 250,
                                                          width:
                                                              double.infinity,
                                                          child: YoutubePlayer(
                                                            progressIndicatorColor:
                                                                AppTheme
                                                                    .textFieldborderColor,
                                                            controller:
                                                                YoutubePlayerController(
                                                              initialVideoId:
                                                                  YoutubePlayer.convertUrlToId(
                                                                          newsDetail.filePath ??
                                                                              '')
                                                                      .toString(),
                                                              flags:
                                                                  YoutubePlayerFlags(
                                                                autoPlay: false,
                                                                mute: false,
                                                              ),
                                                            ),
                                                            showVideoProgressIndicator:
                                                                true,
                                                            width: 150,
                                                            aspectRatio: 16 / 9,
                                                          ),
                                                        ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        height: 250,
                                                        width: double.infinity,
                                                      ),
                                                      // Centered Text
                                                      Center(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // imagepath
                                                            String? imagePath =
                                                                newsDetail
                                                                    .filePath;
                                                            //videopath
                                                            String videopath =
                                                                newsDetail
                                                                    .filePath
                                                                    .toString();

                                                            if (newsDetail
                                                                    .fileType ==
                                                                'image') {
                                                              _showBottomSheet(
                                                                  context,
                                                                  imagePath,
                                                                  null);
                                                            } else if (newsDetail
                                                                    .fileType ==
                                                                'link') {
                                                              // Navigate to VideoScreen when clicked
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      VideoScreen(
                                                                          videoUrl:
                                                                              videopath),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
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
                                                                  width: 1.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                            ),
                                                            child: Text(
                                                              newsDetail.fileType ==
                                                                      'image'
                                                                  ? 'View Image'
                                                                  : newsDetail.fileType ==
                                                                          'link'
                                                                      ? 'View Video'
                                                                      : '',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
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
                                                    top: MediaQuery.of(context)
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
                                                //
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.02,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      //
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
                                                                  "Do you really want to make\n changes to this News?,",
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
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'regular'),
                                                                          )),
                                                                      //edit...
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.025,
                                                                        ),
                                                                        child: ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              padding: EdgeInsets.symmetric(horizontal: 40),
                                                                              backgroundColor: AppTheme.textFieldborderColor,
                                                                              elevation: 0,
                                                                            ),
                                                                            onPressed: () {
                                                                              Navigator.pop(context);
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => Editnewsdraft()));
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
                                                              EdgeInsets.only(
                                                            right: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025,
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
                                                      ),
                                                      //delete icon
                                                      GestureDetector(
                                                        onTap: () {
                                                          final int newsId =
                                                              newsDetail.id;

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
                                                                  "Are you sure you want to delete\n this news?",
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
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'regular'),
                                                                          )),
                                                                      //delete...
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.025,
                                                                        ),
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 40),
                                                                            backgroundColor:
                                                                                AppTheme.textFieldborderColor,
                                                                            elevation:
                                                                                0,
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
                                                                                      if (mounted) {
                                                                                        String message = 'News item deleted successfully!';

                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                            backgroundColor: Colors.green,
                                                                                            content: Text(message),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                      print('News item with ID $newsId has been successfully deleted.');
                                                                                      setState(() {});

                                                                                      // Refresh the news data after deletion
                                                                                      Navigator.pop(context);
                                                                                      //
                                                                                      await _fetchdraft();
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
                                                                                    _fetchdraft();
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
                                                        child: SvgPicture.asset(
                                                          'assets/icons/delete_icons.svg',
                                                          fit: BoxFit.contain,
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
                                      );
                                    }),
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
                          ],
                        );
                      }),
                ),
    );
  }

  ///show bottomsheet.......
  void _showBottomSheet(
      BuildContext context, String? imagePath, String? videoPath) {
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
}

//
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
          color: Colors.black.withOpacity(0.6),
        ),
        child: Center(
          child: YoutubePlayerBuilder(
            onEnterFullScreen: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            },
            onExitFullScreen: () {
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
                  player,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
