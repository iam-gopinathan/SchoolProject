import 'dart:convert';
import 'package:flutter_application_1/models/Dashboard_models/dashboard_Management_count.dart';
import 'package:http/http.dart' as http;

Future<DashboardManagementCount> fetchDashboardCount(
    String rollNumber, String userType) async {
  final String token = '123';

  final response = await http.get(
    Uri.parse(
        'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Dashboard/DashboardManagement?RollNumber=$rollNumber&UserType=$userType'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    final dashboardData =
        DashboardManagementCount.fromJson(jsonDecode(response.body));

    print(
        'Curriculum Management Count: ${dashboardData.curriculamManagementCount}');
    print(
        'Facilities Management Count: ${dashboardData.facilitiesManagementCount}');
    print(
        'Performance Metrics Count: ${dashboardData.performanceMetricsCount}');
    print('Parents Feedback Count: ${dashboardData.parentsFeedbackCount}');

    return dashboardData;
  } else {
    throw Exception('Failed to load dashboard data');
  }
}
