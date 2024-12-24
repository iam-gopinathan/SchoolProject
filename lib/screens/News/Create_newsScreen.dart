import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/News_Models/Create_news_model.dart';
import 'package:flutter_application_1/services/News_Api/Create_news_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CreateNewsscreen extends StatefulWidget {
  final Function onCreateNews;
  CreateNewsscreen({super.key, required this.onCreateNews});

  @override
  State<CreateNewsscreen> createState() => _CreateNewsscreenState();
}

class _CreateNewsscreenState extends State<CreateNewsscreen> {
  QuillController _controller = QuillController.basic();

// Function to convert Delta to HTML with <b> for bold text
  String convertDeltaToHtml(Delta delta) {
    final StringBuffer htmlContent = StringBuffer();

    for (final op in delta.toList()) {
      final attributes = op.attributes;
      final text = op.data.toString();

      if (op.isInsert) {
        // Check for bold attribute
        if (attributes != null && attributes['bold'] == true) {
          htmlContent.write('<b>$text</b>');
        } else {
          // For normal text, no formatting
          htmlContent.write(text);
        }
      }
    }

    return htmlContent.toString();
  }

// Function to extract HTML content from the controller
  String getHtmlContent() {
    final delta = _controller.document.toDelta();
    return convertDeltaToHtml(delta);
  }
// Function to convert Delta to HTML with <b> for bold text endddddddd

  final FocusNode _focusNode = FocusNode();

  TextEditingController _heading = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  TextSpan convertDeltaToTextSpan(Delta delta) {
    final List<TextSpan> textSpans = [];

    for (final op in delta.toList()) {
      final attributes = op.attributes;
      final text = op.data.toString();

      if (op.isInsert) {
        final isBold = attributes != null && attributes['bold'] == true;

        textSpans.add(
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        );
      }
    }

    return TextSpan(children: textSpans);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  bool isuploadimage = true;
  bool isaddLink = false;

  TextEditingController _scheduledDateandtime = TextEditingController();
  String _dateTime = "";

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
                              _heading.text ?? '',
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
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: RichText(
                            text: convertDeltaToTextSpan(
                                _controller.document.toDelta()),
                          ),
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

  ////create news api call....................................................
  void _publishNews({String? status}) {
    final String heading = _heading.text;

    final String description = getHtmlContent();

    if (heading.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in both heading and description'),
        ),
      );
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
      news: description,
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
    postNews(newsPost, status ?? 'post', context);
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
                onTap: () {
                  widget.onCreateNews();
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            title: Text(
              'Create News',
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
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
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
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
                        // Removed fixed height for QuillEditor
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: QuillEditor.basic(
                            controller: _controller,
                            focusNode: _focusNode,
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

                ///display selected image...
                if (isuploadimage)
                  if (selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
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
                //scheduled section....
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                //save as draft
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black, width: 1.5)),
                        onPressed: () {
                          _publishNews(status: 'draft');
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
                          final String status =
                              _scheduledDateandtime.text.isEmpty
                                  ? 'post'
                                  : 'schedule';
                          _publishNews(status: status);
                        },
                        child: Text(
                          _scheduledDateandtime.text.isEmpty
                              ? 'Publish'
                              : 'Scheduled',
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
        ),
      ),
    );
  }
}
