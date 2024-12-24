class UpdateTimetableModel {
  final int id;
  final String userType;
  final String rollNumber;
  final String fileType;
  final String file;
  final String updatedOn;

  UpdateTimetableModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.fileType,
    required this.file,
    required this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'userType': userType,
      'rollNumber': rollNumber,
      'fileType': fileType,
      'file': file,
      'updatedOn': updatedOn,
    };
  }

  factory UpdateTimetableModel.fromJson(Map<String, dynamic> json) {
    return UpdateTimetableModel(
      id: json['Id'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      fileType: json['fileType'],
      file: json['file'],
      updatedOn: json['updatedOn'],
    );
  }
}
