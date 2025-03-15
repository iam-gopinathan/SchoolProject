import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Homework_models/EditHomework_model.dart';
import 'package:flutter_application_1/models/Homework_models/Update_homework_model.dart';
import 'package:flutter_application_1/services/Homeworks_Api/Edit_homework_Api.dart';
import 'package:flutter_application_1/services/Homeworks_Api/Update_homeworks_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditHomework extends StatefulWidget {
  final int id;
  final Function fetchHomework;
  const EditHomework(
      {super.key, required this.id, required this.fetchHomework});

  @override
  State<EditHomework> createState() => _EditHomeworkState();
}

class _EditHomeworkState extends State<EditHomework> {
  EdithomeworkModel? homeWorkData;

  String? _selectedClass;
  String? _selectedSection;

  bool isLoading = true;

  final GradeController _gradeController = Get.put(GradeController());

  List<Map<String, dynamic>> gradeList = [];

  List<String> sectionList = [];

  var statusss;

  Future<void> EditTimetableData() async {
    try {
      final data = await fetchHomework(widget.id);
      print("Fetched Timetable Data: $data");

      setState(() {
        homeWorkData = data;
        isLoading = false;
        gradeList = List<Map<String, dynamic>>.from(_gradeController.gradeList);
        final selectedGrade = gradeList.firstWhere(
          (grade) => grade['id'] == homeWorkData?.gradeId,
          orElse: () => {'sign': null, 'sections': []},
        );
        _selectedClass = selectedGrade['sign'];
        sectionList = List<String>.from(
            homeWorkData?.section != null ? [homeWorkData?.section] : []);
        _selectedSection = homeWorkData?.section;

        statusss = data.status;

        if (data.scheduleOn != null && data.scheduleOn!.isNotEmpty) {
          try {
            // Convert API date to desired format
            DateTime parsedDate = DateTime.parse(data.scheduleOn!);
            _scheduledDateandtime.text =
                DateFormat("dd-MM-yyyy HH:mm").format(parsedDate);
          } catch (e) {
            print("Error parsing date: $e");
            _scheduledDateandtime.text = data.scheduleOn!;
          }
        } else {
          _scheduledDateandtime.text = '';
        }
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
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

      setState(() {
        _dateTime += " ${_timeFormat.format(parsedTime)}";
      });
    }
  }

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
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${_selectedClass}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            ////selected section..
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${_selectedSection}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            //fetchedimage...
                            if (image.isNotEmpty)
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
                    ),
                  ],
                ),
              )
            ]);
          });
        });
  }

  bool isFetchedImageVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EditTimetableData();
    _gradeController.fetchGrades();
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
                      onTap: () {
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
                        'Edit Homework',
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
                        // class dropdown code..
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                            hint: Text(
                              'Select class',
                              style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
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
                            value: _selectedClass,
                            items: gradeList.map((grade) {
                              return DropdownMenuItem<String>(
                                value: grade['sign'],
                                child: Text(grade['sign']),
                              );
                            }).toList(),
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //select sections.....
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
                        // Section dropdown code
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                            hint: Text(
                              'Select Section',
                              style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            decoration: InputDecoration(
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _selectedSection,
                            items: sectionList.map((section) {
                              return DropdownMenuItem<String>(
                                value: section,
                                child: Text(section),
                              );
                            }).toList(),
                            onChanged: null,
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
                            'Re-Upload Image',
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
                      MediaQuery.of(context).size.width *
                          0.05, // 4% of screen width
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
                            isFetchedImageVisible = false;
                            homeWorkData?.filePath = '';
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
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Click Here to',
                                          style: TextStyle(
                                              fontSize: 12,
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
                      // Text(
                      //   '*Upload either an image or a link',
                      //   style: TextStyle(
                      //       fontFamily: 'regular',
                      //       fontSize: 9,
                      //       color: Color.fromRGBO(168, 168, 168, 1)),
                      // ),
                    ],
                  ),
                  //fetchedimage...
                  if (isFetchedImageVisible && homeWorkData?.filePath != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.network(
                        homeWorkData!.filePath!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        height: 150,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                              color: AppTheme.textFieldborderColor,
                              strokeWidth: 4,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              "",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
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
                  //schedule post...
                  if (statusss == 'schedule')
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width *
                            0.08, // 5% of screen width
                        top: MediaQuery.of(context).size.height *
                            0.03, // 3% of screen height
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Re-Schedule Post',
                            style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 14,
                                color: Color.fromRGBO(38, 38, 38, 1)),
                          ),
                        ],
                      ),
                    ),
                  //
                  if (statusss == 'schedule')
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //preview
              GestureDetector(
                onTap: () {
                  _PreviewBottomsheet(
                    context,
                    homeWorkData!.filePath!,
                  );
                },
                child: Text(
                  'Preview',
                  style: TextStyle(
                      fontFamily: 'semibold',
                      fontSize: 16,
                      color: Colors.black),
                ),
              ),

              ///publish
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: AppTheme.textFieldborderColor,
              //       side: BorderSide.none),
              //   onPressed: () {
              //     final String status =
              //         _scheduledDateandtime.text.isEmpty ? 'post' : 'schedule';

              //     updateHomeworkExample(status);
              //   },
              //   child: Text(
              //     _scheduledDateandtime.text.isEmpty ? 'Update' : 'Schedule',
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
                    ? null // Disable button while loading
                    : () async {
                        setState(() {
                          _isLoading = true; // Start loading
                        });

                        final String status = _scheduledDateandtime.text.isEmpty
                            ? 'post'
                            : 'schedule';

                        await updateHomeworkExample(
                            status); // Wait for the update to complete

                        setState(() {
                          _isLoading = false; // Stop loading after completion
                        });
                      },
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: AppTheme.appBackgroundPrimaryColor,
                        ),
                      )
                    : Text(
                        _scheduledDateandtime.text.isEmpty
                            ? 'Update'
                            : 'Schedule',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'medium',
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;

  Future<void> updateHomeworkExample(String status) async {
    String currentDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    String? postedOn = status == 'post' ? currentDateTime : '';

    // String? scheduleOn = status == 'schedule' ? _scheduledDateandtime.text : '';

    String? scheduleOn;
    if (status == 'schedule' && _scheduledDateandtime.text.isNotEmpty) {
      try {
        // Parse the input from "dd-MM-yyyy h:mm a" (12-hour format) if needed
        DateTime selectedDate =
            DateFormat("dd-MM-yyyy h:mm a").parse(_scheduledDateandtime.text);

        // Convert it to "dd-MM-yyyy HH:mm" (24-hour format)
        scheduleOn = DateFormat("dd-MM-yyyy HH:mm").format(selectedDate);
      } catch (e) {
        print("Error formatting scheduleOn date: $e");
        scheduleOn = _scheduledDateandtime.text; // Send as is if error occurs
      }
    } else {
      scheduleOn = '';
    }

// Print to verify the output
    print("Formatted scheduleOn: $scheduleOn");

    // Determine file type and file to send
    String fileType = '';
    File? file;
    if (selectedFile != null) {
      fileType = 'image';
      file = File(selectedFile!.path!);
      homeWorkData?.filePath = '';
    } else if (homeWorkData?.filePath != null &&
        homeWorkData!.filePath!.isNotEmpty) {
      fileType = 'existing';
      file = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an image."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (homeWorkData?.filePath != null && homeWorkData!.filePath!.isNotEmpty) {
      fileType = 'existing';
      file = null;
    } else if (selectedFile != null) {
      fileType = 'image';
      file = File(selectedFile!.path!);
    }
    var request = UpdateHomeworkRequest(
      id: widget.id,
      userType: UserSession().userType.toString(),
      rollNumber: UserSession().rollNumber.toString(),
      fileType: fileType,
      file: file,
      status: status,
      updatedOn: currentDateTime,
      postedOn: postedOn,
      scheduleOn: scheduleOn,
    );
    await updateHomework(request, context, widget.fetchHomework);
  }
}
