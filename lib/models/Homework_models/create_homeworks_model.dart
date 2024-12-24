class CreateHomeworkModel {
  final String gradeId;
  final String section;
  final String userType;
  final String rollNumber;
  final String file;
  final String fileType;
  final String status;
  final String postedOn;
  final String draftedOn;
  final String scheduleOn;

  CreateHomeworkModel({
    required this.gradeId,
    required this.section,
    required this.userType,
    required this.rollNumber,
    required this.fileType,
    required this.status,
    required this.postedOn,
    required this.draftedOn,
    required this.scheduleOn,
    required this.file,
  });

  Map<String, String> toJson() {
    return {
      'gradeId': gradeId.toString(),
      'section': section,
      'userType': userType,
      'rollNumber': rollNumber,
      'fileType': fileType,
      'status': status,
      'postedOn': postedOn,
      'draftedOn': draftedOn,
      'scheduleOn': scheduleOn,
    };
  }
}
