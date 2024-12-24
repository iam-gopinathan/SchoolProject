class MainTimetableModel {
  final int id;
  final String postedOn;
  final String day;
  final int gradeId;
  final String section;
  final String gradeSection;
  final String fileType;
  final String filePath;
  final String status;
  final String isAlterAvailable;
  final String? updatedOn;

  MainTimetableModel({
    required this.id,
    required this.postedOn,
    required this.day,
    required this.gradeId,
    required this.section,
    required this.gradeSection,
    required this.fileType,
    required this.filePath,
    required this.status,
    required this.isAlterAvailable,
    this.updatedOn,
  });

  // From JSON (deserialize)
  factory MainTimetableModel.fromJson(Map<String, dynamic> json) {
    return MainTimetableModel(
      id: json['id'],
      postedOn: json['postedOn'],
      day: json['day'],
      gradeId: json['gradeId'],
      section: json['section'],
      gradeSection: json['gradeSection'],
      fileType: json['fileType'],
      filePath: json['filePath'],
      status: json['status'],
      isAlterAvailable: json['isAlterAvailable'],
      updatedOn: json['updatedOn'],
    );
  }

  // To JSON (serialize)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postedOn': postedOn,
      'day': day,
      'gradeId': gradeId,
      'section': section,
      'gradeSection': gradeSection,
      'fileType': fileType,
      'filePath': filePath,
      'status': status,
      'isAlterAvailable': isAlterAvailable,
      'updatedOn': updatedOn,
    };
  }
}
