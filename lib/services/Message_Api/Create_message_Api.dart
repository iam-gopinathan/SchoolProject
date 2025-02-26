import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Message_models/CreateMessage_Models.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:http/http.dart' as http;
import '../../utils/Api_Endpoints.dart';

Future<void> CreateMessage(
  CreatemessageModels newMessage,
  BuildContext context,
  Function messageFetch,
) async {
  const String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/Message/postMessage';

  // Log the API details
  print("API URL: $url");
  print("Headers: ${{
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  }}");
  print("Request Body: ${json.encode(newMessage.toJson())}");

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(newMessage.toJson()),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print('Message posted successfully: ${response.body}');

      String snackBarMessage = '';
      if (UserSession().userType == 'superadmin') {
        snackBarMessage = 'Message Created Successfully!';
      } else if (UserSession().userType == 'admin' ||
          UserSession().userType == 'staff') {
        snackBarMessage = 'Message Creation Request Was Sent Successfully!';
      }
      if (snackBarMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(snackBarMessage),
          ),
        );
      }

      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));
      messageFetch();
      Navigator.pop(context);
    } else if (response.statusCode == 404) {
      print(
          'Error: Endpoint not found. Check the API URL or backend configuration.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Create Message!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));
      messageFetch();

      Navigator.pop(
        context,
      );
    } else {
      print('Failed to post message: ${response.statusCode}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Create Message!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));
      messageFetch();

      Navigator.pop(
        context,
      );
    }
  } catch (e) {
    print('Error posting message: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to Create Message!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    // Add a delay of 2 seconds before navigating
    await Future.delayed(Duration(seconds: 2));
    messageFetch();

    Navigator.pop(
      context,
    );
  }
}
