import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/TimeTable_models/create_timeTable_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const String apiUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/timetable/postTimeTable";

Future<void> postTimeTable(CreateTimetableModel timeTable,
    PlatformFile selectedFile, context, Function fetchMaintimetable) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );

    if (selectedFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedFile.path!,
        contentType: MediaType('image', selectedFile.extension ?? 'jpeg'),
      ));
    }

    // Log selectedFile details (path and extension)
    print('Selected file path: ${selectedFile.path}');
    print('Selected file extension: ${selectedFile.extension}');

    // Log the values of the timeTable fields
    print('Grade ID: ${timeTable.gradeId}');
    print('Section: ${timeTable.section}');
    print('User Type: ${timeTable.userType}');
    print('Roll Number: ${timeTable.rollNumber}');
    print('File Type: ${timeTable.fileType}');
    print('Status: ${timeTable.status}');
    print('Posted On: ${timeTable.status == "post" ? timeTable.postedOn : ""}');
    print(
        'Drafted On: ${timeTable.status == "draft" ? timeTable.draftedOn : ""}');

    request.fields['gradeId'] = timeTable.gradeId.toString();
    request.fields['section'] = timeTable.section;
    request.fields['userType'] = timeTable.userType;
    request.fields['rollNumber'] = timeTable.rollNumber;
    request.fields['fileType'] = timeTable.fileType;
    request.fields['status'] = timeTable.status;
    request.fields['postedOn'] =
        timeTable.status == "post" ? timeTable.postedOn : "";
    request.fields['draftedOn'] =
        timeTable.status == "draft" ? timeTable.draftedOn : "";

    request.headers['Authorization'] = 'Bearer $authToken';

    var response = await request.send();

    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print(
        'TimeTable posted successfully: ${response.statusCode}',
      );
      print('Response body: $response');
      if (timeTable.status == 'draft') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('TimeTable Saved as Draft!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('TimeTable Created Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      //
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      fetchMaintimetable();

      Navigator.pop(
        context,
      );
    }
    // else {
    //   print('Failed to post TimeTable: ${response.statusCode}');
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Failed to post TimeTable. Please try again.'),
    //     backgroundColor: Colors.red,
    //   ));
    // }
    else {
      try {
        // Parse JSON response and show dynamic error message
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        String errorMessage =
            jsonResponse['message'] ?? "Unknown error occurred.";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
//
        await Future.delayed(Duration(seconds: 2));
        await Future.delayed(Duration(seconds: 2));
        fetchMaintimetable();
        Navigator.pop(context);

        print("Error: $errorMessage");
      } catch (e) {
        print("Error: $e");
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
