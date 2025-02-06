import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Marks_models/ParentMarks_model.dart';
import 'package:flutter_application_1/services/Marks_Api/Parents_marks_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ParentMarksandresults extends StatefulWidget {
  const ParentMarksandresults({super.key});

  @override
  State<ParentMarksandresults> createState() => _ParentMarksandresultsState();
}

class _ParentMarksandresultsState extends State<ParentMarksandresults> {
  ScrollController _scrollController = ScrollController();

  bool ismarks = true;
  bool iscomparison = false;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
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

  bool _isLoading = false;
  ParentmarksModel? _parent;
//fetch..
  Future<void> fetch() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ParentmarksModel marks = await fetchParentMarks(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
      );
      setState(() {
        _parent = marks;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching marks: $error");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch marks. Please try again.")),
      );
    }
  }

  //pdf dwnloader...
  Future<void> generateStudentPDF() async {
    if (_parent == null) return;

    final student = _parent!.data;

    final imageBytes = await _fetchImageBytes(student.profile);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Student Profile',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Image(pw.MemoryImage(imageBytes), width: 100, height: 100),
              pw.Text(student.name),
              pw.Text(student.rollNumber),
              pw.Text(student.gradeAndSection),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['Subject', 'Marks'],
                  ..._parent!.exams.entries.map((examEntry) {
                    return [examEntry.key, examEntry.value.marksScored];
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Failed to get directory");
      return;
    }

    final downloadFolder = Directory('${directory.path}/Downloads');
    if (!await downloadFolder.exists()) {
      await downloadFolder.create(recursive: true);
    }

    final filePath =
        '${downloadFolder.path}/student_${student.name}_results.pdf';
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    // Optionally, you can open the file with a package like open_file
    // await OpenFile.open(filePath);

    await FlutterDownloader.enqueue(
      url: 'file://$filePath',
      savedDir: downloadFolder.path,
      fileName: 'student_${student.name}_results.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  Future<Uint8List> _fetchImageBytes(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception("Failed to load image");
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
                              'Marks/Results',
                              style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Color.fromRGBO(225, 225, 225, 1))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          //marks..
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                ismarks = true;
                                iscomparison = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ismarks
                                      ? AppTheme.textFieldborderColor
                                      : Colors.white),
                              child: Text(
                                'Marks/Results',
                                style: TextStyle(
                                    fontFamily: 'semibold',
                                    fontSize: 14,
                                    color: Color.fromRGBO(24, 24, 24, 1)),
                              ),
                            ),
                          ),
                          //comparison..
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ismarks = false;
                                  iscomparison = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: iscomparison
                                        ? AppTheme.textFieldborderColor
                                        : Colors.white),
                                child: Text(
                                  'Comparison',
                                  style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 14,
                                      color: Color.fromRGBO(24, 24, 24, 1)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //profile data......
            if (ismarks)
              _parent == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.textFieldborderColor,
                          strokeWidth: 4,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromRGBO(215, 215, 215, 1),
                                width: 1),
                          ),
                          child: Column(
                            children: [
                              //
                              ListTile(
                                leading: Image.network(
                                  '${_parent?.data.profile}',
                                  fit: BoxFit.contain,
                                ),
                                title: Text(
                                  '${_parent?.data.name} ',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_parent?.data.rollNumber}',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    //
                                    Text(
                                      '${_parent?.data.gradeAndSection}',
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 16,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              //expansion tile...
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              if (ismarks)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Color.fromRGBO(215, 215, 215, 1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children:
                                          _parent != null &&
                                                  _parent!.exams.isNotEmpty
                                              ? _parent!.exams.entries
                                                  .map((examEntry) {
                                                  String semester =
                                                      examEntry.key;
                                                  var examDetails =
                                                      examEntry.value;
                                                  return ExpansionTile(
                                                    initiallyExpanded: true,
                                                    shape: Border(),
                                                    title: Text(
                                                      semester,
                                                      style: TextStyle(
                                                        fontFamily: 'medium',
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Divider(
                                                          color: Color.fromRGBO(
                                                              249, 249, 249, 1),
                                                          thickness: 2,
                                                          height: 4,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            DataTable(
                                                              dataRowColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                Color.fromRGBO(
                                                                    255,
                                                                    252,
                                                                    252,
                                                                    1),
                                                              ),
                                                              headingRowColor:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                Colors.white,
                                                              ),
                                                              horizontalMargin:
                                                                  0,
                                                              headingRowHeight:
                                                                  50,
                                                              dividerThickness:
                                                                  0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white),
                                                              columnSpacing: 0,
                                                              columns: [
                                                                DataColumn(
                                                                  label:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            25),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            239,
                                                                            239,
                                                                            1),
                                                                    child: Text(
                                                                      'Subjects',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'medium',
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            25),
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            247,
                                                                            247,
                                                                            1)),
                                                                    child: Text(
                                                                      'Marks',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'medium',
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                              rows: _parent !=
                                                                          null &&
                                                                      _parent!
                                                                          .subjects
                                                                          .isNotEmpty
                                                                  ? _parent!
                                                                      .subjects
                                                                      .map(
                                                                          (subject) {
                                                                      String
                                                                          marks =
                                                                          '0';
                                                                      marks =
                                                                          examDetails.subjectMarks[subject.toLowerCase()] ??
                                                                              '0';
                                                                      return DataRow(
                                                                        cells: [
                                                                          DataCell(
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 15),
                                                                              child: Text(subject),
                                                                            ),
                                                                          ),
                                                                          DataCell(
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 15),
                                                                              child: Text(marks),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }).toList()
                                                                  : [],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 30),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'Total Marks ',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'medium',
                                                                            fontSize:
                                                                                10,
                                                                            color: Color.fromRGBO(
                                                                                54,
                                                                                54,
                                                                                54,
                                                                                1)),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                3),
                                                                        child:
                                                                            Text(
                                                                          examDetails.totalMarks ??
                                                                              '0',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'medium',
                                                                            fontSize:
                                                                                12,
                                                                            color: Color.fromRGBO(
                                                                                54,
                                                                                54,
                                                                                54,
                                                                                1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                          top:
                                                                              BorderSide(
                                                                            color: Color.fromRGBO(
                                                                                245,
                                                                                245,
                                                                                245,
                                                                                1),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        'Scored Marks',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'medium',
                                                                            fontSize:
                                                                                12,
                                                                            color: Color.fromRGBO(
                                                                                54,
                                                                                54,
                                                                                54,
                                                                                1)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 2),
                                                                    child: Text(
                                                                      examDetails
                                                                              .marksScored ??
                                                                          '0',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'semibold',
                                                                        fontSize:
                                                                            24,
                                                                        color: Color.fromRGBO(
                                                                            1,
                                                                            133,
                                                                            53,
                                                                            1),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Color.fromRGBO(
                                                                              1,
                                                                              133,
                                                                              53,
                                                                              1),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      examDetails.remarks ==
                                                                              "Not Available"
                                                                          ? "NA"
                                                                          : (examDetails.remarks ??
                                                                              '0'),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'medium',
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${examDetails.percentage ?? '0'}%',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'regular',
                                                                      fontSize:
                                                                          18,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              54,
                                                                              54,
                                                                              54,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 1.5),
                                                          ),
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          var notes = examDetails
                                                                  .teacherNotes ??
                                                              '';
                                                          _viewBottomsheet(
                                                              context, notes);
                                                        },
                                                        child: Text(
                                                          'View Teacher Comment',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'regular',
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10,
                                                                    left: 45,
                                                                    bottom: 20),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            50),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          1.5),
                                                                ),
                                                                elevation: 0,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                              onPressed: () {
                                                                generateStudentPDF();
                                                              },
                                                              child: Text(
                                                                'Download Result',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SvgPicture.asset(
                                                            'assets/icons/Export_dwnl.svg',
                                                            fit: BoxFit.contain,
                                                            height: 40,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }).toList()
                                              : [],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
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

TextEditingController _teachercommmentview = TextEditingController();
//view bottomsheet..
void _viewBottomsheet(BuildContext context, String notes) {
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
          TextEditingController _teachercommentview =
              TextEditingController(text: notes);
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
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        children: [
                          Text(
                            'Teacher Comment',
                            style: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(202, 202, 202, 1),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          readOnly: true,
                          maxLines: 9,
                          controller: _teachercommentview,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 70, vertical: 5),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]);
        },
      );
    },
  );
}
