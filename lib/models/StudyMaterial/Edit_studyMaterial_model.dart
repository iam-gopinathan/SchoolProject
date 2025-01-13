class EditStudymaterialModel {
  final int id;
  final int gradeId;
  final String section;
  final String userType;
  final String rollNumber;
  final String subject;
  final String heading;
  final String filetype;
  final String filename;
  final String filepath;
  final String status;
  final String postedOn;
  final String? draftedOn;
  final String? updatedOn;

  EditStudymaterialModel({
    required this.id,
    required this.gradeId,
    required this.section,
    required this.userType,
    required this.rollNumber,
    required this.subject,
    required this.heading,
    required this.filetype,
    required this.filename,
    required this.filepath,
    required this.status,
    required this.postedOn,
    this.draftedOn,
    this.updatedOn,
  });

  factory EditStudymaterialModel.fromJson(Map<String, dynamic> json) {
    return EditStudymaterialModel(
      id: json['id'],
      gradeId: json['gradeId'],
      section: json['section'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      subject: json['subject'],
      heading: json['heading'],
      filetype: json['filetype'],
      filename: json['filename'],
      filepath: json['filepath'],
      status: json['status'],
      postedOn: json['postedOn'],
      draftedOn: json['draftedOn'],
      updatedOn: json['updatedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gradeId': gradeId,
      'section': section,
      'userType': userType,
      'rollNumber': rollNumber,
      'subject': subject,
      'heading': heading,
      'filetype': filetype,
      'filename': filename,
      'filepath': filepath,
      'status': status,
      'postedOn': postedOn,
      'draftedOn': draftedOn,
      'updatedOn': updatedOn,
    };
  }
}
