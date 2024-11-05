class TeacherAttendance {
  final String subUserType;
  final String? section;
  final int total;
  final int present;
  final int late;
  final int leave;
  final int absent;
  final String? subject;
  final String? userType;
  final double percentage;

  TeacherAttendance({
    required this.subUserType,
    this.section,
    required this.total,
    required this.present,
    required this.late,
    required this.leave,
    required this.absent,
    this.subject,
    this.userType,
    required this.percentage,
  });

  factory TeacherAttendance.fromJson(Map<String, dynamic> json) {
    return TeacherAttendance(
      subUserType: json['subUserType'] as String,
      section: json['section'] as String?,
      total: json['total'] as int,
      present: json['present'] as int,
      late: json['late'] as int,
      leave: json['leave'] as int,
      absent: json['absent'] as int,
      subject: json['subject'] as String?,
      userType: json['userType'] as String?,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
