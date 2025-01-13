class ParentFeedback {
  final int id;
  final String userType;
  final String rollNumber;
  final String grade;
  final String section;
  final String heading;
  final String question;
  final String type;
  final String time;
  final String postedOn;

  ParentFeedback(
      {required this.id,
      required this.userType,
      required this.rollNumber,
      required this.grade,
      required this.section,
      required this.heading,
      required this.question,
      required this.type,
      required this.time,
      required this.postedOn});

  factory ParentFeedback.fromJson(Map<String, dynamic> json) {
    return ParentFeedback(
      id: json['id'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      grade: json['grade'],
      section: json['section'],
      heading: json['heading'],
      question: json['question'],
      type: json['type'],
      time: json['time'],
      postedOn: json['postedOn'] ?? '',
    );
  }
}

// class FeedbackData {
//   final String postedOn;
//   final String day;
//   final List<ParentFeedback> parentsFeedBack;

//   FeedbackData({
//     required this.postedOn,
//     required this.day,
//     required this.parentsFeedBack,
//   });

//   // Factory method to parse the entire feedback data
//   factory FeedbackData.fromJson(Map<String, dynamic> json) {
//     var list = json['parentsFeedBack'] as List;
//     List<ParentFeedback> feedbackList =
//         list.map((i) => ParentFeedback.fromJson(i)).toList();

//     return FeedbackData(
//       postedOn: json['postedOn'],
//       day: json['day'],
//       parentsFeedBack: feedbackList,
//     );
//   }
// }

class FeedbackData {
  final String postedOn;
  final String day;
  final List<ParentFeedback> parentsFeedBack;

  FeedbackData({
    required this.postedOn,
    required this.day,
    required this.parentsFeedBack,
  });

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    var list = json['parentsFeedBack'] as List;
    List<ParentFeedback> feedbackList =
        list.map((i) => ParentFeedback.fromJson(i)).toList();

    return FeedbackData(
      postedOn: json['postedOn'],
      day: json['day'],
      parentsFeedBack: feedbackList,
    );
  }
}
