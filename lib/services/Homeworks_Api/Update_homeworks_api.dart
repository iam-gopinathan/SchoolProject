import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

import '../../models/Homework_models/Update_homework_model.dart';

Future<void> updateHomework(UpdateHomeworkRequest request, context) async {
  const String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeHomeWork/updateHomeWork';

  try {
    var requestBody = http.MultipartRequest('PUT', Uri.parse(url));

    requestBody.headers['Authorization'] = 'Bearer $authToken';
    requestBody.headers['Content-Type'] = 'multipart/form-data';

    requestBody.fields.addAll(request.toFormData());

    if (request.file != null && request.file is File) {
      requestBody.files.add(
        await http.MultipartFile.fromPath('File', (request.file as File).path),
      );
    }

    var response = await requestBody.send();

    if (response.statusCode == 200) {
      print("Homework updated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Homework updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print("Failed to update homework. Status: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Failed to update homework. Status: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ),
      );
      var responseBody = await response.stream.bytesToString();
      print("Response body: $responseBody");
    }
  } catch (e) {
    print("Error during API call: $e");
  }
}
