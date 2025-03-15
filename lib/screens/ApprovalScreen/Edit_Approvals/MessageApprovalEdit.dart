import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Approver_model/Message_update_Approver_model.dart';
import 'package:flutter_application_1/models/Message_models/EditMessage_Models.dart';
import 'package:flutter_application_1/models/Message_models/GradeModels.dart';

import 'package:flutter_application_1/services/Approver_Api/Message_Approver_Update_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Edit_message_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Grade_Api.dart';

import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class Messageapprovaledit extends StatefulWidget {
  final int Id;
  final Function messageFetch;
  Messageapprovaledit(
      {super.key, required this.Id, required this.messageFetch});

  @override
  State<Messageapprovaledit> createState() => _MessageapprovaleditState();
}

class _MessageapprovaleditState extends State<Messageapprovaledit> {
  //

  Future<void> _pasteFromClipboard() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      String text = clipboardData.text ?? "";

      // Insert plain text into QuillEditor
      descriptionController.replaceText(
        descriptionController.selection.baseOffset,
        descriptionController.selection.extentOffset -
            descriptionController.selection.baseOffset,
        text,
        TextSelection.collapsed(
            offset: descriptionController.selection.baseOffset + text.length),
      );
    }
  }

  late String htmlContent = "";

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
                      thickness: 1,
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
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${selectedRecipient}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //
                          if (selected.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      "${selected}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          //
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    _heading.text,
                                    style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          // description...
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.all(10),
                                child: htmlContent.isNotEmpty
                                    ? Html(
                                        data: descriptionController
                                            .pastePlainText)
                                    : const Text(''),
                              ),
                            ],
                          ),
                          //
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  _scheduledDateandtime.text,
                                  style: TextStyle(
                                      fontFamily: 'semibold',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]);
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMessageDetails();
    descriptionController = quill.QuillController.basic();
  }

  late quill.QuillController descriptionController;

  TextEditingController _heading = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _scheduledDateandtime = TextEditingController();

  List<String> dropdownItems = ['Everyone', 'Students', 'Teachers'];

  List<int> selectedGrades = [];

  EditmessageModels? messageDetails;
  bool isLoading = true;

  List<String> gradeNames = [];
  List<String> selected = [];

  @override
  void dispose() {
    super.dispose();

    descriptionController.dispose();
  }

  var scheduleeee;
  String? selectedRecipient;
  //edit fetch..
  void fetchMessageDetails() async {
    try {
      final data = await fetchMessageById(widget.Id);

      if (data != null) {
        List<GradeGet> fetchedGrades = await fetchGrades();

        setState(() {
          messageDetails = data;
          isLoading = false;
          _heading.text = data.headLine;
          _desc.text = data.message;

          htmlContent = data.message;
          scheduleeee = data.status;
//
          // _scheduledDateandtime.text = data.scheduleOnRailwayTime ?? '';

          // _scheduledDateandtime.text = data.scheduleOn ?? '';

          //
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

          final plainText = html_parser.parse(data.message).body?.text ?? "";

          descriptionController = quill.QuillController(
            document: quill.Document()..insert(0, plainText),
            selection: const TextSelection.collapsed(offset: 0),
          );
          selectedRecipient = data.recipient;
          selectedGrades = List<int>.from(data.gradeIds);
          grades = fetchedGrades;

          //
          // Ensure the recipient exists in the dropdown list
          selectedRecipient = dropdownItems.firstWhere(
            (item) => item.toLowerCase() == data.recipient.toLowerCase(),
            orElse: () => dropdownItems.first, // Default to 'Everyone'
          );

          gradeNames = selectedGrades.map((gradeId) {
            var grade = grades.firstWhere(
              (g) => g.id == gradeId,
            );
            return grade != null ? grade.sign : 'Unknown';
          }).toList();

          selected = gradeNames;
        });
      } else {
        setState(() {
          isLoading = false;
          print('Error fetching message details');
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
                        'Edit Message',
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
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(203, 203, 203, 1),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                hintText: 'Select',
                                hintStyle: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 14,
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
                  //
                  if (selectedRecipient == 'Students')
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Transform.translate(
                        offset: Offset(-1, 0),
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
                            if (selectedRecipient == 'Students')
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showMenu(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 11),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(203, 203, 203, 1),
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
                              ),
                          ],
                        ),
                      ),
                    ),
                  //heading...
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width *
                          0.06, // 5% of screen width
                      top: MediaQuery.of(context).size.height *
                          0.03, // 3% of screen height
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
                          0.06, // 5% of screen width
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

                  ///add description
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width *
                          0.06, // 5% of screen width
                      top: MediaQuery.of(context).size.height *
                          0.03, // 3% of screen height
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
                  //description field..
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
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
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              QuillSimpleToolbar(
                                controller: descriptionController,
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
                                  showClipboardCopy: false,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.paste, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      _pasteFromClipboard();
                                    });
                                  }),
                            ],
                          ),
                          //quill controller.....
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: QuillEditor.basic(
                              controller: descriptionController,
                              configurations: const QuillEditorConfigurations(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      vertical: 25)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width *
                          0.06, // 5% of screen width
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
                  //schedule post...
                  if (scheduleeee == 'schedule')
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width *
                            0.06, // 5% of screen width
                        top: MediaQuery.of(context).size.height *
                            0.02, // 3% of screen height
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
                  if (scheduleeee == 'schedule')
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
                  //
                ],
              ),
            ),
      //
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///preview
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

              ///scheduled or update  button
              // if (UserSession().userType == 'superadmin')
              //   ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         padding: EdgeInsets.symmetric(horizontal: 20),
              //         backgroundColor: AppTheme.textFieldborderColor,
              //         side: BorderSide.none),
              //     onPressed: () {
              //       if (_scheduledDateandtime.text.isEmpty) {
              //         _submitUpdateForm("post");
              //       } else {
              //         _submitUpdateForm("schedule");
              //       }
              //     },
              //     child: Text(
              //       _scheduledDateandtime.text.isEmpty ? 'Update' : 'Schedule',
              //       style: TextStyle(
              //           fontSize: 16,
              //           fontFamily: 'medium',
              //           color: Colors.black),
              //     ),
              //   ),
              /// Scheduled or update button
              if (UserSession().userType == 'superadmin')
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: AppTheme.textFieldborderColor,
                    side: BorderSide.none,
                  ),
                  onPressed: _isLoading
                      ? null // Disable button while loading
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          if (_scheduledDateandtime.text.isEmpty) {
                            await _submitUpdateForm("post");
                          } else {
                            await _submitUpdateForm("schedule");
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        },
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppTheme.appBackgroundPrimaryColor,
                            strokeWidth: 4,
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

  //

  Future<void> _submitUpdateForm(String status) async {
    // Convert the QuillController content to HTML
    final generatedHtml = QuillDeltaToHtmlConverter(
      descriptionController.document.toDelta().toJson(),
    ).convert();

    // Assign the generated HTML to htmlContent
    late String htmlContent = generatedHtml;

    // Debug print the generated HTML content
    print("Generated HTML Content: $htmlContent");

    if (_heading.text.isEmpty || htmlContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in both heading and description'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = true; // Start loader before calling API
    });
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

    //
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

    String gradeIdsString = selectedGradeIds.join(',');

    //
    print("Submitting Data:");
    print("ID: ${widget.Id}");
    print("Headline: ${_heading.text}");
    print("Message (HTML): $htmlContent");
    print("User Type: ${UserSession().userType}");
    print("Roll Number: ${UserSession().rollNumber}");
    print("Status: $status");
    print("Recipient: ${selectedRecipient ?? ''}");
    print("Grade IDs: $gradeIdsString");
    print("Schedule On: $scheduleOn");
    print(
        "Updated On: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}");
    print("Action: accept");

    MessageUpdateApproverModel Approvermessageaccept =
        MessageUpdateApproverModel(
      id: widget.Id,
      headLine: _heading.text,
      message: htmlContent,
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      status: status,
      recipient: selectedRecipient ?? '',
      gradeIds: gradeIdsString,
      // postedOn: status == "post"
      //     ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
      //     : "",
      // scheduleOn: status == "schedule" ? _scheduledDateandtime.text : "",
      scheduleOn: status == "schedule" ? scheduleOn : "",
      updatedOn: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
      Action: 'accept',
    );

    await messageApproverupdateApi(
        Approvermessageaccept, context, widget.messageFetch);
  }
}
