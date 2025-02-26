import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

Future<void> updateCircularApprovalAction({
  required String id,
  required String rollNumber,
  required String userType,
  required String action,
  required String reason,
}) async {
  String baseUrl =
      'https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/changeCircular/updateCircularApprovalAction';

  final Map<String, String> queryParams = {
    'Id': id,
    'RollNumber': rollNumber,
    'UserType': userType,
    'Action': action,
    'Reason': reason,
  };

  Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  try {
    final response = await http.put(uri, headers: headers);

    if (response.statusCode == 200) {
      print('News approval updated successfully!');
      print('Response: ${response.body}');
    } else {
      print(
          'Failed to update news approval. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error updating news approval: $e');
  }
}
