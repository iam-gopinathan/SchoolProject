import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_application_1/models/Exam_Timetable/create_ExamTimetables.dart';

Future<void> CreateExamTimeTable(createExamtimetablesModel examTimeTable,
    PlatformFile selectedFile, context) async {
  const String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/examtimetable/postexamtimetable";

  try {
    final Map<String, String> formData = examTimeTable
        .toJson()
        .map((key, value) => MapEntry(key, value.toString()));

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.headers['Authorization'] = 'Bearer $authToken';

    // Add form data fields
    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add the image file directly to the request
    if (selectedFile != null && selectedFile.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'File',
        selectedFile.path!,
        contentType: MediaType('image', selectedFile.extension!),
      ));
    }

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      print("Data posted successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exam TimeTable posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to post Exam TimeTable. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print("Failed to post data. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
