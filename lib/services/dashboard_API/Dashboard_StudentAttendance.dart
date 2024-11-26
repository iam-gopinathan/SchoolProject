import 'dart:convert';

import 'package:flutter_application_1/models/Dashboard_models/Dashboard_StudentsAttendance.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/user_session.dart';

Future<StudentAttendanceModel> FetchStudentsAttendance() async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';
  final String token = '123';

  final studentattendance = '$studentAttendance'
      'RollNumber=$rollNumber&UserType=$userType&Date=30-11-2024';

  final response = await http.get(
    // Uri.parse(
    //   'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Dashboard/DashboardStudentsAttendance?RollNumber=$rollNumber&UserType=$userType&Date=30-11-2024',

    Uri.parse(studentattendance),

    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final studentsAttendanceData = jsonResponse['studentsAttendance'];

    print(response.body);
    return StudentAttendanceModel.fromJson(studentsAttendanceData);
  } else {
    throw Exception('Failed to load attendance data');
  }
}
