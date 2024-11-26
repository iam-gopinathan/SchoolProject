// attendance_model.dart
class ShowStudentdetails {
  final String classTeacher;
  final String grade;
  final String section;
  final List<Student> data;

  ShowStudentdetails({
    required this.classTeacher,
    required this.grade,
    required this.section,
    required this.data,
  });

  factory ShowStudentdetails.fromJson(Map<String, dynamic> json) {
    return ShowStudentdetails(
      classTeacher: json['classTeacher'] ?? '',
      grade: json['grade'] ?? '',
      section: json['section'] ?? '',
      data: (json['data'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(),
    );
  }
}

class Student {
  final String? rollNumber;
  final String studentName;
  final String section;
  final String studentPicture;
  final String attendanceStatus;
  final int attendancePercent;

  Student({
    this.rollNumber,
    required this.studentName,
    required this.section,
    required this.studentPicture,
    required this.attendanceStatus,
    required this.attendancePercent,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      rollNumber: json['rollNumber'],
      studentName: json['studentName'] ?? '',
      section: json['section'] ?? '',
      studentPicture: json['studentPicture'] ?? '',
      attendanceStatus: json['attendanceStatus'] ?? '',
      attendancePercent: json['attendancePercent'] ?? 0,
    );
  }
}
