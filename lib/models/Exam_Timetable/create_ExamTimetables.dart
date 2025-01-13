class createExamtimetablesModel {
  final String gradeId;
  final String userType;
  final String rollNumber;
  final String headline;
  final String description;
  final String exam;
  final String fileType;
  final String file;
  final String status;
  final String postedOn;
  final String draftedOn;

  createExamtimetablesModel({
    required this.gradeId,
    required this.userType,
    required this.rollNumber,
    required this.headline,
    required this.description,
    required this.exam,
    required this.fileType,
    required this.file,
    required this.status,
    required this.postedOn,
    required this.draftedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'GradeId': gradeId,
      'UserType': userType,
      'RollNumber': rollNumber,
      'HeadLine': headline,
      'Description': description,
      'Exam': exam,
      'FileType': fileType,
      'File': file,
      'Status': status,
      'PostedOn': postedOn,
      'DraftedOn': draftedOn,
    };
  }
}
