import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/Parent_feedback_Update_models.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String apiUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/postParentsFeedBack/updateParentsFeedBack';

Future<bool> updateEditParentFeedback(ParentFeedbackUpdateModel feedbackData,
    context, Function fetchparentData, Function updateIsMyProject) async {
  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(feedbackData.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FeedBack Updated Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      //
      updateIsMyProject('Y');
      fetchparentData();

      Navigator.pop(
        context,
      );
      //

      print(response.body);

      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Updated ParentsFeedback. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print('Failed to update: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error updating feedback: $e');
    return false;
  }
}
