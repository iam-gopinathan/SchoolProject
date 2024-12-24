import 'dart:convert';

import 'package:flutter_application_1/models/Attendence_models/Studentscounts_piechart.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<AttendanceData> fetchPiechartAttendanceData(
    String rollNumber, String userType) async {
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';

  // Construct the dashboard URL dynamically
  final String attendencepagepiechart = '$studentcountpiechart'
      'RollNumber=$rollNumber&UserType=$userType&Date=$currentDate';

  try {
    final response = await http.get(
      // Uri.parse(
      //     'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/attendance/piechart?RollNumber=admin@123&UserType=admin&Date=01-12-2024'),

      Uri.parse(attendencepagepiechart),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> json = jsonDecode(response.body);
      return AttendanceData.fromJson(json);
    } else {
      throw Exception('Failed to load attendance data');
    }
  } catch (e) {
    print('Error fetching data: $e');
    rethrow;
  }
}
