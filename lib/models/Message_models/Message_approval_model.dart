import 'dart:convert';

class MessageApprovalModel {
  final List<MessageItem> schedule;
  final List<MessageItem> post;

  MessageApprovalModel({required this.schedule, required this.post});

  factory MessageApprovalModel.fromJson(Map<String, dynamic> json) {
    return MessageApprovalModel(
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((item) => MessageItem.fromJson(item))
              .toList() ??
          [],
      post: (json['post'] as List<dynamic>?)
              ?.map((item) => MessageItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class MessageItem {
  final String status;
  final String createdByUserType;
  final String createdByName;
  final String createdByRollNumber;
  final String? onDate;
  final String? onDay;
  final String? onTime;
  final int id;
  final String headLine;
  final String message;
  final String recipient;
  final List<int> gradeIds;
  final String requestFor;

  MessageItem({
    required this.status,
    required this.createdByUserType,
    required this.createdByName,
    required this.createdByRollNumber,
    this.onDate,
    this.onDay,
    this.onTime,
    required this.id,
    required this.headLine,
    required this.message,
    required this.recipient,
    required this.gradeIds,
    required this.requestFor,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      status: json['status'] ?? '',
      createdByUserType: json['createdByUserType'] ?? '',
      createdByName: json['createdByName'] ?? '',
      createdByRollNumber: json['createdByRollNumber'] ?? '',
      onDate: json['onDate'],
      onDay: json['onDay'],
      onTime: json['onTime'],
      id: json['id'] ?? 0,
      headLine: json['headLine'] ?? '',
      message: json['message'] ?? '',
      recipient: json['recipient'] ?? '',
      gradeIds:
          (json['gradeIds'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              [],
      requestFor: json['requestFor'] ?? '',
    );
  }
}
