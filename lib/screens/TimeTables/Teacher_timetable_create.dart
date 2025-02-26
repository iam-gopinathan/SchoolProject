import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/TimeTable_models/Teacher_timetable_model.dart';
import 'package:flutter_application_1/models/TimeTable_models/Update_teacher_timetable_model.dart';
import 'package:flutter_application_1/services/Timetables/Teacher_timetable_Api.dart';
import 'package:flutter_application_1/services/Timetables/Update_teachertimetable_API.dart';
import 'package:flutter_application_1/services/Timetables/post_teacher_timetable_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';

class TeacherTimetableCreate extends StatefulWidget {
  const TeacherTimetableCreate({super.key});

  @override
  State<TeacherTimetableCreate> createState() => _TeacherTimetableCreateState();
}

class _TeacherTimetableCreateState extends State<TeacherTimetableCreate> {
  TextEditingController searchController = TextEditingController();
  Map<int, PlatformFile?> selectedFiles = {};
  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  List<TeacherTimeTable> _teachersList = [];
  //
  Future<void> fetch() async {
    setState(() {
      isloading = true;
    });
    try {
      List<TeacherTimeTable> teachers = await fetchTeachersTimeTable(
        rollNumber: UserSession().rollNumber ?? '',
        userType: UserSession().userType ?? '',
      );
      setState(() {
        _teachersList = teachers;
        isloading = false;
      });
    } catch (e) {
      setState(() {
        print("Error fetching data: $e");
        isloading = false;
      });
    } finally {
      setState(() {});
    }
  }

