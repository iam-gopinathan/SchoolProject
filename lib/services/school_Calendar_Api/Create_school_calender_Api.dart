import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/School_calendar_model/Create_school_calendar_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String endpoint =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/schoolCalender/postSchoolCalender";

Future<void> postSchoolCalendar(
    CreateSchoolCalendarModel model, context) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse(endpoint));

    // Add form-data fields
    request.fields.addAll(model.toJson());

    if (model.filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'File',
          model.filePath!,
        ),
      );
    }

    request.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      HttpHeaders.contentTypeHeader: "multipart/form-data",
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();

      print("Data successfully posted: $responseBody");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calender Event posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print("Failed to post data: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to Create Event: ${response.statusCode}"),
        backgroundColor: Colors.red,
      ));
    }
  } catch (e) {
    print("Error: $e");
  }
}
