// AttendanceStatus Model
class AttendanceStatus {
  String? today;
  String? date;
  int? monthTotalDays;
  int? present;
  int? leave;
  int? absent;
  int? late;
  int? percentage;

  AttendanceStatus({
    this.today,
    this.date,
    this.monthTotalDays,
    this.present,
    this.leave,
    this.absent,
    this.late,
    this.percentage,
  });

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) {
    return AttendanceStatus(
      today: json['today'],
      date: json['date'],
      monthTotalDays: json['monthTotalDays'],
      present: json['present'],
      leave: json['leave'],
      absent: json['absent'],
      late: json['late'],
      percentage: json['percentage'],
    );
  }
}

// AttendanceGraph Model
class AttendanceGraph {
  double? january;
  double? february;
  double? march;
  double? april;
  double? may;
  double? june;
  double? july;
  double? august;
  double? september;
  double? october;
  double? november;
  double? december;

  AttendanceGraph({
    this.january,
    this.february,
    this.march,
    this.april,
    this.may,
    this.june,
    this.july,
    this.august,
    this.september,
    this.october,
    this.november,
    this.december,
  });

  factory AttendanceGraph.fromJson(Map<String, dynamic> json) {
    return AttendanceGraph(
      january: (json['january'] ?? 0).toDouble(),
      february: (json['february'] ?? 0).toDouble(),
      march: (json['march'] ?? 0).toDouble(),
      april: (json['april'] ?? 0).toDouble(),
      may: (json['may'] ?? 0).toDouble(),
      june: (json['june'] ?? 0).toDouble(),
      july: (json['july'] ?? 0).toDouble(),
      august: (json['august'] ?? 0).toDouble(),
      september: (json['september'] ?? 0).toDouble(),
      october: (json['october'] ?? 0).toDouble(),
      november: (json['november'] ?? 0).toDouble(),
      december: (json['december'] ?? 0).toDouble(),
    );
  }
}

// Main ParentattendenceResponse Model
class ParentattendenceResponse {
  AttendanceStatus? attendanceStatus;
  AttendanceGraph? attendanceGraph;

  ParentattendenceResponse({this.attendanceStatus, this.attendanceGraph});

  factory ParentattendenceResponse.fromJson(Map<String, dynamic> json) {
    return ParentattendenceResponse(
      attendanceStatus: json['attendanceStatus'] != null
          ? AttendanceStatus.fromJson(json['attendanceStatus'])
          : null,
      attendanceGraph: json['attendanceGraph'] != null
          ? AttendanceGraph.fromJson(json['attendanceGraph'])
          : null,
    );
  }
}
