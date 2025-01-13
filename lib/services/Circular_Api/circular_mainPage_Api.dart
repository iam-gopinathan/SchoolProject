import 'dart:convert';

import 'package:flutter_application_1/models/circular_models/Circular_mainpage_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<CircularResponse>> fetchCirculars(
    String rollNumber, String userType, String isMyProject, String date) async {
  String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/circular/CircularFetch';

  final Uri url = Uri.parse(baseUrl).replace(
    queryParameters: {
      'RollNumber': rollNumber,
      'UserType': userType,
      'IsMyProject': isMyProject,
      'Date': date,
    },
  );

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      print("Decoded response data: $data");

      var circularData = data['data'] as List;
      return circularData
          .map((item) => CircularResponse.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load circulars');
    }
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}
