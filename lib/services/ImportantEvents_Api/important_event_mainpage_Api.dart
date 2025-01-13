import 'dart:convert';
import 'package:flutter_application_1/models/ImportantEvents_models/ImportantEvent_mainpage_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EventsResponsess> fetchImportantEvents({
  required String userType,
  required String rollNumber,
  required String date,
}) async {
  final url = Uri.parse(
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeEventCalender/FetchAllSchoolCalenderEvents',
  ).replace(queryParameters: {
    'UserType': userType,
    'RollNumber': rollNumber,
    'Date': date,
  });

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print("importantttttttttt${response.body}");
      final data = json.decode(response.body);
      return EventsResponsess.fromJson(data);
    } else {
      throw Exception('Failed to load events');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}
