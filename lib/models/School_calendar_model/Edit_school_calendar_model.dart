class EditSchoolCalendarModel {
  final int id;
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String filetype;
  final String filename;
  final String filepath;
  final String fromDate;
  final String toDate;
  final String? updatedOn;

  EditSchoolCalendarModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.filetype,
    required this.filename,
    required this.filepath,
    required this.fromDate,
    required this.toDate,
    this.updatedOn,
  });

  // Factory method to create a EditSchoolCalendarModel from a JSON map
  factory EditSchoolCalendarModel.fromJson(Map<String, dynamic> json) {
    return EditSchoolCalendarModel(
      id: json['id'],
      userType: json['userType'],
      rollNumber: json['rollNumber'],
      headLine: json['headLine'],
      description: json['description'],
      filetype: json['filetype'],
      filename: json['filename'],
      filepath: json['filepath'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      updatedOn: json['updatedOn'],
    );
  }

  // Method to convert a EditSchoolCalendarModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userType': userType,
      'rollNumber': rollNumber,
      'headLine': headLine,
      'description': description,
      'filetype': filetype,
      'filename': filename,
      'filepath': filepath,
      'fromDate': fromDate,
      'toDate': toDate,
      'updatedOn': updatedOn,
    };
  }
}
