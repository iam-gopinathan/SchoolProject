import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/TimeTable_models/Update_timeTable_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TimetableService {
  String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeTimetable/updateTimeTable";

  Future<bool> updateTimetable(
      UpdateTimetableModel model, File file, context) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl))
        ..headers.addAll({
          'Authorization': 'Bearer $authToken',
        })
        ..fields['Id'] = model.id.toString()
        ..fields['userType'] = model.userType
        ..fields['rollNumber'] = model.rollNumber
        ..fields['fileType'] = model.fileType
        ..fields['updatedOn'] = model.updatedOn;

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', 'jpg'),
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        print("Timetable updated successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Timetable updated successfully.')),
        );
        return true;
      } else {
        print(
            "Failed to update timetable. Status Code: ${response.statusCode}");
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(
                'Failed to update timetable. Status Code: ${response.statusCode}'));
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
