import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/models/Exam_Timetable/create_ExamTimetables.dart';

Future<void> CreateExamTimeTable(createExamtimetablesModel examTimeTable,
    PlatformFile selectedFile, context, Function fetchmainexam) async {
  const String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/examtimetable/postexamtimetable";

  try {
    final Map<String, String> formData = examTimeTable
        .toJson()
        .map((key, value) => MapEntry(key, value.toString()));
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $authToken';
    // Add form data
    formData.forEach((key, value) {
      request.fields[key] = value;
    });
    // Add the file to the request
    if (selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedFile.path!,
        filename: selectedFile.name,
      ));
    }
    var response = await request.send();

    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("Data posted successfully.");

      if (examTimeTable.status == 'draft') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exam Timetable saved as Draft!'),
            backgroundColor: Colors.green, // Different color for draft
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exam Timetable Created Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));
      fetchmainexam();
      Navigator.pop(context);
    } else {
      try {
        // Parse JSON response and show dynamic error message
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        String errorMessage =
            jsonResponse['message'] ?? "Unknown error occurred.";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
//
        await Future.delayed(Duration(seconds: 2));
        fetchmainexam();
        Navigator.pop(context);

        print("Error: $errorMessage");
      } catch (e) {
        print("Error: $e");
      }
    }
  } catch (e) {
    print("Error: $e");
  }
}
