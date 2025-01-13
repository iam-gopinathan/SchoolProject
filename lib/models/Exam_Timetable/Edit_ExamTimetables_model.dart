class EditExamtimetablesModel {
  final int gradeId; // Updated to int
  final String userType;
  final String rollNumber;
  final String? headline; // Nullable
  final String? description; // Nullable
  final String exam;
  final String fileType;
  final String filename; // Added
  final String filepath; // Added
  final String status;
  final String postedOn;
  final String? draftedOn; // Nullable

  EditExamtimetablesModel({
    required this.gradeId,
    required this.userType,
    required this.rollNumber,
    this.headline,
    this.description,
    required this.exam,
    required this.fileType,
    required this.filename,
    required this.filepath,
    required this.status,
    required this.postedOn,
    this.draftedOn,
  });

  factory EditExamtimetablesModel.fromJson(Map<String, dynamic> json) {
    return EditExamtimetablesModel(
      gradeId: json['gradeId'] ?? 0, // Matches JSON
      userType: json['userType'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      headline: json['headLine'], // Nullable
      description: json['description'], // Nullable
      exam: json['exam'] ?? '',
      fileType: json['filetype'] ?? '',
      filename: json['filename'] ?? '',
      filepath: json['filepath'] ?? '',
      status: json['status'] ?? '',
      postedOn: json['postedOn'] ?? '',
      draftedOn: json['draftedOn'], // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gradeId': gradeId,
      'userType': userType,
      'rollNumber': rollNumber,
      'headLine': headline,
      'description': description,
      'exam': exam,
      'filetype': fileType,
      'filename': filename,
      'filepath': filepath,
      'status': status,
      'postedOn': postedOn,
      'draftedOn': draftedOn,
    };
  }
}
