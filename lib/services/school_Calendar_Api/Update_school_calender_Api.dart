import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/School_calendar_model/Update_school_calender_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const String updateUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeSchoolCalender/updateSchoolCalender';

Future<void> updateSchoolCalendarApi(UpdateSchoolCalendarModel model, context,
    Function fetchStudentCalendar) async {
  try {
    var request = http.MultipartRequest('PUT', Uri.parse(updateUrl));

    request.headers['Authorization'] = 'Bearer $authToken';
    request.fields['id'] = model.id.toString();
    request.fields['userType'] = model.userType;
    request.fields['rollNumber'] = model.rollNumber;
    request.fields['headLine'] = model.headLine;
    request.fields['description'] = model.description;
    request.fields['fileType'] = model.fileType;
    request.fields['link'] = model.link;
    request.fields['updatedOn'] = model.updatedOn;

    if (model.filePath.isNotEmpty) {
      File file = File(model.filePath);

      if (await file.exists()) {
        var fileBytes = await file.readAsBytes();

        String contentType = 'application/octet-stream';
        if (model.filePath.endsWith('.png')) {
          contentType = 'image/png';
        } else if (model.filePath.endsWith('.jpg') ||
            model.filePath.endsWith('.jpeg')) {
          contentType = 'image/jpeg';
        }

        var multipartFile = http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: file.path.split('/').last,
          contentType: MediaType.parse(contentType),
        );

        request.files.add(multipartFile);
      } else {
        print("File does not exist at the specified path: ${model.filePath}");
      }
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Request Headers: ${request.headers}");

      print("Form Fields: ");
      print(
          "ID: ${model.id}, UserType: ${model.userType}, RollNumber: ${model.rollNumber}");
      print("Headline: ${model.headLine}, Description: ${model.description}");
      print(
          "File Type: ${model.fileType}, Link: ${model.link}, Updated On: ${model.updatedOn}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('School calender Updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print('School calendar updated successfully');
      //
      // Add a delay of 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));
      //
      fetchStudentCalendar();

      Navigator.pop(
        context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Update schoolcalender. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print(
          'Failed to update school calendar. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating school calendar: $e');
  }
}
