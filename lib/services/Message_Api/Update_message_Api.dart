import 'dart:convert';
import 'package:flutter_application_1/models/Message_models/Update_message_Models.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net";

Future<void> updateMessage(UpdateMessageModel updateMessage) async {
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
    } else {
      print("Failed to update message: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}
