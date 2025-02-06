class ParentFeedbackEditModel {
  final int id;
  final String userType;
  final String rollNumber;
  final int gradeId;
  final String section;
  final String heading;
  final String question;
  final String type;
  final String postedOn;

  ParentFeedbackEditModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.gradeId,
    required this.section,
    required this.heading,
    required this.question,
    required this.type,
    required this.postedOn,
  });

  // Factory method to create an instance from JSON
  factory ParentFeedbackEditModel.fromJson(Map<String, dynamic> json) {
    return ParentFeedbackEditModel(
      id: json['id'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      gradeId: json['gradeId'],
      section: json['section'],
      heading: json['heading'] ?? '',
      question: json['question'],
      type: json['type'],
      postedOn: json['postedOn'],
    );
  }
}
