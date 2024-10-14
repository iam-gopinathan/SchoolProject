import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    var token = '123';

    var headers = {
      'Authorization': 'Bearer $token',
    };

    String url =
        'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/Login?UserName=$username&Password=$password';

    print('Login URL: $url');

    try {
      print('Sending request...');

      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Request sent. Awaiting response...');

      String responseBody = response.body;
      print('Response: $responseBody');

      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      return {
        'success': jsonResponse['success'] ?? false,
        'userType': jsonResponse['userType'],
        'grade': jsonResponse['grade'],
        'section': jsonResponse['section'],
        'message': jsonResponse['message'] ?? 'Invalid username or password',
      };
    } catch (e) {
      print('Exception occurred: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e',
        'userType': null,
        'grade': null,
        'section': null,
      };
    }
  }
}
