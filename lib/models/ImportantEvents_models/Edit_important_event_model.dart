class EditImportantEventModel {
  final int id;
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String fileType;
  final String fileName;
  final String filePath;
  final String fromDate;
  final String toDate;
  final String? updatedOn;

  EditImportantEventModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.fileType,
    required this.fileName,
    required this.filePath,
    required this.fromDate,
    required this.toDate,
    this.updatedOn,
  });

  factory EditImportantEventModel.fromJson(Map<String, dynamic> json) {
    return EditImportantEventModel(
      id: json['id'] ?? '',
      userType: json['userType'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      headLine: json['headLine'] ?? '',
      description: json['description'] ?? '',
      fileType: json['filetype'] ?? '',
      fileName: json['filename'] ?? '',
      filePath: json['filepath'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      updatedOn: json['updatedOn'] ?? '',
    );
  }
}
