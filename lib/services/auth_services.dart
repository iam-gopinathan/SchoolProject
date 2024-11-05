import 'dart:convert';
import 'package:flutter_application_1/user_Session.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    var token = '123';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String url =
        'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Login';

    print('Login URL: $url');

    Map<String, String> requestBody = {
      'userName': username,
      'password': password,
    };

    try {
      print('Sending request...');

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestBody),
      );

      print('Request sent. Awaiting response...');

      // Check for response status code
      if (response.statusCode == 200) {
        String responseBody = response.body;
        print('Response: $responseBody');

        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        if (jsonResponse['error'] == false) {
          String rollNumber = jsonResponse['data']['rollNumber'];
          String userType = jsonResponse['data']['userType'];
          UserSession().setUserInfo(rollNumber, userType);
          return {
            'success': true,
            'message': jsonResponse['data']['message'],
            'rollNumber': jsonResponse['data']['rollNumber'],
            'userType': jsonResponse['data']['userType'],
            'grade': jsonResponse['data']['grade'],
            'section': jsonResponse['data']['section'],
          };
        } else {
          String errorMessage =
              jsonResponse['data']['message'] ?? 'Error occurred';
          return {
            'success': false,
            'message': errorMessage,
            'rollNumber': null,
            'userType': null,
            'grade': null,
            'section': null,
          };
        }
      } else {
        String responseBody = response.body;
        print('Error: Response status code ${response.statusCode}');

        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        String errorMessage = jsonResponse['data']?['message'] ??
            'Server error: ${response.statusCode}';

        return {
          'success': false,
          'message': errorMessage,
          'rollNumber': null,
          'userType': null,
          'grade': null,
          'section': null,
        };
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e',
        'rollNumber': null,
        'userType': null,
        'grade': null,
        'section': null,
      };
    }
  }
}
