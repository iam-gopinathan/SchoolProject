import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Feedback_models/Parent_create_feedback_model.dart';
import 'package:flutter_application_1/services/Feedback_Api/Parent_create_feedback_Api.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/theme.dart';

class ParentFeedbackCreatepage extends StatefulWidget {
  final Function fetchparentData;
  final Function updateparent;
  const ParentFeedbackCreatepage(
      {super.key, required this.fetchparentData, required this.updateparent});

  @override
  State<ParentFeedbackCreatepage> createState() =>
      _ParentFeedbackCreatepageState();
}

class _ParentFeedbackCreatepageState extends State<ParentFeedbackCreatepage> {
  @override
  void initState() {
    super.initState();
    print('usertype ${UserSession().rollNumber}');
  }

  List<String> options = ['Suggestions', 'Complaints', 'Others'];
  String? selectedOptions = 'Suggestions';

  TextEditingController _desc = TextEditingController();

//preview bottomsheet...
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
                  -0.09, // -9% of screen height
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

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //selected suggesstions..

                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              children: [
                                Text(
                                  "${selectedOptions}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          //selected suggesstions..
                          if (selectedOptions != null &&
                              selectedOptions!.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "${selectedOptions}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),

                          ///selected descriptions...
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    "${_desc.text}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
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
                ],
              ),
            )
          ]);
        });
      },
    );
  }

  //
  String initialHeading = "";
  // Check if there are unsaved changes
  bool hasUnsavedChanges() {
    return _desc.text != initialHeading || options != initialHeading;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 253, 253, 1),
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
            padding: EdgeInsets.all(10),
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
                      GestureDetector(
                        onTap: () async {
                          if (hasUnsavedChanges()) {
                            await _showUnsavedChangesDialog();
                          }
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
                    'Suggestions',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 14,
                        color: Color.fromRGBO(38, 38, 38, 1)),
                  ),
                  //dropdown field.......
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                        value: selectedOptions,
                        decoration: InputDecoration(
                            hintText: 'Select',
                            hintStyle: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 16,
                                color: Colors.black),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(203, 203, 203, 1),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(203, 203, 203, 1),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10)),
                        dropdownColor: Colors.black,
                        items: options.map((String item) {
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
                            selectedOptions = newValue;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return options.map((className) {
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
            //description...
            Padding(
              padding: EdgeInsets.only(
                top: 50,
                left: MediaQuery.of(context).size.width * 0.07,
              ),
              child: Row(children: [
                Text(
                  'Add Description',
                  style: TextStyle(
                      fontFamily: 'medium',
                      fontSize: 14,
                      color: Color.fromRGBO(38, 38, 38, 1)),
                ),
              ]),
            ),
            //description..
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              child: Container(
                child: TextFormField(
                  cursorColor: Colors.black,
                  inputFormatters: [LengthLimitingTextInputFormatter(600)],
                  controller: _desc,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(203, 203, 203, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(203, 203, 203, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(203, 203, 203, 1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
            //
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08,
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child:
            //draft
            Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height *
                0.05, // 5% of screen height
            bottom: MediaQuery.of(context).size.height *
                0.05, // 5% of screen height
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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

              ///post
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: AppTheme.textFieldborderColor,
              //       side: BorderSide.none),
              //   onPressed: () {
              //     createParentFeedback();
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
                onPressed: isloading ? null : createParentFeedback,
                child: isloading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: AppTheme.appBackgroundPrimaryColor,
                        ),
                      )
                    : Text(
                        'Publish',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'medium',
                            color: Colors.black),
                      ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }

  //
  bool isloading = false;

  ///post api...
  void createParentFeedback() {
    if (_desc.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Description!"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isloading = false;
      });
      return;
    }
    setState(() {
      isloading = true;
    });
    ParentCreateFeedbackModel create = ParentCreateFeedbackModel(
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      heading: '',
      question: _desc.text,
      type: selectedOptions.toString(),
    );
    createParentFeedbacks(
        create, context, widget.fetchparentData, widget.updateparent);
  }
}
