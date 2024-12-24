import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/IrRegularmodels.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<Irregularmodels>> fetchAttendanceIrRegular(
    String grade, String section, String date, String status) async {
  const String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api';

  final String endpoint = '/attendance/irregularAttendees';
  final url = Uri.parse(
      '$baseUrl$endpoint?Grade=$grade&Section=$section&Date=$date&Status=$status');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print("Irregular Attendance Response: ${response.body}");
      final jsonResponse = json.decode(response.body);

      List<Irregularmodels> irregularStudents = [];

      // Parse each grade and section
      jsonResponse.forEach((gradeKey, sections) {
        sections.forEach((sectionKey, students) {
          irregularStudents.addAll(
            (students as List)
                .map((studentJson) => Irregularmodels.fromJson(studentJson))
                .toList(),
          );
        });
      });

      return irregularStudents;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
