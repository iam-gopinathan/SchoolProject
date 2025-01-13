import 'dart:convert';
import 'dart:math';
import 'package:flutter_application_1/models/StudyMaterial/StudyMaterial_MainPage_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<List<StudyMaterialModel>> fetchStudyMaterials({
  required String rollNumber,
  required String userType,
  required int grade,
  required String section,
  required String date,
  required String isMyProject,
  required String subject,
}) async {
  final url = Uri.parse(
    'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/studyMaterial/StudyMaterialFetch'
    '?RollNumber=$rollNumber&UserType=$userType&Grade=$grade&section=$section&IsMyProject=$isMyProject&Date=$date&subject=$subject',
  );

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      print(url);
      final Map<String, dynamic> responseData = json.decode(response.body);

      print('Response bodyyyyy studyyyyyyyy: ${response.body}');

      if (responseData.containsKey('data') && responseData['data'] is List) {
        final List<dynamic> data = responseData['data'];

        return data.map((json) => StudyMaterialModel.fromJson(json)).toList();
      } else {
        print(responseData);
        throw Exception(
            'Unexpected response format: Missing or invalid "data" field');
      }
    } else {
      print('Response body: ${response.body}');
      throw Exception(
          'Failed to load study materials. Status code: ${response.statusCode} ');
    }
  } catch (e) {
    print('Error fetching study materials: ${e}');
    rethrow;
  }
}
