import 'dart:convert';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/Message_models/Message_mainPage_model.dart';

Future<List<Post>> fetchPosts({
  required String rollNumber,
  required String userType,
  required String isMyProject,
  required String date,
}) async {
  const String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/message/MessageFetch?';

  final Uri url = Uri.parse(baseUrl).replace(
    queryParameters: {
      'RollNumber': rollNumber,
      'UserType': userType,
      'IsMyProject': isMyProject,
      'Date': date,
    },
  );

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("yyyyyyyyyyyyyyyyyyy ${response.body}");

    final Map<String, dynamic> responseData = json.decode(response.body);
    final PostResponse postResponse = PostResponse.fromJson(responseData);

    return postResponse.data;
  } else {
    throw Exception('Failed to load posts');
  }
}
