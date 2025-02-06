class EditTimetableModel {
  final int id;
  final int gradeId;
  final String section;
  final String userType;
  final String rollNumber;
  final String? filetype;
  final String filename;
  final String? filepath;
  final String status;
  final String postedOn;
  final String? draftedOn;
  final String? updatedOn;

  EditTimetableModel({
    required this.id,
    required this.gradeId,
    required this.section,
    required this.userType,
    required this.rollNumber,
    this.filetype,
    required this.filename,
    this.filepath,
    required this.status,
    required this.postedOn,
    this.draftedOn,
    this.updatedOn,
  });

  // Factory method to parse JSON data
  factory EditTimetableModel.fromJson(Map<String, dynamic> json) {
    return EditTimetableModel(
      id: json['id'] ?? 0,
      gradeId: json['gradeId'] ?? 0,
      section: json['section'] ?? '',
      userType: json['userType'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      filetype: json['filetype'] ?? '',
      filename: json['filename'] ?? '',
      filepath: json['filepath'] ?? '',
      status: json['status'] ?? '',
      postedOn: json['postedOn'] ?? '',
      draftedOn: json['draftedOn'],
      updatedOn: json['updatedOn'],
    );
  }
}
