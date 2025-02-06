import 'dart:convert';
import 'package:flutter_application_1/models/ConsentForm/Parentscreen_formResponse_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/ConsentParents/parentsFetch';

Future<ConsentParentResponse> fetchConsentParentFormData(
    String rollNumber, String userType) async {
  final url = Uri.parse('$baseUrl?RollNumber=$rollNumber&UserType=$userType');

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('parentformmmm:${response.body}');
      final jsonResponse = json.decode(response.body);
      return ConsentParentResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e');
  }
}
