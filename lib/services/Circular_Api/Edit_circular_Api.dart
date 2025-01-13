import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/circular_models/Edit_circular_models.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/FindCircular';

Future<EditCircularModels?> fetchCircularById(int id) async {
  final String url = '$baseUrl?Id=$id';
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      print(url);
      print(response.body);
      final data = jsonDecode(response.body);
      return EditCircularModels.fromJson(data);
    } else {
      debugPrint('Failed to load circular: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Error fetching circular: $e');
    return null;
  }
}
