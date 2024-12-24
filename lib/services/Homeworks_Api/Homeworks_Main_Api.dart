import 'dart:convert';
import 'package:flutter_application_1/models/Homework_models/HomeWorks_Main_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<HomeworkResponse> fetchHomework({
  required String rollNumber,
  required String userType,
  required String grade,
  required String section,
  required String isMyProject,
  required String date,
}) async {
  const String apiUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/homeWork/HomeWorkFetch';

  final response = await http.get(
      Uri.parse(
          '$apiUrl?RollNumber=$rollNumber&UserType=$userType&Grade=$grade&section=$section&IsMyProject=$isMyProject&Date=$date'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

  if (response.statusCode == 200) {
    print('homeworksssmain ${response.body}');
    return HomeworkResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load homework');
  }
}
