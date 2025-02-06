import 'dart:convert';
import 'package:flutter_application_1/models/Feedback_models/Parent_feedback_edit_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net";
Future<ParentFeedbackEditModel?> fetchParentFeedbackById(int id) async {
  final String endpoint =
      "$baseUrl/api/postParentsFeedBack/findParentsFeedBackByID?Id=$id";

  try {
    final response = await http.get(Uri.parse(endpoint), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('editttt ${response.body}');
      final Map<String, dynamic> data = json.decode(response.body);
      return ParentFeedbackEditModel.fromJson(data);
    } else {
      print("Failed to load feedback: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching feedback: $e");
    return null;
  }
}
