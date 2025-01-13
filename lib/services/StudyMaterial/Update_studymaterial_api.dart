import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/StudyMaterial/Update_studymaterial_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

Future<void> updateStudyMaterial(
    UpdateStudymaterialModel studyMaterial, File file, context) async {
  try {
    // The API URL
    final url = Uri.parse(
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeStudyMaterial/updateStudyMaterial');

    // Prepare multipart request
    var request = http.MultipartRequest('PUT', url);

    // Add Bearer token to the request headers
    request.headers['Authorization'] = 'Bearer $authToken';

    // Add the fields to the request
    request.fields['id'] = studyMaterial.id.toString();
    request.fields['userType'] = studyMaterial.userType;
    request.fields['rollNumber'] = studyMaterial.rollNumber;
    request.fields['subject'] = studyMaterial.subject;
    request.fields['heading'] = studyMaterial.heading;
    request.fields['fileType'] = studyMaterial.fileType;
    request.fields['updatedOn'] = studyMaterial.updatedOn;

    // Add the file to the request
    var fileBytes = await file.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: studyMaterial.file, // The name of the file on the server
      contentType:
          MediaType('image', 'jpg'), // Adjust this according to your file type
    );
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text('Studymaterial updated successfully.')),
      );
      print("Study Material Updated Successfully");
      // You can also check the response body if needed
      final responseData = await http.Response.fromStream(response);
      print('Response: ${responseData.body}');
    } else {
      print(
          "Failed to update study material. Status Code: ${response.statusCode}");
      SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'Failed to update timetable. Status Code: ${response.statusCode}'));
    }
  } catch (e) {
    print('Error: $e');
  }
}
