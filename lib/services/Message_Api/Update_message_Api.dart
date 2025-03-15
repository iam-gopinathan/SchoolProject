import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Message_models/Update_message_Models.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net";

Future<void> updateMessage(
    UpdateMessageModel updateMessage, context, Function messageFetch) async {
  final url = Uri.parse("$baseUrl/api/changeMessage/updateMessage");

  try {
    final Map<String, dynamic> data = updateMessage.toJson();

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
      print("🆔 Message ID: ${updateMessage.id}");
      print("📜 Message Content: ${updateMessage.message}");
      print("📆 Scheduled Date: ${updateMessage.scheduleOn}");
      print("🕒 Scheduled Time: ${updateMessage.status}");
      print("📌 Status: ${updateMessage.status}");
      print("👤 User Type: ${UserSession().userType}");

      String snackBarMessage = '';
      if (UserSession().userType == 'superadmin') {
        snackBarMessage = updateMessage.status == "schedule"
            ? 'Message Scheduled Successfully!'
            : 'Message Updated Successfully!';
      } else if (UserSession().userType == 'admin' ||
          UserSession().userType == 'staff') {
        snackBarMessage = updateMessage.status == "schedule"
            ? 'Message Scheduling Request Sent Successfully!'
            : 'Message Update Request Was Sent Successfully!';
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
