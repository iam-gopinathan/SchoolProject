class GradeGet {
  final int id;
  final String grade;
  final String sign;

  GradeGet({required this.id, required this.grade, required this.sign});

  factory GradeGet.fromJson(Map<String, dynamic> json) {
    return GradeGet(
      id: json['id'],
      grade: json['grade'],
      sign: json['sign'],
    );
  }
}
