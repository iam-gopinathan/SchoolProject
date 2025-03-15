import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/ConsentForm/Create_consentForm_model.dart';
import 'package:flutter_application_1/services/ConsentForm/create_ConsentForm_api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateConsentformpage extends StatefulWidget {
  final Function fetch;
  const CreateConsentformpage({super.key, required this.fetch});

  @override
  State<CreateConsentformpage> createState() => _CreateConsentformpageState();
}

class _CreateConsentformpageState extends State<CreateConsentformpage> {
  TextEditingController _heading = TextEditingController();

  final GradeController gradeController = Get.put(GradeController());

  String selectedGradeName = '';

  String? selectedGrade;
  String? selectedSection;
  String? selectedClasses;

  String? selectedSubject;

  String? selectedGradeId;
  List<String> sections = [];
  List<String> subjects = [];

  List<int> textFieldList = [1];
  int questionCounter = 1;

  List<TextEditingController> questionControllers = [TextEditingController()];

  void _addTextField() {
    setState(() {
      questionControllers.add(TextEditingController());
      textFieldList.add(questionCounter++);
    });
  }

  void _removeTextField(int index) {
    setState(() {
      questionControllers[index].dispose();
      questionControllers.removeAt(index);
      textFieldList.removeAt(index);
    });
  }

