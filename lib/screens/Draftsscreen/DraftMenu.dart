import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Draftsscreen/CircularDraft/CircularDraftMainpage.dart';
import 'package:flutter_application_1/screens/Draftsscreen/ConsentDraft/consentDraftMainpage.dart';
import 'package:flutter_application_1/screens/Draftsscreen/MessageDraft/MessageDraftMainpage.dart';
import 'package:flutter_application_1/screens/Draftsscreen/NewsDraft/NewsDraftmainpage.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

class Draftmenu extends StatefulWidget {
  const Draftmenu({super.key});

  @override
  State<Draftmenu> createState() => _DraftmenuState();
}

class _DraftmenuState extends State<Draftmenu> {
  //
  final List<Map<String, dynamic>> items = [
    {
      "svg": 'assets/icons/Attendancepage_news.svg',
      "label": "News",
      "color": [
        Color.fromRGBO(176, 93, 208, 0.1),
        Color.fromRGBO(134, 0, 187, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 248, 251, 1),
        Color.fromRGBO(250, 248, 251, 1)
      ],
      "page": Newsdraftmainpage(),
    },
    {
      "svg": 'assets/icons/Attendancepage_message.svg',
      "label": "Messages",
      "color": [
        Color.fromRGBO(252, 170, 103, 0.1),
        Color.fromRGBO(206, 92, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 252, 251, 1),
        Color.fromRGBO(254, 252, 251, 1),
      ],
      "page": Messagedraftmainpage(),
    },
    {
      "svg": 'assets/icons/Attendancepage_notesoutline.svg',
      "label": "Circulars",
      "color": [
        Color.fromRGBO(125, 195, 83, 0.1),
        Color.fromRGBO(66, 177, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(252, 253, 250, 1),
        Color.fromRGBO(252, 253, 250, 1)
      ],
      "page": Circulardraftmainpage(),
    },
    {
      "svg": 'assets/icons/Attendencepage_form.svg',
      "label": "Consent\n Forms",
      "color": [
        Color.fromRGBO(216, 70, 0, 0.1),
        Color.fromRGBO(219, 71, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 251, 250, 1),
        Color.fromRGBO(254, 251, 250, 1),
      ],
      "page": Consentdraftmainpage(),
    },
    {
      "svg": 'assets/icons/Attendencepage_time.svg',
      "label": "Time Tables",
      "color": [
        Color.fromRGBO(255, 212, 0, 0.1),
        Color.fromRGBO(224, 186, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 253, 250, 1),
        Color.fromRGBO(254, 253, 250, 1),
      ],
      "page": '',
    },
    {
      "svg": 'assets/icons/Attendancepage_homework.svg',
      "label": "Homeworks",
      "color": [
        Color.fromRGBO(230, 1, 84, 0.1),
        Color.fromRGBO(223, 0, 81, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 250, 251, 1),
        Color.fromRGBO(254, 250, 251, 1),
      ],
      "page": '',
    },
    {
      "svg": 'assets/icons/Attendencepage_examhomework.svg',
      "label": "Exam\n Timetables",
      "color": [
        Color.fromRGBO(105, 57, 184, 0.1),
        Color.fromRGBO(57, 0, 149, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(251, 250, 253, 1),
        Color.fromRGBO(251, 250, 253, 1),
      ],
      "page": '',
    },
    {
      "svg": 'assets/icons/Attendencepage_book.svg',
      "label": "Study\n Materials",
      "color": [
        Color.fromRGBO(31, 115, 194, 0.1),
        Color.fromRGBO(0, 78, 152, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 251, 253, 1),
        Color.fromRGBO(250, 251, 253, 1)
      ],
      "page": '',
    },
    {
      "svg": 'assets/icons/Attendencepage_audit.svg',
      "label": "Marks /\n Results",
      "color": [
        Color.fromRGBO(0, 65, 166, 0.1),
        Color.fromRGBO(11, 46, 100, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(250, 251, 252, 1),
        Color.fromRGBO(250, 251, 252, 1),
      ],
      "page": '',
    },
    {
      "svg": 'assets/icons/Attendencepage_comment.svg',
      "label": "Feedback",
      "color": [
        Color.fromRGBO(250, 90, 42, 0.1),
        Color.fromRGBO(204, 47, 0, 0.1)
      ],
      "cardcolor": [
        Color.fromRGBO(254, 251, 250, 1),
        Color.fromRGBO(254, 251, 250, 1),
      ],
      "page": '',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Drafts',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                color: Colors.white,
                child: GridView.builder(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item['page'],
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: null,
                            gradient: LinearGradient(
                              colors: item['cardcolor'],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: item['color'],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    item['svg'],
                                    fit: BoxFit.contain,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['label'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
