import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Feedback_models/ParentFeedback_main_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String _baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/feedBackParents/parentsFetch";

// Future<ParentFeedbackResponse?> fetchParentFeedbackMain({
//   required String rollNumber,
//   required String userType,
//   required String isMyFeedback,
//   required BuildContext context,
// }) async {
//   print(
//       'API call with RollNumber: $rollNumber, UserType: $userType, IsMyFeedback: $isMyFeedback');
//   try {
//     final uri = Uri.parse(
//         "$_baseUrl?RollNumber=$rollNumber&UserType=$userType&IsMyFeedBack=$isMyFeedback");

//     final response = await http.get(
//       uri,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $authToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       print('roolllllnummmmm ${rollNumber}');

//       print('Parentmainnnnn ${response.body}');
//       final jsonResponse = json.decode(response.body);
//       return ParentFeedbackResponse.fromJson(jsonResponse);
//     } else {
//       print('uriii $uri');
//       print("Failed to fetch feedback data: ${response.body}");

//       return null;
//     }
//   } catch (e) {
//     print("An error occurred: $e");

//     return null;
//   }
// }

Future<dynamic> fetchParentFeedbackMain({
  required String rollNumber,
  required String userType,
  required String isMyFeedback,
  required BuildContext context,
}) async {
  print(
      'API call with RollNumber: $rollNumber, UserType: $userType, IsMyFeedback: $isMyFeedback');
  try {
    final uri = Uri.parse(
        "$_baseUrl?RollNumber=$rollNumber&UserType=$userType&IsMyFeedBack=$isMyFeedback");

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      print('roolllllnummmmm ${rollNumber}');
      print('Parentmainnnnn ${response.body}');

      final jsonResponse = json.decode(response.body);

      if (isMyFeedback == 'Y') {
        return ParentFeedbackYResponse.fromJson(jsonResponse);
      } else {
        return ParentFeedbackResponse.fromJson(jsonResponse);
      }
    } else {
      print('uriii $uri');
      print("Failed to fetch feedback data: ${response.body}");
      return null;
    }
  } catch (e) {
    print("An error occurred: $e");
    return null;
  }
}
