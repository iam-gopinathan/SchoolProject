import 'dart:convert';
import 'package:flutter_application_1/models/Marks_models/Showmarks_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<MarksResponse> fetchShowMarksData({
  required String rollNumber,
  required String userType,
  required int gradeId,
  required String section,
  required String exam,
}) async {
  String url =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/fetchAllMarksStudents';

  final response = await http.get(
      Uri.parse(
          '$url?RollNumber=$rollNumber&UserType=$userType&GradeId=$gradeId&Section=$section&Exam=$exam'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

  if (response.statusCode == 200) {
    print('showwwwwwwmarks...${response.body}');

    return MarksResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load marks data');
  }
}
