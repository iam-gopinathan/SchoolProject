class EdithomeworkModel {
  final int id;
  final int gradeId;
  final String section;
  final String userType;
  final String rollNumber;
  final String fileType;
  final String fileName;
  String filePath;
  final String status;
  final String postedOn;
  final String? draftedOn;
  final String? scheduleOn;
  final String? updatedOn;

  EdithomeworkModel({
    required this.id,
    required this.gradeId,
    required this.section,
    required this.userType,
    required this.rollNumber,
    required this.fileType,
    required this.fileName,
    required this.filePath,
    required this.status,
    required this.postedOn,
    this.draftedOn,
    this.scheduleOn,
    this.updatedOn,
  });

  factory EdithomeworkModel.fromJson(Map<String, dynamic> json) {
    return EdithomeworkModel(
      id: json['id'] ?? '',
      gradeId: json['gradeId'] ?? '',
      section: json['section'] ?? '',
      userType: json['userType'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      fileType: json['filetype'] ?? '',
      fileName: json['filename'] ?? '',
      filePath: json['filepath'] ?? '',
      status: json['status'] ?? '',
      postedOn: json['postedOn'] ?? '',
      draftedOn: json['draftedOn'] ?? '',
      scheduleOn: json['scheduleOn'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gradeId': gradeId,
      'section': section,
      'userType': userType,
      'rollNumber': rollNumber,
      'filetype': fileType,
      'filename': fileName,
      'filepath': filePath,
      'status': status,
      'postedOn': postedOn,
      'draftedOn': draftedOn,
      'scheduleOn': scheduleOn,
      'updatedOn': updatedOn,
    };
  }
}
