import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/StudyMaterial/Update_studymaterial_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

Future<void> updateStudyMaterial(UpdateStudymaterialModel studyMaterial,
    File? file, context, Function fetchstudymaterial) async {
  try {
    final url = Uri.parse(
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeStudyMaterial/updateStudyMaterial');

    var request = http.MultipartRequest('PUT', url);

    request.headers['Authorization'] = 'Bearer $authToken';

    request.fields['id'] = studyMaterial.id.toString();
    request.fields['userType'] = studyMaterial.userType;
    request.fields['rollNumber'] = studyMaterial.rollNumber;
    request.fields['subject'] = studyMaterial.subject;
    request.fields['heading'] = studyMaterial.heading;
    request.fields['fileType'] = studyMaterial.fileType;
    request.fields['updatedOn'] = studyMaterial.updatedOn;

    // Print request fields
    print('Request Fields:');
    print('id: ${studyMaterial.id}');
    print('userType: ${studyMaterial.userType}');
    print('rollNumber: ${studyMaterial.rollNumber}');
    print('subject: ${studyMaterial.subject}');
    print('heading: ${studyMaterial.heading}');
    print('fileType: ${studyMaterial.fileType}');
    print('updatedOn: ${studyMaterial.updatedOn}');

    if (file != null) {
      var fileBytes = await file.readAsBytes();
      var extension = file.path.split('.').last.toLowerCase();

      MediaType? mimeType;
      if (['jpeg', 'jpg'].contains(extension)) {
        mimeType = MediaType('image', 'jpeg');
      } else if (extension == 'png') {
        mimeType = MediaType('image', 'png');
      } else if (extension == 'webp') {
        mimeType = MediaType('image', 'webp');
      } else if (extension == 'jpg') {
        mimeType = MediaType('image', 'jpg');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Unsupported file type. Please upload an image in jpeg, jpg, png, or webp format.')),
        );
        return;
      }

      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: file.path.split('/').last,
        contentType: mimeType,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      print(response);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text('Studymaterial updated successfully.')),
      );
      print("Study Material Updated Successfully");

      final responseData = await http.Response.fromStream(response);
      print('Response: ${responseData.body}');

      await Future.delayed(Duration(seconds: 2));

      fetchstudymaterial();

      Navigator.pop(
        context,
      );
    } else {
      print(
          "Failed to update study material. Status Code: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to update study material.')),
      );
      final responseData = await http.Response.fromStream(response);
      print('Response: ${responseData.body}');
      //
      Navigator.pop(
        context,
      );
    }
  } catch (e) {
    print('Error: $e');
  }
}
