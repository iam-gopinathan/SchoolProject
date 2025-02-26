import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Controller/grade_controller.dart';
import 'package:flutter_application_1/models/TimeTable_models/Edit_timetable_model.dart';
import 'package:flutter_application_1/models/TimeTable_models/Update_timeTable_model.dart';
import 'package:flutter_application_1/services/Timetables/Edit_timetables_Api.dart';
import 'package:flutter_application_1/services/Timetables/update_timeTable_Api.dart';
import 'package:flutter_application_1/user_session.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';

class EditTimetable extends StatefulWidget {
  final int id;
  final Function fetchMaintimetable;
  const EditTimetable(
      {super.key, required this.id, required this.fetchMaintimetable});

  @override
  State<EditTimetable> createState() => _EditTimetableState();
}

class _EditTimetableState extends State<EditTimetable> {
  EditTimetableModel? timetableData;
  final GradeController _gradeController = Get.put(GradeController());

  List<Map<String, dynamic>> gradeList = [];

  List<String> sectionList = [];

  String? _selectedClass;
  String? _selectedSection;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    EditTimetableData();
    _gradeController.fetchGrades();
  }

  String? imageUrl;
  Future<void> EditTimetableData() async {
    try {
      final data = await fetchEditTimetableData(widget.id);

      print("Fetched Timetable Data: $data");

      setState(() {
        timetableData = data;
        isLoading = false;

        gradeList = List<Map<String, dynamic>>.from(_gradeController.gradeList);

        final selectedGrade = gradeList.firstWhere(
          (grade) => grade['id'] == timetableData?.gradeId,
          orElse: () => {'sign': null, 'sections': []},
        );

        _selectedClass = selectedGrade['sign'];

        sectionList = List<String>.from(
            timetableData?.section != null ? [timetableData?.section] : []);

        _selectedSection = timetableData?.section;

        // Store the image URL
        imageUrl = timetableData?.filepath;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
                        thickness: 1,
                        color: Color.fromRGBO(243, 243, 243, 1),
                      ),
                    ),
//heading...
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15, top: 10),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "${_selectedClass}",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 16,
                    //             color: Colors.black),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    //selected section..
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15, top: 10),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "${_selectedSection}",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 16,
                    //             color: Colors.black),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //fetched image shows
                    if (isFetchedImageVisible)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),

                    ///image section...
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Center(
                        child:
                            selectedFile != null && selectedFile!.bytes != null
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
      },
    );
  }

  bool isFetchedImageVisible = true;

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
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.fetchMaintimetable();
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
                          'Edit Timetable',
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
                        //class dropdown code..
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: DropdownButtonFormField<String>(
                            hint: Text(
                              "Select Class",
                              style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
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
                            value: _selectedClass,
                            items: gradeList.map((grade) {
                              return DropdownMenuItem<String>(
                                value: grade['sign'],
                                child: Text(grade['sign']),
                              );
                            }).toList(),
                            onChanged: null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //select sections.....
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height *
                          0.025, // 2.5% of screen height
                      left: MediaQuery.of(context).size.width *
                          0.005, // 0.5% of screen width
                    ),
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

                        // Section dropdown code
                        Transform.translate(
                          offset: Offset(-3, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: DropdownButtonFormField<String>(
                              hint: Text(
                                "Select Section",
                                style: TextStyle(
                                  fontFamily: 'regular',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                              value: _selectedSection,
                              items: sectionList.map((section) {
                                return DropdownMenuItem<String>(
                                  value: section,
                                  child: Text(section),
                                );
                              }).toList(),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

//upload image......

                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height *
                          0.05, // 5% of screen height
                      left: MediaQuery.of(context).size.width *
                          0.05, // 4% of screen width
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(246, 246, 246, 1)),
                          child: Text(
                            'Re-Upload Image',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'medium',
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            isFetchedImageVisible = false;
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
                  // Display the fetched image if the URL exists
                  if (isFetchedImageVisible &&
                      imageUrl != null &&
                      imageUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Image.network(
                        imageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      (progress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'Failed to load image.',
                            style: TextStyle(color: Colors.red),
                          );
                        },
                      ),
                    ),

                  /// Display selected image...
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
                                  isFetchedImageVisible = true;
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Supported Format : JPEG,Webp PNG, PDF',
                        style: TextStyle(
                            fontFamily: 'regular',
                            fontSize: 9,
                            color: Color.fromRGBO(168, 168, 168, 1)),
                      ),
                      // Text(
                      //   '*Upload either an image or a link',
                      //   style: TextStyle(
                      //       fontFamily: 'regular',
                      //       fontSize: 9,
                      //       color: Color.fromRGBO(168, 168, 168, 1)),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 50),
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

              ///publish
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor,
                    side: BorderSide.none),
                onPressed: () {
                  _updateTimetable();
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'medium', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //update api calls................

  Future<void> _updateTimetable() async {
    File? file;

    String formattedDate =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

    if (selectedFile == null && imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected!')),
      );
      return;
    }

    String fileType = '';
    if (selectedFile != null) {
      final bytes = selectedFile!.bytes;
      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No data available for the selected file.')),
        );
        return;
      }

      final tempFile =
          File('${Directory.systemTemp.path}/${selectedFile!.name}');
      await tempFile.writeAsBytes(bytes);

      file = tempFile;
      fileType = 'image';
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      fileType = 'existing';
      file = null;
    }

    final model = UpdateTimetableModel(
      id: widget.id,
      userType: UserSession().userType ?? '',
      rollNumber: UserSession().rollNumber ?? '',
      fileType: fileType,
      file: selectedFile?.extension ?? "image",
      updatedOn: formattedDate,
    );

    final timetableService = TimetableService();

    bool success = await timetableService.updateTimetable(
        model, file, context, widget.fetchMaintimetable);

    if (success) {
      print("Timetable updated.");
    } else {
      print("Failed to update timetable.");
    }
  }
}
