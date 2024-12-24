class EditmessageModels {
  final int id;
  final String headLine;
  final String message;
  final String userType;
  final String rollNumber;
  final String status;
  final String postedOn;
  final String? scheduleOn;
  final String? draftedOn;
  final String recipient;
  final List<int> gradeIds;
  final String? updatedOn;

  EditmessageModels({
    required this.id,
    required this.headLine,
    required this.message,
    required this.userType,
    required this.rollNumber,
    required this.status,
    required this.postedOn,
    this.scheduleOn,
    this.draftedOn,
    required this.recipient,
    required this.gradeIds,
    this.updatedOn,
  });

  // Factory method to create an object from JSON
  factory EditmessageModels.fromJson(Map<String, dynamic> json) {
    return EditmessageModels(
      id: json['id'] ?? '',
      headLine: json['headLine'] ?? '',
      message: json['message'] ?? '',
      userType: json['userType'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      status: json['status'] ?? '',
      postedOn: json['postedOn'] ?? '',
      scheduleOn: json['scheduleOn'] ?? '',
      draftedOn: json['draftedOn'] ?? '',
      recipient: json['recipient'] ?? '',
      gradeIds: List<int>.from(json['gradeIds'] ?? ''),
      updatedOn: json['updatedOn'] ?? '',
    );
  }
}
