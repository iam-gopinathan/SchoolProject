class CreateFeedbackModel {
  final String userType;
  final String rollNumber;
  final String recipient;
  final String gradeId;
  final String section;
  final String heading;
  final String question;
  final String status;
  final String postedOn;
  final String draftedOn;

  // Named constructor for CreateFeedbackModel
  CreateFeedbackModel({
    required this.userType,
    required this.rollNumber,
    required this.recipient,
    required this.gradeId,
    required this.section,
    required this.heading,
    required this.question,
    required this.status,
    required this.postedOn,
    required this.draftedOn,
  });

  // toJson method for creating a JSON from the model
  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'rollNumber': rollNumber,
      'recipient': recipient,
      'gradeId': gradeId,
      'section': section,
      'heading': heading,
      'question': question,
      'status': status,
      'postedOn': postedOn,
      'draftedOn': draftedOn,
    };
  }
}
