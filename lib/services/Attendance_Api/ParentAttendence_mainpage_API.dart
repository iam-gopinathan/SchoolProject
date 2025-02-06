import 'dart:convert';
import 'package:flutter_application_1/models/Attendence_models/Parent_Attendence_mainpage_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<ParentattendenceResponse?> fetchParentmainAttendanceData({
  required String userType,
  required String rollNumber,
  required String date,
}) async {
  String url =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/attendance/parentsView/regular";
  final Map<String, String> params = {
    "UserType": userType,
    "RollNumber": rollNumber,
    "Date": date,
  };

  try {
    final Uri uri = Uri.parse(url).replace(queryParameters: params);

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('parentatttt ${response.body}');
      final Map<String, dynamic> data = json.decode(response.body);
      return ParentattendenceResponse.fromJson(data);
    } else {
      print("Failed to fetch data: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error occurred while fetching attendance data: $e");
    return null;
  }
}
