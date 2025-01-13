import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Message_models/GradeModels.dart';
import 'package:flutter_application_1/models/circular_models/Edit_circular_models.dart';
import 'package:flutter_application_1/models/circular_models/update_Circular_model.dart';
import 'package:flutter_application_1/services/Circular_Api/Edit_circular_Api.dart';
import 'package:flutter_application_1/services/Circular_Api/Update_circular_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Grade_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class EditCircularpage extends StatefulWidget {
  final int Id;
  final Function fetchcircular;
  const EditCircularpage(
      {super.key, required this.Id, required this.fetchcircular});

  @override
  State<EditCircularpage> createState() => _EditCircularpageState();
}

class _EditCircularpageState extends State<EditCircularpage> {
  bool isLoading = true;
  List<String> dropdownItems = ['Everyone', 'Students', 'Teachers'];
  String? selectedRecipient;
  List<int> selectedGrades = [];
  TextEditingController _heading = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _scheduledDateandtime = TextEditingController();

  TextEditingController _linkController = TextEditingController();

  bool isuploadimage = true;
  bool isaddLink = false;

  // Define the selectedFile variable

  String? initialFilePath;
  String? initialFileType;
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
  ///
  bool isFetchedImageVisible = true;

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
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              selectedRecipient.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //class
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              selected.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
//heading...
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              _heading.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //description...
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                _desc.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //fetched image..
                      if (isFetchedImageVisible && image.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      //image..
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
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              _scheduledDateandtime.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
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
    fetchEditCircular();
    fetchGrades();
    _editcircular = fetchCircularById(widget.Id).then((data) {
      setState(() {
        editCircularData = data;
        if (editCircularData?.gradeIds != null) {
          selected = grades
              .where((grade) => editCircularData!.gradeIds.contains(grade.id))
              .map((grade) => grade.sign)
              .toList();

          String? initialFilePath;
          String? initialFileType;
          PlatformFile? selectedFile;
        }
      });
      return data;
    });
  }

  ///edit circular..

  void fetchEditCircular() async {
    try {
      final data = await fetchCircularById(widget.Id);

      if (data != null) {
        List<GradeGet> fetchedGrades = await fetchGrades();

        setState(() {
          isLoading = false;
          _heading.text = data.headLine;
          _desc.text = data.circular;
          selectedRecipient = data.recipient;
          selectedGrades = List<int>.from(data.gradeIds);
          grades = fetchedGrades;

          gradeNames = selectedGrades.map((gradeId) {
            var grade = grades.firstWhere(
              (g) => g.id == gradeId,
            );
            return grade != null ? grade.sign : 'Unknown';
          }).toList();

          selected = gradeNames;

          initialFilePath = data.filePath;
          initialFileType = data.fileType;
        });
      } else {
        setState(() {
          print('Error fetching message details');
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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

  // Date format
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  final DateFormat _timeFormat = DateFormat("HH:mm");

  String _dateTime = "";

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

  late Future<EditCircularModels?> _editcircular;

  EditCircularModels? editCircularData;

  List<String> gradeNames = [];
  List<String> selected = [];

  List<GradeGet> grades = [];

  void _showMenu(BuildContext context) {
    showMenu<String>(
      color: Colors.black,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      position: RelativeRect.fromLTRB(1, 270, 0, 0),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter menuSetState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      menuSetState(() {
                        if (selected.length == grades.length) {
                          selected.clear();
                        } else {
                          selected = grades.map((grade) => grade.sign).toList();
                        }
                      });
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        color: Colors.black,
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Row(
                          children: [
                            Checkbox(
                              value: selected.length == grades.length,
                              onChanged: (bool? value) {
                                menuSetState(() {
                                  if (value == true) {
                                    selected = grades
                                        .map((grade) => grade.sign)
                                        .toList();
                                  } else {
                                    selected.clear();
                                  }
                                });
                                setState(() {});
                              },
                              checkColor: Colors.black,
                              activeColor: Colors.white,
                            ),
                            Text(
                              "Everyone",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: grades.map((GradeGet grade) {
                          return Container(
                            color: Colors.black,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selected.contains(grade.sign),
                                  onChanged: (bool? value) {
                                    menuSetState(() {
                                      if (value == true) {
                                        selected.add(grade.sign);
                                      } else {
                                        selected.remove(grade.sign);
                                      }
                                    });
                                    setState(() {});
                                  },
                                  checkColor: Colors.black,
                                  activeColor: Colors.white,
                                ),
                                Text(
                                  grade.sign,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
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
                        widget.fetchcircular();
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
                        'Edit Circular',
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select Recipient',
                          style: TextStyle(
                              fontFamily: 'medium',
                              fontSize: 14,
                              color: Color.fromRGBO(38, 38, 38, 1)),
                        ),

                        //dropdown field.......
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                              value: selectedRecipient,
                              decoration: InputDecoration(
                                hintText: 'Select',
                                hintStyle: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 16,
                                    color: Colors.black),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 203, 203, 1),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 203, 203, 1),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              dropdownColor: Colors.black,
                              items: dropdownItems.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'regular'),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRecipient = newValue;
                                  if (newValue != 'Students') {
                                    selectedGrades.clear();
                                  }
                                });
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return dropdownItems.map((className) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        className,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'regular'),
                                      ),
                                    ),
                                  );
                                }).toList();
                              }),
                        )
                      ],
                    ),
                  ),
                  if (selectedRecipient == 'Students')
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
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
                            child: GestureDetector(
                              onTap: () {
                                _showMenu(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromRGBO(203, 203, 203, 1),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selected.isEmpty
                                            ? 'Select class'
                                            : selected.join(', '),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: 'regular',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  //heading...
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 45),
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

                  ///add description
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
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

                  //description field..
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
                        maxLines: 6,
                        controller: _desc,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(600)
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

                  ///upload sections....

                  if (isuploadimage)
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

                  ///fetched image show
                  if (selectedFile == null)
                    if (initialFilePath != null)
                      if (initialFileType == 'image')
                        Image.network(
                          initialFilePath!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        )
                      else if (initialFileType == 'pdf')
                        Icon(
                          Icons.picture_as_pdf,
                          size: 100,
                          color: Colors.red,
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

                  //schedule post...
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
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
                    padding: const EdgeInsets.only(left: 20, top: 20),
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
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: _scheduledDateandtime,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
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

                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///preview
                        GestureDetector(
                          onTap: () {
                            _PreviewBottomsheet(context, initialFilePath ?? '');
                          },
                          child: Text(
                            'Preview',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),

                        ///scheduled
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.textFieldborderColor,
                              side: BorderSide.none),
                          onPressed: () {
                            String status = _scheduledDateandtime.text.isEmpty
                                ? 'post'
                                : 'schedule';
                            _updateCircular(status, context);
                          },
                          child: Text(
                            _scheduledDateandtime.text.isEmpty
                                ? 'Update'
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
                ],
              ),
            ),
    );
  }

