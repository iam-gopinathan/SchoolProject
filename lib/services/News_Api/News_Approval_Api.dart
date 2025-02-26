import 'dart:convert';
import 'package:flutter_application_1/models/News_Models/News_Approval_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/news/ApprovalStatusNewsFetch";
Future<NewsApprovalModel> fetchApproNews(
    {required String rollNumber,
    required String userType,
    required String screen}) async {
  final Uri uri = Uri.parse(
      "$baseUrl?RollNumber=$rollNumber&UserType=$userType&Screen=$screen");

  try {
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      print('Response: ${response.body}');

      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return NewsApprovalModel.fromJson(jsonResponse);
    } else {
      print("Error: ${response.statusCode}");
      return NewsApprovalModel(post: [], schedule: []);
    }
  } catch (e) {
    print("Exception: $e");
    return NewsApprovalModel(post: [], schedule: []);
  }
}
