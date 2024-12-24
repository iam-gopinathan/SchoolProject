class CreateTimetableModel {
  final String gradeId;
  final String section;
  final String userType;
  final String rollNumber;
  final String fileType;
  final String file; // Base64 encoded file
  final String status;
  final String postedOn;
  final String draftedOn;

  CreateTimetableModel({
    required this.gradeId,
    required this.section,
    required this.userType,
    required this.rollNumber,
    required this.fileType,
    required this.file,
    required this.status,
    required this.postedOn,
    required this.draftedOn,
  });

  // Convert JSON to CreateTimetableModel
  factory CreateTimetableModel.fromJson(Map<String, dynamic> json) {
    return CreateTimetableModel(
      gradeId: json['GradeId'],
      section: json['Section'],
      userType: json['UserType'],
      rollNumber: json['RollNumber'],
      fileType: json['FileType'],
      file: json['File'],
      status: json['Status'],
      postedOn: json['PostedOn'],
      draftedOn: json['DraftedOn'],
    );
  }

  // Convert CreateTimetableModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'GradeId': gradeId,
      'Section': section,
      'UserType': userType,
      'RollNumber': rollNumber,
      'FileType': fileType,
      'File': file,
      'Status': status,
      'PostedOn': postedOn,
      'DraftedOn': draftedOn,
    };
  }
}
