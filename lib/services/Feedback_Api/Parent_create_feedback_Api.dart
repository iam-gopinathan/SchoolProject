import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/Parent_create_feedback_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

String _baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/postParentsFeedBack";

Future<void> createParentFeedbacks(ParentCreateFeedbackModel feedback, context,
    Function fetchparentData, Function updateIsMyProject) async {
  try {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(feedback.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback Created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print("Feedback submitted successfully!");
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));
      updateIsMyProject('Y');
      fetchparentData();

      Navigator.pop(
        context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create Feedback. Please try again.'),
        backgroundColor: Colors.red,
      ));

      print("Failed to submit feedback: ${response.body}");
      Navigator.pop(
        context,
      );
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}
