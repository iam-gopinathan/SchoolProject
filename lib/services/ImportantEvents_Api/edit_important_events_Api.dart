import 'dart:convert';
import 'package:flutter_application_1/models/ImportantEvents_models/Edit_important_event_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<EditImportantEventModel?> fetchEditEventDetails(String id) async {
  final String apiUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeEventCalender/FindEventCalender?Id=$id";

  try {
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print("Edit Important Event Data: ${response.body}");
      final jsonResponse = json.decode(response.body);
      return EditImportantEventModel.fromJson(jsonResponse);
    } else {
      print('Failed to load data: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
