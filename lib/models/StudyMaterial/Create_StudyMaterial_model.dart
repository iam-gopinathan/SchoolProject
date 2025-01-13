class CreateStudymaterialModel {
  final String gradeId;
  final String section;
  final String userType;
  final String rollNumber;
  final String subject;
  final String heading;
  final String fileType;
  final String filePath; // File path (you'll send it as a file in form data)
  final String status;
  final String postedOn;
  final String draftedOn;

  CreateStudymaterialModel({
    required this.gradeId,
    required this.section,
    required this.userType,
    required this.rollNumber,
    required this.subject,
    required this.heading,
    required this.fileType,
    required this.filePath,
    required this.status,
    required this.postedOn,
    required this.draftedOn,
  });
}