  Widget _buildQuestion(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.02,

            left:
                MediaQuery.of(context).size.width * 0.06, // 5% of screen width
          ),
          child: Row(
            children: [
              Text(
                'Question ${index + 1}',
                style: TextStyle(
                    fontFamily: 'medium',
                    fontSize: 16,
                    color: Color.fromRGBO(38, 38, 38, 1)),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.03,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Color.fromRGBO(247, 240, 249, 1)),
                  onPressed: _addTextField,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'regular',
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index > 0)
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 240, 249, 1),
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Color.fromRGBO(84, 84, 84, 1),
                    ),
                    onPressed: () => _removeTextField(index),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 173, 172, 172).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: TextFormField(
              controller: questionControllers[index],
              inputFormatters: [LengthLimitingTextInputFormatter(300)],
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            children: [
              Text(
                '*Max 300 Characters',
                style: TextStyle(
                    fontFamily: 'regular',
                    fontSize: 12,
                    color: Color.fromRGBO(127, 127, 127, 1)),
              )
            ],
          ),
        ),
      ],
    );
  }

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
                            //heading...
                            if (selectedGradeName.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "${selectedGradeName}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            //selected section..
                            if (sections.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedSections.isEmpty
                                          ? ""
                                          : selectedSections.join(', '),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            //heading
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      "${_heading.text}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
//
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < questionControllers.length;
                                      i++)
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            questionControllers[i].text,
                                            style: const TextStyle(
                                                fontFamily: 'medium',
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

  List<String> selectedSections = [];

  //show menu
  void _showSectionMenu(
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
                        if (selectedSections.length == sections.length) {
                          selectedSections.clear();
                        } else {
                          selectedSections = List<String>.from(sections);
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
                              value: selectedSections.length == sections.length,
                              onChanged: (bool? value) {
                                menuSetState(() {
                                  if (value == true) {
                                    selectedSections =
                                        List<String>.from(sections);
                                  } else {
                                    selectedSections.clear();
                                  }
                                });
                                setState(() {});
                              },
                              checkColor: Colors.black,
                              activeColor: Colors.white,
                            ),
                            Text(
                              "Select All",
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
                        children: sections.map((String section) {
                          return Container(
                            color: Colors.black,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectedSections.contains(section),
                                  onChanged: (bool? value) {
                                    menuSetState(() {
                                      if (value == true) {
                                        selectedSections.add(section);
                                      } else {
                                        selectedSections.remove(section);
                                      }
                                    });
                                    setState(() {});
                                  },
                                  checkColor: Colors.black,
                                  activeColor: Colors.white,
                                ),
                                Text(
                                  section,
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

  //
  String initialHeading = "";

  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return _heading.text != initialHeading ||
        selectedClasses != initialHeading ||
        selectedSection != initialHeading;
  }

  // Function to show the unsaved changes dialog
  Future<void> _showUnsavedChangesDialog() async {
    bool discard = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    initialHeading = _heading.text;
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
                        widget.fetch();
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
                        'Consent Form',
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
            //select class
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.058,
                  ),
                  Text(
                    'Select Class',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 14,
                        color: Color.fromRGBO(38, 38, 38, 1)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.184,
                  ),
                  //dropdown field.......
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Obx(
                      () {
                        if (gradeController.gradeList.isEmpty) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return DropdownButtonFormField<String>(
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(203, 203, 203, 1),
                              ),
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
                          dropdownColor: Colors.black,
                          menuMaxHeight: 150,
                          value: selectedGradeId,
                          hint: Text(
                            "Select Class",
                            style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedGradeId = value;

                              final selectedGrade =
                                  gradeController.gradeList.firstWhere(
                                (grade) => grade['id'].toString() == value,
                                orElse: () => null,
                              );

                              if (selectedGrade != null) {
                                selectedGradeName =
                                    selectedGrade['sign'].toString();
                                sections = List<String>.from(
                                    selectedGrade['sections'] ?? []);
                                subjects = List<String>.from(
                                    selectedGrade['subjects'] ?? []);
                              } else {
                                sections = [];
                                subjects = [];
                              }
                              selectedSection = null;
                              selectedSubject = null;
                            });
                          },
                          items: gradeController.gradeList.map((grade) {
                            return DropdownMenuItem<String>(
                              value: grade['id'].toString(),
                              child: Text(
                                grade['sign'].toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'regular',
                                    fontSize: 14),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return gradeController.gradeList.map((grade) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  grade['sign'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            //select sections...
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.058,
                  ),
                  Text(
                    'Select Section',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 14,
                        color: Color.fromRGBO(38, 38, 38, 1)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.152,
                  ),

                  ///section dropdown..
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: GestureDetector(
                      onTap: () {
                        _showSectionMenu(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(203, 203, 203, 1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedSections.isEmpty
                                    ? 'Select section'
                                    : selectedSections.join(', '),
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
            //add heading...
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
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
                      color: Colors.black, fontFamily: 'medium', fontSize: 14),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.06,
              ), // 5% of screen width),
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

            ///questions loop...
            for (int i = 0; i < textFieldList.length; i++) _buildQuestion(i),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Padding(
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
              //     String status = 'draft';
              //     _createconsentform(status);
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
                    : () {
                        String status = 'draft';
                        _createconsentform(status);
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
                          color: Colors.black,
                        ),
                      ),
              ),
              //preview
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
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: AppTheme.textFieldborderColor,
              //       side: BorderSide.none),
              //   onPressed: () {
              //     String status = 'post';
              //     _createconsentform(status);
              //   },
              //   child: Text(
              //     'Publish',
              //     style: TextStyle(
              //         fontSize: 16, fontFamily: 'medium', color: Colors.black),
              //   ),
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textFieldborderColor,
                  side: BorderSide.none,
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });

                  String status = 'post';
                  await _createconsentform(status);

                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppTheme.appBackgroundPrimaryColor,
                          strokeWidth: 4,
                        ),
                      )
                    : Text(
                        'Publish',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'medium',
                          color: Colors.black,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;

  bool isdraft = false;

  //create consent form..
  Future<void> _createconsentform(String status) async {
    String currentDateTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    String postedOn = status == "post" ? currentDateTime : "";
    String draftedOn = status == "draft" ? currentDateTime : "";

    // Collect all the questions
    List<String> questions =
        questionControllers.map((controller) => controller.text).toList();

    // Get the selected section (assuming you have selectedSections)
    String selectedSection =
        selectedSections.isEmpty ? "" : selectedSections.join(", ");

    //
    setState(() {
      if (status == 'draft') {
        isdraft = true;
        isLoading = false;
      } else {
        isdraft = false;
        isLoading = true;
      }
    });

    // **Validation for Empty Fields**
    if (selectedGradeId == null) {
      _showSnackBar("Please select a Class");
      setState(() {
        isLoading = false;
        isdraft = false;
      });
      return;
    }
    if (selectedSections.isEmpty) {
      _showSnackBar("Please select at least one section");
      setState(() {
        isLoading = false;
        isdraft = false;
      });
      return;
    }
    if (_heading.text.trim().isEmpty) {
      _showSnackBar("Please enter heading");
      setState(() {
        isLoading = false;
        isdraft = false;
      });

      return;
    }
    if (questions.isEmpty || questions.any((q) => q.isEmpty)) {
      _showSnackBar("Please enter at least one question");
      setState(() {
        isLoading = false;
        isdraft = false;
      });
      return;
    }

    CreateConsentformModel create = CreateConsentformModel(
        userType: UserSession().userType.toString(),
        rollNumber: UserSession().rollNumber.toString(),
        gradeId: selectedGradeId!,
        section: selectedSection,
        heading: _heading.text,
        question: questions.join("|"),
        status: status,
        postedOn: postedOn,
        draftedOn: draftedOn);

    await CreateConsentForm(create, context, widget.fetch);
  }

  // Function to show Snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
