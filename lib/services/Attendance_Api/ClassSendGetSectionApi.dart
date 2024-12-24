import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/ClassSendGetSectionModel.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<Section>> fetchSections(String grade) async {
  final url = Uri.parse(
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/sectionsDropdown?Grade=$grade');

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': '$authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('sectionssssssssssssss${response.body}');
      final jsonResponse = json.decode(response.body);
      final sectionsResponse = SectionsResponse.fromJson(jsonResponse);
      return sectionsResponse.sections;
    } else {
      throw Exception('Failed to load sections: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching sections: $e');
  }
}
