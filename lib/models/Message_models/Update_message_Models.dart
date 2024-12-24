class UpdateMessageModel {
  int id;
  String headLine;
  String message;
  String userType;
  String rollNumber;
  String status;
  String postedOn;
  String scheduleOn;
  String recipient;
  String gradeIds;
  String updatedOn;

  UpdateMessageModel({
    required this.id,
    required this.headLine,
    required this.message,
    required this.userType,
    required this.rollNumber,
    required this.status,
    required this.postedOn,
    required this.scheduleOn,
    required this.recipient,
    required this.gradeIds,
    required this.updatedOn,
  });

  // Factory method to create an instance from JSON
  factory UpdateMessageModel.fromJson(Map<String, dynamic> json) {
    return UpdateMessageModel(
      id: json['id'],
      headLine: json['headLine'],
      message: json['message'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      status: json['status'],
      postedOn: json['postedOn'],
      scheduleOn: json['scheduleOn'],
      recipient: json['recipient'],
      gradeIds: json['gradeIds'],
      updatedOn: json['updatedOn'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'headLine': headLine,
      'message': message,
      'userType': userType,
      'rollNumber': rollNumber,
      'status': status,
      'postedOn': postedOn,
      'scheduleOn': scheduleOn,
      'recipient': recipient,
      'gradeIds': gradeIds,
      'updatedOn': updatedOn,
    };
  }
}
