import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ImportantEvents_models/Create_important_event_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<bool> postEventCalendar(
    CreateImportantEventModel eventCalendar, context) async {
  final url = Uri.parse(
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/eventCalender/postEventCalender');

  try {
    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $authToken',
    });

    request.fields['UserType'] = eventCalendar.userType;
    request.fields['RollNumber'] = eventCalendar.rollNumber;
    request.fields['HeadLine'] = eventCalendar.headLine;
    request.fields['Description'] = eventCalendar.description;
    request.fields['FileType'] = eventCalendar.fileType;
    request.fields['File'] = eventCalendar.file;
    request.fields['Link'] = eventCalendar.link;
    request.fields['FromDate'] = eventCalendar.fromDate;
    request.fields['ToDate'] = eventCalendar.toDate;

    if (eventCalendar.file != null && File(eventCalendar.file!).existsSync()) {
      var file = await http.MultipartFile.fromPath(
        'File',
        eventCalendar.file!,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(file);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event posted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print("Event posted successfully");
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to post Event. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print("Failed to post event: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error: $e");
    return false;
  }
}
