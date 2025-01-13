// Feedback model
class Feedback {
  final String userType;
  final String name;
  final String rollNumber;
  final String recipient;
  final String time;
  final int questionId;
  final String heading;
  final String question;
  final String gradeId;
  final List<String> section;
  final String status;
  final String isAlterAvailable;

  Feedback({
    required this.userType,
    required this.name,
    required this.rollNumber,
    required this.recipient,
    required this.time,
    required this.questionId,
    required this.heading,
    required this.question,
    required this.gradeId,
    required this.section,
    required this.status,
    required this.isAlterAvailable,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      userType: json['userType'],
      name: json['name'],
      rollNumber: json['rollNumber'],
      recipient: json['recipient'],
      time: json['time'],
      questionId: json['questionId'],
      heading: json['heading'],
      question: json['question'],
      gradeId: json['gradeId'],
      section: List<String>.from(json['section']),
      status: json['status'],
      isAlterAvailable: json['isAlterAvilable'],
    );
  }
}

// Parent FeedbackData model
class FeedbackDataQuestion {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<Feedback> feedbackList;

  FeedbackDataQuestion({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.feedbackList,
  });

  factory FeedbackDataQuestion.fromJson(Map<String, dynamic> json) {
    return FeedbackDataQuestion(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'],
      feedbackList: (json['feedBack'] as List)
          .map((feedback) => Feedback.fromJson(feedback))
          .toList(),
    );
  }
}

// Complete API Response model
class FeedbackResponse {
  final List<FeedbackDataQuestion> data;

  FeedbackResponse({required this.data});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      data: (json['data'] as List)
          .map((feedbackData) => FeedbackDataQuestion.fromJson(feedbackData))
          .toList(),
    );
  }
}
