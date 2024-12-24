import 'dart:convert';
import 'package:flutter_application_1/models/Dashboard_models/Dashboard_teacherBirthday.dart';
import 'package:flutter_application_1/user_Session.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<List<Birthday>> fetchBirthdayData(String category) async {
  final String rollNumber = UserSession().rollNumber ?? '';
  final String userType = UserSession().userType ?? '';

  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  final String staffbirthdays = '$teachersBirthday'
      'RollNumber=$rollNumber&UserType=$userType&Date=$formattedDate';

  final response = await http.get(
    // Uri.parse(
    //     'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Dashboard/DashboardBirthday?RollNumber=$rollNumber&UserType=$userType&Date=$formattedDate'),
    Uri.parse(staffbirthdays),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final Map<String, dynamic> staffBirthdays = jsonResponse['staffsbirthday'];
    print('Birthdayyyyyyyyyyy......$jsonResponse');

    List<Birthday> birthdayList = [];
    if (staffBirthdays[category] != null) {
      for (var item in staffBirthdays[category]) {
        birthdayList.add(Birthday.fromJson(item));
      }
    }

    return birthdayList;
  } else {
    throw Exception('Failed to load birthday data');
  }
}
