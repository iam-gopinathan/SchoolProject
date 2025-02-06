import 'dart:convert';
import 'package:flutter_application_1/models/TimeTable_models/Teacher_timetable_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<TeacherTimeTable>> fetchTeachersTimeTable(
    {required String rollNumber, required String userType}) async {
  try {
    var url = Uri.parse(
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/teachersTimeTable/fetchTeachersTimeTable?RollNumber=$rollNumber&UserType=$userType');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('teacherssss ${response.body}');
      print('🔵 API Response: ${response.statusCode}');
      print('📝 Response Body: ${jsonEncode(jsonDecode(response.body))}');

      if (data['teachersTimeTableData'] != null) {
        return (data['teachersTimeTableData'] as List)
            .map((e) => TeacherTimeTable.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      print('📝 Response Body: ${jsonEncode(jsonDecode(response.body))}');

      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
}
