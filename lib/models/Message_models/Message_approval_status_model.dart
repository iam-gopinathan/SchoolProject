class MessageApprovalStatusModel {
  String status;
  String messageStatus;
  String createdByUserType;
  String createdByName;
  String createdByRollNumber;
  String onDate;
  String onDay;
  String onTime;
  int id;
  String headLine;
  String message;
  String recipient;
  List<dynamic> gradeIds;
  String? declinedByUserType;
  String? declinedByName;
  String? declinedByRollNumber;
  String? declinedOnDate;
  String? reason;
  String? requestFor;

  MessageApprovalStatusModel({
    required this.status,
    required this.messageStatus,
    required this.createdByUserType,
    required this.createdByName,
    required this.createdByRollNumber,
    required this.onDate,
    required this.onDay,
    required this.onTime,
    required this.id,
    required this.headLine,
    required this.message,
    required this.recipient,
    required this.gradeIds,
    this.declinedByUserType,
    this.declinedByName,
    this.declinedByRollNumber,
    this.declinedOnDate,
    this.reason,
    this.requestFor,
  });

  factory MessageApprovalStatusModel.fromJson(Map<String, dynamic> json) {
    return MessageApprovalStatusModel(
      status: json['status'] ?? '',
      messageStatus: json['messageStatus'] ?? '',
      createdByUserType: json['createdByUserType'] ?? '',
      createdByName: json['createdByName'] ?? '',
      createdByRollNumber: json['createdByRollNumber'] ?? '',
      onDate: json['onDate'] ?? '',
      onDay: json['onDay'] ?? '',
      onTime: json['onTime'] ?? '',
      id: json['id'] ?? 0,
      headLine: json['headLine'] ?? '',
      message: json['message'] ?? '',
      recipient: json['recipient'] ?? '',
      gradeIds: json['gradeIds'] ?? [],
      declinedByUserType: json['declinedByUserType'],
      declinedByName: json['declinedByName'],
      declinedByRollNumber: json['declinedByRollNumber'],
      declinedOnDate: json['declinedOnDate'],
      reason: json['reason'],
      requestFor: json['requestFor'],
    );
  }

  static List<MessageApprovalStatusModel> fromJsonList(List<dynamic> list) {
    return list
        .map((item) => MessageApprovalStatusModel.fromJson(item))
        .toList();
  }
}
