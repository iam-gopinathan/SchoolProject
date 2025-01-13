class UpdateEventCalendarModel {
  final String id;
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String file;
  final String fileType;
  final String link;
  final String updatedOn;

  UpdateEventCalendarModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.file,
    required this.fileType,
    required this.link,
    required this.updatedOn,
  });

  // Modify the toJson method to return Map<String, String>
  Map<String, String> toJson() {
    return {
      'Id': id,
      'UserType': userType,
      'RollNumber': rollNumber,
      'HeadLine': headLine,
      'Description': description,
      'File': file,
      'FileType': fileType,
      'link': link,
      'UpdatedOn': updatedOn,
    };
  }

  Map<String, String> toMap() {
    return {
      'Id': id,
      'UserType': userType,
      'RollNumber': rollNumber,
      'HeadLine': headLine,
      'Description': description,
      'File': file,
      'FileType': fileType,
      'link': link,
      'UpdatedOn': updatedOn,
    };
  }
}
