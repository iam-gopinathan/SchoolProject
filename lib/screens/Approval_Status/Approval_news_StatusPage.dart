import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ApprovalNewsStatuspage extends StatefulWidget {
  const ApprovalNewsStatuspage({super.key});

  @override
  State<ApprovalNewsStatuspage> createState() => _ApprovalNewsStatuspageState();
}

class _ApprovalNewsStatuspageState extends State<ApprovalNewsStatuspage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(251, 251, 251, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            titleSpacing: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: AppTheme.appBackgroundPrimaryColor,
            leading: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            title: Text(
              'News Approvals Status',
              style: TextStyle(
                fontFamily: 'semibold',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
            Transform.translate(
              offset: Offset(0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 236, 254, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Scheduled For Monday at 11.15am',
                      style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 10,
                        color: Color.fromRGBO(131, 56, 236, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                            text: ' Edit',
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
            Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  borderRadius: BorderRadius.circular(15)),
              elevation: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(238, 238, 238, 1),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.all(15),
                width: 370,
                child: Column(
                  children: [
                    //
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            '{news.headline ?? ' '}',
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Divider(
                        thickness: 2,
                        color: Color.fromRGBO(243, 243, 243, 1),
                      ),
                    ),
                    //
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            '{news.headline ?? ' '}',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    //
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    //image....
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        //image
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.asset(
                              'assets/images/NewsPage_image.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        //
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10)),
                          height: 250,
                          width: double.infinity,
                        ),
                        GestureDetector(
                          onTap: () {
                            var imagePath;
                            var videoPath;
                            _showBottomSheet(context, imagePath, videoPath);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'View Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'semibold',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created On : 01-12-2024',
                                style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 12,
                                    color: Color.fromRGBO(138, 138, 138, 1)),
                              ),
                              //
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'Created By : Admin',
                                  style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 12,
                                      color: Color.fromRGBO(138, 138, 138, 1)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'Time : 10:45',
                                  style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 12,
                                      color: Color.fromRGBO(138, 138, 138, 1)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Divider(
                        thickness: 2,
                        color: Color.fromRGBO(243, 243, 243, 1),
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5),
                            color: Color.fromRGBO(235, 130, 0, 1),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 230, 204, 1),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 20,
                                      color: Color.fromRGBO(235, 130, 0, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Pending',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(235, 130, 0, 1)),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }

  //
  void _showBottomSheet(
      BuildContext context, String? imagePath, String? videoPath) {
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
