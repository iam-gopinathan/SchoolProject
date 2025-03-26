import 'dart:convert';
import 'package:flutter_application_1/models/DraftModels/news_fetch_draft_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

class NewsDraftApi {
  Future<NewsFetchDraftModel?> fetchNews(
      {required String rollNumber,
      required String userType,
      required String date}) async {
    String url =
        "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/news/NewsFetchDraft";

    try {
      final response = await http.get(
          Uri.parse(
              "$url?RollNumber=$rollNumber&UserType=$userType&Date=$date"),
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('draft fetch ${response.body}');
        return NewsFetchDraftModel.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}
