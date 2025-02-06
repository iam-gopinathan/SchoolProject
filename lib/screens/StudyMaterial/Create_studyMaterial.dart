import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/StudyMaterial/Create_StudyMaterial_model.dart';
import 'package:flutter_application_1/services/StudyMaterial/Create_studymaterial_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateStudymaterial extends StatefulWidget {
  final Function fetchstudymaterial;
  const CreateStudymaterial({super.key, required this.fetchstudymaterial});

  @override
  State<CreateStudymaterial> createState() => _CreateStudymaterialState();
}

class _CreateStudymaterialState extends State<CreateStudymaterial> {
  TextEditingController _heading = TextEditingController();

  final GradeController gradeController = Get.put(GradeController());

  String selectedGradeName = '';

  String? selectedGrade;
  String? selectedSection;
  String? selectedClasses;

  String? selectedSubject;

  String? selectedGradeId;
  List<String> sections = [];
  List<String> subjects = [];

  String _dateTime = "";

  @override
  void initState() {
    super.initState();
    gradeController.fetchGrades();
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
                              "${selectedGradeName}",
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
  //

  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return selectedClasses != initialHeading;
  }

  // Function to show the unsaved changes dialog
  Future<void> _showUnsavedChangesDialog() async {
    bool discard = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Unsaved Changes !",
                style: TextStyle(
                  fontFamily: 'semibold',
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              content: Text(
                "You have unsaved changes. Are you sure you want to discard them?",
                style: TextStyle(
                    fontFamily: 'medium', fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Discard",
                    style: TextStyle(
                        fontFamily: 'semibold',
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (hasUnsavedChanges()) {
                          await _showUnsavedChangesDialog();
                        }
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
                        'Create Study Material',
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
      body: SingleChildScrollView(
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

                  //dropdown field.......
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Obx(
                      () {
                        if (gradeController.gradeList.isEmpty) {
                          return Center(child: CircularProgressIndicator());
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
                          dropdownColor: Colors.black,
                          menuMaxHeight: 150,
                          value: selectedGradeId,
                          hint: Text("Select Class"),
                          onChanged: (String? value) {
                            setState(() {
                              selectedGradeId = value;

                              final selectedGrade =
                                  gradeController.gradeList.firstWhere(
                                (grade) => grade['id'].toString() == value,
                                orElse: () => null,
                              );

                              if (selectedGrade != null) {
                                // When selectedGrade is found, set the name properly
                                selectedGradeName =
                                    selectedGrade['sign'].toString();
                                sections = List<String>.from(
                                    selectedGrade['sections'] ?? []);
                                subjects = List<String>.from(
                                    selectedGrade['subjects'] ?? []);
                              } else {
                                sections = [];
                                subjects = [];
                              }
                              selectedSection = null;
                              selectedSubject = null;
                            });
                          },
                          items: gradeController.gradeList.map((grade) {
                            return DropdownMenuItem<String>(
                              value: grade['id'].toString(),
                              child: Text(
                                grade['sign'].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'regular',
                                    fontSize: 14),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return gradeController.gradeList.map((grade) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  grade['sign'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                  ),
                                ),
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

            //select sections...
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
                )),

            //select subject
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

                  //dropdown field.......
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 150,
                      dropdownColor: Colors.black,
                      value: selectedSubject,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
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
                      color: Colors.black, fontFamily: 'medium', fontSize: 14),
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
                    },
                    child: Container(
                      color: Color.fromRGBO(228, 238, 253, 1).withOpacity(0.9),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Click Here to',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'medium',
                                        color: Color.fromRGBO(93, 93, 93, 1)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
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
                                        color: Color.fromRGBO(0, 102, 255, 1)),
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

            ///display selected image...

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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black, width: 1.5)),
                    onPressed: () {
                      String status = 'draft';
                      _createstudymaterial(status);
                    },
                    child: Text(
                      'Save as Draft',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'medium',
                          color: Colors.black),
                    ),
                  ),
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
                      String status = 'post';
                      _createstudymaterial(status);
                    },
                    child: Text(
                      'Publish',
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

  //create studymaterial function..
  void _createstudymaterial(String status) {
    String currentDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    String postedOn = status == "post" ? currentDateTime : "";
    String draftedOn = status == "draft" ? currentDateTime : "";

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

    CreateStudymaterialModel create = CreateStudymaterialModel(
        gradeId: selectedGradeId!,
        section: selectedSection!,
        userType: UserSession().userType.toString(),
        rollNumber: UserSession().rollNumber.toString(),
        subject: selectedSubject!,
        heading: _heading.text,
        fileType: fileType,
        filePath: filePath,
        status: status,
        postedOn: postedOn,
        draftedOn: draftedOn);
    postStudyMaterial(create, context, widget.fetchstudymaterial);
  }
}
