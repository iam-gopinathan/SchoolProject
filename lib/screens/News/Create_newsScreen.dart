import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/News_Models/Create_news_model.dart';
import 'package:flutter_application_1/services/News_Api/Create_news_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Style;
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class CreateNewsscreen extends StatefulWidget {
  final Function onCreateNews;
  CreateNewsscreen({super.key, required this.onCreateNews});

  @override
  State<CreateNewsscreen> createState() => _CreateNewsscreenState();
}

class _CreateNewsscreenState extends State<CreateNewsscreen> {
  //

  // Function to paste clipboard text
  Future<void> _pasteFromClipboard() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      _controller.document
          .insert(_controller.selection.baseOffset, clipboardData.text!);
    }
  }

  //
  late String htmlContent = "";

  TextEditingController _heading = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  QuillController _controller = QuillController.basic();
  bool isuploadimage = true;
  bool isaddLink = false;
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
      //
      // Check if the selected time is in the past
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

//   ///image bottomsheeet
//   void _PreviewBottomsheet(BuildContext context) {
//     showModalBottomSheet(
//         backgroundColor: Colors.white,
//         context: context,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//         ),
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setModalState) {
//             return Stack(clipBehavior: Clip.none, children: [
//               // Close icon
//               Positioned(
//                 top: MediaQuery.of(context).size.height * (-70 / 800),
//                 left: MediaQuery.of(context).size.width * 0.4,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Color.fromRGBO(19, 19, 19, 0.475),
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 35,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(10),
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height * 0.7,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10, left: 10),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Preview Screen',
//                               style: TextStyle(
//                                   fontFamily: 'medium',
//                                   fontSize: 16,
//                                   color: Color.fromRGBO(104, 104, 104, 1)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       //
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Divider(
//                           thickness: 2,
//                           color: Color.fromRGBO(243, 243, 243, 1),
//                         ),
//                       ),
// //heading...
//                       Padding(
//                         padding: const EdgeInsets.only(left: 15, top: 10),
//                         child: Row(
//                           children: [
//                             Text(
//                               _heading.text ?? '',
//                               style:
//                                   TextStyle(fontSize: 16, color: Colors.black),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // description...
//                       Row(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.7,
//                             padding: const EdgeInsets.all(10),
//                             child: htmlContent.isNotEmpty
//                                 ? Html(data: htmlContent)
//                                 : const Text(''),
//                           ),
//                         ],
//                       ),

//                       ///image section...
//                       Padding(
//                         padding: const EdgeInsets.only(top: 15),
//                         child: Center(
//                           child: selectedFile != null &&
//                                   selectedFile!.bytes != null
//                               ? Image.memory(
//                                   selectedFile!.bytes!,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Container(),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ]);
//           });
//         });
//   }
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
                  top: MediaQuery.of(context).size.height * (-70 / 800),
                  left: MediaQuery.of(context).size.width * 0.4,
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

                /// **Main Container**
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    children: [
                      // ✅ **Static Header (Won't Scroll)**
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            Text(
                              'Preview Screen',
                              style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 16,
                                color: Color.fromRGBO(104, 104, 104, 1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// **Divider (Also Static)**
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(
                          thickness: 2,
                          color: Color.fromRGBO(243, 243, 243, 1),
                        ),
                      ),

                      // ✅ **Scrollable Content**
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              // **Heading**
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        _heading.text ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // **Description**
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: const EdgeInsets.all(10),
                                    child: htmlContent.isNotEmpty
                                        ? Html(data: htmlContent, style: {
                                            "body": Style(
                                              fontFamily: 'semibold',
                                              color: Colors.black,
                                              textAlign: TextAlign.justify,
                                              fontSize: FontSize(
                                                16.0,
                                              ),
                                            ),
                                          })
                                        : const Text(''),
                                  ),
                                ],
                              ),
                              // **Image Section**
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
                ),
              ],
            );
          },
        );
      },
    );
  }

  String initialHeading = "";

  @override
  void initState() {
    super.initState();
    initialHeading = _heading.text;
  }

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return _heading.text != initialHeading;
  }

  // Function to show the unsaved changes dialog
  // Future<void> _showUnsavedChangesDialog() async {
  //   bool discard = await showDialog<bool>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text(
  //               "Unsaved Changes !",
  //               style: TextStyle(
  //                 fontFamily: 'semibold',
  //                 fontSize: 16,
  //                 color: Colors.black,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //             content: Text(
  //               "You have unsaved changes. Are you sure you want to discard them?",
  //               style: TextStyle(
  //                   fontFamily: 'medium', fontSize: 14, color: Colors.black),
  //               textAlign: TextAlign.center,
  //             ),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: AppTheme.textFieldborderColor,
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       "Discard",
  //                       style: TextStyle(
  //                           fontFamily: 'semibold',
  //                           fontSize: 14,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           );
  //         },
  //       ) ??
  //       false;
  // }
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

  // Regular expression to validate YouTube links
  bool isValidYouTubeLink(String url) {
    final RegExp youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)[a-zA-Z0-9_-]+$',
      caseSensitive: false,
      multiLine: false,
    );
    return youtubeRegex.hasMatch(url);
  }

  //
  String? _errorMessage;

  void _validateLink(String input) {
    if (input.isEmpty) {
      setState(() {
        _errorMessage = "";
      });
    } else if (!isValidYouTubeLink(input)) {
      setState(() {
        _errorMessage = "Enter a valid YouTube link";
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
    }
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
          preferredSize: Size.fromHeight(100),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
              titleSpacing: 0,
              backgroundColor: AppTheme.appBackgroundPrimaryColor,
              iconTheme: IconThemeData(color: Colors.black),
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: AppTheme.appBackgroundPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
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
                              widget.onCreateNews();
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.025),
                            child: Text(
                              'Create News',
                              style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Color.fromRGBO(251, 251, 251, 1),
                  border: Border.all(
                      color: Color.fromRGBO(244, 244, 244, 1), width: 2)),
              child: Column(
                children: [
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
                  // Description Section
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
                  //editor...
                  Padding(
                    padding: const EdgeInsets.all(12.0),
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
                                              color: Colors.black,
                                              fontSize: 14)),
                                      showBoldButton: true,
                                      showClipboardCopy: false,
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
                                  IconButton(
                                      icon: Icon(Icons.paste,
                                          color: Colors.black),
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
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.025),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 20),
                                child: quill.QuillEditor.basic(
                                  controller: _controller,
                                  configurations: QuillEditorConfigurations(
                                      customStyles: DefaultStyles(
                                    paragraph: quill.DefaultTextBlockStyle(
                                      TextStyle(
                                          color: Colors.black,
                                          fontSize: 16), // Text color black
                                      quill.HorizontalSpacing(0, 0),
                                      quill.VerticalSpacing.zero,
                                      quill.VerticalSpacing(0, 0),
                                      null,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // //
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
                  // Upload Image and Add Link Section
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
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
                              _linkController.text = '';
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
                  if (isuploadimage)
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
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
                            onChanged: (value) {
                              //
                              _validateLink(value);
                              //
                              selectedFile = null;
                            },
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
                                  borderSide: BorderSide.none),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a link";
                              } else if (!isValidYouTubeLink(value)) {
                                return "Enter a valid YouTube link";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  // Show error message below TextFormField
                  if (isaddLink && _linkController.text.isNotEmpty)
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 5),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: 'semibold'),
                        ),
                      ),
                  //
                  if (isaddLink)
                    Row(
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

                  ///schedule post..
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
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
                  //
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20, top: 10),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Set Date',
                  //         style: TextStyle(
                  //             fontFamily: 'medium',
                  //             fontSize: 14,
                  //             color: Colors.black),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //scheduled section....
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                ],
              ),
            ),
          ),
        ),
        //
        bottomNavigationBar: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       backgroundColor: Colors.white,
                //       side: BorderSide(color: Colors.black, width: 1.5)),
                //   onPressed: () {
                //     _publishNews(status: 'draft');
                //   },
                //   child: Text(
                //     'Save as Draft',
                //     style: TextStyle(
                //         fontSize: 14, fontFamily: 'medium', color: Colors.black),
                //   ),
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black, width: 1.5),
                  ),
                  onPressed: isdraft
                      ? null
                      : () async {
                          setState(() {
                            isdraft = true;
                            debugPrint(
                                'Loading started: $isLoading'); // Debugging
                          });

                          await Future.delayed(
                              Duration(seconds: 2)); // Allow UI update

                          await _publishNews(status: 'draft');

                          setState(() {
                            isdraft = false;
                            debugPrint(
                                'Loading stopped: $isLoading'); // Debugging
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
                            fontSize: 14,
                            fontFamily: 'medium',
                            color: Colors.black,
                          ),
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
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ),

                ///scheduled or post button..
                // if (UserSession().userType == 'superadmin')
                //   ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         padding: EdgeInsets.symmetric(horizontal: 20),
                //         backgroundColor: AppTheme.textFieldborderColor,
                //         side: BorderSide.none),
                //     onPressed: () {
                //       setState(() {
                //         isLoading = true;
                //       });
                //       final String status = _scheduledDateandtime.text.isEmpty
                //           ? 'post'
                //           : 'schedule';
                //       _publishNews(status: status);
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: AppTheme.textFieldborderColor,
                      side: BorderSide.none,
                    ),
                    onPressed: isLoading
                        ? null // Disable button when loading
                        : () {
                            setState(() {
                              isLoading = true; // Start loading
                            });

                            final String status =
                                _scheduledDateandtime.text.isEmpty
                                    ? 'post'
                                    : 'schedule';

                            _publishNews(status: status);
                          },
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  AppTheme.appBackgroundPrimaryColor,
                              strokeWidth: 4,
                              color: AppTheme.textFieldborderColor,
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
                ////request now button..
                if (UserSession().userType == 'admin' ||
                    UserSession().userType == 'staff')
                  Builder(builder: (context) {
                    bool isload = false;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: AppTheme.textFieldborderColor,
                        side: BorderSide.none,
                      ),
                      onPressed: () {
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
                        //         builder: (context, setState) {
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
                        //           // ElevatedButton(
                        //           //   style: ElevatedButton.styleFrom(
                        //           //       backgroundColor: Colors.amber),
                        //           //   onPressed: () {
                        //           //     final String status =
                        //           //         _scheduledDateandtime.text.isEmpty
                        //           //             ? 'post'
                        //           //             : 'schedule';
                        //           //     _publishNews(status: status);
                        //           //     //
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
                        //           ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor: isload
                        //                   ? Colors.grey
                        //                   : Colors
                        //                       .amber, // Disable color when loading
                        //             ),
                        //             onPressed: isload
                        //                 ? null // Disable button while loading
                        //                 : () async {
                        //                     setState(() {
                        //                       isload = true; // Show loader
                        //                     });

                        //                     final String status =
                        //                         _scheduledDateandtime
                        //                                 .text.isEmpty
                        //                             ? 'post'
                        //                             : 'schedule';

                        //                     await _publishNews(
                        //                         status:
                        //                             status); // Wait for API call to complete

                        //                     setState(() {
                        //                       isload = false; // Hide loader
                        //                     });

                        //                      Navigator.of(context).pop();
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
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                // Use setModalState
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
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Colors.black, width: 1),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontFamily: 'semibold',
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ),
                                    // ElevatedButton(
                                    //   style: ElevatedButton.styleFrom(
                                    //     elevation: 0,
                                    //     backgroundColor: isload
                                    //         ? Colors.grey
                                    //         : AppTheme.textFieldborderColor,
                                    //   ),
                                    //   onPressed: isload
                                    //       ? null
                                    //       : () async {
                                    //           setModalState(() {
                                    //             isload = true;
                                    //           });

                                    //           final String status =
                                    //               _scheduledDateandtime
                                    //                       .text.isEmpty
                                    //                   ? 'post'
                                    //                   : 'schedule';

                                    //           await _publishNews(
                                    //               status: status);

                                    //           setModalState(() {
                                    //             isload = false;
                                    //           });

                                    //           Navigator.of(context).pop();
                                    //         },
                                    //   child: isload
                                    //       ? SizedBox(
                                    //           width: 20,
                                    //           height: 20,
                                    //           child: CircularProgressIndicator(
                                    //             color: AppTheme
                                    //                 .appBackgroundPrimaryColor,
                                    //             strokeWidth: 4,
                                    //           ),
                                    //         )
                                    //       : Text(
                                    //           "Yes Send",
                                    //           style: TextStyle(
                                    //             fontFamily: 'semibold',
                                    //             fontSize: 14,
                                    //             color: Colors.black,
                                    //           ),
                                    //         ),
                                    // ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: isload
                                            ? Colors.grey
                                            : AppTheme.textFieldborderColor,
                                      ),
                                      onPressed: isload
                                          ? null
                                          : () async {
                                              setModalState(() {
                                                isload = true; // Show loader
                                              });

                                              await Future.delayed(Duration(
                                                  seconds:
                                                      2)); // Allow UI update

                                              final String status =
                                                  _scheduledDateandtime
                                                          .text.isEmpty
                                                      ? 'post'
                                                      : 'schedule';

                                              await _publishNews(
                                                  status: status); // API Call

                                              setModalState(() {
                                                isload = false; // Hide loader
                                              });

                                              await Future.delayed(Duration(
                                                  seconds:
                                                      2)); // Small delay for smooth transition

                                              if (context.mounted) {
                                                Navigator.of(context)
                                                    .pop(); // Close dialog only after loader update
                                              }
                                            },
                                      child: isload
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
                          fontSize: 14,
                          fontFamily: 'medium',
                          color: Colors.black,
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  bool isdraft = false;

  ////create news api call....................................................
  Future<void> _publishNews({String? status}) async {
    //
    final String heading = _heading.text;

    final generatedHtml = QuillDeltaToHtmlConverter(
      _controller.document.toDelta().toJson(),
    ).convert();

    late String htmlContent = generatedHtml;
    // Print the generated HTML content for debugging
    print("Generated HTML Content: $htmlContent");

    if (heading.isEmpty || _controller.document.toPlainText().trim().isEmpty) {
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
      // Validate YouTube Link
      if (!isValidYouTubeLink(link)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Invalid YouTube link. Please enter a valid link.'),
          ),
        );
        setState(() {
          isLoading = false; // Stop loading if validation fails
        });
        return;
      }
    } else {
      fileType = 'empty';
    }
    String postedOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    String scheduleOn =
        _scheduledDateandtime.text.isNotEmpty ? _scheduledDateandtime.text : '';
    String draftedOn = '';
    if (status == 'draft') {
      draftedOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    } else if (status == 'schedule' && scheduleOn.isEmpty) {
      scheduleOn = postedOn;
    }
    final newsPost = CreateNewsModel(
      headline: heading,
      news: htmlContent,
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      postedOn: status == 'draft' ? '' : postedOn,
      status: status ?? (scheduleOn.isEmpty ? 'post' : 'schedule'),
      scheduleOn: status == 'schedule' ? scheduleOn : '',
      draftedOn: status == 'draft' ? draftedOn : '',
      fileType: fileType,
      file: file,
      link: link,
    );
    postNews(newsPost, status ?? 'post', context, widget.onCreateNews);

    // Print the newsPost object for debugging
    print("News Postttttttt: ${newsPost.toJson()}");
  }
}
