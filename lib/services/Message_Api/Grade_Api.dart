import 'dart:convert';
import 'package:flutter_application_1/models/Message_models/GradeModels.dart';
import 'package:http/http.dart' as http;
import '../../utils/Api_Endpoints.dart';

Future<List<GradeGet>> fetchGrades() async {
  const url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/GradeValueFetch/GettingGrades';

  final headers = {
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  };

  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );

  if (response.statusCode == 200) {
    print(response.body);
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => GradeGet.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load grades');
  }
}
