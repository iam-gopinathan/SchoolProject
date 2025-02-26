class ApprovalCircularModel {
  List<CircularPost> schedule;
  List<CircularPost> post;

  ApprovalCircularModel({required this.schedule, required this.post});

  factory ApprovalCircularModel.fromJson(Map<String, dynamic> json) {
    return ApprovalCircularModel(
      schedule: (json["schedule"] as List)
          .map(
              (e) => CircularPost.fromJson(e)) // Parse schedule as CircularPost
          .toList(),
      post:
          (json["post"] as List).map((e) => CircularPost.fromJson(e)).toList(),
    );
  }
}

class CircularPost {
  String status;
  String createdByUserType;
  String createdByName;
  String createdByRollNumber;
  String onDate;
  String onDay;
  String onTime;
  int id;
  String headLine;
  String circular;
  String recipient;
  List<int> gradeIds;
  String? requestFor;
  String fileType;
  String? filePath;

  CircularPost({
    required this.status,
    required this.createdByUserType,
    required this.createdByName,
    required this.createdByRollNumber,
    required this.onDate,
    required this.onDay,
    required this.onTime,
    required this.id,
    required this.headLine,
    required this.circular,
    required this.recipient,
    required this.gradeIds,
    this.requestFor,
    required this.fileType,
    this.filePath,
  });

  factory CircularPost.fromJson(Map<String, dynamic> json) {
    return CircularPost(
      status: json["status"] ?? "",
      createdByUserType: json["createdByUserType"] ?? "",
      createdByName: json["createdByName"] ?? "",
      createdByRollNumber: json["createdByRollNumber"] ?? "",
      onDate: json["onDate"] ?? "",
      onDay: json["onDay"] ?? "",
      onTime: json["onTime"] ?? "",
      id: json["id"] ?? 0,
      headLine: json["headLine"] ?? "",
      circular: json["circular"] ?? "",
      recipient: json["recipient"] ?? "",
      gradeIds: List<int>.from(json["gradeIds"] ?? []),
      requestFor: json["requestFor"],
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'], // Nullable, so it's fine to leave it as it is
    );
  }
}
