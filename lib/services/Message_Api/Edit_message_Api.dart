import 'dart:convert';
import 'package:flutter_application_1/models/Message_models/EditMessage_Models.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api';

Future<EditmessageModels?> fetchMessageById(int id) async {
  final String endpoint = '$baseUrl/changeMessage/FindMessage?Id=$id';

  try {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body);
      return EditmessageModels.fromJson(data);
    } else {
      print('Failed to fetch message: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}
