import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/StudyMaterial/Edit_studyMaterial_model.dart';
import 'package:flutter_application_1/models/StudyMaterial/Update_studymaterial_model.dart';
import 'package:flutter_application_1/services/StudyMaterial/Edit_studymaterial_api.dart';
import 'package:flutter_application_1/services/StudyMaterial/Update_studymaterial_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditStudymaterialpage extends StatefulWidget {
  final int id;
  final Function fetchstudymaterial;
  const EditStudymaterialpage(
      {super.key, required this.id, required this.fetchstudymaterial});

  @override
  State<EditStudymaterialpage> createState() => _EditStudymaterialpageState();
}

class _EditStudymaterialpageState extends State<EditStudymaterialpage> {
  TextEditingController _heading = TextEditingController();

  final GradeController _gradeController = Get.put(GradeController());
  List<Map<String, dynamic>> gradeList = [];

  bool isLoading = true;
  var studyMaterialData;

  String? selectedGradeId;
  String? selectedSection;
  String? selectedSubject;
  List<String> sections = [];
  List<String> subjects = [];
  String? selectedClasses;

  @override
  void initState() {
    super.initState();
    _gradeController.fetchGrades();
    EditStudyMaterialData();
  }

  String? imageUrl;
//edit
  Future<void> EditStudyMaterialData() async {
    try {
      final data = await fetchEditStudyMaterial(widget.id);
      print("Fetched Study Material Data: $data");

      setState(() {
        studyMaterialData = data;
        isLoading = false;

        _heading.text = studyMaterialData?.heading ?? '';

        gradeList = List<Map<String, dynamic>>.from(_gradeController.gradeList);

        selectedGradeId = studyMaterialData?.gradeId.toString();

        final selectedGrade = gradeList.firstWhere(
          (grade) => grade['id'].toString() == selectedGradeId,
          orElse: () => {'sign': null, 'sections': [], 'subjects': []},
        );

        selectedClasses = selectedGrade['sign'];
        sections = List<String>.from(selectedGrade['sections'] ?? []);
        subjects = List<String>.from(selectedGrade['subjects'] ?? []);

        selectedSection = studyMaterialData?.section;
        selectedSubject = studyMaterialData?.subject;

        // Store the image URL if available in the fetched data
        imageUrl = studyMaterialData?.filepath;
        print("Fetched Image URL: $imageUrl");
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Date format
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  final DateFormat _timeFormat = DateFormat("HH:mm");

  // Method to show date picker
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
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
        _dateTime = _dateFormat.format(pickedDate);
      });
    }
  }

  String _dateTime = "";

  // Define the selectedFile variable
  PlatformFile? selectedFile;
  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpeg', 'webp', 'pdf', 'png'],
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
  void _PreviewBottomsheet(BuildContext context) {
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
                          thickness: 2,
                          color: Color.fromRGBO(243, 243, 243, 1),
                        ),
                      ),
//heading...
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${selectedClasses}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                      //selected section..
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${selectedSection}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //subject..
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${selectedSubject}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //heading
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${_heading.text}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.fetchstudymaterial();
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
                        'Edit Study Material',
                        style: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    )
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
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Select Class
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Obx(
                            () {
                              if (_gradeController.gradeList.isEmpty) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
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
                                ),
                                value: selectedGradeId,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedGradeId = value;

                                    final selectedGrade =
                                        _gradeController.gradeList.firstWhere(
                                      (grade) =>
                                          grade['id'].toString() == value,
                                      orElse: () =>
                                          {'sections': [], 'subjects': []},
                                    );

                                    sections = List<String>.from(
                                        selectedGrade['sections'] ?? []);
                                    subjects = List<String>.from(
                                        selectedGrade['subjects'] ?? []);
                                    selectedSection = null;
                                    selectedSubject = null;
                                  });
                                },
                                items: _gradeController.gradeList.map((grade) {
                                  return DropdownMenuItem<String>(
                                    value: grade['id'].toString(),
                                    child: Text(grade['sign'].toString()),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

// Select Section
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Section',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.black,
                            menuMaxHeight: 150,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
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
                            ),
                            value: selectedSection,
                            hint: Text(
                              "Select Section",
                              style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                selectedSection = value;
                              });
                            },
                            items: sections.map((String section) {
                              return DropdownMenuItem<String>(
                                value: section,
                                child: Text(
                                  section,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return sections.map((String section) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    section,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'regular',
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //subject..

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Subject',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Obx(
                            () {
                              if (_gradeController.gradeList.isEmpty) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return DropdownButtonFormField<String>(
                                menuMaxHeight: 150,
                                dropdownColor: Colors.black,
                                value: selectedSubject,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
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
                                ),
                                hint: Text("Select Subject"),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedSubject = value;
                                  });
                                },
                                items: subjects.map((subject) {
                                  return DropdownMenuItem<String>(
                                    value: subject,
                                    child: Text(
                                      subject,
                                      style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                selectedItemBuilder: (BuildContext context) {
                                  return subjects.map((String subject) {
                                    return Text(
                                      subject,
                                      style: TextStyle(color: Colors.black),
                                    );
                                  }).toList();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  //add heading
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 45),
                    child: Row(
                      children: [
                        Text(
                          'Add Heading',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _heading,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100)
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'medium',
                            fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text(
                          '*Max 100 Characters',
                          style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 12,
                              color: Color.fromRGBO(127, 127, 127, 1)),
                        )
                      ],
                    ),
                  ),

                  // Upload Image
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
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
                        ),
                      ],
                    ),
                  ),

                  ///upload section
                  Padding(
                    padding: const EdgeInsets.all(15.0),
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

                  //fetched image show..

                  if (isFetchedImageVisible &&
                      imageUrl != null &&
                      imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Image.network(
                        imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      (progress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'Failed to load image.',
                            style: TextStyle(color: Colors.red),
                          );
                        },
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
                                  isFetchedImageVisible = true;
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Supported Format : JPEG,Webp PNG, PDF',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 9,
                            color: Color.fromRGBO(168, 168, 168, 1)),
                      ),
                      Text(
                        '*Upload either an image or a link',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 9,
                            color: Color.fromRGBO(168, 168, 168, 1)),
                      ),
                    ],
                  ),

                  //save as draft
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //preview
                        GestureDetector(
                          onTap: () {
                            _PreviewBottomsheet(context);
                          },
                          child: Text(
                            'Preview',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),

                        ///
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.textFieldborderColor,
                              side: BorderSide.none),
                          onPressed: () {
                            _updatestudymaterial();
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'medium',
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  //update
  void _updatestudymaterial() {
    File file = File(selectedFile!.path!);
    String fileType = "";
    String filePath = "";

    if (selectedFile != null) {
      if (selectedFile!.extension == 'pdf') {
        fileType = 'pdf';
        filePath = selectedFile!.path ?? '';
      } else if (['jpeg', 'webp', 'png', 'jpg']
          .contains(selectedFile!.extension)) {
        fileType = 'image';
        filePath = selectedFile!.path ?? '';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unsupported file type selected.')),
        );
        return;
      }
    }
    String currentDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    UpdateStudymaterialModel updatestudy = UpdateStudymaterialModel(
        id: widget.id,
        userType: UserSession().userType.toString(),
        rollNumber: UserSession().rollNumber.toString(),
        subject: selectedSubject.toString(),
        heading: _heading.text,
        fileType: fileType,
        file: filePath,
        updatedOn: currentDateTime);

    updateStudyMaterial(updatestudy, file, context);
  }
}
