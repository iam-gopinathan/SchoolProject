import 'dart:convert';
import 'package:flutter_application_1/models/Feedback_models/Received_feedback_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<ReceivedFeedbackModel?> fetchReceivedFeedback({
  required String rollNumber,
  required String userType,
  required String date,
  required String gradeId,
  required String section,
}) async {
  String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBackAll/feedBackFetchAll';
  final Uri uri = Uri.parse(url).replace(queryParameters: {
    'RollNumber': rollNumber,
    'UserType': userType,
    'Date': date,
    'GradeId': gradeId,
    'Section': section,
  });

  try {
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      print("recieved feedback ${response.body}");
      final jsonData = json.decode(response.body);
      return ReceivedFeedbackModel.fromJson(jsonData);
    } else {
      print('Failed to load feedback. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching feedback: $e');
    return null;
  }
}