  void pickFile(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'webp', 'pdf', 'png'],
        withData: true,
      );

      if (result != null) {
        final file = result.files.single;

        if (file.size > 25 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File size exceeds 25 MB limit.')),
          );
          return;
        }

        setState(() {
          selectedFiles[index] = file; // Store file for the specific index
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File selected: ${file.name}')),
        );
      } else {
        print('File selection canceled');
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }

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
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Create Timetable',
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
          : _teachersList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.textFieldborderColor,
                    strokeWidth: 4,
                  ),
                )
              : Column(
                  children: [
                    //search container...
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: searchController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                prefixIcon: Transform.translate(
                                  offset: Offset(60, 0),
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
                                      width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(245, 245, 245, 1),
                                      width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(245, 245, 245, 1),
                                      width: 1.5),
                                ),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    //
                    Transform.translate(
                      offset: Offset(30, 12),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10)),
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(48, 126, 185, 1),
                                      Color.fromRGBO(0, 70, 123, 1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Text(
                              'Teaching Staffs',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                    Expanded(
                      child: ListView.builder(
                        itemCount: _teachersList.length,
                        itemBuilder: (context, index) {
                          var teacher = _teachersList[index];
                          return Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromRGBO(238, 238, 238, 1),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.04),
                                child: Column(
                                  children: [
                                    //
                                    Row(
                                      children: [
                                        Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.025,
                                          ),
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundImage:
                                                NetworkImage(teacher.photo),
                                          ),
                                        ),
                                        //
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05, // 5% of screen width
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${teacher.name}',
                                                style: TextStyle(
                                                    fontFamily: 'semibold',
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                ),
                                                child: Text(
                                                  '${teacher.employeeCode}',
                                                  style: TextStyle(
                                                      fontFamily: 'semibold',
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: Divider(
                                        color: Color.fromRGBO(
                                          245,
                                          245,
                                          245,
                                          1,
                                        ),
                                        thickness: 1,
                                      ),
                                    ),
                                    //
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50),
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                                color: Colors.black,
                                                width: 1.5),
                                          ),
                                          onPressed: () {
                                            pickFile(index);
                                          },
                                          child: Text(
                                            (teacher.preView.isNotEmpty)
                                                ? 'Reupload Image'
                                                : (selectedFiles[index] == null
                                                    ? 'Upload Image'
                                                    : 'upload Image'),
                                            style: TextStyle(
                                                fontFamily: 'regular',
                                                fontSize: 14,
                                                color: Colors.black),
                                          )),
                                    ),
                                    //
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: Divider(
                                        color: Color.fromRGBO(
                                          245,
                                          245,
                                          245,
                                          1,
                                        ),
                                        thickness: 1,
                                      ),
                                    ),
                                    //
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      child: Row(
                                        children: [
                                          //
                                          GestureDetector(
                                            onTap: () {
                                              var view = teacher.preView;
                                              _showBottomSheet(
                                                  context, view, index);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 25),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Color.fromRGBO(
                                                      252, 246, 240, 1)),
                                              child: Text(
                                                'View Image',
                                                style: TextStyle(
                                                    fontFamily: 'regular',
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        230, 1, 84, 1)),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          //
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
                                                      "Are you sure you want to delete\n this Teacher Timetable?",
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
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
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
                                                          //delete...
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            40),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .textFieldborderColor,
                                                                elevation: 0,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                var rno = teacher
                                                                    .employeeCode;
                                                                try {
                                                                  setState(
                                                                      () {});
                                                                  final response =
                                                                      await http
                                                                          .delete(
                                                                    Uri.parse(
                                                                        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/teachersTimeTable/deleteTeachersTimeTable?RollNumber=$rno'),
                                                                    headers: {
                                                                      'Authorization':
                                                                          'Bearer $authToken',
                                                                      'Content-Type':
                                                                          'application/json',
                                                                    },
                                                                  );

                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    if (mounted) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          backgroundColor:
                                                                              Colors.green,
                                                                          content:
                                                                              Text('Teachers TimeTable  deleted successfully!'),
                                                                        ),
                                                                      );
                                                                    }
                                                                    print(
                                                                        'TimeTable deleted Successfully');

                                                                    Navigator.pop(
                                                                        context);

                                                                    await fetch();
                                                                  } else {
                                                                    print(
                                                                        'Failed to delete news. Status code: ${response.statusCode}');
                                                                    print(
                                                                        'Response body: ${response.body}');

                                                                    if (mounted) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          content:
                                                                              Text(
                                                                            'Failed to delete news item. Status code: ${response.statusCode}',
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  }
                                                                } catch (error) {
                                                                  print(
                                                                      'Error during deletion: $error');
                                                                  if (mounted) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        content:
                                                                            Text('Error: Unable to delete Timetable!'),
                                                                      ),
                                                                    );
                                                                  }
                                                                } finally {
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'regular'),
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
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: SvgPicture.asset(
                                                'assets/icons/delete_icons.svg',
                                                fit: BoxFit.contain,
                                                height: 35,
                                              ),
                                            ),
                                          ),
                                          //
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              disabledBackgroundColor:
                                                  Colors.white,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30),
                                              elevation: 0,
                                              side: BorderSide(
                                                color: Color.fromRGBO(
                                                    252, 190, 58, 1),
                                                width: 2,
                                              ),
                                              backgroundColor:
                                                  AppTheme.textFieldborderColor,
                                            ),
                                            onPressed: isImageSelected(teacher,
                                                    selectedFiles, index)
                                                ? () async {
                                                    if (selectedFiles[index] !=
                                                        null) {
                                                      PlatformFile
                                                          platformFile =
                                                          selectedFiles[index]!;

                                                      if (platformFile.path !=
                                                          null) {
                                                        File file = File(
                                                            platformFile.path!);
                                                        bool result;

                                                        if (teacher.preView !=
                                                                null &&
                                                            teacher.preView!
                                                                .isNotEmpty) {
                                                          if (file.path !=
                                                              teacher.preView) {
                                                            UpdateTeacherTimetableModel
                                                                model =
                                                                UpdateTeacherTimetableModel(
                                                              rollNumber: teacher
                                                                  .employeeCode,
                                                              file: file,
                                                            );

                                                            result =
                                                                await updateTeacherTimeTable(
                                                                    model,
                                                                    context);

                                                            if (result) {
                                                              print(
                                                                  "✅ File updated successfully!");
                                                            } else {
                                                              print(
                                                                  "❌ Failed to update file.");
                                                            }
                                                          } else {
                                                            print(
                                                                "⚠️ File not changed, no update needed.");
                                                          }
                                                        } else {
                                                          result =
                                                              await postTeacherTimeTable(
                                                                  teacher
                                                                      .employeeCode,
                                                                  file,
                                                                  context);

                                                          if (result) {
                                                            print(
                                                                "✅ File uploaded successfully!");
                                                          } else {
                                                            print(
                                                                "❌ Failed to upload file.");
                                                          }
                                                        }
                                                        await Future.delayed(
                                                            Duration(
                                                                seconds: 2));

                                                        // Fetch updated data
                                                        await fetch();
                                                      } else {
                                                        print(
                                                            "❌ File path is null, unable to proceed.");
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                              'Please upload image!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'regular',
                                                                  fontSize: 14),
                                                            ),
                                                            backgroundColor:
                                                                AppTheme
                                                                    .textFieldborderColor),
                                                      );
                                                      print(
                                                          "!! No file selected.");
                                                    }
                                                  }
                                                : null,
                                            child: Text(
                                              (teacher.preView.isNotEmpty)
                                                  ? 'Update'
                                                  : 'Save',
                                              style: TextStyle(
                                                  fontFamily: 'medium',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          //
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  //
  bool isImageSelected(teacher, selectedFiles, index) {
    return teacher.preView.isNotEmpty || selectedFiles[index] != null;
  }

  //
  void _showBottomSheet(BuildContext context, String? image, int index) {
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
                //
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: (selectedFiles[index] != null)
                      ? Image.file(
                          File(selectedFiles[index]!.path.toString()),
                          fit: BoxFit.contain,
                        )
                      : (image != null && image.isNotEmpty)
                          ? Image.network(
                              image,
                              fit: BoxFit.contain,
                            )
                          : Center(
                              child: Text(
                                "No image available",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'semibold'),
                              ),
                            ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
