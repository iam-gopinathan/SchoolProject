class CreateConsentformModel {
  final String userType;
  final String rollNumber;
  final String gradeId;
  final String section;
  final String heading;
  final String question;
  final String status;
  final String postedOn;
  final String draftedOn;

  CreateConsentformModel({
    required this.userType,
    required this.rollNumber,
    required this.gradeId,
    required this.section,
    required this.heading,
    required this.question,
    required this.status,
    required this.postedOn,
    required this.draftedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      "userType": userType,
      "rollNumber": rollNumber,
      "gradeId": gradeId,
      "section": section,
      "heading": heading,
      "question": question,
      "status": status,
      "postedOn": postedOn,
      "draftedOn": draftedOn,
    };
  }
}
