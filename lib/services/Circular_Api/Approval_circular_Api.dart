import 'dart:convert';
import 'package:flutter_application_1/models/circular_models/Approval_circular_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String _baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net";
Future<ApprovalCircularModel> fetchApprovalCirculars({
  required String rollNumber,
  required String userType,
  required String screen,
  required String status,
  required String date,
}) async {
  try {
    String url = "$_baseUrl/api/circular/ApprovalStatusCircularFetch";

    // Query parameters
    Map<String, dynamic> queryParams = {
      "RollNumber": rollNumber,
      "UserType": userType,
      "Screen": screen,
      if (status.isNotEmpty) "Status": status,
      if (date.isNotEmpty) "Date": date,
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('appro circ ${response.body}');

      // Convert response to ApprovalCircularModel instead of List<CircularPost>
      ApprovalCircularModel circularResponse =
          ApprovalCircularModel.fromJson(data);
      return circularResponse;
    } else {
      throw Exception("Failed to load data: ${response.reasonPhrase}");
    }
  } catch (e) {
    throw Exception("API Error: $e");
  }
}
