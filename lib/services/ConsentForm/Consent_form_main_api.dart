import 'dart:convert';
import 'package:flutter_application_1/models/ConsentForm/Consentform_main_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/Consent/ConsentFetchFetch";

Future<ConsentFetchResponse> fetchConsentData({
  required String rollNumber,
  required String userType,
  required String isMyProject,
  String? date,
}) async {
  final Uri url = Uri.parse(baseUrl).replace(queryParameters: {
    'RollNumber': rollNumber,
    'UserType': userType,
    'IsMyProject': isMyProject,
    'Date': date ?? '',
  });

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print('constent url $url');
      final data = json.decode(response.body);
      print('Raw response: ${response.body}');
      print('Parsed data: $data');
      return ConsentFetchResponse.fromJson(data);
    } else {
      throw Exception(
          'Failed to fetch consent data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching consent data: $e');
  }
}
