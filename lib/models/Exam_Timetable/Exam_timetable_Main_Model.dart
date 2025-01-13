// exam_timetable_model.dart

class ExamTimetableMainModel {
  final int id;
  final String postedOn;
  final String? postedBy;
  final String day;
  final int gradeId;
  final String headLine;
  final String description;
  final String exam;
  final String fileType;
  final String filePath;
  final String status;
  final String isAlterAvailable;
  final String? updatedOn;

  ExamTimetableMainModel({
    required this.id,
    required this.postedOn,
    this.postedBy,
    required this.day,
    required this.gradeId,
    required this.headLine,
    required this.description,
    required this.exam,
    required this.fileType,
    required this.filePath,
    required this.status,
    required this.isAlterAvailable,
    this.updatedOn,
  });

  factory ExamTimetableMainModel.fromJson(Map<String, dynamic> json) {
    return ExamTimetableMainModel(
      id: json['id'] ?? '',
      postedOn: json['postedOn'] ?? '',
      postedBy: json['postedBy'] ?? '',
      day: json['day'] ?? '',
      gradeId: json['gradeId'] ?? '',
      headLine: json['headLine'] ?? '',
      description: json['description'] ?? '',
      exam: json['exam'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'] ?? '',
      status: json['status'] ?? '',
      isAlterAvailable: json['isAlterAvailable'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postedOn': postedOn,
      'postedBy': postedBy,
      'day': day,
      'gradeId': gradeId,
      'headLine': headLine,
      'description': description,
      'exam': exam,
      'fileType': fileType,
      'filePath': filePath,
      'status': status,
      'isAlterAvailable': isAlterAvailable,
      'updatedOn': updatedOn,
    };
  }
}
