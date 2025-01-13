import 'dart:convert';

import 'package:flutter_application_1/models/Feedback_models/parent_feedback_fetch_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/parentsFeedBack/parentsFeedBackFetchAll';
Future<List<FeedbackData>> fetchParentFeedback({
  required String rollNumber,
  required String userType,
  required String type,
}) async {
  final Uri url = Uri.parse(baseUrl).replace(queryParameters: {
    'RollNumber': rollNumber,
    'UserType': userType,
    'type': type,
  });

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      print("Response: $responseBody");

      if (responseBody.containsKey('data')) {
        final List<dynamic> data = responseBody['data'];

        List<FeedbackData> feedbackDataList = [];

        for (var item in data) {
          if (item.containsKey('parentsFeedBack')) {
            final List<dynamic> feedbackData = item['parentsFeedBack'];

            List<ParentFeedback> feedbackList = feedbackData
                .map((json) =>
                    ParentFeedback.fromJson(json as Map<String, dynamic>))
                .toList();

            feedbackDataList.add(FeedbackData(
              postedOn: item['postedOn'],
              day: item['day'],
              parentsFeedBack: feedbackList,
            ));
          }
        }

        return feedbackDataList;
      } else {
        throw Exception('Missing "data" field in the response');
      }
    } else {
      throw Exception(
          'Failed to load feedback. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching feedback: $e');
  }
}
