class CircularUpdateRequest {
  final int id;
  final String rollNumber;
  final String userType;
  final String headLine;
  final String circular;
  final String? filePath;
  final String fileType;
  final String link;
  final String status;
  // final String postedOn;
  final String scheduleOn;
  final String updatedOn;
  final String recipient;
  final String gradeIds;

  CircularUpdateRequest({
    required this.id,
    required this.rollNumber,
    required this.userType,
    required this.headLine,
    required this.circular,
    this.filePath,
    required this.fileType,
    required this.link,
    required this.status,
    // required this.postedOn,
    required this.scheduleOn,
    required this.updatedOn,
    required this.recipient,
    required this.gradeIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'RollNumber': rollNumber,
      'UserType': userType,
      'HeadLine': headLine,
      'Circular': circular,
      'FileType': fileType,
      'link': link,
      'Status': status,
      // 'PostedOn': postedOn,
      'ScheduleOn': scheduleOn,
      'UpdatedOn': updatedOn,
      'Recipient': recipient,
      'GradeIds': gradeIds,
    };
  }
}
