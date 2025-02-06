// feedback_model.dart
class ParentFeedbackResponse {
  final List<FeedbackData> data;

  ParentFeedbackResponse({required this.data});

  factory ParentFeedbackResponse.fromJson(Map<dynamic, dynamic> json) {
    return ParentFeedbackResponse(
      data: (json['data'] as List)
          .map((item) => FeedbackData.fromJson(item))
          .toList(),
    );
  }
}

class FeedbackData {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<FromParents> fromParents;

  FeedbackData({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.fromParents,
  });

  factory FeedbackData.fromJson(Map<dynamic, dynamic> json) {
    return FeedbackData(
      postedOnDate: json['postedOnDate'] ?? '',
      postedOnDay: json['postedOnDay'] ?? '',
      tag: json['tag'] ?? '',
      fromParents: (json['fromParents'] as List)
          .map((item) => FromParents.fromJson(item))
          .toList(),
    );
  }
}

class FromParents {
  final int id;
  final String questionID;
  final String heading;
  final String question;
  final String grade;
  final String section;
  final String rollNumber;
  final String name;
  final String? answer;
  final String? answeredOn;
  final String isAlterAvailable;

  FromParents({
    required this.id,
    required this.questionID,
    required this.heading,
    required this.question,
    required this.grade,
    required this.section,
    required this.rollNumber,
    required this.name,
    this.answer,
    this.answeredOn,
    required this.isAlterAvailable,
  });

  factory FromParents.fromJson(Map<dynamic, dynamic> json) {
    return FromParents(
      id: json['id'] ?? 0,
      questionID: json['questionID'] ?? '',
      heading: json['heading'] ?? '',
      question: json['question'] ?? '',
      grade: json['grade'] ?? '',
      section: json['section'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      name: json['name'] ?? '',
      answer: json['answer'],
      answeredOn: json['answeredOn'],
      isAlterAvailable: json['isAlterAvailable'] ?? '',
    );
  }
}

/////parent feedback Y response model...
class ParentFeedbackYResponse {
  final List<FeedbackDataYresponse> feedbackList;

  ParentFeedbackYResponse({required this.feedbackList});

  factory ParentFeedbackYResponse.fromJson(List<dynamic> json) {
    return ParentFeedbackYResponse(
      feedbackList:
          json.map((item) => FeedbackDataYresponse.fromJson(item)).toList(),
    );
  }
}

class FeedbackDataYresponse {
  final int Id;
  final String createdOnDate;
  final String day;
  final String heading;
  final String question;
  final String type;

  FeedbackDataYresponse({
    required this.Id,
    required this.createdOnDate,
    required this.day,
    required this.heading,
    required this.question,
    required this.type,
  });

  factory FeedbackDataYresponse.fromJson(Map<String, dynamic> json) {
    return FeedbackDataYresponse(
      Id: json['id'] ?? '',
      createdOnDate: json['createdOn'] ?? '',
      day: json['day'] ?? '',
      heading: json['heading'] ?? '',
      question: json['question'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
