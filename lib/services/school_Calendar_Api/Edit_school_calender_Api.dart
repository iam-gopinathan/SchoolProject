import 'dart:convert';
import 'package:flutter_application_1/models/School_calendar_model/Edit_school_calendar_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EditSchoolCalendarModel> EditfetchSchoolCalendar(
  var id,
) async {
  try {
    // Make the base URL dynamic by using the passed `id`
    final String baseUrl =
        "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeSchoolCalender/FindSchoolCalender?Id=$id";

    final response = await http.get(Uri.parse(baseUrl), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print("School Calendar Details: ${response.body}");
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return EditSchoolCalendarModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load school calendar');
    }
  } catch (e) {
    throw Exception('Error fetching school calendar: $e');
  }
}
