import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/Sectionwise_barchart.dart';
import 'package:http/http.dart' as http;

Future<AttendanceDataModel> fetchsectionwise(
    String date, String grade, String section) async {
  const String apiUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/attendanceSpecific?';

  final Map<String, String> queryParams = {
    'Date': date,
    'Grade': grade,
    'Section': section,
  };

  const String token = '123';

  final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print('section wise datttttaaaaaaaa ${response.body}');
    // Parse the response into AttendanceDataModel
    return AttendanceDataModel.fromJson(data);
  } else {
    throw Exception(
        'Failed to fetch attendance data. Status: ${response.statusCode}');
  }
}
