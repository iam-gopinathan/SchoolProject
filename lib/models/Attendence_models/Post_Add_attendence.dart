class PostAddAttendence {
  String? rollNumber;
  String? status;

  PostAddAttendence({
    this.rollNumber,
    this.status = 'present',
  });

  Map<String, dynamic> toJson() {
    return {
      'rollNumber': rollNumber,
      'status': status,
    };
  }
}

class AttendanceRequest {
  String? grade;
  String? section;
  String? date;
  List<PostAddAttendence> details;

  AttendanceRequest({
    this.grade,
    this.section,
    this.date,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'grade': grade,
      'section': section,
      'date': date,
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }
}
