class ParentmarksModel {
  final Data data;
  final List<String> subjects;
  final Map<String, Exam> exams;

  ParentmarksModel({
    required this.data,
    required this.subjects,
    required this.exams,
  });

  factory ParentmarksModel.fromJson(Map<String, dynamic> json) {
    return ParentmarksModel(
      data: Data.fromJson(json['data']),
      subjects: List<String>.from(json['subject'] ?? []),
      exams: (json['exams'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Exam.fromJson(value)),
      ),
    );
  }
}

class Data {
  final String name;
  final String rollNumber;
  final String profile;
  final String gradeAndSection;

  Data({
    required this.name,
    required this.rollNumber,
    required this.profile,
    required this.gradeAndSection,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'] ?? '',
      rollNumber: json['rollnumber'] ?? '',
      profile: json['profile'] ?? '',
      gradeAndSection: json['gradeAndSection'] ?? '',
    );
  }
}

class Exam {
  final String totalMarks;
  final String marksScored;
  final String remarks;
  final String percentage;
  final String teacherNotes;
  final Map<String, String> subjectMarks;

  Exam({
    required this.totalMarks,
    required this.marksScored,
    required this.remarks,
    required this.percentage,
    required this.teacherNotes,
    required this.subjectMarks,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    final subjectMarks = Map<String, String>.from(json)
      ..removeWhere((key, value) => [
            'totalMarks',
            'marksScored',
            'remarks',
            'percentage',
            'teacherNotes'
          ].contains(key));

    return Exam(
      totalMarks: json['totalMarks'] ?? '',
      marksScored: json['marksScored'] ?? '',
      remarks: json['remarks'] ?? '',
      percentage: json['percentage'] ?? '',
      teacherNotes: json['teacherNotes'] ?? '',
      subjectMarks: subjectMarks,
    );
  }
}
