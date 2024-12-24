import 'dart:convert';
import 'package:flutter_application_1/models/TimeTable_models/Edit_timetable_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EditTimetableModel> fetchEditTimetableData(int id) async {
  final apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeTimetable/FindTimeTable?Id=$id";

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body);
      return EditTimetableModel.fromJson(data);
    } else {
      throw Exception("Failed to load timetable data");
    }
  } catch (e) {
    throw Exception("Error fetching timetable: $e");
  }
}
