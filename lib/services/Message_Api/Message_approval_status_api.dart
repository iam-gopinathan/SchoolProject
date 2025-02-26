import 'dart:convert';
import 'package:flutter_application_1/models/Message_models/Message_approval_status_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/message";

Future<List<MessageApprovalStatusModel>> fetchMessagesAppStatus({
  required String rollNumber,
  required String userType,
  required date,
  required String status,
  required String screen,
}) async {
  final Uri url = Uri.parse(
      "$baseUrl/ApprovalStatusMessageFetch?RollNumber=$rollNumber&UserType=$userType&Date=$date&Status=$status&Screen=$screen");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      print('appro message ${response.body}');
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return MessageApprovalStatusModel.fromJsonList(jsonData['data']);
    } else {
      throw Exception("Failed to load messages");
    }
  } catch (e) {
    print("Error fetching messages: $e");
    return [];
  }
}
