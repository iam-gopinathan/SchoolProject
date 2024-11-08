class StudentAttendanceModel {
  List<StudentAttendance> preKgAttendance;
  List<StudentAttendance> lkgAttendance;
  List<StudentAttendance> ukgAttendance;
  List<StudentAttendance> grade1Attendance;
  List<StudentAttendance> grade2Attendance;
  List<StudentAttendance> grade3Attendance;
  List<StudentAttendance> grade4Attendance;
  List<StudentAttendance> grade5Attendance;
  List<StudentAttendance> grade6Attendance;
  List<StudentAttendance> grade7Attendance;
  List<StudentAttendance> grade8Attendance;
  List<StudentAttendance> grade9Attendance;
  List<StudentAttendance> grade10Attendance;

  StudentAttendanceModel({
    required this.preKgAttendance,
    required this.lkgAttendance,
    required this.ukgAttendance,
    required this.grade1Attendance,
    required this.grade2Attendance,
    required this.grade3Attendance,
    required this.grade4Attendance,
    required this.grade5Attendance,
    required this.grade6Attendance,
    required this.grade7Attendance,
    required this.grade8Attendance,
    required this.grade9Attendance,
    required this.grade10Attendance,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      preKgAttendance: List<StudentAttendance>.from(
          json['pre_kg_attendance'].map((x) => StudentAttendance.fromJson(x))),
      lkgAttendance: List<StudentAttendance>.from(
          json['lkg_attendance'].map((x) => StudentAttendance.fromJson(x))),
      ukgAttendance: List<StudentAttendance>.from(
          json['ukg_attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade1Attendance: List<StudentAttendance>.from(
          json['grade1Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade2Attendance: List<StudentAttendance>.from(
          json['grade2Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade3Attendance: List<StudentAttendance>.from(
          json['grade3Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade4Attendance: List<StudentAttendance>.from(
          json['grade4Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade5Attendance: List<StudentAttendance>.from(
          json['grade5Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade6Attendance: List<StudentAttendance>.from(
          json['grade6Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade7Attendance: List<StudentAttendance>.from(
          json['grade7Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade8Attendance: List<StudentAttendance>.from(
          json['grade8Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade9Attendance: List<StudentAttendance>.from(
          json['grade9Attendance'].map((x) => StudentAttendance.fromJson(x))),
      grade10Attendance: List<StudentAttendance>.from(
          json['grade10Attendance'].map((x) => StudentAttendance.fromJson(x))),
    );
  }
}

class StudentAttendance {
  String section;
  int total;
  int present;
  int late;
  int leave;
  int absent;
  double percentage;

  StudentAttendance({
    required this.section,
    required this.total,
    required this.present,
    required this.late,
    required this.leave,
    required this.absent,
    required this.percentage,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      section: json['section'],
      total: json['total'],
      present: json['present'],
      late: json['late'],
      leave: json['leave'],
      absent: json['absent'],
      percentage: json['percentage'].toDouble(),
    );
  }
}
