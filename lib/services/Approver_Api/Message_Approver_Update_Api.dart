import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Approver_model/Message_update_Approver_model.dart';

import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net";

Future<void> messageApproverupdateApi(
    MessageUpdateApproverModel updateMessageee,
    context,
    Function messageFetch) async {
  final url = Uri.parse("$baseUrl/api/changeMessage/updateMessage");

  try {
    final Map<String, dynamic> data = updateMessageee.toJson();

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Message updated successfully!");
      print(response.body);
      // Print the entered data
      print("📌 Entered Data:");
      print("🆔 Message ID: ${updateMessageee.id}");
      print("📜 Message Content: ${updateMessageee.message}");
      print("📆 Scheduled Date: ${updateMessageee.scheduleOn}");
      print("🕒 Scheduled Time: ${updateMessageee.status}");
      print("📌 Status: ${updateMessageee.status}");
      print("👤 User Type: ${UserSession().userType}");
      print("👤 Action: ${updateMessageee.Action}");

      String snackBarMessage = '';
      if (UserSession().userType == 'superadmin') {
        snackBarMessage = updateMessageee.status == "schedule"
            ? 'Message Approved Successfully!'
            : 'Message Approved Successfully!';
      } else if (UserSession().userType == 'admin' ||
          UserSession().userType == 'staff') {
        snackBarMessage = updateMessageee.status == "schedule"
            ? 'Message Approved Successfully!'
            : 'Message Approved Successfully!';
      }
      if (snackBarMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(snackBarMessage),
          ),
        );
      }
      // Delay before navigation
      await Future.delayed(Duration(seconds: 2));
      messageFetch();
      Navigator.pop(context);
      //
      print(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Update Message!'),
          backgroundColor: Colors.green,
        ),
      );
      print("Failed to update message: ${response.statusCode}");
      print("Response: ${response.body}");
      // Delay before navigation
      await Future.delayed(Duration(seconds: 2));
      messageFetch();
      Navigator.pop(context);
      //
    }
  } catch (e) {
    print("Error occurred: $e");
    // Delay before navigation
    await Future.delayed(Duration(seconds: 2));
    messageFetch();
    Navigator.pop(context);
    //
  }
}
