import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/Reset_password/reset_password_model.dart';
import 'package:flutter_application_1/utils/Api_Endpoints.dart';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static const String _baseUrl =
      "https://schoolcommunication-gmdtekepd3g3ffb9.canadacentral-01.azurewebsites.net/api/ResetPassword";

  Future<String> resetPassword(ResetPasswordModel model, context) async {
    try {
      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
        body: model.toRawJson(),
      );

      if (response.statusCode == 200) {
        // Show a Snackbar based on response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your password has been reset successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        //
        // Wait for 2 seconds before navigating back
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context); // Navigate back

        return "Password reset successful: ${response.body}";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset password! please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        // Wait for 2 seconds before navigating back
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context); // Navigate back

        return "Failed: ${response.statusCode}, ${response.body}";
        //
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
