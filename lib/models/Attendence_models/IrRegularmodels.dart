/// Model representing individual student data.
class Irregularmodels {
  final String classTeacher;
  final String rollNumber;
  final String studentName;
  final String grade;
  final String section;
  final String studentPicture;
  final String currentStatus;

  Irregularmodels({
    required this.classTeacher,
    required this.rollNumber,
    required this.studentName,
    required this.grade,
    required this.section,
    required this.studentPicture,
    required this.currentStatus,
  });

  factory Irregularmodels.fromJson(Map<String, dynamic> json) {
    return Irregularmodels(
      classTeacher: json['classTeacher'] ?? 'No teacher assigned',
      rollNumber: json['rollNumber'] ?? 'No roll number',
      studentName: json['studentName'] ?? 'Unknown',
      grade: json['grade'] ?? 'Unknown',
      section: json['section'] ?? 'Unknown',
      studentPicture: json['studentPicture'] ?? '',
      currentStatus: json['currentStatus'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classTeacher': classTeacher,
      'rollNumber': rollNumber,
      'studentName': studentName,
      'grade': grade,
      'section': section,
      'studentPicture': studentPicture,
      'currentStatus': currentStatus,
    };
  }
}

class Grade {
  final String grade;
  final Map<String, List<Irregularmodels>> sections;

  Grade({
    required this.grade,
    required this.sections,
  });

  factory Grade.fromJson(String grade, Map<String, dynamic> json) {
    final Map<String, List<Irregularmodels>> sections = {};

    json.forEach((section, studentsList) {
      if (studentsList is List) {
        sections[section] = studentsList
            .map((studentJson) => Irregularmodels.fromJson(studentJson))
            .toList();
      } else {
        sections[section] = [];
        print('Unexpected data type for section $section');
      }
    });

    return Grade(
      grade: grade,
      sections: sections,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> sectionJson = {};
    sections.forEach((key, value) {
      sectionJson[key] = value.map((student) => student.toJson()).toList();
    });

    return {
      'grade': grade,
      'sections': sectionJson,
    };
  }
}
