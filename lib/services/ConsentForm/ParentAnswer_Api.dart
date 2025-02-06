import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ConsentForm/Parent_Answer_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:flutter_application_1/utils/theme.dart';
import 'package:http/http.dart' as http;

Future<void> updateConsentAnswer(ParentAnswerModel model, context) async {
  const String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/ConsentParents/updateAnswer';

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(model.toJson()),
    );

    // Decode the response body
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Response Updated Successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      print('Answer updated successfully!');
      String message =
          responseData['message'] ?? 'Response updated successfully!';
      // Show an alert dialog
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
      //
    } else {
      String message =
          responseData['message'] ?? 'Failed to update the response';
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
            content: Text(
              "${message}!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'semibold',
              ),
              textAlign: TextAlign.center,
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

      print('Failed to update the answer. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating answer: $error');
  }
}
