// api_service.dart

import 'dart:convert';
import 'package:flutter_application_1/models/Exam_Timetable/Exam_timetable_Main_Model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<ExamTimetableMainModel>> fetchExamTimetable({
  required String rollNumber,
  required String userType,
  required String grade,
  required String isMyProject,
  required String exam,
}) async {
  const String apiUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/ExamtimeTable/ExamTimeTableFetch';

  try {
    final Map<String, String> queryParams = {
      'RollNumber': rollNumber,
      'UserType': userType,
      'Grade': grade,
      'IsMyProject': isMyProject,
      'Date': '',
      'Exam': exam,
    };

    final response = await http
        .get(Uri.parse(apiUrl).replace(queryParameters: queryParams), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      print('exammmmmmmm ${response.body}');

      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> timetableData = data['data'];

      return timetableData
          .map((examData) => ExamTimetableMainModel.fromJson(examData))
          .toList();
    } else {
      throw Exception('Failed to load exam timetable');
    }
  } catch (e) {
    throw Exception('Error fetching exam timetable: $e');
  }
}
