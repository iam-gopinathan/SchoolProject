class UpdateExamTimetableModel {
  final String id;
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String exam;
  final String fileType;
  final String file;
  final String updatedOn;

  UpdateExamTimetableModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.exam,
    required this.fileType,
    required this.file,
    required this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserType': userType,
      'RollNumber': rollNumber,
      'HeadLine': headLine,
      'Description': description,
      'Exam': exam,
      'FileType': fileType,
      'File': file,
      'UpdatedOn': updatedOn,
    };
  }
}
