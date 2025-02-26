class StudentsFetchModel {
  final String rollNumber;
  final String name;
  final String grade;
  final String section;
  final String profile;

  StudentsFetchModel({
    required this.rollNumber,
    required this.name,
    required this.grade,
    required this.section,
    required this.profile,
  });

  factory StudentsFetchModel.fromJson(Map<String, dynamic> json) {
    return StudentsFetchModel(
      rollNumber: json['rollNumber'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      section: json['section'] ?? '',
      profile: json['profile'] ?? '',
    );
  }
}

class GradeMarkss {
  final int gradeId;
  final String section;
  final String gradeSection;
  final List<String> subjects;
  final List<StudentsFetchModel> students;
  final String classTeacher;

  GradeMarkss(
      {required this.gradeId,
      required this.section,
      required this.gradeSection,
      required this.subjects,
      required this.students,
      required this.classTeacher});

  factory GradeMarkss.fromJson(Map<String, dynamic> json) {
    var list = json['students'] as List;
    List<StudentsFetchModel> studentList =
        list.map((i) => StudentsFetchModel.fromJson(i)).toList();

    return GradeMarkss(
      gradeId: json['gradeId'] ?? '',
      section: json['section'] ?? "",
      gradeSection: json['gradeSection'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? ''),
      students: studentList,
      classTeacher: json['classTeacher'] ?? '',
    );
  }
}
