import 'dart:convert';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_teacherAttendance.dart';
import 'package:intl/intl.dart';

Future<List<TeacherAttendance>> fetchTeacherAttendance() async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';

  if (rollNumber.isEmpty || userType.isEmpty) {
    throw Exception('Roll number or user type is missing');
  }

  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  final String teacheratt = '$teacherAttendance'
      'RollNumber=$rollNumber&UserType=$userType&Date=$formattedDate';

  final response = await http.get(
    // Uri.parse(
    //     'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Dashboard/DashboardTeachersAttendance?RollNumber=$rollNumber&UserType=$userType&Date=30-11-2024'),
    Uri.parse(teacheratt),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsedData = json.decode(response.body);

    if (parsedData.containsKey('teacher_attendance')) {
      final List<dynamic> attendanceList = parsedData['teacher_attendance'];
      print(attendanceList);
      return attendanceList
          .map((json) => TeacherAttendance.fromJson(json))
          .toList();
    } else {
      throw Exception('Response does not contain teacher_attendance data');
    }
  } else {
    print('Error: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load teacher attendance');
  }
}
