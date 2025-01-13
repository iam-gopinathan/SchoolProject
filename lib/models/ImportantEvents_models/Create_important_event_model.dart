class CreateImportantEventModel {
  String userType;
  String rollNumber;
  String headLine;
  String description;
  String fileType;
  String file;
  String link;
  String fromDate;
  String toDate;

  CreateImportantEventModel({
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.fileType,
    required this.file,
    required this.link,
    required this.fromDate,
    required this.toDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserType': userType,
      'RollNumber': rollNumber,
      'HeadLine': headLine,
      'Description': description,
      'FileType': fileType,
      'File': file,
      'Link': link,
      'FromDate': fromDate,
      'ToDate': toDate,
    };
  }
}
