import 'dart:convert';
import 'package:flutter_application_1/models/Feedback_models/Questions_feedback_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<FeedbackResponse?> fetchFeedback({
  required String rollNumber,
  required String userType,
  String date = '',
  String isMyProject = 'Y',
}) async {
  String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBack/FeedBackFetchFetch';

  final Map<String, String> queryParams = {
    'RollNumber': rollNumber,
    'UserType': userType,
    'Date': date,
    'IsMyProject': isMyProject,
  };

  final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

  try {
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print(uri);
      print("questionssssssss${response.body}");
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return FeedbackResponse.fromJson(jsonResponse);
    } else {
      print('Failed to load feedback: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
