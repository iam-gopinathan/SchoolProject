import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/Post_Update_Attendence.dart';
import 'package:http/http.dart' as http;

Future<void> updateAttendance(String grade, String section, String date,
    List<PostUpdateAttendence> attendanceList) async {
  final url = Uri.parse(
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/updateAttendance");
  const String authToken = '123';

  final body = json.encode({
    'grade': grade,
    'section': section,
    'date': date,
    'details': attendanceList.map((attendance) => attendance.toJson()).toList(),
  });

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Attendance updated successfully');
    } else {
      print('Failed to update attendance. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error while updating attendance: $e');
  }
}
