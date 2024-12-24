import 'package:flutter_application_1/models/News_Models/Edit_news_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<EditNewsModel> fetchEditNews(int id) async {
  // Prepare headers with the auth token
  final headers = {
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  };
  final response = await http.get(
    Uri.parse(
        'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeNews/FindNews?Id=$id'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    print(response.body);
    return EditNewsModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load news');
  }
}
