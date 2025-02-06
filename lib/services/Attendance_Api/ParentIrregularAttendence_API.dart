import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/Parent_IrregularAttendence_Model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<ParentIrregularattendenceModel> fetchIrregularAttendance(
    {required String userType,
    required rollNumber,
    required String date}) async {
  String apiUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/parentsView/irregular';

  final Uri uri =
      Uri.parse('$apiUrl?UserType=$userType&RollNumber=$rollNumber&Date=$date');

  try {
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      print('irrregular ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);
      return ParentIrregularattendenceModel.fromJson(responseData);
    } else {
      throw Exception('Failed to load attendance data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
