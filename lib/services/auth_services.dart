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
    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    try {
      print('Sending request...');
      http.StreamedResponse response = await request.send();

      print('Request sent. Awaiting response...');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response: $responseBody'); // Print the full response

        // Parse the response as JSON
        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        if (jsonResponse['message'] == 'Success') {
          // Assuming success means user is authenticated
          return {
            'success': true,
            'userType': jsonResponse['userType'],
            'grade': jsonResponse['grade'],
            'section': jsonResponse['section'],
            'message': 'Login successful'
          };
        } else {
          return {'success': false, 'message': 'Invalid username or password'};
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        return {'success': false, 'message': 'Error: ${response.reasonPhrase}'};
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }
}
