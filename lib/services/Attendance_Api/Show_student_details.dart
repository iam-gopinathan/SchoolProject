import 'dart:convert';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Attendence_models/show_studentDetails.dart';

Future<ShowStudentdetails> fetchShowStudentDetails({
  required String date,
  required String grade,
  required String section,
  required String percentage,
  required String status,
}) async {
  final String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/attendanceTable'
      '?Date=$date&Grade=$grade&Section=$section&Percentage=$percentage&Status=$status';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('showwwwwwwwwwwwwwwwwwwww ${response.body}');
      final jsonData = json.decode(response.body);
      return ShowStudentdetails.fromJson(jsonData);
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching attendance data: $e');
  }
}
