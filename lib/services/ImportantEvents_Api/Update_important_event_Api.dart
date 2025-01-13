import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/ImportantEvents_models/Update_event_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<void> updateEventCalendar(
    UpdateEventCalendarModel model, context) async {
  String _url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeEventCalender/updateEventCalender';

  try {
    var request = http.MultipartRequest('PUT', Uri.parse(_url));

    request.headers.addAll({
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'multipart/form-data',
    });

    request.fields.addAll(model.toJson());

    if (model.file.isNotEmpty) {
      var file = await http.MultipartFile.fromPath('File', model.file);
      request.files.add(file);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event Updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print('Event updated successfully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Update Event. Please try again.'),
        backgroundColor: Colors.red,
      ));
      print('Failed to update event');
    }
  } catch (e) {
    print('Error: $e');
  }
}
