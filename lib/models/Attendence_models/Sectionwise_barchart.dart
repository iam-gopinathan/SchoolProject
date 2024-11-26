// Model for DetailedAttendance
class DetailedAttendanceModel {
  final String section;
  final double percentage;

  DetailedAttendanceModel({
    required this.section,
    required this.percentage,
  });

  // Convert JSON object into DetailedAttendanceModel
  factory DetailedAttendanceModel.fromJson(Map<String, dynamic> json) {
    return DetailedAttendanceModel(
      section: json['section'] ?? '',
      percentage:
          json['percentage'] != null ? json['percentage'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'percentage': percentage,
    };
  }
}

// Model for SectionDetails
class SectionDetailsModel {
  final int totalStudents;
  final int male;
  final int female;
  final int present;
  final int absent;
  final int leave;
  final int late;
  final int presentPercentage;

  SectionDetailsModel({
    required this.totalStudents,
    required this.male,
    required this.female,
    required this.present,
    required this.absent,
    required this.leave,
    required this.late,
    required this.presentPercentage,
  });

  // Convert JSON object into SectionDetailsModel
  factory SectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return SectionDetailsModel(
      totalStudents: json['totalStudents'] ?? 0, // Default to 0 if null
      male: json['male'] ?? 0,
      female: json['female'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      leave: json['leave'] ?? 0,
      late: json['late'] ?? 0,
      presentPercentage: json['presentPercentage'] != null
          ? json['presentPercentage']
          // Convert to double if not null
          : 0, // Default to 0.0 if null
    );
  }

  // Convert SectionDetailsModel to JSON object
  Map<String, dynamic> toJson() {
    return {
      'totalStudents': totalStudents,
      'male': male,
      'female': female,
      'present': present,
      'absent': absent,
      'leave': leave,
      'late': late,
      'presentPercentage': presentPercentage,
    };
  }
}

// Parent model that contains both the detailedAttendance and sectionDetails
class AttendanceDataModel {
  final List<DetailedAttendanceModel> detailedAttendance;
  final SectionDetailsModel sectionDetails;

  AttendanceDataModel({
    required this.detailedAttendance,
    required this.sectionDetails,
  });

  // Convert JSON object into AttendanceDataModel
  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['detailedAttendance'] as List? ?? [];
    List<DetailedAttendanceModel> detailedList =
        list.map((i) => DetailedAttendanceModel.fromJson(i)).toList();

    return AttendanceDataModel(
      detailedAttendance: detailedList,
      sectionDetails: SectionDetailsModel.fromJson(json['sectionDetails']),
    );
  }

  // Convert AttendanceDataModel to JSON object
  Map<String, dynamic> toJson() {
    return {
      'detailedAttendance': detailedAttendance.map((i) => i.toJson()).toList(),
      'sectionDetails': sectionDetails.toJson(),
    };
  }
}
