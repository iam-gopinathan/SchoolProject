class AttendanceModel {
  final String grade;
  final String percentage;
  final String group;

  AttendanceModel({
    required this.grade,
    required this.percentage,
    required this.group,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      grade: json['grade'],
      percentage: json['percentage'],
      group: json['group'],
    );
  }

  @override
  String toString() {
    return 'Grade: $grade, Percentage: $percentage%, Group: $group';
  }
}

class AttendanceResponse {
  final List<AttendanceModel> totalAttendanceGraph;

  AttendanceResponse({required this.totalAttendanceGraph});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      totalAttendanceGraph: List<AttendanceModel>.from(
        json['totalAttendanceGraph']
            .map((item) => AttendanceModel.fromJson(item)),
      ),
    );
  }
}
