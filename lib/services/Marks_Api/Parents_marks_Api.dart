import 'dart:convert';
import 'package:flutter_application_1/models/Marks_models/ParentMarks_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String _baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/marksParents/parentsFetchMarks";

Future<ParentmarksModel> fetchParentMarks(
    {required rollNumber, required userType}) async {
  final Uri url =
      Uri.parse("$_baseUrl?RollNumber=$rollNumber&UserType=$userType");

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    print('parentmarks ${response.body}');
    final Map<String, dynamic> json = jsonDecode(response.body);
    return ParentmarksModel.fromJson(json);
  } else {
    throw Exception("Failed to load marks");
  }
}
