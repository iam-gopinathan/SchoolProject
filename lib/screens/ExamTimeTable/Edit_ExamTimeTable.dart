import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Exam_Timetable/Edit_ExamTimetables_model.dart';
import 'package:flutter_application_1/models/Exam_Timetable/Update_ExamTimetable_model.dart';
import 'package:flutter_application_1/services/ExamTimetables_Api/Edit_examtimetable_Api.dart';
import 'package:flutter_application_1/services/ExamTimetables_Api/Update_examTimetable_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditExamtimetable extends StatefulWidget {
  final int id;
  final Function fetchmainexam;
  const EditExamtimetable(
      {super.key, required this.id, required this.fetchmainexam});

  @override
  State<EditExamtimetable> createState() => _EditExamtimetableState();
}

class _EditExamtimetableState extends State<EditExamtimetable> {
  EditExamtimetablesModel? edit;
  final GradeController _gradeController = Get.put(GradeController());

  List<Map<String, dynamic>> gradeList = [];

  List<String> availableExams = [];
  String? _selectedClass;
  bool isLoading = true;
  String? _selectedExam;

  /// edit exam timetable..
  Future<void> EditExamTimetableData() async {
    try {
      isLoading = true;
      final data = await fetchEditExamTimetableData(widget.id);
      print("Fetched Timetable Data: $data");

      if (_gradeController.gradeList.isEmpty) {
        print("Grade list is empty. Ensure fetchGrades is called.");
        return;
      }

      print("Grade List: ${_gradeController.gradeList}");
      print("Grade ID from Timetable Data: ${data.gradeId}");

      setState(() {
        edit = data;
        isLoading = false;

        gradeList = List<Map<String, dynamic>>.from(_gradeController.gradeList);
        final selectedGrade = gradeList.firstWhere(
          (grade) => grade['id'].toString() == data.gradeId.toString(),
          orElse: () {
            print("Grade ID ${data.gradeId} not found in grade list.");
            return {'sign': null, 'sections': []};
          },
        );

        _selectedClass = selectedGrade['sign'];

        availableExams = List<String>.from(selectedGrade['exams'] ?? []);
        availableExams = availableExams.toSet().toList();

        if (!availableExams.contains(data.exam)) {
          _selectedExam = '';
        } else {
          _selectedExam = data.exam;
        }

        print("Available Exams: $availableExams");
        print("Selected Exam: $_selectedExam");

        // Set initial file details
        initialFilePath = data.filepath;
        initialFileType = data.fileType;

        setState(() {
          filename = data.filename ?? 'No file selected';
        });
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  String? initialFilePath;
  String? initialFileType;

  String? filename;

  PlatformFile? selectedFile;

  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'webp', 'pdf', 'png', 'jpg'],
        withData: true,
      );

      if (result != null) {
        final file = result.files.single;

        if (file.bytes == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to read file data.')),
          );
          return;
        }

        if (file.size > 25 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File size exceeds 25 MB limit.')),
          );
        } else {
          setState(() {
            selectedFile = file;
          });

          print('Selected file name: ${file.name}');
          print('Selected file size: ${file.size}');
          print('Selected file extension: ${file.extension}');
          print('File bytes length: ${file.bytes?.length ?? 0}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File selected: ${file.name}')),
          );
        }
      } else {
        print('File selection canceled');
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }

  ///image bottomsheeet
  void _PreviewBottomsheet(BuildContext context, String image) {
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
                top: MediaQuery.of(context).size.height *
                    -0.08, // 8% of screen height (negative)
                left: MediaQuery.of(context).size.width *
                    0.45, // 45% of screen width

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
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            Text(
                              'Preview Screen',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 16,
                                  color: Color.fromRGBO(104, 104, 104, 1)),
                            ),
                          ],
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(
                          thickness: 1,
                          color: Color.fromRGBO(243, 243, 243, 1),
                        ),
                      ),
                      //selectedclass
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15, top: 10),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         _selectedClass.toString(),
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 16,
                      //             color: Colors.black),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //slected exam

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 15, top: 10),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         _selectedExam.toString(),
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 16,
                      //             color: Colors.black),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //fethed image..
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),

                      ///image section...
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Center(
                          child: selectedFile != null &&
                                  selectedFile!.bytes != null
                              ? Image.memory(
                                  selectedFile!.bytes!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]);
          });
        });
  }

  @override
  void initState() {
    super.initState();
    _gradeController.fetchGrades();
    EditExamTimetableData();
  }

  bool isFetchedImageVisible = true;

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
                  ), // 3
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.fetchmainexam();
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
                          'Edit Exam Timetable',
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  //select class
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Class',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ),
                        //class dropdown code..
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Select class',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                            ),
                            value: _selectedClass,
                            items: gradeList.map((grade) {
                              return DropdownMenuItem<String>(
                                value: grade['sign'],
                                child: Text(
                                  grade['sign'],
                                  style: TextStyle(
                                      fontFamily: 'regular',
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //select exam...
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Exam',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ),
                        // Exam dropdown.......
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Select exam',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                ),
                              ),
                            ),
                            value: _selectedExam,
                            dropdownColor: Colors.black,
                            menuMaxHeight: 150,
                            items: availableExams.map((exam) {
                              return DropdownMenuItem<String>(
                                value: exam,
                                child: Text(
                                  exam,
                                  style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedExam = value;
                              });
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return availableExams.map<Widget>((exam) {
                                return Text(
                                  exam,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //upload image......
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height *
                          0.05, // 5% of screen height
                      left: MediaQuery.of(context).size.width *
                          0.05, // 4% of screen width
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(246, 246, 246, 1)),
                          child: Text(
                            'Upload Image',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'medium',
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DottedBorder(
                        dashPattern: [8, 4],
                        borderType: BorderType.Rect,
                        color: Color.fromRGBO(0, 102, 255, 1),
                        strokeWidth: 2,
                        child: GestureDetector(
                          onTap: () {
                            pickFile();
                            isFetchedImageVisible = false;
                          },
                          child: Container(
                            color: Color.fromRGBO(228, 238, 253, 1)
                                .withOpacity(0.9),
                            height: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/NewsPage_file.svg',
                                    fit: BoxFit.contain,
                                    height: 40,
                                    width: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Click Here to',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'medium',
                                              color: Color.fromRGBO(
                                                  93, 93, 93, 1)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            'Upload File',
                                            style: TextStyle(
                                                fontFamily: 'semibold',
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          'Maximum Size : 25MB',
                                          style: TextStyle(
                                              fontFamily: 'medium',
                                              fontSize: 10,
                                              color: Color.fromRGBO(
                                                  0, 102, 255, 1)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Display selected image...
                  if (selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              if (['jpeg', 'png', 'webp', 'jpg']
                                  .contains(selectedFile!.extension))
                                selectedFile!.bytes != null
                                    ? Image.memory(
                                        selectedFile!.bytes!,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      )
                                    : Text(
                                        'Failed to load image data.',
                                        style: TextStyle(color: Colors.red),
                                      )
                              else if (selectedFile!.extension == 'pdf')
                                Icon(
                                  Icons.picture_as_pdf,
                                  size: 100,
                                  color: Colors.red,
                                ),
                              SizedBox(height: 10),
                              // Display file name
                              Text(
                                selectedFile!.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // Close icon to remove image
                          Positioned(
                            top: 0,
                            right: 40,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFile = null;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  //

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Supported Format : JPEG,Webp PNG, PDF',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 9,
                            color: Color.fromRGBO(168, 168, 168, 1)),
                      ),
                      // Text(
                      //   '*Upload either an image or a link',
                      //   style: TextStyle(
                      //       fontFamily: 'regular',
                      //       fontSize: 9,
                      //       color: Color.fromRGBO(168, 168, 168, 1)),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        child: //preview
            Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _PreviewBottomsheet(context, initialFilePath!);
                },
                child: Text(
                  'Preview',
                  style: TextStyle(
                      fontFamily: 'semibold',
                      fontSize: 16,
                      color: Colors.black),
                ),
              ),

              //update..
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor,
                    side: BorderSide.none),
                onPressed: () {
                  onUpdateExamTimeTable(selectedFile, context);
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'medium', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//
  // Future<void> onUpdateExamTimeTable(
  //     PlatformFile selectedFile, BuildContext context) async {
  //   String formattedDate =
  //       DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

  //   String? fileType;
  //   String? filePath;

  //   if (selectedFile != null) {
  //     fileType = 'image';
  //     filePath = selectedFile.extension!;
  //   } else {
  //     fileType = 'existing';
  //     filePath = '';
  //   }

  //   final examTimeTable = UpdateExamTimetableModel(
  //     id: widget.id.toString(),
  //     userType: UserSession().userType.toString(),
  //     rollNumber: UserSession().rollNumber.toString(),
  //     headLine: '',
  //     description: '',
  //     exam: _selectedExam.toString(),
  //     fileType: fileType.toString(),
  //     file: filePath,
  //     updatedOn: formattedDate,
  //   );

  //   await updateExamTimeTable(examTimeTable, selectedFile, context);
  // }
  Future<void> onUpdateExamTimeTable(
      PlatformFile? selectedFile, BuildContext context) async {
    String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    String? fileType;
    String? filePath;

    if (selectedFile != null && selectedFile.extension != null) {
      fileType = 'image';
      filePath = selectedFile.extension;
    } else if (isFetchedImageVisible && initialFilePath != null) {
      fileType = 'existing';
      filePath = initialFilePath;
    }

    // Validate fileType and filePath before proceeding
    if (fileType == null || filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or use an existing file!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final examTimeTable = UpdateExamTimetableModel(
      id: widget.id.toString(),
      userType: UserSession().userType ?? 'unknown',
      rollNumber: UserSession().rollNumber ?? 'unknown',
      headLine: '',
      description: '',
      exam: _selectedExam ?? 'unknown',
      fileType: fileType,
      file: filePath,
      updatedOn: formattedDate,
    );

    await updateExamTimeTable(
        examTimeTable, selectedFile, context, widget.fetchmainexam);
  }
}
