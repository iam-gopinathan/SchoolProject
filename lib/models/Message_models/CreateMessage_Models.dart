class CreatemessageModels {
  String headLine;
  String message;
  String userType;
  String rollNumber;
  String status;
  String recipient;
  String gradeIds;
  String postedOn;
  String scheduleOn;
  String draftedOn;
  String updatedOn;

  CreatemessageModels({
    required this.headLine,
    required this.message,
    required this.userType,
    required this.rollNumber,
    required this.status,
    required this.recipient,
    required this.gradeIds,
    required this.postedOn,
    required this.scheduleOn,
    required this.draftedOn,
    required this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'headLine': headLine,
      'message': message,
      'userType': userType,
      'rollNumber': rollNumber,
      'status': status,
      'recipient': recipient,
      'gradeIds': gradeIds,
      'postedOn': postedOn,
      'scheduleOn': scheduleOn,
      'draftedOn': draftedOn,
      'updatedOn': updatedOn,
    };
  }

  factory CreatemessageModels.fromJson(Map<String, dynamic> json) {
    return CreatemessageModels(
      headLine: json['headLine'],
      message: json['message'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      status: json['status'],
      recipient: json['recipient'],
      gradeIds: json['gradeIds'],
      postedOn: json['postedOn'],
      scheduleOn: json['scheduleOn'],
      draftedOn: json['draftedOn'],
      updatedOn: json['updatedOn'],
    );
  }
}
