class CircularFetchDraftModel {
  List<CircularData>? data;

  CircularFetchDraftModel({this.data});

  factory CircularFetchDraftModel.fromJson(Map<String, dynamic> json) {
    return CircularFetchDraftModel(
      data: json['data'] != null
          ? (json['data'] as List).map((e) => CircularData.fromJson(e)).toList()
          : [],
    );
  }
}

class CircularData {
  String? postedOnDate;
  String? postedOnDay;
  String? tag;
  List<Circular>? circular;

  CircularData({this.postedOnDate, this.postedOnDay, this.tag, this.circular});

  factory CircularData.fromJson(Map<String, dynamic> json) {
    return CircularData(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'],
      circular: json['circular'] != null
          ? (json['circular'] as List).map((e) => Circular.fromJson(e)).toList()
          : [],
    );
  }
}

class Circular {
  String? userType;
  String? name;
  String? rollNumber;
  String? time;
  int? id;
  String? headLine;
  String? circular;
  String? fileType;
  String? filePath;
  String? status;
  String? isAlterAvilable;
  String? updatedOn;
  String? recipient;
  List<int>? gradeIds;
  String? approvedByName;
  String? approvedByUserType;
  String? approvedOnDate;

  Circular({
    this.userType,
    this.name,
    this.rollNumber,
    this.time,
    this.id,
    this.headLine,
    this.circular,
    this.fileType,
    this.filePath,
    this.status,
    this.isAlterAvilable,
    this.updatedOn,
    this.recipient,
    this.gradeIds,
    this.approvedByName,
    this.approvedByUserType,
    this.approvedOnDate,
  });

  factory Circular.fromJson(Map<String, dynamic> json) {
    return Circular(
      userType: json['userType'],
      name: json['name'],
      rollNumber: json['rollNumber'],
      time: json['time'],
      id: json['id'],
      headLine: json['headLine'],
      circular: json['circular'],
      fileType: json['fileType'],
      filePath: json['filePath'],
      status: json['status'],
      isAlterAvilable: json['isAlterAvilable'],
      updatedOn: json['updatedOn'],
      recipient: json['recipient'],
      gradeIds:
          json['gradeIds'] != null ? List<int>.from(json['gradeIds']) : [],
      approvedByName: json['approvedByName'],
      approvedByUserType: json['approvedByUserType'],
      approvedOnDate: json['approvedOnDate'],
    );
  }
}
