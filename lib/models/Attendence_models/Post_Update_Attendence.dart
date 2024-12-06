class PostUpdateAttendence {
  final String rollNumber;
  final String status;

  PostUpdateAttendence({required this.rollNumber, required this.status});

  Map<String, dynamic> toJson() {
    return {
      'rollNumber': rollNumber,
      'status': status,
    };
  }
}
