import 'dart:convert';
import 'package:flutter_application_1/models/School_calendar_model/Main_fetch_school_calendar_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EventsResponse> fetchEvents({
  required String userType,
  required String rollNumber,
  required String date,
}) async {
  final url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeSchoolCalender/FetchAllSchoolCalenderEvents'
      '?UserType=$userType&RollNumber=$rollNumber&Date=$date';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(url);
      print('Event Response: ${response.body}');

      if (data['todayEvents'] is List) {
        EventsResponse eventsResponse = EventsResponse.fromJson({
          'todayEvents': data['todayEvents'],
          'upcomingEvents': data['upCommingEvents'],
          'allEvents': data['allEvents'],
        });

        return eventsResponse;
      } else {
        throw Exception('Unexpected data format in API response.');
      }
    } else {
      throw Exception(
          'Failed to load events: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error fetching events: $e');
    rethrow;
  }
}