//update circular.......
  void _updateCircular(String status, BuildContext context) async {
    List<int> selectedGradeIds = selected
        .map((selectedGradeName) {
          final grade = grades.firstWhere(
            (grade) => grade.sign == selectedGradeName,
          );
          return grade != null ? grade.id : null;
        })
        .where((id) => id != null)
        .cast<int>()
        .toList();

    String gradeIdsString = selectedGradeIds.join(',');

    String postedOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    String updateOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    String? fileType;
    String? filePath;

    if (selectedFile != null) {
      fileType = 'image';
      filePath = selectedFile!.extension!;
    } else if (_linkController.text.isNotEmpty) {
      // If a link is entered
      fileType = 'link';
      filePath = _linkController.text;
    } else {
      fileType = 'existing';
      filePath = '';
    }

    CircularUpdateRequest update = CircularUpdateRequest(
        id: widget.Id,
        rollNumber: UserSession().userType ?? '',
        userType: UserSession().rollNumber ?? '',
        headLine: _heading.text,
        circular: _desc.text,
        fileType: fileType,
        link: _linkController.text,
        status: status,
        postedOn: postedOn,
        scheduleOn: _scheduledDateandtime.text,
        updatedOn: updateOn,
        recipient: selectedRecipient.toString(),
        gradeIds: gradeIdsString);

    // Debugging: Print all request details
    print("Request Payload:");
    print("ID: ${update.id}");
    print("Roll Number: ${update.rollNumber}");
    print("User Type: ${update.userType}");
    print("Headline: ${update.headLine}");
    print("Circular: ${update.circular}");
    print("File Type: ${update.fileType}");
    print("File Path: ${update.link}");
    print("Status: ${update.status}");
    print("Posted On: ${update.postedOn}");
    print("Schedule On: ${update.scheduleOn}");
    print("Updated On: ${update.updatedOn}");
    print("Recipient: ${update.recipient}");
    print("Grade IDs: ${update.gradeIds}");

    await updateCircular(update, context);
  }
}
