import 'dart:convert';

import 'package:flutter_application_1/models/Dashboard_models/Dashboard_name_model.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<DashboardName> fetchDashboardData(
    String rollNumber, String userType) async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';

  // Construct the dashboard URL dynamically
  final String dashboardUrl =
      '$dashboardNAme' 'RollNumber=$rollNumber&UserType=$userType';

  final response = await http.get(
    Uri.parse(dashboardUrl),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print("API Response: ${response.body}");
    return DashboardName.fromJson(data);
  } else {
    throw Exception('Failed to load dashboard data');
  }
}
