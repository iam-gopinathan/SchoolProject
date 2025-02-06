class PostTeacherTimetableModel {
  final String rollNumber;
  final String filePath;

  PostTeacherTimetableModel({
    required this.rollNumber,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      "RollNumber": rollNumber,
    };
  }
}
