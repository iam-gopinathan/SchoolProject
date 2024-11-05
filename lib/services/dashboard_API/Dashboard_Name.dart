import 'dart:convert';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_name_model.dart';
import 'package:http/http.dart' as http;

Future<DashboardName> fetchDashboardData(
    String rollNumber, String userType) async {
  final String token = '123';
  final response = await http.get(
    Uri.parse(
      'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Dashboard/DashboardUsers?RollNumber=$rollNumber&UserType=$userType',
    ),
    headers: {
      'Authorization': 'Bearer $token',
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
