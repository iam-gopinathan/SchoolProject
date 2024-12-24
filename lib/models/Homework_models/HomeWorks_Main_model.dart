class HomeworksMainModel {
  final int id;
  final String postedOn;
  final String? scheduleOn;
  final String rollNumber;
  final String postedBy;
  final String day;
  final int gradeId;
  final String section;
  final String gradeSection;
  final String fileType;
  final String filePath;
  final String status;
  final String isAlterAvailable;
  final String? updatedOn;

  HomeworksMainModel({
    required this.id,
    required this.postedOn,
    this.scheduleOn,
    required this.rollNumber,
    required this.postedBy,
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

  factory HomeworksMainModel.fromJson(Map<String, dynamic> json) {
    return HomeworksMainModel(
      id: json['id'] as int,
      postedOn: json['postedOn'] as String,
      scheduleOn: json['scheduleOn'] as String?,
      rollNumber: json['rollNumber'] as String,
      postedBy: json['postedBy'] as String,
      day: json['day'] as String,
      gradeId: json['gradeId'] as int,
      section: json['section'] as String,
      gradeSection: json['gradeSection'] as String,
      fileType: json['fileType'] as String,
      filePath: json['filePath'] as String,
      status: json['status'] as String,
      isAlterAvailable: json['isAlterAvailable'] as String,
      updatedOn: json['updatedOn'] as String?,
    );
  }
}

class HomeworkResponse {
  final List<HomeworksMainModel> data;

  HomeworkResponse({required this.data});

  factory HomeworkResponse.fromJson(Map<String, dynamic> json) {
    return HomeworkResponse(
      data: List<HomeworksMainModel>.from(
        json['data'].map((item) => HomeworksMainModel.fromJson(item)),
      ),
    );
  }
}
