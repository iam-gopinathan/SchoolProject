import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Message_models/CreateMessage_Models.dart';
import 'package:flutter_application_1/models/Message_models/GradeModels.dart';
import 'package:flutter_application_1/services/Message_Api/Create_message_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Grade_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class Createmessagepage extends StatefulWidget {
  final Function messageFetch;
  const Createmessagepage({super.key, required this.messageFetch});

  @override
  State<Createmessagepage> createState() => _CreatemessagepageState();
}

class _CreatemessagepageState extends State<Createmessagepage> {
  TextEditingController _heading = TextEditingController();

  TextEditingController _scheduledDateandtime = TextEditingController();

  QuillController _controller = QuillController.basic();

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

  @override
  void initState() {
    super.initState();
    _loadGrades();
    initialHeading = _heading.text;
  }

  void _loadGrades() async {
    try {
      final fetchedGrades = await fetchGrades();
      setState(() {
        grades = fetchedGrades;
      });
    } catch (error) {
      print('Error fetching grades: $error');
    }
  }

  String? selectedRecipient;
  String? selectedClass;
  bool showTextField = false;

  List<String> dropdownItems = ['Everyone', 'Students', 'Teachers'];

  List<String> selected = [];
  List<GradeGet> grades = [];

  List<int> selectedIds = [];

//show menu............
  void _showMenu(
    BuildContext context,
  ) {
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

  ///image bottomsheeet..
  void _PreviewBottomsheet(
    BuildContext context,
  ) {
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
//selected recipents...
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
                      //selected class
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              selectedClass.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //heading
                      //selected class
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
                      //description..
                      //selected class
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: htmlContent.isNotEmpty
                                ? Html(data: htmlContent)
                                : const Text(''),
                          ),
                        ],
                      ),
                      //schedulepost..
                      //selected class
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

//match grade Id...
  int? getGradeId(String sign) {
    for (var grade in grades) {
      if (grade.sign == sign) {
        return grade.id;
      }
    }
    return null;
  }

  late String htmlContent = "";

  //create message api call...
  void _submitForm(String status) {
    //

    final generatedHtml = QuillDeltaToHtmlConverter(
      _controller.document.toDelta().toJson(),
    ).convert();

    late String htmlContent = generatedHtml;
    // Print the generated HTML content for debugging
    print("Generated HTML Content: $htmlContent");

    if (_heading.text.isEmpty || htmlContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in both heading and description'),
        ),
      );
      return;
    }

    String gradeIds = '';

    if (selectedRecipient == 'Students') {
      gradeIds = selected
          .map((className) {
            int? gradeId = getGradeId(className);
            return gradeId?.toString();
          })
          .where((id) => id != null)
          .join(',');
    }
    CreatemessageModels newMessage = CreatemessageModels(
      headLine: _heading.text,
      message: htmlContent,
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      status: status,
      recipient: selectedRecipient ?? '',
      gradeIds: gradeIds,
      postedOn: status == "post"
          ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
          : "",
      scheduleOn: status == "schedule" ? _scheduledDateandtime.text : "",
      draftedOn: status == "draft"
          ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
          : "",
      updatedOn: "",
    );

    print("New Message Object: ${newMessage.toJson()}");
    CreateMessage(
      newMessage,
      context,
      widget.messageFetch,
    );
  }

  //
  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return _heading.text != initialHeading;
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
                        widget.messageFetch();
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
                        'Create Message',
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
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return dropdownItems.map((className) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
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
            //
            if (selectedRecipient == 'Students')
              Padding(
                padding: EdgeInsets.only(top: 35),
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
                    //class dropdown...
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
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),
            //heading...
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

            ///add description
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
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

            // //description field..
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.transparent,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.2),
            //           spreadRadius: 2,
            //           blurRadius: 5,
            //           offset: Offset(0, 0),
            //         ),
            //       ],
            //     ),
            //     child: TextFormField(
            //       maxLines: 6,
            //       controller: _desc,
            //       inputFormatters: [LengthLimitingTextInputFormatter(600)],
            //       decoration: InputDecoration(
            //         enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: BorderSide(color: Colors.white),
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           borderSide: BorderSide(color: Colors.white),
            //         ),
            //         filled: true,
            //         fillColor: Colors.white,
            //         focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.white),
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       style: TextStyle(
            //           color: Colors.black, fontFamily: 'medium', fontSize: 14),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15),
            //   child: Row(
            //     children: [
            //       Text(
            //         '*Max 600 Characters',
            //         style: TextStyle(
            //             fontFamily: 'regular',
            //             fontSize: 12,
            //             color: Color.fromRGBO(127, 127, 127, 1)),
            //       )
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          QuillSimpleToolbar(
                            controller: _controller,
                            configurations:
                                const QuillSimpleToolbarConfigurations(
                              dialogTheme: QuillDialogTheme(
                                  labelTextStyle:
                                      TextStyle(color: Colors.black),
                                  inputTextStyle: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              showBoldButton: true,
                              showClearFormat: false,
                              showAlignmentButtons: false,
                              showBackgroundColorButton: false,
                              showFontSize: false,
                              showColorButton: false,
                              showCenterAlignment: false,
                              showClipboardCut: false,
                              showIndent: false,
                              showDirection: false,
                              showDividers: false,
                              showFontFamily: false,
                              showItalicButton: false,
                              showClipboardPaste: false,
                              showInlineCode: false,
                              showCodeBlock: false,
                              showHeaderStyle: false,
                              showJustifyAlignment: false,
                              showLeftAlignment: false,
                              showLineHeightButton: false,
                              showLink: false,
                              showListBullets: false,
                              showListCheck: false,
                              showListNumbers: false,
                              showQuote: false,
                              showRightAlignment: false,
                              showSearchButton: false,
                              showRedo: false,
                              showSmallButton: false,
                              showSubscript: false,
                              showStrikeThrough: false,
                              showUndo: false,
                              showUnderLineButton: false,
                              showSuperscript: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quill editor
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 10),
                          child: quill.QuillEditor.basic(
                            controller: _controller,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                      _submitForm("draft");
                    },
                    child: Text(
                      'Save as Draft',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'medium',
                          color: Colors.black),
                    ),
                  ),

                  ///preview
                  GestureDetector(
                    onTap: () {
                      final generatedHtml = QuillDeltaToHtmlConverter(
                        _controller.document.toDelta().toJson(),
                      ).convert();

                      setState(() {
                        htmlContent = generatedHtml;
                      });

                      print("Generated HTML Content: $htmlContent");

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

                  ///scheduled
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textFieldborderColor,
                        side: BorderSide.none),
                    onPressed: () {
                      if (_scheduledDateandtime.text.isEmpty) {
                        _submitForm("post");
                      } else {
                        _submitForm("schedule");
                      }
                    },
                    child: Text(
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
          ],
        ),
      ),
    );
  }
}
