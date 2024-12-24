import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:flutter_svg/svg.dart';

class Addmarks extends StatefulWidget {
  const Addmarks({super.key});

  @override
  State<Addmarks> createState() => _AddmarksState();
}

class _AddmarksState extends State<Addmarks> {
  String? _selectedValue;

  final List<String> _dropdownItems = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
  ];

//view bottomsheeet...
  void _viewBottomsheet(BuildContext context) {
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
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            Text(
                              'Teacher Comment',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromRGBO(202, 202, 202, 1),
                              )),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            maxLines: 9,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 70),
                                elevation: 0,
                                backgroundColor: Colors.white,
                                side:
                                    BorderSide(color: Colors.black, width: 1)),
                            onPressed: () {},
                            child: Text(
                              'Close',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ]);
          });
        });
  }

  //add bottomsheet..
  void _addBottomsheet(BuildContext context) {
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
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Row(
                          children: [
                            Text(
                              'Teacher Comment',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      //
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromRGBO(202, 202, 202, 1),
                              )),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            maxLines: 9,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 70),
                              elevation: 0,
                              backgroundColor: AppTheme.textFieldborderColor,
                            ),
                            onPressed: () {},
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ]);
          });
        });
  }

//filter..
  String _selectedFilter = "";
  void _showFilter(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.black,
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'Above 60 %',
          child: SizedBox(
            width: 100,
            child: Text(
              'Above 60 %',
              style: TextStyle(
                  fontFamily: 'regular', fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Above 80 %',
          child: Text(
            'Above 80 %',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Above 90 %',
          child: Text(
            'Above 90 %',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Below 60 %',
          child: Text(
            'Below 60 %',
            style: TextStyle(
                fontFamily: 'regular', fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
    if (result != null) {
      setState(() {
        _selectedFilter = result;
      });
    }
  }

  final int numberOfRows = 1;

  final List<TextEditingController> tamilControllers = [];
  final List<TextEditingController> englishControllers = [];
  final List<TextEditingController> mathsControllers = [];
  final List<TextEditingController> scienceControllers = [];
  final List<TextEditingController> socialControllers = [];

  ///linear progress indicator..
  ScrollController _linearprogresscontroller = ScrollController();
  double _progress = 0.0;

  int totalMarks = 0;
  String status = 'Pass';
  double percentage = 0.0;

  void calculateResults() {
    setState(() {
      final tamil = int.tryParse(tamilControllers[0].text);
      final english = int.tryParse(englishControllers[0].text);
      final maths = int.tryParse(mathsControllers[0].text);
      final science = int.tryParse(scienceControllers[0].text);
      final social = int.tryParse(socialControllers[0].text);

      if (tamil == null ||
          english == null ||
          maths == null ||
          science == null ||
          social == null) {
        status = '';
        totalMarks = 0;
        percentage = 0.0;
        return;
      }

      totalMarks = tamil + english + maths + science + social;

      if (tamil < 35 ||
          english < 35 ||
          maths < 35 ||
          science < 35 ||
          social < 35) {
        status = 'Fail';
      } else {
        status = 'Pass';
      }

      percentage = totalMarks / 5;
    });
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 1; i++) {
      tamilControllers.add(TextEditingController());
      englishControllers.add(TextEditingController());
      mathsControllers.add(TextEditingController());
      scienceControllers.add(TextEditingController());
      socialControllers.add(TextEditingController());
    }
    _linearprogresscontroller.addListener(() {
      setState(() {
        double progress = _linearprogresscontroller.offset /
            (_linearprogresscontroller.position.maxScrollExtent);

        _progress = progress.clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    for (var controller in tamilControllers) controller.dispose();
    for (var controller in englishControllers) controller.dispose();
    for (var controller in mathsControllers) controller.dispose();
    for (var controller in scienceControllers) controller.dispose();
    super.dispose();
  }

  final List<String> classes = [
    'PREKG',
    'LKG',
    'UKG',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
  ];
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      context: context,
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
                top: -70,
                left: 180,
                child: GestureDetector(
                  onTap: () {
                    setModalState(() {});
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
                height: MediaQuery.of(context).size.height *
                    0.4, //bottomsheet containner
                width: double.infinity,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'Select Class and Section',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            //select class
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Select Class',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'regular',
                                      color: Color.fromRGBO(53, 53, 53, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //classes..
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: classes.map((className) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Container(
                                        width: 100,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Color.fromRGBO(
                                                  223, 223, 223, 1)),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {});
                                            },
                                            child: Text(
                                              className,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'medium',
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            //sectionwise.....
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Select Section',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'regular',
                                      color: Color.fromRGBO(53, 53, 53, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Display sections below the classes
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    // Dynamic sections
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() {});
                                        },
                                        child: Container(
                                          width: 100,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color.fromRGBO(
                                                  223, 223, 223, 1),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'medium',
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.textFieldborderColor),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'OK',
                            style: TextStyle(
                                fontFamily: 'semibold',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              )
            ],
          );
        });
      },
    );
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
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back)),
            title: Text(
              'Add Marks',
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Add Exam Name',
                    style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 12,
                        color: Colors.black),
                  ),

                  //dropdown..
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.black,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      value: _selectedValue,
                      menuMaxHeight: 150,
                      borderRadius: BorderRadius.circular(10),
                      hint: Text('Select'),
                      items: _dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'regular'),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return _dropdownItems.map((String item) {
                          return Text(
                            item,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'regular'),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  //filter icon..
                  GestureDetector(
                    onTap: () {
                      _showFilterBottomSheet(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/Filter_icon.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  //export icon..
                  SvgPicture.asset(
                    'assets/icons/export_icon.svg',
                    fit: BoxFit.contain,
                  )
                ],
              ),
            ),
            //

            Transform.translate(
              offset: Offset(0, 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(children: [
                  IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(10)),
                          border: Border.all(
                              color: Color.fromRGBO(234, 234, 234, 1))),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10)),
                                color: Color.fromRGBO(31, 106, 163, 1)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'PreKG - A1',
                                style: TextStyle(
                                    fontFamily: 'medium',
                                    fontSize: 12,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: Text(
                              'Class Teacher - Premlatha M.',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _showFilter(context, details);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Filter_icon.svg',
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'by %',
                            style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 12,
                                color: Color.fromRGBO(47, 47, 47, 1)),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),

            ///
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(238, 238, 238, 1),
                    )),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'medium',
                              color: Colors.black),
                        ),
                        Image.asset(
                          'assets/images/Dashboard_profileimage.png',
                          fit: BoxFit.contain,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kavin Kumar V.',
                              style: TextStyle(
                                  fontFamily: 'semibold',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Text(
                              '562147',
                              style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Percentage',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Color.fromRGBO(54, 54, 54, 1)),
                                ),
                                Text(
                                  "$percentage %",
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 16,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),

                        //
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Total Marks ',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 10,
                                      color: Color.fromRGBO(54, 54, 54, 1)),
                                ),
                                Text(
                                  '500',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Scored Marks ',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 10,
                                      color: Color.fromRGBO(54, 54, 54, 1)),
                                ),
                                Text(
                                  '$totalMarks',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 12,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            //pass..
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status == 'Pass'
                                      ? Color.fromRGBO(1, 133, 53, 1)
                                      : (status == 'Fail'
                                          ? Colors.red
                                          : Colors.white),
                                ),
                                onPressed: () {},
                                child: Text(
                                  '$status',
                                  style: TextStyle(
                                      fontFamily: 'medium',
                                      fontSize: 16,
                                      color: Colors.white),
                                )),
                          ],
                        ),
                      ],
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 25, right: 25),
                      child: Divider(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        height: 5,
                        thickness: 3,
                      ),
                    ),
                    //
                    SingleChildScrollView(
                      controller: _linearprogresscontroller,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (states) => Color.fromRGBO(255, 247, 247, 1),
                          ),
                          border: TableBorder.all(
                              color: Colors.black.withOpacity(0.1)),
                          columns: const [
                            DataColumn(label: Text('Total Marks')),
                            DataColumn(label: Text('Tamil')),
                            DataColumn(label: Text('English')),
                            DataColumn(label: Text('Maths')),
                            DataColumn(label: Text('Science')),
                            DataColumn(label: Text('Social')),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text('500')),
                              DataCell(TextField(
                                controller: tamilControllers[0],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                onChanged: (value) => calculateResults(),
                              )),
                              DataCell(TextField(
                                controller: englishControllers[0],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                onChanged: (value) => calculateResults(),
                              )),
                              DataCell(TextField(
                                controller: mathsControllers[0],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                onChanged: (value) => calculateResults(),
                              )),
                              DataCell(TextField(
                                controller: scienceControllers[0],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                onChanged: (value) => calculateResults(),
                              )),
                              DataCell(TextField(
                                controller: socialControllers[0],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                onChanged: (value) => calculateResults(),
                              )),
                            ]),
                          ],
                        ),
                      ),
                    ),

                    //
                    Divider(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      height: 5,
                      thickness: 3,
                    ),
//linear indicator...
                    Container(
                      width: 60,
                      height: 10,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Color.fromRGBO(225, 225, 225, 1),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        value: _progress,
                      ),
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            'Teacher Comment',
                            style: TextStyle(
                                fontFamily: 'medium',
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _addBottomsheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15, top: 10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.black)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Add',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'regular',
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _viewBottomsheet(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15, top: 10),
                            child: Text(
                              'View',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'regular',
                                  color: Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          fontFamily: 'semibold',
                          color: Colors.black),
                    ),
                  ),

                  ///scheduled
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.textFieldborderColor,
                          side: BorderSide.none),
                      onPressed: () {},
                      child: Text(
                        'Publish',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'semibold',
                            color: Colors.black),
                      ),
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
}
