import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/StudyMaterial/Create_StudyMaterial_model.dart';

import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<void> postStudyMaterial(
    CreateStudymaterialModel studyMaterial, context) async {
  Uri url = Uri.parse(
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/studyMaterial/poststudyMaterial');

  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer $authToken',
  };

  var request = http.MultipartRequest('POST', url)
    ..headers.addAll(headers)
    ..fields['GradeId'] = studyMaterial.gradeId
    ..fields['Section'] = studyMaterial.section
    ..fields['UserType'] = studyMaterial.userType
    ..fields['RollNumber'] = studyMaterial.rollNumber
    ..fields['Subject'] = studyMaterial.subject
    ..fields['Heading'] = studyMaterial.heading
    ..fields['FileType'] = studyMaterial.fileType
    ..fields['Status'] = studyMaterial.status
    ..fields['PostedOn'] = studyMaterial.postedOn
    ..fields['DraftedOn'] = studyMaterial.draftedOn;

  var file = await http.MultipartFile.fromPath('File', studyMaterial.filePath);
  request.files.add(file);

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('StudyMaterial posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print('Study Material uploaded successfully');

      var responseBody = await response.stream.bytesToString();
      print(responseBody);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to post Study Material. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print('Failed to upload study material: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
