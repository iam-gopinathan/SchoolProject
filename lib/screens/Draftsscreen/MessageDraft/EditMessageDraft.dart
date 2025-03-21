import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Message_models/EditMessage_Models.dart';
import 'package:flutter_application_1/models/Message_models/GradeModels.dart';
import 'package:flutter_application_1/models/Message_models/Update_message_Models.dart';
import 'package:flutter_application_1/services/Message_Api/Edit_message_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Grade_Api.dart';
import 'package:flutter_application_1/services/Message_Api/Update_message_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Style;
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class Editmessagedraft extends StatefulWidget {
  const Editmessagedraft({super.key});

  @override
  State<Editmessagedraft> createState() => _EditmessagedraftState();
}

class _EditmessagedraftState extends State<Editmessagedraft> {
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
                                            .pastePlainText,
                                        style: {
                                          "body": Style(
                                              fontFamily: 'semibold',
                                              fontSize: FontSize(16),
                                              textAlign: TextAlign.justify)
                                        },
                                      )
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
    // fetchMessageDetails();
    // descriptionController = quill.QuillController.basic();
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
//   void fetchMessageDetails() async {
//     try {
//       final data = await fetchMessageById(widget.Id);

//       if (data != null) {
//         List<GradeGet> fetchedGrades = await fetchGrades();

//         setState(() {
//           messageDetails = data;
//           isLoading = false;
//           _heading.text = data.headLine;
//           _desc.text = data.message;

//           htmlContent = data.message;
//           scheduleeee = data.status;
// //
//           // _scheduledDateandtime.text = data.scheduleOnRailwayTime ?? '';

//           //
//           if (data.scheduleOn != null && data.scheduleOn!.isNotEmpty) {
//             try {
//               // Convert API date to desired format
//               DateTime parsedDate = DateTime.parse(data.scheduleOn!);
//               _scheduledDateandtime.text =
//                   DateFormat("dd-MM-yyyy HH:mm").format(parsedDate);
//             } catch (e) {
//               print("Error parsing date: $e");
//               _scheduledDateandtime.text = data.scheduleOn!;
//             }
//           } else {
//             _scheduledDateandtime.text = '';
//           }

//           final plainText = html_parser.parse(data.message).body?.text ?? "";

//           descriptionController = quill.QuillController(
//             document: quill.Document()..insert(0, plainText),
//             selection: const TextSelection.collapsed(offset: 0),
//           );
//           selectedRecipient = data.recipient;
//           selectedGrades = List<int>.from(data.gradeIds);
//           grades = fetchedGrades;

//           //
//           // Ensure the recipient exists in the dropdown list
//           selectedRecipient = dropdownItems.firstWhere(
//             (item) => item.toLowerCase() == data.recipient.toLowerCase(),
//             orElse: () => dropdownItems.first, // Default to 'Everyone'
//           );

//           gradeNames = selectedGrades.map((gradeId) {
//             var grade = grades.firstWhere(
//               (g) => g.id == gradeId,
//             );
//             return grade != null ? grade.sign : 'Unknown';
//           }).toList();

//           selected = gradeNames;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//           print('Error fetching message details');
//         });
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

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
    return Scaffold();
  }
}
