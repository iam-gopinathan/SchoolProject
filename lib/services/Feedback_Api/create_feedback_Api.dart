import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/create_feedback_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String _baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/FeedBack/postFeedBack";

Future<void> CreateFeedbackss(
    CreateFeedbackModel feedbackModel, context) async {
  try {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        "Content-Type": "application/json",
      },
      body: jsonEncode(feedbackModel.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Parse response if needed
      print("Feedback submitted successfully: ${response.body}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create Feedback. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print(
          "Failed to submit feedback. Status code: ${response.statusCode}, Error: ${response.body}");
    }
  } catch (e) {
    print("Error occurred while submitting feedback: $e");
  }
}
