import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/theme.dart';

class CreateConsentformpage extends StatefulWidget {
  const CreateConsentformpage({super.key});

  @override
  State<CreateConsentformpage> createState() => _CreateConsentformpageState();
}

class _CreateConsentformpageState extends State<CreateConsentformpage> {
  List<String> selectClass = ['Everyone', 'Students', 'Teachers'];
  TextEditingController _heading = TextEditingController();

  // List to keep track of text fields
  List<int> textFieldList = [1];
  int questionCounter = 1;

  void _addTextField() {
    setState(() {
      questionCounter++;
      textFieldList.add(questionCounter);
    });
  }

  void _removeTextField(int index) {
    setState(() {
      textFieldList.remove(index);
    });
  }

  ///questions...
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
            child: Column(children: [
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
                      items: selectClass.map((String item) {
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
                      onChanged: (String? newValue) {},
                      selectedItemBuilder: (BuildContext context) {
                        return selectClass.map((className) {
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
          //select section...
          //select class
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
                      items: selectClass.map((String item) {
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
                      onChanged: (String? newValue) {},
                      selectedItemBuilder: (BuildContext context) {
                        return selectClass.map((className) {
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
          //add heading...
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 45),
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
                  onPressed: () {},
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
                  onTap: () {},
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
                  onPressed: () {},
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
        ])));
  }
}
