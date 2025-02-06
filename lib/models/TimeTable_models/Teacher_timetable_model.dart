// Model Class for Teacher's Time Table
class TeacherTimeTable {
  final String employeeCode;
  final String name;
  final String photo;
  final String preView;

  TeacherTimeTable({
    required this.employeeCode,
    required this.name,
    required this.photo,
    required this.preView,
  });

  factory TeacherTimeTable.fromJson(Map<String, dynamic> json) {
    return TeacherTimeTable(
      employeeCode: json['employeeCode'] ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      preView: json['preView'] ?? '',
    );
  }
}
