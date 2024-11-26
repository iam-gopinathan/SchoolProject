class AttendanceData {
  final CategoryData nurseryPrimary;
  final CategoryData secondary;
  final String totalSchoolStudents;

  AttendanceData(
      {required this.nurseryPrimary,
      required this.secondary,
      required this.totalSchoolStudents});

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      nurseryPrimary: CategoryData.fromJson(json['nurseryAndPrimary']),
      secondary: CategoryData.fromJson(json['secondary']),
      totalSchoolStudents: json['totalSchoolStudents'] ?? '',
    );
  }
}

class CategoryData {
  final AttendanceStatus overallLate;
  final AttendanceStatus overallLeave;
  final AttendanceStatus overallAbsent;
  final AttendanceStatus overallPresent;

  CategoryData({
    required this.overallLate,
    required this.overallLeave,
    required this.overallAbsent,
    required this.overallPresent,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      overallLate: AttendanceStatus.fromJson(json['overallLate']),
      overallLeave: AttendanceStatus.fromJson(json['overallLeave']),
      overallAbsent: AttendanceStatus.fromJson(json['overallAbsent']),
      overallPresent: AttendanceStatus.fromJson(json['overallPresent']),
    );
  }
}

class AttendanceStatus {
  final String totalStudents;
  final String percentage;
  final String count;

  AttendanceStatus({
    required this.totalStudents,
    required this.percentage,
    required this.count,
  });

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) {
    return AttendanceStatus(
      totalStudents: json['totalStudents'],
      percentage: json['percentage'],
      count: json.containsKey('late')
          ? json['late']
          : json.containsKey('leave')
              ? json['leave']
              : json.containsKey('absent')
                  ? json['absent']
                  : json.containsKey('present')
                      ? json['present']
                      : '0',
    );
  }
}
