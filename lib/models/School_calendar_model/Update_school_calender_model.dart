class UpdateSchoolCalendarModel {
  final int id;
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String filePath;
  final String fileType;
  final String link;
  final String updatedOn;

  UpdateSchoolCalendarModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.filePath,
    required this.fileType,
    required this.link,
    required this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userType': userType,
      'rollNumber': rollNumber,
      'headLine': headLine,
      'description': description,
      'filePath': filePath,
      'fileType': fileType,
      'link': link,
      'updatedOn': updatedOn,
    };
  }
}
