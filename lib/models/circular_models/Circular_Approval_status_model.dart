class CircularApprovalStatusModel {
  String status;
  String circularStatus;
  String createdByUserType;
  String createdByName;
  String createdByRollNumber;
  String onDate;
  String onDay;
  String onTime;
  int id;
  String headLine;
  String circular;
  String fileType;
  String filePath;
  String recipient;
  List<int> gradeIds;
  String? declinedByUserType;
  String? declinedByName;
  String? declinedByRollNumber;
  String? declinedOnDate;
  String? reason;
  String? requestFor;

  CircularApprovalStatusModel({
    required this.status,
    required this.circularStatus,
    required this.createdByUserType,
    required this.createdByName,
    required this.createdByRollNumber,
    required this.onDate,
    required this.onDay,
    required this.onTime,
    required this.id,
    required this.headLine,
    required this.circular,
    required this.fileType,
    required this.filePath,
    required this.recipient,
    required this.gradeIds,
    this.declinedByUserType,
    this.declinedByName,
    this.declinedByRollNumber,
    this.declinedOnDate,
    this.reason,
    this.requestFor,
  });

  // Convert JSON data to CircularApprovalStatusModel model
  factory CircularApprovalStatusModel.fromJson(Map<String, dynamic> json) {
    return CircularApprovalStatusModel(
      status: json['status'] ?? '',
      circularStatus: json['circularStatus'] ?? '',
      createdByUserType: json['createdByUserType'] ?? '',
      createdByName: json['createdByName'] ?? '',
      createdByRollNumber: json['createdByRollNumber'] ?? '',
      onDate: json['onDate'] ?? '',
      onDay: json['onDay'] ?? '',
      onTime: json['onTime'] ?? '',
      id: json['id'] ?? '',
      headLine: json['headLine'] ?? '',
      circular: json['circular'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'] ?? '',
      recipient: json['recipient'],
      gradeIds: List<int>.from(json['gradeIds'] ?? []),
      declinedByUserType: json['declinedByUserType'] ?? '',
      declinedByName: json['declinedByName'] ?? '',
      declinedByRollNumber: json['declinedByRollNumber'] ?? '',
      declinedOnDate: json['declinedOnDate'] ?? '',
      reason: json['reason'] ?? '',
      requestFor: json['requestFor'] ?? '',
    );
  }

  // Convert CircularApprovalStatusModel model to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'circularStatus': circularStatus,
      'createdByUserType': createdByUserType,
      'createdByName': createdByName,
      'createdByRollNumber': createdByRollNumber,
      'onDate': onDate,
      'onDay': onDay,
      'onTime': onTime,
      'id': id,
      'headLine': headLine,
      'circular': circular,
      'fileType': fileType,
      'filePath': filePath,
      'recipient': recipient,
      'gradeIds': gradeIds,
      'declinedByUserType': declinedByUserType,
      'declinedByName': declinedByName,
      'declinedByRollNumber': declinedByRollNumber,
      'declinedOnDate': declinedOnDate,
      'reason': reason,
      'requestFor': requestFor,
    };
  }
}

class CircularResponse {
  List<CircularApprovalStatusModel> data;

  CircularResponse({required this.data});

  factory CircularResponse.fromJson(Map<String, dynamic> json) {
    return CircularResponse(
      data: List<CircularApprovalStatusModel>.from(
        json['data'].map((x) => CircularApprovalStatusModel.fromJson(x)),
      ),
    );
  }
}
