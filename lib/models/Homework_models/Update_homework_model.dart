class UpdateHomeworkRequest {
  final int id;
  final String userType;
  final String rollNumber;
  final String fileType;
  final String status;
  final String updatedOn;
  final String? postedOn;
  final String? scheduleOn;
  final dynamic file;

  UpdateHomeworkRequest({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.fileType,
    required this.status,
    required this.updatedOn,
    this.postedOn,
    this.scheduleOn,
    this.file,
  });

  // Convert the request object to a map for form-data fields
  Map<String, String> toFormData() {
    return {
      'Id': id.toString(),
      'UserType': userType,
      'RollNumber': rollNumber,
      'FileType': fileType,
      'Status': status,
      'UpdatedOn': updatedOn,
      if (postedOn != null) 'PostedOn': postedOn!,
      if (scheduleOn != null) 'ScheduleOn': scheduleOn!,
    };
  }
}
