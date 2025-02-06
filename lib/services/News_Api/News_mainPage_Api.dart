import 'dart:convert';
import 'package:flutter_application_1/models/News_Models/NewsMainPage_model.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String Url =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/news/NewsFetch';
Future<List<NewsResponse>> fetchMainNews({
  required String date,
  required String isMyProject,
}) async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';

  final String url =
      '$Url?RollNumber=$rollNumber&UserType=$userType&Date=$date&IsMyProject=$isMyProject';

  print('URL: $url');

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    // Debugging: Print rollNumber and userType to verify their values
    print('Roll Number: $rollNumber');
    print('User Type: $userType');

    print('Response status: ${response.statusCode}'); // Log the status code
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((item) => NewsResponse.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load news, Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching news: $e');
  }
}
