import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/Feedback_models/Parent_feedback_Update_models.dart';
import 'package:flutter_application_1/models/Feedback_models/Parent_feedback_edit_model.dart';
import 'package:flutter_application_1/services/Feedback_Api/Parent_feedback_Update_API.dart';
import 'package:flutter_application_1/services/Feedback_Api/Parent_feedback_Edit_Api.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:intl/intl.dart';

class ParentFeedbackEditpage extends StatefulWidget {
  final int Id;
  final Function fetchparentData;
  final Function updateparent;

  const ParentFeedbackEditpage(
      {super.key,
      required this.Id,
      required this.fetchparentData,
      required this.updateparent});

  @override
  State<ParentFeedbackEditpage> createState() => _ParentFeedbackEditpageState();
}

class _ParentFeedbackEditpageState extends State<ParentFeedbackEditpage> {
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

                      ///selected descriptions...
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "${_desc.text}",
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

//fetch function...
  String? selectedOptions;

  List<String> options = ['Complaints', 'Suggestions', 'Others'];

  bool isLoading = true;

  ParentFeedbackEditModel? edit;
  Future<void> fetchFeedbackData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await fetchParentFeedbackById(widget.Id);
      setState(() {
        edit = data;
        isLoading = false;
        _desc.text = data!.question;
        selectedOptions = data.type;

        selectedOptions = options.firstWhere(
          (option) => option == data.type,
          orElse: () => options[0],
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFeedbackData();
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
                        'Edit Feedback',
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
                    'Suggestions',
                    style: TextStyle(
                        fontFamily: 'medium',
                        fontSize: 14,
                        color: Color.fromRGBO(38, 38, 38, 1)),
                  ),
                  //
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                      value: selectedOptions,
                      decoration: InputDecoration(
                        hintText: 'Select',
                        hintStyle: TextStyle(
                          fontFamily: 'medium',
                          fontSize: 16,
                          color: Colors.black,
                        ),
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
                      ),
                      dropdownColor: Colors.black,
                      items: options.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'regular',
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: null,
                    ),
                  ),
                ],
              ),
            ),
            //description...
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 30),
              child: Row(children: [
                Text(
                  'Edit Description',
                  style: TextStyle(
                      fontFamily: 'medium',
                      fontSize: 14,
                      color: Color.fromRGBO(38, 38, 38, 1)),
                ),
              ]),
            ),
            //description..
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: TextFormField(
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
                  ),
                ),
              ),
            ),
            //
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
            //draft
            Padding(
              padding: const EdgeInsets.only(
                top: 230,
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textFieldborderColor,
                        side: BorderSide.none),
                    onPressed: () {
                      update();
                    },
                    child: Text(
                      'Update',
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

  //update...functions....
  void update() {
    String postedOn = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    ParentFeedbackUpdateModel update = ParentFeedbackUpdateModel(
        id: widget.Id,
        headLine: '',
        question: _desc.text,
        type: selectedOptions.toString(),
        postedOn: postedOn);
    updateEditParentFeedback(
        update, context, widget.fetchparentData, widget.updateparent);
  }
}
