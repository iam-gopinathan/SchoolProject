import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/School_calendar_model/Edit_school_calendar_model.dart';
import 'package:flutter_application_1/models/School_calendar_model/Update_school_calender_model.dart';
import 'package:flutter_application_1/services/school_Calendar_Api/Edit_school_calender_Api.dart';
import 'package:flutter_application_1/services/school_Calendar_Api/Update_school_calender_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';

class EditSchoolCalender extends StatefulWidget {
  final int Id;
  final Function fetchStudentCalendar;
  const EditSchoolCalender(
      {super.key, required this.Id, required this.fetchStudentCalendar});

  @override
  State<EditSchoolCalender> createState() => _EditSchoolCalenderState();
}

class _EditSchoolCalenderState extends State<EditSchoolCalender> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEdit();
  }

  EditSchoolCalendarModel? _schoolCalendar;
  bool _isLoading = true;

  String? image;

  ///fetch
  void fetchEdit() async {
    var Id = widget.Id;
    try {
      _isLoading = true;
      EditSchoolCalendarModel calender = await EditfetchSchoolCalendar(Id);
      setState(() {
        _schoolCalendar = calender;
        _isLoading = false;
        _startdate.text = _schoolCalendar?.fromDate ?? '';
        _enddate.text = _schoolCalendar?.toDate ?? '';
        _heading.text = _schoolCalendar?.headLine ?? '';
        _desc.text = _schoolCalendar?.description ?? '';
        image = _schoolCalendar?.filepath ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  bool isFetchedImageVisible = true;

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
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height *
                        0.04, // 3% of screen height
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Edit School Calender',
                                    style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: AppTheme.textFieldborderColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(249, 249, 249, 1)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                          top: MediaQuery.of(context).size.height * 0.02,
                        ),
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                          top: MediaQuery.of(context).size.height * 0.02,
                        ),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: TextFormField(
                                      controller: _startdate,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.calendar_month),
                                          onPressed: () =>
                                              _selectStartDate(context),
                                        ),
                                        hintText: 'Start Date',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    203, 203, 203, 1))),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    203, 203, 203, 1))),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    203, 203, 203, 1))),
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
                                        color:
                                            Color.fromRGBO(167, 167, 167, 1)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: TextFormField(
                                        enabled: !_isChecked,
                                        controller: _enddate,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.calendar_month),
                                            onPressed: () =>
                                                _selectEndDate(context),
                                          ),
                                          hintText: 'End Date',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      203, 203, 203, 1))),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      203, 203, 203, 1))),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      203, 203, 203, 1))),
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                          top: MediaQuery.of(context).size.height *
                              0.025, // 2.5% of screen height
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Edit Heading',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 14,
                                  color: Color.fromRGBO(38, 38, 38, 1)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.04),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 173, 172, 172)
                                    .withOpacity(0.2),
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                        ),
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                          top: MediaQuery.of(context).size.height *
                              0.025, // 2.5% of screen height
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Edit Description',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 14,
                                  color: Color.fromRGBO(38, 38, 38, 1)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.04),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 173, 172, 172)
                                    .withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            maxLines: 5,
                            controller: _desc,
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.05, // 5% of screen width
                        ),
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
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width *
                              0.04, // 4% of screen width
                          top: MediaQuery.of(context).size.height *
                              0.04, // 4% of screen height
                        ),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/NewsPage_file.svg',
                                          fit: BoxFit.contain,
                                          height: 40,
                                          width: 40,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
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
                                                padding: const EdgeInsets.only(
                                                    top: 2),
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
                      // fetched image
                      if (isFetchedImageVisible)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              _schoolCalendar!.filepath ?? '',
                              fit: BoxFit.cover,
                              height: 150,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                      strokeWidth: 4,
                                      color: AppTheme.textFieldborderColor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                      /// Display selected image...
                      if (isuploadimage)
                        if (selectedFile != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                                              style:
                                                  TextStyle(color: Colors.red),
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

                      /// Display Selected File end...
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
                                      fillColor:
                                          Color.fromRGBO(228, 238, 253, 1)
                                              .withOpacity(0.9),
                                      filled: true,
                                      hintText: 'Paste Link Here',
                                      hintStyle: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(0, 102, 255, 1)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                )),
                          ),
                        ),
                      if (isuploadimage)
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
                      if (isaddLink)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '*Paste a Valid  Video Link',
                                style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 9,
                                    color: Color.fromRGBO(168, 168, 168, 1)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height *
                0.05, // 5% of screen height
            bottom: MediaQuery.of(context).size.height *
                0.06, // 6% of screen height
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'semibold',
                      color: Colors.black),
                ),
              ),

              ///update
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor,
                    side: BorderSide.none),
                onPressed: () {
                  updateSchoolCalendar();
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'semibold',
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //update school calender function....

  void updateSchoolCalendar() {
    String fileType = '';
    String? filePath;
    String? link;

    if (isuploadimage && selectedFile != null) {
      fileType = 'image';
      filePath = selectedFile!.path;
    } else if (isaddLink && _linkController.text.isNotEmpty) {
      fileType = 'link';
      link = _linkController.text;
    } else if (isFetchedImageVisible && _schoolCalendar != null) {
      fileType = 'existing';
      filePath = '';
    } else {
      print("Please upload a file or provide a link.");
      return;
    }

    //updateon
    String updatedOn = DateFormat('dd-MM-yyyy').format(DateTime.now());

    UpdateSchoolCalendarModel update = UpdateSchoolCalendarModel(
        id: widget.Id,
        userType: UserSession().userType ?? '',
        rollNumber: UserSession().rollNumber ?? '',
        headLine: _heading.text,
        description: _desc.text,
        filePath: filePath.toString(),
        fileType: fileType,
        link: _linkController.text,
        updatedOn: updatedOn);

    updateSchoolCalendarApi(update, context, widget.fetchStudentCalendar);
  }
}
