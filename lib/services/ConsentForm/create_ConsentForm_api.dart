import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ConsentForm/Create_consentForm_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net";

Future<void> CreateConsentForm(
    CreateConsentformModel request, context, Function fetch) async {
  final String endpoint = "/api/ConsentForm/postConsentForm";
  final url = Uri.parse(baseUrl + endpoint);

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ConsentForm posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      print("Success: ${response.body}");

      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      fetch();

      Navigator.pop(
        context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Create ConsentForm. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Exception occurred: $e");
  }
}
