import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CircularApprovalPage extends StatefulWidget {
  const CircularApprovalPage({super.key});

  @override
  State<CircularApprovalPage> createState() => _CircularApprovalPageState();
}

class _CircularApprovalPageState extends State<CircularApprovalPage> {
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
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: AppTheme.appBackgroundPrimaryColor,
            leading: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            title: Text(
              ' Circular Approvals',
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
            //
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(131, 56, 236, 1)),
                      onPressed: () {},
                      child: Text(
                        'Scheduled Circulars',
                        style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 14,
                            color: Colors.white),
                      )),
                ],
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
                            text: ' New',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _declinebottomsheet(context);
                          },
                          child: Transform.translate(
                            offset: Offset(-20, 2),
                            child: Text(
                              'Decline',
                              style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 16,
                                color: Color.fromRGBO(255, 0, 0, 1),
                                decoration: TextDecoration.underline,
                                decorationColor: Color.fromRGBO(255, 0, 0, 1),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: 40,
                            child: isAccepted
                                ? Lottie.asset(
                                    'assets/images/Accept.json',
                                    fit: BoxFit.cover,
                                    height: 40,
                                  )
                                : GestureDetector(
                                    onTap: onAccept,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Color.fromRGBO(0, 150, 60, 1)),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                          fontFamily: 'medium',
                                          fontSize: 16,
                                          color: Color.fromRGBO(0, 150, 60, 1),
                                        ),
                                      ),
                                    ),
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
      ),
    );
  }
  //

  //image or video bottomsheet..
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

  //
  //decline bottomsheeet..
  void _declinebottomsheet(
    BuildContext context,
  ) {
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
                            onPressed: () {},
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            )),
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
}
