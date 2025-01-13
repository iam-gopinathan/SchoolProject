import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/Feedback_models/create_feedback_model.dart';

import 'package:flutter_application_1/services/Feedback_Api/create_feedback_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateFeedback extends StatefulWidget {
  const CreateFeedback({super.key});

  @override
  State<CreateFeedback> createState() => _CreateFeedbackState();
}

class _CreateFeedbackState extends State<CreateFeedback> {
  final GradeController gradeController = Get.put(GradeController());

  TextEditingController _heading = TextEditingController();

  List<String> dropdownItems = ['Everyone', 'Students', 'Teachers'];
  String? selectedRecipient;

  String selectedGradeName = '';

  String? selectedGrade;
  String? selectedSection;
  String? selectedClasses;

  String? selectedSubject;

  String? selectedGradeId;
  List<String> sections = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gradeController.fetchGrades();
  }

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
          padding: const EdgeInsets.only(left: 20, right: 15, top: 15),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(247, 240, 249, 1)),
                onPressed: _addTextField,
                child: Row(
                  children: [
                    Icon(Icons.add),
                    Text(
                      'Add',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'regular',
                          color: Color.fromRGBO(84, 84, 84, 1)),
                    ),
                  ],
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
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
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
          padding: const EdgeInsets.only(left: 15),
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

  ///

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
                      //selected reciepents..
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${selectedRecipient}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),

//selected grade
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${selectedGradeName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                      //selected section..
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${selectedSection}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //heading
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${_heading.text}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //questions...
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              questionControllers
                                  .map((controller) => controller.text)
                                  .join(", "),
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
                        'Create Feedback',
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
            //select receipents..
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

            if (selectedRecipient == 'Students')
              //select class
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                      child: Obx(
                        () {
                          if (gradeController.gradeList.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              border: OutlineInputBorder(
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
                            hint: Text("Select Class"),
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
                                } else {
                                  sections = [];
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
            if (selectedRecipient == 'Students')
              //select sections...
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Select Section',
                        style: TextStyle(
                            fontFamily: 'medium',
                            fontSize: 14,
                            color: Color.fromRGBO(38, 38, 38, 1)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.black,
                          menuMaxHeight: 150,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            border: OutlineInputBorder(
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
                          value: selectedSection,
                          hint: Text(
                            "Select Section",
                            style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              selectedSection = value;
                            });
                          },
                          items: sections.map((String section) {
                            return DropdownMenuItem<String>(
                              value: section,
                              child: Text(
                                section,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'regular',
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return sections.map((String section) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  section,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'regular',
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  )),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

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

            ///questions loop...

            for (int i = 0; i < textFieldList.length; i++) _buildQuestion(i),

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
                      String status = 'draft';
                      submitFeedback(status);
                    },
                    child: Text(
                      'Save as Draft',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'medium',
                          color: Colors.black),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textFieldborderColor,
                        side: BorderSide.none),
                    onPressed: () {
                      String status = 'post';
                      submitFeedback(status);
                    },
                    child: Text(
                      'Publish',
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

  List<String> selected = [];

  // Create feedback
  void submitFeedback(String status) {
    // Collect all the questions
    List<String> questions =
        questionControllers.map((controller) => controller.text).toList();

    CreateFeedbackModel create = CreateFeedbackModel(
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      recipient: selectedRecipient!,
      gradeId: selectedGradeId!,
      section: selectedSection!,
      heading: _heading.text,
      question: questions.join("|"),
      status: status,
      postedOn: status == "post"
          ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
          : "",
      draftedOn: status == "draft"
          ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
          : "",
    );

    CreateFeedbackss(create, context);
  }
}
