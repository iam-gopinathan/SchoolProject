import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/circular_models/Create_Circular_model.dart';
import 'package:flutter_application_1/services/Circular_Api/circular_mainPage_Api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

Future<void> postCircular(CreateCircularModel circular, selectedFile, context,
    Function fetchcircular) async {
  try {
    final uri = Uri.parse(
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/circular/postCircular');

    final request = http.MultipartRequest('POST', uri);

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $authToken',
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    request.headers.addAll(headers);

    request.fields['HeadLine'] = circular.headline;
    request.fields['Circular'] = circular.circular;
    request.fields['UserType'] = circular.userType;
    request.fields['RollNumber'] = circular.rollNumber;
    request.fields['PostedOn'] = circular.postedOn;
    request.fields['Status'] = circular.status;
    request.fields['ScheduleOn'] = circular.scheduleOn;
    request.fields['DraftedOn'] = circular.draftedOn;
    request.fields['FileType'] = circular.fileType;
    request.fields['Link'] = circular.link;
    request.fields['Recipient'] = circular.recipient;
    request.fields['GradeIds'] = circular.gradeIds;

    if (selectedFile != null) {
      String fileName = basename(selectedFile.path);
      request.files.add(await http.MultipartFile.fromPath(
        'File',
        selectedFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text('Circular posted successfully!')),
      );

      print('Circular posted successfully');
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      fetchcircular();

      Navigator.pop(
        context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to post circular: ${response.statusCode}')),
      );
      print('Failed to post circular: ${response.statusCode}');
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  } catch (e) {
    print('Error posting circular: $e');
  }
}
