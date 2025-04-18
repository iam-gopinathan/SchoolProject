import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Homework_models/create_homeworks_model.dart';
import 'package:flutter_application_1/services/Homeworks_Api/create_homeworks_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';

class CreateHomeworks extends StatefulWidget {
  final Function fetchHomework;
  const CreateHomeworks({super.key, required this.fetchHomework});

  @override
  State<CreateHomeworks> createState() => _CreateHomeworksState();
}

class _CreateHomeworksState extends State<CreateHomeworks> {
  // Get the GradeController
  final GradeController gradeController = Get.put(GradeController());
  String? selectedGrade;
  String? selectedSection;
  String? selectedClasses;

  String? selectedGradeId;

  List<String> sections = [];

  String status = "";
  String draftedOn = "";
  String postedOn = "";

  @override
  void initState() {
    super.initState();
    gradeController.fetchGrades();
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

  TextEditingController _scheduledDateandtime = TextEditingController();
  String _dateTime = "";

  // Date format
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  final DateFormat _timeFormat = DateFormat("HH:mm");

  // Method to show date picker
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: now,
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
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.black,
                dialBackgroundColor: Colors.grey[900],
                hourMinuteColor: Colors.white10,
                hourMinuteTextColor: Colors.white,
                entryModeIconColor: Colors.white,
                dayPeriodColor: AppTheme.textFieldborderColor,
                dayPeriodTextColor: Colors.white,
              ),
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

  // Method to show time picker
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
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

    if (pickedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime parsedTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      //
      // // Check if the selected time is in the past
      if (parsedTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select Future Time!"),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _dateTime = '';
        });

        return;
      }

      setState(() {
        _dateTime += " ${_timeFormat.format(parsedTime)}";
      });
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
            return Stack(
              clipBehavior: Clip.none,
              children: [
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
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
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
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              //
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    if (selectedGradeId != null &&
                                        selectedGradeId!.isNotEmpty)
                                      Text(
                                        selectedGradeId != null
                                            ? gradeController.gradeList
                                                .firstWhere(
                                                  (grade) =>
                                                      grade['id'].toString() ==
                                                      selectedGradeId,
                                                  orElse: () => {'sign': 'N/A'},
                                                )['sign']
                                                .toString()
                                            : "",
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                  ],
                                ),
                              ),
                              //selected section..
                              if (selectedSection != null &&
                                  selectedSection!.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedSection.toString(),
                                        style: TextStyle(
                                            fontFamily: 'medium',
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
                              ),
                              //
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        _scheduledDateandtime.text,
                                        style: TextStyle(
                                            fontFamily: 'medium',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
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
            );
          },
        );
      },
    );
  }

  //
  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return selectedGrade != initialHeading;
  }

  // Function to show the unsaved changes dialog
  Future<void> _showUnsavedChangesDialog() async {
    bool discard = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        Navigator.pop(context);
                        widget.fetchHomework();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Create Homework',
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
                            enabledBorder: OutlineInputBorder(
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
                          hint: Text(
                            "Select Class",
                            style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedGradeId = value;

                              final selectedGradeData =
                                  gradeController.gradeList.firstWhere(
                                (grade) => grade['id'].toString() == value,
                                orElse: () => null,
                              );

                              if (selectedGradeData != null) {
                                sections = List<String>.from(
                                    selectedGradeData['sections'] ?? []);
                              } else {
                                sections = [];
                              }
                              selectedSection = null;
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
                                  fontSize: 14,
                                ),
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
                  )
                ],
              ),
            ),

            //select sections...
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.0125),
                      child: Text(
                        'Select Section',
                        style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 14,
                            color: Color.fromRGBO(38, 38, 38, 1)),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-3, 0),
                      child: Container(
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
                            enabledBorder: OutlineInputBorder(
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
                    ),
                  ],
                )),
