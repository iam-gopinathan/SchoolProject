import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ConsentForm/Parent_Answer_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
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

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('Answer updated successfully!');
      String message =
          responseData['message'] ?? 'Response updated successfully!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      String message =
          responseData['message'] ?? 'Failed to update the response';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update feedback ${message}'),
        backgroundColor: Colors.red,
      ));
      print('Failed to update feedback ${response.body}');

      print('Failed to update the answer. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error updating answer: $error');
  }
}
