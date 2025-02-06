import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Homework_models/create_homeworks_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<void> postHomework(
    CreateHomeworkModel homework,
    PlatformFile selectedFile,
    BuildContext context,
    Function fetchHomework) async {
  const String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/homeWork/postHomeWork";

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );

    print('Homework data:');
    print('GradeId: ${homework.gradeId}');
    print('Section: ${homework.section}');
    print('UserType: ${homework.userType}');
    print('RollNumber: ${homework.rollNumber}');
    print('FileType: ${homework.fileType}');
    print('File: ${homework.file}');
    print('Status: ${homework.status}');
    print('PostedOn: ${homework.postedOn}');
    print('DraftedOn: ${homework.draftedOn}');
    print('ScheduleOn: ${homework.scheduleOn}');

    if (selectedFile != null) {
      print('Selected File:');
      print('File name: ${selectedFile.name}');
      print('File path: ${selectedFile.path}');
      print('File extension: ${selectedFile.extension}');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          selectedFile.path!,
          contentType:
              MediaType('application', selectedFile.extension ?? 'jpeg'),
        ),
      );
    } else {
      print('No file selected');
    }

    request.fields['GradeId'] = homework.gradeId.toString();
    request.fields['Section'] = homework.section;
    request.fields['UserType'] = homework.userType;
    request.fields['RollNumber'] = homework.rollNumber;
    request.fields['FileType'] = homework.fileType;
    request.fields['File'] = homework.file;
    request.fields['Status'] = homework.status;
    request.fields['PostedOn'] = homework.postedOn;
    request.fields['DraftedOn'] = homework.draftedOn;
    request.fields['ScheduleOn'] = homework.scheduleOn;

    print('Request fields:');
    print(request.fields);

    request.headers['Authorization'] = 'Bearer $authToken';

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Homework posted successfully: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Homework posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      //
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      fetchHomework();

      Navigator.pop(
        context,
      );
    } else {
      print('Failed to post homework: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post homework. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error posting homework: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
