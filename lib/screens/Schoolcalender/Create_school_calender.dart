import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/School_calendar_model/Create_school_calendar_model.dart';
import 'package:flutter_application_1/services/school_Calendar_Api/Create_school_calender_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CreateSchoolCalender extends StatefulWidget {
  final Function fetchStudentCalendar;
  const CreateSchoolCalender({super.key, required this.fetchStudentCalendar});

  @override
  State<CreateSchoolCalender> createState() => _CreateSchoolCalenderState();
}

class _CreateSchoolCalenderState extends State<CreateSchoolCalender> {
  TextEditingController _heading = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _startdate = TextEditingController();
  TextEditingController _enddate = TextEditingController();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
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
    if (picked != null) {
      setState(() {
        _startdate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
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
    if (picked != null) {
      setState(() {
        _enddate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  bool isuploadimage = true;
  bool isaddLink = false;
  bool _isChecked = false;

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

  //
  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return _startdate.text != initialHeading;
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
                  if (hasUnsavedChanges()) {
                    await _showUnsavedChangesDialog();
                  }
                  Navigator.pop(context);
                  widget.fetchStudentCalendar();
                },
                child: Icon(Icons.arrow_back)),
            title: Text(
              'Create School Calender',
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
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Text(
                    'Set Date',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 14,
                            color: Color.fromRGBO(167, 167, 167, 1)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            controller: _startdate,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_month),
                                onPressed: () => _selectStartDate(context),
                              ),
                              hintText: 'Start Date',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 203, 203, 1))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 203, 203, 1))),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  //end date..
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 14,
                              color: Color.fromRGBO(167, 167, 167, 1)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              enabled: !_isChecked,
                              controller: _enddate,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.calendar_month),
                                  onPressed: () => _selectEndDate(context),
                                ),
                                hintText: 'End Date',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(203, 203, 203, 1))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(203, 203, 203, 1))),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //only from...
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: AppTheme.textFieldborderColor,
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue!;
                      });
                      //
                      if (_isChecked) {
                        // Set "To Date" to match "From Date" when checkbox is checked
                        _enddate.text = _startdate.text;
                      } else {
                        // Optionally clear the "To Date" field when unchecked
                        _enddate.clear();
                      }
                    },
                  ),
                  Text(
                    'Only From',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'regular',
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
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
            //desc
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    'Add Description',
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
                  maxLines: 5,
                  controller: _desc,
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
                    '*Max 600 Characters',
                    style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 12,
                        color: Color.fromRGBO(127, 127, 127, 1)),
                  )
                ],
              ),
            ),

            // Upload Image and Add Link Section
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isuploadimage = true;
                        isaddLink = false;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isuploadimage
                              ? Color.fromRGBO(246, 246, 246, 1)
                              : Colors.transparent),
                      child: Text(
                        'Upload Image',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'medium',
                            color: Colors.black),
                      ),
                    ),
                  ),
                  // Add Link Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isuploadimage = false;
                        isaddLink = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isaddLink
                                ? Color.fromRGBO(246, 246, 246, 1)
                                : Colors.transparent),
                        child: Text(
                          'Add Link',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'medium',
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (isuploadimage)

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
                        color:
                            Color.fromRGBO(228, 238, 253, 1).withOpacity(0.9),
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
                                          color:
                                              Color.fromRGBO(0, 102, 255, 1)),
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
            if (isuploadimage)
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

            //addlink tab....
            if (isaddLink)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DottedBorder(
                  dashPattern: [8, 4],
                  borderType: BorderType.Rect,
                  color: Color.fromRGBO(0, 102, 255, 1),
                  strokeWidth: 2,
                  child: Container(
                      height: 50,
                      child: TextFormField(
                        controller: _linkController,
                        decoration: InputDecoration(
                            fillColor: Color.fromRGBO(228, 238, 253, 1)
                                .withOpacity(0.9),
                            filled: true,
                            hintText: 'Paste Link Here',
                            hintStyle: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Color.fromRGBO(0, 102, 255, 1)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      )),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.black, width: 1.5)),
                    onPressed: () {},
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'semibold',
                          color: Colors.black),
                    ),
                  ),

                  ///scheduled
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.textFieldborderColor,
                          side: BorderSide.none),
                      onPressed: () {
                        _createschoolcalender();
                      },
                      child: Text(
                        'Publish',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'semibold',
                            color: Colors.black),
                      ),
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

  //create school calendar.............
  void _createschoolcalender() {
    if (_startdate.text.isEmpty ||
        _heading.text.isEmpty ||
        _desc.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in both heading and description'),
        ),
      );
      return;
    }

    String fileType = '';
    String? filePath;
    String? link;

    if (isuploadimage && selectedFile != null) {
      fileType = 'image';
      filePath = selectedFile!.path;
    } else if (isaddLink && _linkController.text.isNotEmpty) {
      fileType = 'link';
      link = _linkController.text;
    } else {
      print("Please upload a file or provide a link.");
      return;
    }

    CreateSchoolCalendarModel create = CreateSchoolCalendarModel(
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        headLine: _heading.text,
        description: _desc.text,
        fileType: fileType,
        filePath: filePath,
        link: _linkController.text,
        fromDate: _startdate.text,
        toDate: _enddate.text);

    postSchoolCalendar(create, context, widget.fetchStudentCalendar);
  }
}
