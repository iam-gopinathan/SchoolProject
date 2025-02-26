import 'dart:convert';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<void> updateMessageApprovalAction({
  required String id,
  required String rollNumber,
  required String userType,
  required String action,
  required String reason,
}) async {
  // Base URL
  String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeMessage/updateMessageApprovalAction?Id=1&RollNumber=superadmin@123&UserType=superadmin&Action=accept';

  // Query Parameters
  final Map<String, String> queryParams = {
    'Id': id,
    'RollNumber': rollNumber,
    'UserType': userType,
    'Action': action,
    'Reason': reason,
  };

  // Construct URL with query parameters
  Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

  // Headers
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  try {
    // Sending PUT request
    final response = await http.put(uri, headers: headers);

    if (response.statusCode == 200) {
      print('Message approval updated successfully!');
      print('Response: ${response.body}');
    } else {
      print(
          'Failed to update Message approval. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error updating Message approval: $e');
  }
}
