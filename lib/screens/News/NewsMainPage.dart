import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/News_Models/NewsMainPage_model.dart';
import 'package:flutter_application_1/screens/News/Create_newsScreen.dart';
import 'package:flutter_application_1/screens/News/Edit_newsScreen.dart';
import 'package:flutter_application_1/services/News_Api/News_mainPage_Api.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Newsmainpage extends StatefulWidget {
  const Newsmainpage({super.key});

  @override
  State<Newsmainpage> createState() => _NewsmainpageState();
}

class _NewsmainpageState extends State<Newsmainpage> {
  TextEditingController searchController = TextEditingController();
  //loading....
  bool isLoading = true;

  bool isdeleteloader = false;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNewsData();
  }

  bool isswitched = false;

// Fetch the news data............
  List<NewsResponse> newsList = [];
  List<NewsResponse> filteredNewsList = [];
  Future<void> _fetchNewsData() async {
    try {
      isLoading = true;

      String isMyProject = isswitched ? 'Y' : 'N';
      final fetchedNews =
          await fetchMainNews(date: selectedDate, isMyProject: isMyProject);
      setState(() {
        newsList = fetchedNews;
        filteredNewsList = newsList;
        isLoading = false;

        print("main pageeeeeee newwwwwwwwwwwssssssssssss$newsList");
        print("Selected Date: $selectedDate");
        print("Switch Status: $isswitched");
      });
    } catch (e) {
      isLoading = false;
      print("Error fetching news: $e");
    }
  }

  //search news...
  void _filterNews(String query) {
    setState(() {
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
    });
  }

  // ///bold text function start..
  // TextSpan _parseNewsContent(String content) {
  //   final RegExp boldPattern = RegExp(r"<b>(.*?)</b>");
  //   final List<TextSpan> spans = [];
  //   int currentIndex = 0;

  //   for (final match in boldPattern.allMatches(content)) {
  //     if (match.start > currentIndex) {
  //       spans.add(TextSpan(
  //         text: content.substring(currentIndex, match.start),
  //         style: TextStyle(
  //           fontFamily: 'medium',
  //           fontSize: 12,
  //           color: Colors.black,
  //         ),
  //       ));
  //     }

  //     spans.add(TextSpan(
  //       text: match.group(1),
  //       style: TextStyle(
  //         fontFamily: 'medium',
  //         fontSize: 12,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //       ),
  //     ));

  //     currentIndex = match.end; // Update the index
  //   }

  //   // Add remaining plain text after the last <b> tag
  //   if (currentIndex < content.length) {
  //     spans.add(TextSpan(
  //       text: content.substring(currentIndex),
  //       style: TextStyle(
  //         fontFamily: 'medium',
  //         fontSize: 12,
  //         color: Colors.black,
  //       ),
  //     ));
  //   }

  //   return TextSpan(children: spans);
  // }

  TextSpan _parseNewsContent(String content) {
    final RegExp tagPattern =
        RegExp(r"<(/?)(\w+)([^>]*?)>(.*?)</\2>|<([^>]+)>");
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    // Loop over all matching HTML tags
    for (final match in tagPattern.allMatches(content)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: content.substring(currentIndex, match.start),
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.black,
          ),
        ));
      }

      // Safely handle match groups
      String tagName = match.group(2) ?? '';
      String tagContent = match.group(4) ?? '';

      if (tagName == 'b') {
        spans.add(TextSpan(
          text: tagContent,
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
      } else if (tagName == 'i') {
        spans.add(TextSpan(
          text: tagContent,
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
        ));
      } else if (tagName == 'u') {
        spans.add(TextSpan(
          text: tagContent,
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            decoration: TextDecoration.underline,
            color: Colors.black,
          ),
        ));
      } else if (tagName == 'a') {
        String href =
            match.group(3)?.replaceFirst('href="', '').replaceFirst('"', '') ??
                '';
        spans.add(TextSpan(
          text: tagContent,
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (href.isNotEmpty) {
                print("Opening URL: $href");
              }
            },
        ));
      } else if (tagName == 'p') {
        spans.add(TextSpan(
          text: tagContent,
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.black,
          ),
        ));
      } else if (tagName == 'div' &&
          match.group(3)?.contains('class="table"') == true) {
        spans.add(TextSpan(
          text: "Table content: $tagContent",
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.blue,
          ),
        ));
      } else if (tagName == 'br') {
        spans.add(TextSpan(
          text: "\n",
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.black,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: tagContent,
          style: TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.black,
          ),
        ));
      }

      currentIndex = match.end;
    }

    if (currentIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(currentIndex),
        style: TextStyle(
          fontFamily: 'medium',
          fontSize: 12,
          color: Colors.black,
        ),
      ));
    }

    return TextSpan(children: spans);
  }

