import 'dart:convert';

import 'package:flutter_application_1/models/Login_models/newsArticlesModel.dart';
import 'package:http/http.dart' as http;

Future<List<NewsArticle>> fetchNews() async {
  final String bearerToken = '123';

  final response = await http.get(
    Uri.parse(
        'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/LoginNews'),
    headers: {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> newsList = json.decode(response.body)['news'];
    print(response.body);
    return newsList.map((json) => NewsArticle.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}
