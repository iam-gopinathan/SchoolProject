import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/circular_models/update_Circular_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

String apiUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/updateCircular";

Future<void> updateCircular(
    CircularUpdateRequest request, context, Function fetchcircular) async {
  try {
    var uri = Uri.parse(apiUrl);
    var requestHttp = http.MultipartRequest(
      'PUT',
      uri,
    );

    requestHttp.headers.addAll({
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'multipart/form-data',
    });

    requestHttp.fields.addAll(request.toMap().map((key, value) {
      if (value is List<int>) {
        return MapEntry(key, jsonEncode(value));
      }
      return MapEntry(key, value.toString());
    }));

    if (request.filePath != null) {
      File file = File(request.filePath!);
      requestHttp.files.add(await http.MultipartFile.fromPath(
        'File',
        file.path,
      ));
    }

    var response = await requestHttp.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cicular Updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      var responseData = await response.stream.bytesToString();
      print(responseData);
      print("Circular updated successfully: $responseData");
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      fetchcircular();

      Navigator.pop(
        context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Updated Circular. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print("Failed to update circular: ${response.statusCode}");
    }
  } catch (e) {
    print("Error updating circular: $e");
  }
}
