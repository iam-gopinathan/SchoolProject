class UpdateStudymaterialModel {
  final int id;
  final String userType;
  final String rollNumber;
  final String subject;
  final String heading;
  final String fileType;
  final String file; // File path or URL
  final String updatedOn;

  UpdateStudymaterialModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.subject,
    required this.heading,
    required this.fileType,
    required this.file,
    required this.updatedOn,
  });

  // Convert to a Map for sending in the request
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userType': userType,
      'rollNumber': rollNumber,
      'subject': subject,
      'heading': heading,
      'fileType': fileType,
      'fileName': file,
      'updatedOn': updatedOn,
    };
  }
}
