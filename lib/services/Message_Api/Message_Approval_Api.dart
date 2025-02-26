import 'dart:convert';
import 'package:flutter_application_1/models/Message_models/Message_approval_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

const String baseUrl =
    "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/message/ApprovalStatusMessageFetch";

Future<MessageApprovalModel?> fetchMessageApproval({
  required String rollNumber,
  required String userType,
  required String date,
  required status,
  required screen,
}) async {
  try {
    // Construct the URL with parameters
    Uri url = Uri.parse(
      "$baseUrl?RollNumber=$rollNumber&UserType=$userType&Date=$date&Status=$status&Screen=$screen",
    );

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print('mesage : ${response.body}');
      final Map<String, dynamic> data = json.decode(response.body);
      return MessageApprovalModel.fromJson(data);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    print("API Error: $e");
    return null;
  }
}
