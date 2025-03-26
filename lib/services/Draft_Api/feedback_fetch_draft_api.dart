import 'dart:convert';
import 'package:flutter_application_1/models/DraftModels/Feedback_fetch_draft_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

class FeedbackDraftController {
  Future<FeedBackDraftModel?> fetchFeedbackDraft({
    required String rollNumber,
    required String userType,
    required String date,
  }) async {
    String url =
        "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBack/FeedBackFetchFetchDraft?RollNumber=$rollNumber&UserType=$userType&Date=$date";

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('feedback draft ${response.body}');
        final jsonResponse = json.decode(response.body);
        return FeedBackDraftModel.fromJson(jsonResponse);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
