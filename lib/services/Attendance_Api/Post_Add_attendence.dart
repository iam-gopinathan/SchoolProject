import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/Post_Add_attendence.dart';
import 'package:http/http.dart' as http;

// Define the function to post attendance data
Future<void> postAttendance(String grade, String section, String date,
    List<PostAddAttendence> students) async {
  final url = Uri.parse(
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/postAttendance');

  // Create the body for the POST request
  final body = {
    "grade": grade,
    "section": section,
    "date": date,
    "details": students.map((student) => student.toJson()).toList(),
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 123', // Make sure to replace with actual token
      },
      body: jsonEncode(body), // Convert the body map to a JSON string
    );

    if (response.statusCode == 200) {
      print('Attendance submitted successfully');
    } else {
      // Log the failure and response body for debugging
      print('Failed to submit attendance: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
