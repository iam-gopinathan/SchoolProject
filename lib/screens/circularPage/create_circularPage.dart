import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Message_models/GradeModels.dart';
import 'package:flutter_application_1/models/circular_models/Create_Circular_model.dart';
import 'package:flutter_application_1/services/Circular_Api/Create_circular_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Grade_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Style;
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class CreateCircularpage extends StatefulWidget {
  final Function fetchcircular;
  const CreateCircularpage({super.key, required this.fetchcircular});

  @override
  State<CreateCircularpage> createState() => _CreateCircularpageState();
}

class _CreateCircularpageState extends State<CreateCircularpage> {
  // Function to paste clipboard text
  Future<void> _pasteFromClipboard() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      _controller.document
          .insert(_controller.selection.baseOffset, clipboardData.text!);
    }
  }

  List<String> dropdownItems = ['Everyone', 'Students', 'Teachers'];
  String? selectedRecipient = 'Everyone';

  List<String> selected = [];
  List<GradeGet> grades = [];

  List<int> selectedIds = [];

  TextEditingController _heading = TextEditingController();

  TextEditingController _scheduledDateandtime = TextEditingController();

  TextEditingController _linkController = TextEditingController();

  QuillController _controller = QuillController.basic();

  bool isuploadimage = true;
  bool isaddLink = false;

  late String htmlContent = "";

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
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            //
                            if (selectedRecipient?.isNotEmpty ?? false)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedRecipient ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            //
                            //class
                            if (selected.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        selected.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            //heading...
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Text(
                                      _heading.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //description...
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: const EdgeInsets.all(10),
                                  child: htmlContent.isNotEmpty
                                      ? Html(
                                          data: htmlContent,
                                          style: {
                                            "body": Style(
                                                color: Colors.black,
                                                fontFamily: 'semibold',
                                                fontSize: FontSize(16),
                                                textAlign: TextAlign.justify)
                                          },
                                        )
                                      : const Text(''),
                                ),
                              ],
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
                    ),
                  ],
                ),
              )
            ]);
          },
        );
      },
    );
  }

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

  @override
  void initState() {
    // TODO: implement initState
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

  //
  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return _heading.text != initialHeading;
  }

  // Function to show the unsaved changes dialog
  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Unsaved Changes!",
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
                        Navigator.pop(context, true); // Allow back navigation
                      },
                      child: Text(
                        "Discard",
                        style: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                    // Add spacing
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
    return WillPopScope(
      onWillPop: () async {
        return await _showUnsavedChangesDialog();
      },
      child: Scaffold(
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
                          'Create Circular',
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
                          value: selectedRecipient,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(10)),
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
                        //class dropdown...
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.06),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: GestureDetector(
                              onTap: () {
                                _showMenu(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
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
                        ),
                      ],
                    ),
                  ),
                ),

              //heading...
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width *
                      0.05, // 5% of screen width
                  top: MediaQuery.of(context).size.height *
                      0.04, // 3% of screen height
                ),
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
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Container(
                  width: double.infinity,
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
                        color: Colors.black,
                        fontFamily: 'medium',
                        fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
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
                      0.05, // 5% of screen width
                  top: MediaQuery.of(context).size.height *
                      0.03, // 3% of screen height
                ),
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

              //editor...
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Container(
                  width: double.infinity,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      color: const Color.fromRGBO(
                                          225, 225, 225, 1),
                                      width: 1))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
                      ),
                      // Quill editor
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 20),
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
              //
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Click Here to',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'medium',
                                            color:
                                                Color.fromRGBO(93, 93, 93, 1)),
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
                ],
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
                          style: TextStyle(
                            color:
                                Colors.black, // Set input text color to black
                            fontSize: 14,
                            fontFamily: 'regular',
                          ),
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
              //schedule post...
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width *
                      0.05, // 5% of screen width
                  top: MediaQuery.of(context).size.height *
                      0.03, // 3% of screen height
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
            ],
          ),
        ),
        bottomNavigationBar: Container(
          child:
              //save as draft
              Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       backgroundColor: Colors.white,
                //       side: BorderSide(color: Colors.black, width: 1.5)),
                //   onPressed: () {
                //     _createcircular("draft");
                //   },
                //   child: Text(
                //     'Save as Draft',
                //     style: TextStyle(
                //         fontSize: 16, fontFamily: 'medium', color: Colors.black),
                //   ),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  onPressed: isdraft
                      ? null // Disable button while loading
                      : () async {
                          setState(() {
                            isdraft = true; // Show progress
                          });

                          await _createcircular("draft"); // Call API

                          setState(() {
                            isdraft = false; // Hide progress after submission
                          });
                        },
                  child: isdraft
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: AppTheme.textFieldborderColor,
                          ),
                        )
                      : Text(
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

                ///scheduled or post
                // if (UserSession().userType == 'superadmin')
                //   ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         padding: EdgeInsets.symmetric(horizontal: 15),
                //         backgroundColor: AppTheme.textFieldborderColor,
                //         side: BorderSide.none),
                //     onPressed: () {
                //       if (_scheduledDateandtime.text.isEmpty) {
                //         _createcircular("post");
                //       } else {
                //         _createcircular("schedule");
                //       }
                //     },
                //     child: Text(
                //       _scheduledDateandtime.text.isEmpty ? 'Publish' : 'Schedule',
                //       style: TextStyle(
                //           fontSize: 16,
                //           fontFamily: 'medium',
                //           color: Colors.black),
                //     ),
                //   ),
                if (UserSession().userType == 'superadmin')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        backgroundColor: AppTheme.textFieldborderColor,
                        side: BorderSide.none),
                    onPressed: isLoading
                        ? null // Disable button when loading
                        : () {
                            setState(() {
                              isLoading = true; // Show loader
                            });

                            if (_scheduledDateandtime.text.isEmpty) {
                              _createcircular("post");
                            } else {
                              _createcircular("schedule");
                            }
                          },
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppTheme.textFieldborderColor,
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
                ////request now..
                if (UserSession().userType == 'admin' ||
                    UserSession().userType == 'staff')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      backgroundColor: AppTheme.textFieldborderColor,
                      side: BorderSide.none,
                    ),
                    onPressed: () {
                      //
                      if (_heading.text.isEmpty ||
                          _controller.document.isEmpty()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'Please fill in both heading and description'),
                          ),
                        );
                        return;
                      }
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext dialogContext) {
                      //     return StatefulBuilder(
                      //         builder: (context, setModalState) {
                      //       bool isload = false;
                      //       return AlertDialog(
                      //         backgroundColor: Colors.white,
                      //         title: Text(
                      //           "Confirm Request !",
                      //           style: TextStyle(
                      //             fontFamily: 'semibold',
                      //             fontSize: 18,
                      //             color: Colors.black,
                      //           ),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         content: Text(
                      //           "Are you sure you want to create\n a new request?",
                      //           style: TextStyle(
                      //               fontFamily: 'regular',
                      //               fontSize: 16,
                      //               color: Colors.black),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         actions: [
                      //           ElevatedButton(
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: Colors.white,
                      //               side: BorderSide(
                      //                   color: Colors.black, width: 1),
                      //             ),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //             child: Text(
                      //               "Cancel",
                      //               style: TextStyle(
                      //                   fontFamily: 'semibold',
                      //                   fontSize: 14,
                      //                   color: Colors.black),
                      //             ),
                      //           ),
                      //           //
                      //           // ElevatedButton(
                      //           //   style: ElevatedButton.styleFrom(
                      //           //     backgroundColor: isload
                      //           //         ? Colors.grey
                      //           //         : AppTheme.textFieldborderColor,
                      //           //   ),
                      //           //   onPressed: () {
                      //           //     if (_scheduledDateandtime.text.isEmpty) {
                      //           //       _createcircular("post");
                      //           //     } else {
                      //           //       _createcircular("schedule");
                      //           //     }
                      //           //     Navigator.of(context).pop();
                      //           //   },
                      //           //   child: Text(
                      //           //     "Yes Send",
                      //           //     style: TextStyle(
                      //           //         fontFamily: 'semibold',
                      //           //         fontSize: 14,
                      //           //         color: Colors.black),
                      //           //   ),
                      //           // ),
                      //           // Yes Send Button with Loader
                      //           ElevatedButton(
                      //             style: ElevatedButton.styleFrom(
                      //               backgroundColor: isload
                      //                   ? Colors.grey
                      //                   : AppTheme.textFieldborderColor,
                      //             ),
                      //             onPressed: isload
                      //                 ? null // Disable button while loading
                      //                 : () async {
                      //                     setModalState(() {
                      //                       isload = true; // Show loader
                      //                     });

                      //                     if (_scheduledDateandtime
                      //                         .text.isEmpty) {
                      //                       await _createcircular(
                      //                           "post"); // API Call
                      //                     } else {
                      //                       await _createcircular(
                      //                           "schedule"); // API Call
                      //                     }

                      //                     setModalState(() {
                      //                       isload = false; // Hide loader
                      //                     });

                      //                     Navigator.of(dialogContext)
                      //                         .pop(); // Close dialog
                      //                   },
                      //             child: isload
                      //                 ? SizedBox(
                      //                     width: 20,
                      //                     height: 20,
                      //                     child: CircularProgressIndicator(
                      //                       color: AppTheme
                      //                           .appBackgroundPrimaryColor,
                      //                       strokeWidth: 4,
                      //                     ),
                      //                   )
                      //                 : Text(
                      //                     "Yes Send",
                      //                     style: TextStyle(
                      //                       fontFamily: 'semibold',
                      //                       fontSize: 14,
                      //                       color: Colors.black,
                      //                     ),
                      //                   ),
                      //           ),
                      //         ],
                      //       );
                      //     });
                      //   },
                      // );
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          bool isLoad = false; // Loading state
                          return StatefulBuilder(
                            builder: (context, setModalState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  "Confirm Request !",
                                  style: TextStyle(
                                    fontFamily: 'semibold',
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                content: Text(
                                  "Are you sure you want to create\n a new request?",
                                  style: TextStyle(
                                    fontFamily: 'regular',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  // Cancel Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontFamily: 'semibold',
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                                  // Yes Send Button with Loader
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLoad
                                          ? Colors.grey
                                          : AppTheme.textFieldborderColor,
                                    ),
                                    onPressed: isLoad
                                        ? null // Disable button while loading
                                        : () async {
                                            setModalState(() {
                                              isLoad = true; // Show loader
                                            });

                                            if (_scheduledDateandtime
                                                .text.isEmpty) {
                                              await _createcircular(
                                                  "post"); // API Call
                                            } else {
                                              await _createcircular(
                                                  "schedule"); // API Call
                                            }

                                            setModalState(() {
                                              isLoad = false; // Hide loader
                                            });

                                            Navigator.of(dialogContext)
                                                .pop(); // Close dialog
                                          },
                                    child: isLoad
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: AppTheme
                                                  .appBackgroundPrimaryColor,
                                              strokeWidth: 4,
                                            ),
                                          )
                                        : Text(
                                            "Yes Send",
                                            style: TextStyle(
                                              fontFamily: 'semibold',
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Request Now',
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
      ),
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

    if (pickedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime parsedTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
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

  //match grade Id...
  int? getGradeId(String sign) {
    for (var grade in grades) {
      if (grade.sign == sign) {
        return grade.id;
      }
    }
    return null;
  }

//
  bool isdraft = false;
//
  bool isLoading = false;
//create function...
  Future<void> _createcircular(String status) async {
    //
    final generatedHtml = QuillDeltaToHtmlConverter(
      _controller.document.toDelta().toJson(),
    ).convert();

    late String htmlContent = generatedHtml;
    // Print the generated HTML content for debugging
    print("Generated HTML Content: $htmlContent");
    //
    if (_heading.text.isEmpty ||
        _controller.document.toPlainText().trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in both heading and description'),
        ),
      );
      setState(() {
        isLoading = false; // Stop loading if validation fails
      });
      return;
    }
    //

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

    String fileType = '';
    String file = '';
    String link = '';

    if (selectedFile != null) {
      fileType = 'image';
      file =
          selectedFile!.bytes != null ? base64Encode(selectedFile!.bytes!) : '';
    } else if (_linkController.text.isNotEmpty) {
      fileType = 'link';
      link = _linkController.text;
    } else {
      fileType = 'empty';
    }

    final circular = CreateCircularModel(
      headline: _heading.text,
      circular: htmlContent,
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
      fileType: fileType,
      file: file,
      link: link,
    );

    await postCircular(circular, selectedFile, context, widget.fetchcircular);
  }
}
