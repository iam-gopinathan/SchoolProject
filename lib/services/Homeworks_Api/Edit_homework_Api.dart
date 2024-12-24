import 'dart:convert';
import 'package:flutter_application_1/models/Homework_models/EditHomework_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EdithomeworkModel> fetchHomework(int id) async {
  final url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeHomeWork/FindHomeWork?Id=$id';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      return EdithomeworkModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load homework');
    }
  } catch (e) {
    throw Exception('Error fetching homework: $e');
  }
}
