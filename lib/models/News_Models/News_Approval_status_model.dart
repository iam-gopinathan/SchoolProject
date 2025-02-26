class NewsApprovalStatusModel {
  final String status;
  final String newsStatus;
  final String createdByUserType;
  final String createdByName;
  final String createdByRollNumber;
  final String onDate;
  final String onDay;
  final String onTime;
  final int id;
  final String headLine;
  final String news;
  final String fileType;
  final String filePath;
  final String declinedByUserType;
  final String declinedByName;
  final String declinedByRollNumber;
  final String declinedOnDate;
  final String reason;
  final String requestFor;

  NewsApprovalStatusModel({
    required this.status,
    required this.newsStatus,
    required this.createdByUserType,
    required this.createdByName,
    required this.createdByRollNumber,
    required this.onDate,
    required this.onDay,
    required this.onTime,
    required this.id,
    required this.headLine,
    required this.news,
    required this.fileType,
    required this.filePath,
    required this.declinedByUserType,
    required this.declinedByName,
    required this.declinedByRollNumber,
    required this.declinedOnDate,
    required this.reason,
    required this.requestFor,
  });

  // Factory method to convert JSON into a model
  factory NewsApprovalStatusModel.fromJson(Map<String, dynamic> json) {
    return NewsApprovalStatusModel(
      status: json['status'] ?? '',
      newsStatus: json['newsStatus'] ?? '',
      createdByUserType: json['createdByUserType'] ?? '',
      createdByName: json['createdByName'] ?? '',
      createdByRollNumber: json['createdByRollNumber'] ?? '',
      onDate: json['onDate'] ?? '',
      onDay: json['onDay'] ?? '',
      onTime: json['onTime'] ?? '',
      id: json['id'] ?? 0,
      headLine: json['headLine'] ?? '',
      news: json['news'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'] ?? '',
      declinedByUserType: json['declinedByUserType'] ?? '',
      declinedByName: json['declinedByName'] ?? '',
      declinedByRollNumber: json['declinedByRollNumber'] ?? '',
      declinedOnDate: json['declinedOnDate'] ?? '',
      reason: json['reason'] ?? '',
      requestFor: json['requestFor'] ?? '',
    );
  }
}
