class FeedBackDraftModel {
  List<FeedBackData>? data;

  FeedBackDraftModel({this.data});

  factory FeedBackDraftModel.fromJson(Map<String, dynamic> json) {
    return FeedBackDraftModel(
      data: json["data"] == null
          ? []
          : List<FeedBackData>.from(
              json["data"].map((x) => FeedBackData.fromJson(x))),
    );
  }
}

class FeedBackData {
  String? postedOnDate;
  String? postedOnDay;
  String? tag;
  List<FeedBack>? feedBack;

  FeedBackData({this.postedOnDate, this.postedOnDay, this.tag, this.feedBack});

  factory FeedBackData.fromJson(Map<String, dynamic> json) {
    return FeedBackData(
      postedOnDate: json["postedOnDate"] ?? "",
      postedOnDay: json["postedOnDay"] ?? "",
      tag: json["tag"] ?? "",
      feedBack: json["feedBack"] == null
          ? []
          : List<FeedBack>.from(
              json["feedBack"].map((x) => FeedBack.fromJson(x))),
    );
  }
}

class FeedBack {
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
  String? isAlterAvailable;

  FeedBack({
    this.userType,
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
    this.isAlterAvailable,
  });

  factory FeedBack.fromJson(Map<String, dynamic> json) {
    return FeedBack(
      userType: json["userType"] ?? "",
      name: json["name"] ?? "",
      rollNumber: json["rollNumber"] ?? "",
      recipient: json["recipient"] ?? "",
      time: json["time"] ?? "",
      questionId: json["questionId"] ?? 0,
      heading: json["heading"] ?? "",
      question: json["question"] ?? "",
      gradeId: json["gradeId"] ?? "",
      section: json["section"] == null
          ? []
          : List<String>.from(json["section"].map((x) => x)),
      status: json["status"] ?? "",
      isAlterAvailable: json["isAlterAvilable"] ?? "",
    );
  }
}
