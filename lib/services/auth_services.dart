// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   Future<Map<String, dynamic>> login(String username, String password) async {
//     var token = '123';
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     String url =
//         'https://schoolcommunication-azfthrgshmgegbdc.southindia-01.azurewebsites.net/api/Login';

//     print('Login URL: $url');

//     Map<String, String> requestBody = {
//       'userName': username,
//       'password': password,
//     };

//     try {
//       print('Sending request...');

//       var response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: json.encode(requestBody),
//       );

//       print('Request sent. Awaiting response...');

//       if (response.statusCode == 200) {
//         String responseBody = response.body;
//         print('Response: $responseBody');

//         Map<String, dynamic> jsonResponse = json.decode(responseBody);

//         if (jsonResponse['error'] == false) {
//           return {
//             'success': true,
//             'message': jsonResponse['data']['message'],
//             'rollNumber': jsonResponse['data']['rollNumber'],
//             'userType': jsonResponse['data']['userType'],
//             'grade': jsonResponse['data']['grade'],
//             'section': jsonResponse['data']['section'],
//           };
//         } else {
//           return {
//             'success': false,
//             'message': jsonResponse['data']['message'] ?? 'Error occurred',
//             'rollNumber': null,
//             'userType': null,
//             'grade': null,
//             'section': null,
//           };
//         }
//       } else {
//         print('Error: Response status code ${response.statusCode}');
//         return {
//           'success': false,
//           'message': 'Server error: ${response.statusCode}',
//           'rollNumber': null,
//           'userType': null,
//           'grade': null,
//           'section': null,
//         };
//       }
//     } catch (e) {
//       print('Exception occurred: $e');
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//         'rollNumber': null,
//         'userType': null,
//         'grade': null,
//         'section': null,
//       };
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    var token = '123'; // Replace with your actual token
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Keep the authorization header
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
          // Successful login
          return {
            'success': true,
            'message': jsonResponse['data']['message'],
            'rollNumber': jsonResponse['data']['rollNumber'],
            'userType': jsonResponse['data']['userType'],
            'grade': jsonResponse['data']['grade'],
            'section': jsonResponse['data']['section'],
          };
        } else {
          // Handle specific error messages based on server response
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
        // Handle other error responses
        String responseBody = response.body;
        print('Error: Response status code ${response.statusCode}');

        // Check if the response body contains specific error details
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
