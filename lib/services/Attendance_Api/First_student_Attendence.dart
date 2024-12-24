import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/First_student_attendence_model.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<AttendanceResponse> fetchAttendanceData(
    String rollNumber, String userType, DateTime date) async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';

  // Format the date for API endpoint
  final String formattedDate = DateFormat('dd-MM-yyyy').format(date);

  // Construct the dashboard URL dynamically
  final String attendencepagetotalstudent = '$totalstudentgraph'
      'RollNumber=$rollNumber&UserType=$userType&Date=$formattedDate';
  // const String baseUrl =
  // 'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/attendance/barchart?RollNumber=$rollNumber&UserType=$userType&Date=01-12-2024';

  try {
    final response = await http.get(
      Uri.parse(attendencepagetotalstudent),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Response data totalllllllll: ${response.body}');
      return AttendanceResponse.fromJson(data);
    } else {
      print('Failed response: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load attendance data');
    }
  } catch (e) {
    print('Error occurred: $e');
    throw Exception('Error: $e');
  }
}
