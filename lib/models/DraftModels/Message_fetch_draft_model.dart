import 'dart:convert';

class MessageFetchDraftModel {
  final List<MessageData> data;

  MessageFetchDraftModel({required this.data});

  factory MessageFetchDraftModel.fromJson(String str) =>
      MessageFetchDraftModel.fromMap(json.decode(str));

  factory MessageFetchDraftModel.fromMap(Map<String, dynamic> json) =>
      MessageFetchDraftModel(
        data: List<MessageData>.from(
            json["data"].map((x) => MessageData.fromMap(x))),
      );
}

class MessageData {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<Message> messages;

  MessageData({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.messages,
  });

  factory MessageData.fromMap(Map<String, dynamic> json) => MessageData(
        postedOnDate: json["postedOnDate"],
        postedOnDay: json["postedOnDay"],
        tag: json["tag"],
        messages:
            List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
      );
}

class Message {
  final String userType;
  final String name;
  final String rollNumber;
  final String time;
  final int id;
  final String headLine;
  final String message;
  final String status;
  final String recipient;
  final String isAlterAvailable;
  final List<int> gradeIds;
  final String? approvedByName;
  final String? approvedByUserType;
  final String? approvedOnDate;

  Message({
    required this.userType,
    required this.name,
    required this.rollNumber,
    required this.time,
    required this.id,
    required this.headLine,
    required this.message,
    required this.status,
    required this.recipient,
    required this.isAlterAvailable,
    required this.gradeIds,
    this.approvedByName,
    this.approvedByUserType,
    this.approvedOnDate,
  });

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        userType: json["userType"],
        name: json["name"],
        rollNumber: json["rollNumber"],
        time: json["time"],
        id: json["id"],
        headLine: json["headLine"],
        message: json["message"],
        status: json["status"],
        recipient: json["recipient"],
        isAlterAvailable: json["isAlterAvailable"],
        gradeIds: List<int>.from(json["gradeIds"].map((x) => x)),
        approvedByName: json["approvedByName"],
        approvedByUserType: json["approvedByUserType"],
        approvedOnDate: json["approvedOnDate"],
      );
}
