import 'dart:convert';
import 'package:flutter_application_1/models/circular_models/Circular_Approval_status_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<CircularApprovalStatusModel>> fetchCircularApprovalStatusData({
  required String rollNumber,
  required String userType,
  required String screen,
  String? status,
  String? date,
}) async {
  final String apiUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/circular/ApprovalStatusCircularFetch';

  final response = await http.get(
    Uri.parse(
        '$apiUrl?RollNumber=$rollNumber&UserType=$userType&Screen=$screen&Status=$status&Date=$date'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Approval status response: ${response.body}');

    // If the response contains a list of circular approval statuses
    final List<dynamic> data = json.decode(
        response.body)['data']; // Assuming the response contains a "data" field
    return data
        .map((json) => CircularApprovalStatusModel.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load circular approval status data');
  }
}
