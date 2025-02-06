import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/Parent_EmojiFeedback_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:http/http.dart' as http;

Future<void> sendEmojiFeedback(int parentId, String emojiValue, context) async {
  final url = Uri.parse(
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBackParents/updateAnswer');

  final parentFeedback =
      ParentEmojifeedbackModel(id: parentId, answer: emojiValue);

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(parentFeedback.toJson()),
    );

    // Decode the response body
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Show an alert dialog

      String message =
          responseData['message'] ?? 'Response updated successfully!';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Success!',
              style: TextStyle(
                  fontFamily: 'semibold', fontSize: 16, color: Colors.black),
            )),
            content: Text(
              message,
              style: TextStyle(
                  fontSize: 14, color: Colors.black, fontFamily: 'semibold'),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'regular', fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );

      print('Feedback updated successfully');
    } else {
      // Decode the response body to get the message
      var responseData = json.decode(response.body);

      // Extract the message from the response
      String message = responseData['message'] ?? 'Unknown error';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update feedback ${message}'),
        backgroundColor: Colors.red,
      ));
      print('Failed to update feedback ${response.body}');
      // Show failure alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Oops!',
              style: TextStyle(
                  fontFamily: 'semibold', fontSize: 16, color: Colors.red),
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${message}!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'semibold',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppTheme.textFieldborderColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'regular', fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    print('Error: $error');
  }
}
