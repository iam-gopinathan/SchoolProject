import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/TimeTable_models/Update_teacher_timetable_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/teachersTimeTable";

// Update Teacher Timetable API (PUT request)
Future updateTeacherTimeTable(
    UpdateTeacherTimetableModel model, context) async {
  var url = Uri.parse("$baseUrl/updateTeachersTimeTable");

  var request = http.MultipartRequest("PUT", url); // Using PUT request

  // Adding authorization header
  request.headers['Authorization'] = 'Bearer $authToken';

  // Adding RollNumber as a form field
  request.fields['RollNumber'] = model.rollNumber;

  // Printing file details for debugging purposes
  print("Uploading file: ${model.file.path}");
  print("File name: ${model.file.uri.pathSegments.last}");
  print("File size: ${await model.file.length()} bytes");

  // Adding the file to the request
  request.files.add(await http.MultipartFile.fromPath('File', model.file.path));

  try {
    // Sending the PUT request
    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Timetable Updated Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print("File updated successfully!");
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to post TimeTable. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print("Failed to update timetable: ${response.reasonPhrase}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}
