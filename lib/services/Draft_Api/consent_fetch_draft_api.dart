import 'dart:convert';
import 'package:flutter_application_1/models/DraftModels/Consent_fetch_draft_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

class ApiServiceconsent {
  Future<ConsentFetchDraftModel?> fetchConsentDraft({
    required String rollNumber,
    required String userType,
    required String date,
  }) async {
    final String apiUrl =
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/Consent/ConsentFetchFetchDradt?RollNumber=$rollNumber&UserType=$userType&Date=$date';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('consent draft ${response.body}');
        final jsonData = json.decode(response.body);
        return ConsentFetchDraftModel.fromJson(jsonData);
      } else {
        print("Failed to load data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }
}
