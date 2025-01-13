class MarksResponse {
  final int gradeId;
  final String section;
  final String gradeSection;
  final String? classTeacher;
  final List<StudentMark> prekgRequest;

  MarksResponse({
    required this.gradeId,
    required this.section,
    required this.gradeSection,
    this.classTeacher,
    required this.prekgRequest,
  });
  //
  factory MarksResponse.fromJson(Map<String, dynamic> json) {
    return MarksResponse(
      gradeId: json['gradeId'],
      section: json['section'] ?? "",
      gradeSection: json['gradeSection'] ?? '',
      classTeacher: json['classTeacher'],
      prekgRequest: List<StudentMark>.from(
        (json['prekgRequest'] ??
                json['lkgRequest'] ??
                json['ukgRequest'] ??
                json['grade1Request'] ??
                json['grade2Request'] ??
                json['grade3Request'] ??
                json['grade4Request'] ??
                json['grade5Request'] ??
                json['grade6Request'] ??
                json['grade7Request'] ??
                json['grade8Request'] ??
                json['grade9Request'] ??
                json['grade10Request'])
            .map((student) => StudentMark.fromJson(student)),
      ),
    );
  }
}

class StudentMark {
  final String examName;
  final String rollnumber;
  final String studentName;
  final String grade;
  final String section;
  final String profile;
  final int totalMarks;
  final String status;
  final int marksScored;
  final int percentage;
  final String remarks;
  final String teacherNotes;
  final int tamil;
  final int english;
  final int hindi;

  StudentMark({
    required this.examName,
    required this.rollnumber,
    required this.studentName,
    required this.grade,
    required this.section,
    required this.profile,
    required this.totalMarks,
    required this.status,
    required this.marksScored,
    required this.percentage,
    required this.remarks,
    required this.teacherNotes,
    required this.tamil,
    required this.english,
    required this.hindi,
  });

  factory StudentMark.fromJson(Map<String, dynamic> json) {
    return StudentMark(
      examName: json['examName'],
      rollnumber: json['rollnumber'],
      studentName: json['studentName'],
      grade: json['grade'],
      section: json['section'],
      profile: json['profile'],
      totalMarks: json['totalMarks'],
      status: json['status'],
      marksScored: json['marksScored'],
      percentage: json['percentage'],
      remarks: json['remarks'],
      teacherNotes: json['teacherNotes'],
      tamil: json['tamil'],
      english: json['english'],
      hindi: json['hindi'],
    );
  }
  // Empty StudentMark constructor
  static StudentMark empty() {
    return StudentMark(
      examName: '',
      rollnumber: '',
      studentName: '',
      grade: '',
      section: '',
      profile: '',
      totalMarks: 0,
      status: '',
      marksScored: 0,
      percentage: 0,
      remarks: '',
      teacherNotes: '',
      tamil: 0,
      english: 0,
      hindi: 0,
    );
  }
}
