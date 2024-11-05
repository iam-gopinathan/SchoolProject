class Birthday {
  final String name;
  final String rollNumber;
  final String? subject;
  final String filepath;

  Birthday({
    required this.name,
    required this.rollNumber,
    this.subject,
    required this.filepath,
  });

  factory Birthday.fromJson(Map<String, dynamic> json) {
    return Birthday(
      name: json['name'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      subject: json['subject'] as String?,
      filepath: json['filepath'] ?? '',
    );
  }
}
