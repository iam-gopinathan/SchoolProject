class CreateCircularModel {
  String headline;
  String circular;
  String userType;
  String rollNumber;
  String postedOn;
  String status;
  String scheduleOn;
  String draftedOn;
  String fileType;
  String file;
  String link;
  String recipient;
  String gradeIds;

  CreateCircularModel({
    required this.headline,
    required this.circular,
    required this.userType,
    required this.rollNumber,
    required this.postedOn,
    required this.status,
    required this.scheduleOn,
    required this.draftedOn,
    required this.fileType,
    required this.file,
    required this.link,
    required this.recipient,
    required this.gradeIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'HeadLine': headline,
      'Circular': circular,
      'UserType': userType,
      'RollNumber': rollNumber,
      'PostedOn': postedOn,
      'Status': status,
      'ScheduleOn': scheduleOn,
      'DraftedOn': draftedOn,
      'FileType': fileType,
      'File': file,
      'Link': link,
      'Recipient': recipient,
      'GradeIds': gradeIds,
    };
  }
}
