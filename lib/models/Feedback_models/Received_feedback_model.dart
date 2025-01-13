class ReceivedFeedbackModel {
  List<FeedbackData>? data;

  ReceivedFeedbackModel({this.data});

  factory ReceivedFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ReceivedFeedbackModel(
      data: json['data'] != null
          ? List<FeedbackData>.from(
              json['data'].map((item) => FeedbackData.fromJson(item)))
          : null,
    );
  }
}

class FeedbackData {
  String? postedOnDate;
  String? postedOnDay;
  String? tag;
  List<Feedback>? feedBack;

  FeedbackData({this.postedOnDate, this.postedOnDay, this.tag, this.feedBack});

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'],
      feedBack: json['feedBack'] != null
          ? List<Feedback>.from(
              json['feedBack'].map((item) => Feedback.fromJson(item)))
          : null,
    );
  }
}

class Feedback {
  String? userType;
  String? name;
  String? rollNumber;
  String? recipient;
  String? time;
  int? questionId;
  String? heading;
  String? question;
  String? gradeId;
  List<String>? section;
  String? status;
  String? isAlterAvilable;
  List<FeedbackAnswers>? feedBackAnswers;

  Feedback(
      {this.userType,
      this.name,
      this.rollNumber,
      this.recipient,
      this.time,
      this.questionId,
      this.heading,
      this.question,
      this.gradeId,
      this.section,
      this.status,
      this.isAlterAvilable,
      this.feedBackAnswers});

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
      isAlterAvilable: json['isAlterAvilable'],
      feedBackAnswers: json['feedBackAnswers'] != null
          ? List<FeedbackAnswers>.from(json['feedBackAnswers']
              .map((item) => FeedbackAnswers.fromJson(item)))
          : null,
    );
  }
}

class FeedbackAnswers {
  String? rollNumber;
  String? studentName;
  String? studentClass;
  String? section;
  String? profile;
  String? responses;
  String? responsesOn;

  FeedbackAnswers(
      {this.rollNumber,
      this.studentName,
      this.studentClass,
      this.section,
      this.profile,
      this.responses,
      this.responsesOn});

  factory FeedbackAnswers.fromJson(Map<String, dynamic> json) {
    return FeedbackAnswers(
      rollNumber: json['rollNumber'],
      studentName: json['studentName'],
      studentClass: json['class'],
      section: json['section'],
      profile: json['profile'],
      responses: json['responses'],
      responsesOn: json['responsesOn'],
    );
  }
}
