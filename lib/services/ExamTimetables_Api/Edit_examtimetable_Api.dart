import 'dart:convert';
import 'package:flutter_application_1/models/Exam_Timetable/Edit_ExamTimetables_model.dart';

import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EditExamtimetablesModel> fetchEditExamTimetableData(int id) async {
  String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeExamTimetable/FindExamTimeTable?Id=$id";

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("ediiiiittttt Body: ${response.body}");
      final data = json.decode(response.body);
      return EditExamtimetablesModel.fromJson(data);
    } else {
      print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      throw Exception("Failed to load timetable data");
    }
  } catch (e) {
    print("Exception caught: $e");
    throw Exception("Error fetching timetable: $e");
  }
}
