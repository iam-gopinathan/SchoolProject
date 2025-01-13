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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Marks posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print("Marks posted successfully: ${response.body}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.body}'),
        backgroundColor: Colors.red,
      ));
      print("Failed to post marks: ${response.body}");
      print("Error: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}
