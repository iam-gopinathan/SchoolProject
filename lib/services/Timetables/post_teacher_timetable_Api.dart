import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/teachersTimeTable";

Future<bool> postTeacherTimeTable(String rollNumber, File file, context) async {
  var url = Uri.parse("$baseUrl/postTeachersTimeTable");

  var request = http.MultipartRequest("POST", url);

  request.headers['Authorization'] = 'Bearer $authToken';

  request.fields['RollNumber'] = rollNumber;

  request.files.add(await http.MultipartFile.fromPath('File', file.path));

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Timetable Created Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Print file details before upload
      print("Uploading file: ${file.path}");
      print("File name: ${file.uri.pathSegments.last}");
      print("File size: ${await file.length()} bytes");
      print("File uploaded successfully!");
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create Timetable!'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to upload file: ${response.reasonPhrase}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}
