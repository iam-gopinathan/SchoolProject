import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Approver_model/Circular_update_Approver_model.dart';

import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

String apiUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/updateCircular";

Future<void> circularapproverupdate(
  CircularUpdateApproverModel request,
  BuildContext context,
  Function fetchCircular,
) async {
  try {
    var uri = Uri.parse(apiUrl);
    var requestHttp = http.MultipartRequest('PUT', uri);

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
      var responseData = await response.stream.bytesToString();
      print("Circular updated successfully: $responseData");

      // Determine the message based on user role and circular status
      String snackBarMessage = 'Circular Updated successfully!';

      if (UserSession().userType == 'superadmin') {
        if (request.status == 'post') {
          snackBarMessage = 'Circular Accepted Successfully!';
        } else if (request.status == 'schedule') {
          snackBarMessage = 'Circular Accepted Successfully!';
        }
      } else if (UserSession().userType == 'admin' ||
          UserSession().userType == 'staff') {
        if (request.status == 'post') {
          snackBarMessage = 'Circular Accepted Successfully!';
        } else if (request.status == 'schedule') {
          snackBarMessage = 'Circular Accepted Successfully!';
        }
      }
      // Ensure the widget is mounted before showing the SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackBarMessage),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Wait for 2 seconds before navigating back
      await Future.delayed(Duration(seconds: 2));

      // Ensure the widget is still mounted before navigating
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Refresh circular data
      fetchCircular();
    } else {
      // Handle failure and ensure widget is mounted
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to Update Circular. Please try again.'),
          backgroundColor: Colors.red,
        ));

        //
        Navigator.pop(context);
      }
      print("Failed to update circular: ${response.statusCode}");
    }
  } catch (e) {
    // Handle error and ensure widget is mounted
    print("Error updating circular: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }
}
