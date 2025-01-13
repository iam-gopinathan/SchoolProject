import 'dart:convert';
import 'package:flutter_application_1/models/StudyMaterial/Edit_studyMaterial_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String apiUrl =
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeStudyMaterial/FindStudyMaterial';

Future<EditStudymaterialModel> fetchEditStudyMaterial(int id) async {
  final response = await http.get(
    Uri.parse('$apiUrl?Id=$id'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("ediiiiiiit ${response.body}");

    return EditStudymaterialModel.fromJson(json.decode(response.body));
  } else {
    print(response.body);

    throw Exception('Failed to load study material');
  }
}
