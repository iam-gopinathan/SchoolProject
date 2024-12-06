import 'dart:convert';

class AddAttendenceGetModel {
  final String? classTeacher;
  final String grade;
  final String section;
  final String isAttendanceAdded;
  final String isUpdateAvailable;
  final List<Details> details;

  AddAttendenceGetModel({
    this.classTeacher,
    required this.grade,
    required this.section,
    required this.isAttendanceAdded,
    required this.isUpdateAvailable,
    required this.details,
  });

  factory AddAttendenceGetModel.fromJson(Map<String, dynamic> json) {
    return AddAttendenceGetModel(
      classTeacher: json['classTeacher'],
      grade: json['grade'],
      section: json['section'],
      isAttendanceAdded: json['isAttendanceAdded'],
      isUpdateAvailable: json['isUpdateAvailable'],
      details:
          List<Details>.from(json['details'].map((x) => Details.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classTeacher': classTeacher,
      'grade': grade,
      'section': section,
      'isAttendanceAdded': isAttendanceAdded,
      'isUpdateAvailable': isUpdateAvailable,
      'details': details.map((x) => x.toJson()).toList(),
    };
  }
}

class Details {
  final String rollNumber;
  final String studentName;
  final String grade;
  final String section;
  final String? studentPicture;
  String attendanceAction;
  final String currentStatus;
  final int attendancePercent;

  Details({
    required this.rollNumber,
    required this.studentName,
    required this.grade,
    required this.section,
    this.studentPicture,
    required this.attendanceAction,
    required this.currentStatus,
    required this.attendancePercent,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      rollNumber: json['rollNumber'],
      studentName: json['studentName'],
      grade: json['grade'],
      section: json['section'],
      studentPicture: json['studentPicture'],
      attendanceAction: json['attendanceAction'],
      currentStatus: json['currentStatus'],
      attendancePercent: json['attendancePercent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rollNumber': rollNumber,
      'studentName': studentName,
      'grade': grade,
      'section': section,
      'studentPicture': studentPicture,
      'attendanceAction': attendanceAction,
      'currentStatus': currentStatus,
      'attendancePercent': attendancePercent,
    };
  }
}
