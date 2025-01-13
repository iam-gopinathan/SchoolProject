class MarksRequest {
  String gradeId;
  String status;
  List<MarksDetails> allMarksRequest;

  MarksRequest({
    required this.gradeId,
    required this.status,
    required this.allMarksRequest,
  });

  Map<String, dynamic> toJson() => {
        "gradeId": gradeId,
        "status": status,
        "all_marksRequest": allMarksRequest.map((e) => e.toJson()).toList(),
      };
}

class MarksDetails {
  String examName;
  String rollnumber;
  String studentName;
  String grade;
  String section;
  String profile;
  int totalMarks;
  int marksScored;
  int percentage;
  String remarks;
  String teacherNotes;
  int tamil;
  int english;
  int hindi;
  int maths;
  int evs;
  int science;
  int social;
  int phonics;

  MarksDetails({
    required this.examName,
    required this.rollnumber,
    required this.studentName,
    required this.grade,
    required this.section,
    required this.profile,
    required this.totalMarks,
    required this.marksScored,
    required this.percentage,
    required this.remarks,
    required this.teacherNotes,
    required this.tamil,
    required this.english,
    required this.hindi,
    required this.maths,
    required this.evs,
    required this.science,
    required this.social,
    required this.phonics,
  });

  Map<String, dynamic> toJson() => {
        "examName": examName,
        "rollnumber": rollnumber,
        "studentName": studentName,
        "grade": grade,
        "section": section,
        "profile": profile,
        "totalMarks": totalMarks,
        "marksScored": marksScored,
        "percentage": percentage,
        "remarks": remarks,
        "teacherNotes": teacherNotes,
        "tamil": tamil,
        "english": english,
        "hindi": hindi,
        "maths": maths,
        "evs": evs,
        "science": science,
        "social": social,
        "phonics": phonics,
      };
}
