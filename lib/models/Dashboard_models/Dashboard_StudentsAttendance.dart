class StudentAttendanceModel {
  List<Attendance> preKgAttendance;
  List<Attendance> lkgAttendance;
  List<Attendance> ukgAttendance;
  List<Attendance> grade1Attendance;
  List<Attendance> grade2Attendance;
  List<Attendance> grade3Attendance;
  List<Attendance> grade4Attendance;
  List<Attendance> grade5Attendance;
  List<Attendance> grade6Attendance;
  List<Attendance> grade7Attendance;
  List<Attendance> grade8Attendance;
  List<Attendance> grade9Attendance;
  List<Attendance> grade10Attendance;

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
      preKgAttendance: List<Attendance>.from(
          json['pre_kg_attendance'].map((x) => Attendance.fromJson(x))),
      lkgAttendance: List<Attendance>.from(
          json['lkg_attendance'].map((x) => Attendance.fromJson(x))),
      ukgAttendance: List<Attendance>.from(
          json['ukg_attendance'].map((x) => Attendance.fromJson(x))),
      grade1Attendance: List<Attendance>.from(
          json['grade1Attendance'].map((x) => Attendance.fromJson(x))),
      grade2Attendance: List<Attendance>.from(
          json['grade2Attendance'].map((x) => Attendance.fromJson(x))),
      grade3Attendance: List<Attendance>.from(
          json['grade3Attendance'].map((x) => Attendance.fromJson(x))),
      grade4Attendance: List<Attendance>.from(
          json['grade4Attendance'].map((x) => Attendance.fromJson(x))),
      grade5Attendance: List<Attendance>.from(
          json['grade5Attendance'].map((x) => Attendance.fromJson(x))),
      grade6Attendance: List<Attendance>.from(
          json['grade6Attendance'].map((x) => Attendance.fromJson(x))),
      grade7Attendance: List<Attendance>.from(
          json['grade7Attendance'].map((x) => Attendance.fromJson(x))),
      grade8Attendance: List<Attendance>.from(
          json['grade8Attendance'].map((x) => Attendance.fromJson(x))),
      grade9Attendance: List<Attendance>.from(
          json['grade9Attendance'].map((x) => Attendance.fromJson(x))),
      grade10Attendance: List<Attendance>.from(
          json['grade10Attendance'].map((x) => Attendance.fromJson(x))),
    );
  }
}

class Attendance {
  String section;
  int total;
  int present;
  int late;
  int leave;
  int absent;
  double percentage;

  Attendance({
    required this.section,
    required this.total,
    required this.present,
    required this.late,
    required this.leave,
    required this.absent,
    required this.percentage,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
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
