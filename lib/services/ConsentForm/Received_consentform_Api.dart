import 'dart:convert';
import 'package:flutter_application_1/models/ConsentForm/receivedConsent_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart'; // Adjust with actual path
import 'package:http/http.dart' as http;

Future<List<ReceivedconsentModel>> fetchReceivedStudents({
  required String rollNumber,
  required String userType,
  String date = '',
  required String gradeId,
  required String section,
}) async {
  const String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/ConsentAll/ConsentFormFetchAll';

  final Uri apiUrl = Uri.parse(baseUrl).replace(queryParameters: {
    'RollNumber': rollNumber,
    'UserType': userType,
    'Date': date,
    'GradeId': gradeId,
    'Section': section,
  });

  try {
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $authToken', // Ensure this is defined or set
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = json.decode(response.body);
      print('ReceivedJSON: $decodedJson');

      // Check the structure of 'data' in the response JSON
      List<dynamic> data = decodedJson['data'];

      // Map the data from the nested structure to the consent model
      List<ReceivedconsentModel> consentModels =
          data.map((json) => ReceivedconsentModel.fromJson(json)).toList();

      return consentModels;
    } else {
      throw Exception(
          'Failed to load students. HTTP Status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching student data: $e');
  }
}
