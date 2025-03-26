import 'dart:convert';
import 'package:flutter_application_1/models/DraftModels/Message_fetch_draft_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

class MessageService {
  String baseUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/message";

  Future<MessageFetchDraftModel?> fetchDraftMessages(
      {required String rollNumber,
      required String userType,
      required String date}) async {
    try {
      final Uri url = Uri.parse(
          "$baseUrl/MessageFetchDraft?RollNumber=$rollNumber&UserType=$userType&Date=$date");

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('messagedraft ${response.body}');
        return MessageFetchDraftModel.fromJson(response.body);
      } else {
        print("Failed to fetch messages: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching messages: $e");
      return null;
    }
  }
}
