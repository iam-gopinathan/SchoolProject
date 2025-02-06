class ParentIrregularattendenceModel {
  final IrregularAttendanceStatus irregularAttendanceStatus;
  final List<AttendanceDetail> absent;
  final List<AttendanceDetail> leave;
  final List<AttendanceDetail> late;

  ParentIrregularattendenceModel({
    required this.irregularAttendanceStatus,
    required this.absent,
    required this.leave,
    required this.late,
  });

  factory ParentIrregularattendenceModel.fromJson(Map<String, dynamic> json) {
    return ParentIrregularattendenceModel(
      irregularAttendanceStatus:
          IrregularAttendanceStatus.fromJson(json['irregularAttendanceStatus']),
      absent: (json['absent'] as List)
          .map((item) => AttendanceDetail.fromJson(item))
          .toList(),
      leave: (json['leave'] as List)
          .map((item) => AttendanceDetail.fromJson(item))
          .toList(),
      late: (json['late'] as List)
          .map((item) => AttendanceDetail.fromJson(item))
          .toList(),
    );
  }
}

class IrregularAttendanceStatus {
  final String today;
  final String date;
  final String monthYear;
  final int monthTotalDays;
  final int present;
  final int leave;
  final int absent;
  final int late;
  final int percentage;

  IrregularAttendanceStatus({
    required this.today,
    required this.date,
    required this.monthYear,
    required this.monthTotalDays,
    required this.present,
    required this.leave,
    required this.absent,
    required this.late,
    required this.percentage,
  });

  factory IrregularAttendanceStatus.fromJson(Map<String, dynamic> json) {
    return IrregularAttendanceStatus(
      today: json['today'] ?? '',
      date: json['date'] ?? '',
      monthYear: json['monthYear'] ?? '',
      monthTotalDays: json['monthTotalDays'] ?? 0,
      present: json['present'] ?? 0,
      leave: json['leave'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}

class AttendanceDetail {
  final String day;
  final String date;

  AttendanceDetail({
    required this.day,
    required this.date,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      day: json['day'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
