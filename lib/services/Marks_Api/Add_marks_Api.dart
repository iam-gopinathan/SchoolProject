import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Marks_models/AddMarks_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';

import 'package:http/http.dart' as http;

const String _baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api";

Future<void> postMarks(MarksRequest request, context) async {
  final url = Uri.parse("$_baseUrl/postMarks");
  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);

      if (responseJson['students'] != null) {
        var studentsData = responseJson['students'];

        print(studentsData);
      }
      print('posttttt${response.body}');

      // Show different SnackBars based on status
      if (request.status == 'draft') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved as Draft Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Marks posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Wait for 2 seconds before navigating back
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });

      print("Marks posted successfully: ${response.body}");
    } else {
      print("Failed to post marks: ${response.body}");
      print("Error: ${response.body}");
      var responseJson = jsonDecode(response.body); // Convert response to JSON

      String errorMessage =
          responseJson['message'] ?? 'Something went wrong!'; // Get message

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage), // Show only the message
          backgroundColor: Colors.red,
        ),
      );
      //
      Navigator.pop(context);
    }
  } catch (e) {
    print("Error: $e");
  }
}
