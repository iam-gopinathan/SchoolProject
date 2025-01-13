class CreateSchoolCalendarModel {
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String fileType;
  final String? filePath;
  final String? link;
  final String fromDate;
  final String toDate;

  CreateSchoolCalendarModel({
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.fileType,
    this.filePath,
    this.link,
    required this.fromDate,
    required this.toDate,
  });

  Map<String, String> toJson() {
    return {
      'UserType': userType,
      'RollNumber': rollNumber,
      'HeadLine': headLine,
      'Description': description,
      'FileType': fileType,
      'Link': link ?? '',
      'FromDate': fromDate,
      'ToDate': toDate,
    };
  }
}
