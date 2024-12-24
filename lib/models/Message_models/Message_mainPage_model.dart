class MessageMainpageModel {
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
  final String? updatedOn;
  final List<int> gradeIds;

  MessageMainpageModel({
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
    this.updatedOn,
    required this.gradeIds,
  });

  factory MessageMainpageModel.fromJson(Map<String, dynamic> json) {
    return MessageMainpageModel(
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      time: json['time'] ?? '',
      id: json['id'] ?? '',
      headLine: json['headLine'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      recipient: json['recipient'] ?? '',
      isAlterAvailable: json['isAlterAvailable'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
      gradeIds: List<int>.from(json['gradeIds'] ?? []),
    );
  }
}

class Post {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<MessageMainpageModel> messages;

  Post({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.messages,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postedOnDate: json['postedOnDate'] ?? '',
      postedOnDay: json['postedOnDay'] ?? '',
      tag: json['tag'] ?? '',
      messages: (json['messages'] as List)
          .map((message) => MessageMainpageModel.fromJson(message))
          .toList(),
    );
  }
}

class PostResponse {
  final List<Post> data;

  PostResponse({required this.data});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      data: (json['data'] as List).map((post) => Post.fromJson(post)).toList(),
    );
  }
}