//bold text function end...

  ///fetch news data end....

  ///image bottomsheeet.....
  void _showBottomSheet(BuildContext context, String imagePath) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Stack(clipBehavior: Clip.none, children: [
            // Close icon
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
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.network(
                      '${imagePath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ]);
        });
      },
    );
  }
  //show image bottomsheet code end....

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
                            SizedBox(height: 10),
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
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      decorationColor:
                                          Color.fromRGBO(75, 75, 75, 1),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
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
                                isLoading = true;
                              });
                              _fetchNewsData();
                            },
                          ),
                        ],
                      ),
                    ),
//add screen....
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
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
              : Column(
                  children: [
                    ///nextsection
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            //search container...
                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: searchController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    prefixIcon: Transform.translate(
                                      offset: Offset(75, 0),
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
                          itemCount: filteredNewsList.length,
                          itemBuilder: (context, index) {
                            final newsResponse = filteredNewsList[index];

                            return Column(
                              children: [
                                //cardsection..
                                ...newsResponse.news.map((news) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, top: 20),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Posted on : ${newsResponse.postedOnDate} | ${newsResponse.postedOnDay}',
                                              style: TextStyle(
                                                  fontFamily: 'regular',
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0, 5),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: newsResponse.tag.isNotEmpty
                                                ? 0
                                                : 50,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: newsResponse
                                                    .tag.isNotEmpty
                                                ? MainAxisAlignment.spaceAround
                                                : MainAxisAlignment.start,
                                            children: [
                                              if (newsResponse.news[index]
                                                          .updatedOn !=
                                                      null &&
                                                  newsResponse.news[index]
                                                      .updatedOn!.isNotEmpty)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 251, 245, 1),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
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
                                                )
                                              else
                                                SizedBox(width: 100),
                                              if (newsResponse.tag.isNotEmpty)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                    color: AppTheme
                                                        .textFieldborderColor,
                                                  ),
                                                  child: Text(
                                                    '${newsResponse.tag}',
                                                    style: TextStyle(
                                                      fontFamily: 'medium',
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color.fromRGBO(
                                                  238, 238, 238, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 1,
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
                                          width: 370,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                      '${news.headline}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'semibold',
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
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
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: RichText(
                                                        text: _parseNewsContent(
                                                            news.news),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              //image....
                                              if (news.filePath?.isNotEmpty ??
                                                  false)
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 250,
                                                      width: double.infinity,
                                                      child: Image.network(
                                                        '${news.filePath}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.6),
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
                                                          String? imagePath =
                                                              news.filePath;
                                                          if (imagePath !=
                                                                  null &&
                                                              imagePath
                                                                  .isNotEmpty) {
                                                            _showBottomSheet(
                                                                context,
                                                                imagePath);
                                                          } else {
                                                            _showBottomSheet(
                                                                context,
                                                                'assets/images/default_image.png');
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
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
                                                            'View Image',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Posted by : ${news.name}',
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
                                                        Text(
                                                          'Time : ${news.time}',
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
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),

                                                    //edit icon
                                                    if (newsResponse.news[index]
                                                            .isAlterAvailable ==
                                                        'Y')
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
                                                                  "Do you really want to make\n changes to this news?",
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
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                10),
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
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
                                                                    Icons.edit),
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
                                                    if (newsResponse.news[index]
                                                            .isAlterAvailable ==
                                                        'Y')
                                                      //delete icon
                                                      GestureDetector(
                                                        onTap: () {
                                                          final int newsId =
                                                              news.id;

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
                                                                  "Are you sure you want to delete\n this news item?",
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
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                10),
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
                                                                          onPressed:
                                                                              () async {
                                                                            isdeleteloader =
                                                                                true;
                                                                            try {
                                                                              const authToken = '123';

                                                                              final response = await http.delete(
                                                                                Uri.parse('https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeNews/DeleteNews?Id=$newsId'),
                                                                                headers: {
                                                                                  'Authorization': 'Bearer $authToken',
                                                                                  'Content-Type': 'application/json',
                                                                                },
                                                                              );

                                                                              if (response.statusCode == 200) {
                                                                                if (mounted) {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                    SnackBar(
                                                                                      backgroundColor: Colors.green,
                                                                                      content: Text('News item deleted successfully'),
                                                                                    ),
                                                                                  );
                                                                                }

                                                                                print('News item with ID $newsId has been successfully deleted.');
                                                                                setState(() {
                                                                                  newsResponse.news.removeWhere((item) => item.id == newsId);
                                                                                });
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
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Delete',
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 16,
                                                                                fontFamily: 'regular'),
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
                                    ],
                                  );
                                }).toList(),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
    );
  }
}
