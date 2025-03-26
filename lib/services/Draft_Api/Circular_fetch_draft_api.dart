import 'dart:convert';
import 'package:flutter_application_1/models/DraftModels/Circular_fetch_draft_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/circular";

  Future<CircularFetchDraftModel?> fetchDraftCirculars(
      {required String rollNumber,
      required String userType,
      required String date}) async {
    final Uri url = Uri.parse(
        "$baseUrl/CircularFetchDraft?RollNumber=$rollNumber&UserType=$userType&Date=$date");

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('draft circular ${response.body}');
        return CircularFetchDraftModel.fromJson(json.decode(response.body));
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
