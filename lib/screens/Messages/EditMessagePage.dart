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
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Editmessagepage extends StatefulWidget {
  final int Id;
  final Function messageFetch;
  Editmessagepage({super.key, required this.Id, required this.messageFetch});

  @override
  State<Editmessagepage> createState() => _EditmessagepageState();
}

class _EditmessagepageState extends State<Editmessagepage> {
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
                              _heading.text,
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
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              _desc.text,
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
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMessageDetails();
  }

  TextEditingController _heading = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _scheduledDateandtime = TextEditingController();

  List<String> dropdownItems = ['Everyone', 'Students', 'Teachers'];
  String? selectedRecipient;
  List<int> selectedGrades = [];

  EditmessageModels? messageDetails;
  bool isLoading = true;

  List<String> gradeNames = [];
  List<String> selected = [];

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
          selectedRecipient = data.recipient;
          selectedGrades = List<int>.from(data.gradeIds);
          grades = fetchedGrades;

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
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
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
                          child: GestureDetector(
                            onTap: () {
                              _showMenu(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
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
                      ],
                    ),
                  ),

                  //heading...
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

                  ///add description
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
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
                        maxLines: 6,
                        controller: _desc,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(600)
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 30),
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
                    padding: const EdgeInsets.only(left: 20, top: 20),
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

                  Padding(
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

                        ///scheduled
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.textFieldborderColor,
                              side: BorderSide.none),
                          onPressed: () {
                            if (_scheduledDateandtime.text.isEmpty) {
                              _submitUpdateForm("post");
                            } else {
                              _submitUpdateForm("schedule");
                            }
                          },
                          child: Text(
                            _scheduledDateandtime.text.isEmpty
                                ? 'Update'
                                : 'Schedule',
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

  void _submitUpdateForm(String status) {
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

    String gradeIdsString = selectedGradeIds.join(',');

    UpdateMessageModel updatedMessage = UpdateMessageModel(
      id: widget.Id,
      headLine: _heading.text,
      message: _desc.text,
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      status: status,
      recipient: selectedRecipient ?? '',
      gradeIds: gradeIdsString,
      postedOn: status == "post"
          ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
          : "",
      scheduleOn: status == "schedule" ? _scheduledDateandtime.text : "",
      updatedOn: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
    );

    updateMessage(updatedMessage);
  }
}
