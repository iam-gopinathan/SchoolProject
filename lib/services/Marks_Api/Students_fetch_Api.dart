import 'dart:convert';
import 'package:flutter_application_1/models/Marks_models/Students_fetch_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<GradeMarkss> fetchGradeData(
    {required String UserType,
    required String rollNumber,
    required String gradeId,
    required String section}) async {
  final response = await http.get(
      Uri.parse(
          'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/marksStudent/MarksStudentsFetch?RollNumber=$rollNumber&UserType=$UserType&GradeId=$gradeId&Section=$section'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      });

  if (response.statusCode == 200) {
    print(response);
    print('mar ${response.body}');
    return GradeMarkss.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load grade data');
  }
}
