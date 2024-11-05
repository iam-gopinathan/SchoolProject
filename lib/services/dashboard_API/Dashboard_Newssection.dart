import 'dart:convert';
import 'package:flutter_application_1/models/Dashboard_models/dashboard_newsModel.dart';
import 'package:http/http.dart' as http;

Future<List<News>> fetchDashboardNews(
    String rollNumber, String userType) async {
  final String token = '123';

  final response = await http.get(
    Uri.parse(
        'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Dashboard/DashboardNews&Circular?RollNumber=$rollNumber&UserType=$userType'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body)['newsDetails'];
    print("dataaaaaaaaa.......$data");
    return data.map((json) => News.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}
