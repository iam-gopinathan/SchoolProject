import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/Add_Attendence_Get_Model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<AddAttendenceGetModel> fetchADDGETAttendanceData(
    String grade, String section, String date, String status) async {
  const String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api';

  final String endpoint = '/attendance/fetchAttendance';
  final url = Uri.parse(
      '$baseUrl$endpoint?Grade=$grade&Section=$section&Date=$date&Status=$status');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print('ADDDDDD GETTTTT: ${response.body}');
      final jsonResponse = json.decode(response.body);
      // Parse the response into the model
      return AddAttendenceGetModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load attendance data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
