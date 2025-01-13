class StudyMaterialModel {
  final int id;
  final String postedOn;
  final String rollNumber;
  final String postedBy;
  final String day;
  final String gradeId;
  final String section;
  final String gradeSection;
  final String subject;
  final String heading;
  final String fileType;
  final String filePath;
  final String status;
  final String isAlterAvailable;

  StudyMaterialModel({
    required this.id,
    required this.postedOn,
    required this.rollNumber,
    required this.postedBy,
    required this.day,
    required this.gradeId,
    required this.section,
    required this.gradeSection,
    required this.subject,
    required this.heading,
    required this.fileType,
    required this.filePath,
    required this.status,
    required this.isAlterAvailable,
  });

  factory StudyMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudyMaterialModel(
      id: json['id'],
      postedOn: json['postedOn'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      postedBy: json['postedBy'] ?? '',
      day: json['day'] ?? '',
      gradeId: json['gradeId'].toString(),
      section: json['section'] ?? '',
      gradeSection: json['gradeSection'] ?? '',
      subject: json['subject'] ?? '',
      heading: json['heading'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'] ?? '',
      status: json['status'] ?? '',
      isAlterAvailable: json['isAlterAvailable'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postedOn': postedOn,
      'rollNumber': rollNumber,
      'postedBy': postedBy,
      'day': day,
      'gradeId': gradeId,
      'section': section,
      'gradeSection': gradeSection,
      'subject': subject,
      'heading': heading,
      'fileType': fileType,
      'filePath': filePath,
      'status': status,
      'isAlterAvailable': isAlterAvailable,
    };
  }
}
