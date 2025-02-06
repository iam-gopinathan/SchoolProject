class ParentCreateFeedbackModel {
  final String userType;
  final String rollNumber;
  final String heading;
  final String question;
  final String type;

  ParentCreateFeedbackModel({
    required this.userType,
    required this.rollNumber,
    required this.heading,
    required this.question,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'rollNumber': rollNumber,
      'heading': heading,
      'question': question,
      'type': type,
    };
  }
}
