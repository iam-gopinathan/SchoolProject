import 'dart:convert';

class ResetPasswordModel {
  String rollNumber;
  String userType;
  String password;

  ResetPasswordModel({
    required this.rollNumber,
    required this.userType,
    required this.password,
  });

  // Convert a model to JSON
  Map<String, dynamic> toJson() {
    return {
      "rollNumber": rollNumber,
      "userType": userType,
      "password": password,
    };
  }

  // Convert JSON to model
  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      rollNumber: json["rollNumber"],
      userType: json["userType"],
      password: json["password"],
    );
  }

  // Convert object to JSON string
  String toRawJson() => jsonEncode(toJson());
}