//upload image...
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                MediaQuery.of(context).size.width * 0.05, // 4% of screen width
              ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Click Here to',
                                    style: TextStyle(
                                        fontSize: 12,
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
              ],
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

            //scheduled post...
            //schedule post...
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width *
                    0.08, // 5% of screen width
                top: MediaQuery.of(context).size.height *
                    0.04, // 3% of screen height
              ),
              child: Row(
                children: [
                  Text(
                    'Schedule Post',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 14,
                        color: Color.fromRGBO(38, 38, 38, 1)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.width *
                    0.03, // 3% of screen width
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.87,
                    child: TextFormField(
                      controller: _scheduledDateandtime,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height *
                                0.015, // 1.5% of screen height
                            bottom: MediaQuery.of(context).size.height *
                                0.015, // 1.5% of screen height
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/NewsPage_timepicker.svg',
                            fit: BoxFit.contain,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        hintText: 'Tap to select date and time',
                        hintStyle: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 14,
                            color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(203, 203, 203, 1),
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(203, 203, 203, 1),
                                width: 1)),
                      ),
                      onTap: () async {
                        await _pickDate();
                        await _pickTime();
                        _scheduledDateandtime.text = _dateTime;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: //save as draft..
            Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.symmetric(horizontal: 15),
              //       backgroundColor: Colors.white,
              //       side: BorderSide(color: Colors.black, width: 1.5)),
              //   onPressed: () {
              //     String status = "draft";
              //     submitHomework(status);
              //   },
              //   child: Text(
              //     'Save as Draft',
              //     style: TextStyle(
              //         fontSize: 16, fontFamily: 'medium', color: Colors.black),
              //   ),
              // ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(horizontal: 15),
              //     backgroundColor: Colors.white,
              //     side: BorderSide(color: Colors.black, width: 1.5),
              //   ),
              //   onPressed: isdraft
              //       ? null // Disable button when loading
              //       : () {
              //           String status = "draft";
              //           submitHomework(status);
              //         },
              //   child: isdraft
              //       ? SizedBox(
              //           width: 24,
              //           height: 24,
              //           child: CircularProgressIndicator(
              //               color: AppTheme.textFieldborderColor,
              //               strokeWidth: 4),
              //         )
              //       : Text(
              //           'Save as Draft',
              //           style: TextStyle(
              //               fontSize: 16,
              //               fontFamily: 'medium',
              //               color: Colors.black),
              //         ),
              // ),
              //preview..
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

              ///scheduled..
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: AppTheme.textFieldborderColor,
              //       side: BorderSide.none),
              //   onPressed: () {
              //     String status =
              //         _scheduledDateandtime.text.isEmpty ? 'post' : 'schedule';

              //     submitHomework(status);
              //   },
              //   child: Text(
              //     _scheduledDateandtime.text.isEmpty ? 'Publish' : 'Schedule',
              //     style: TextStyle(
              //         fontSize: 16, fontFamily: 'medium', color: Colors.black),
              //   ),
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textFieldborderColor,
                  side: BorderSide.none,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        String status = _scheduledDateandtime.text.isEmpty
                            ? 'post'
                            : 'schedule';
                        submitHomework(status);
                      },
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppTheme.appBackgroundPrimaryColor,
                          strokeWidth: 4,
                        ),
                      )
                    : Text(
                        _scheduledDateandtime.text.isEmpty
                            ? 'Publish'
                            : 'Schedule',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'medium',
                            color: Colors.black),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  bool isdraft = false;

//create homework...
  void submitHomework(String status) async {
    setState(() {
      if (status == 'draft') {
        isdraft = true; // ✅ Show loader for draft button
        isLoading = false;
      } else {
        isLoading = true; // ✅ Show loader for publish button
        isdraft = false;
      }
    });

    // Check if grade, section, or image is empty
    if (selectedGradeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a grade!'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
        isdraft = false;
      });
      return;
    }

    if (selectedSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a section!'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
        isdraft = false;
      });
      return;
    }

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image !'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
        isdraft = false;
      });
      return;
    }
    String currentDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    String postedOn = status == "post" ? currentDateTime : "";
    String draftedOn = status == "draft" ? currentDateTime : "";

    CreateHomeworkModel homework = CreateHomeworkModel(
      gradeId: selectedGradeId!,
      section: selectedSection!,
      userType: UserSession().userType.toString(),
      rollNumber: UserSession().rollNumber.toString(),
      fileType: "image",
      file: selectedFile!.extension ?? "image",
      status: status,
      postedOn: postedOn,
      draftedOn: draftedOn,
      scheduleOn: _scheduledDateandtime.text,
    );
    await postHomework(homework, selectedFile!, context, widget.fetchHomework);
  }
}
