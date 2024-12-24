import 'dart:convert';
import 'package:flutter_application_1/models/TimeTable_models/Main_timetable_model.dart';
import 'package:http/http.dart' as http;
import '../../utils/Api_Endpoints.dart';

const String apiUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/timeTable/TimeTableFetch";

Future<List<MainTimetableModel>> fetchTimeTableData({
  required String rollNumber,
  required String userType,
  required String grade,
  required String isMyProject,
}) async {
  try {
    print("Fetching timetable with the following parameters:");
    print("RollNumber: $rollNumber");
    print("UserType: $userType");
    print("Grade: $grade");
    print("IsMyProject: $isMyProject");

    final fullUrl = Uri.parse(
        '$apiUrl?RollNumber=$rollNumber&UserType=$userType&Grade=$grade&IsMyProject=$isMyProject');

    print('Request URL: $fullUrl');

    final response = await http.get(fullUrl, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
      'Cache-Control': 'no-cache',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print(response.body);

      List<dynamic> timeTableData = data['data'];
      List<MainTimetableModel> timeTableList = timeTableData
          .map((item) => MainTimetableModel.fromJson(item))
          .toList();

      return timeTableList;
    } else {
      throw Exception('Failed to load timetable data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
