import 'dart:convert';
import 'package:flutter_application_1/models/News_Models/News_Approval_status_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<NewsApprovalStatusModel>> fetchApprovalstatusNews({
  required String rollNumber,
  required String userType,
  required String date,
  required String status,
  required String screen,
}) async {
  final String url =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/news/ApprovalStatusNewsFetch?RollNumber=$rollNumber&UserType=$userType&Date=$date&Status=$status&Screen=$screen";

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('appr $url');
      print('newsapproval ${response.body}');
      final data = jsonDecode(response.body);
      List<dynamic> newsList = data['data'];
      return newsList
          .map((news) => NewsApprovalStatusModel.fromJson(news))
          .toList();
    } else {
      throw Exception("Failed to load news");
    }
  } catch (e) {
    throw Exception("Error fetching news: $e");
  }
}
