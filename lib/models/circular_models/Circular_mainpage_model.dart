class CircularMainpageModel {
  final String userType;
  final String name;
  final String rollNumber;
  final String time;
  final int id;
  final String headLine;
  final String circular;
  final String fileType;
  final String? filePath;
  final String status;
  final String isAlterAvailable;
  final String? updatedOn;
  final String recipient;
  final List<int> gradeIds;

  CircularMainpageModel({
    required this.userType,
    required this.name,
    required this.rollNumber,
    required this.time,
    required this.id,
    required this.headLine,
    required this.circular,
    required this.fileType,
    this.filePath,
    required this.status,
    required this.isAlterAvailable,
    this.updatedOn,
    required this.recipient,
    required this.gradeIds,
  });

  factory CircularMainpageModel.fromJson(Map<String, dynamic> json) {
    return CircularMainpageModel(
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      time: json['time'] ?? '',
      id: json['id'],
      headLine: json['headLine'] ?? '',
      circular: json['circular'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'],
      status: json['status'] ?? '',
      isAlterAvailable: json['isAlterAvilable'] ?? '',
      updatedOn: json['updatedOn'],
      recipient: json['recipient'] ?? '',
      gradeIds: List<int>.from(json['gradeIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'name': name,
      'rollNumber': rollNumber,
      'time': time,
      'id': id,
      'headLine': headLine,
      'circular': circular,
      'fileType': fileType,
      'filePath': filePath,
      'status': status,
      'isAlterAvilable': isAlterAvailable,
      'updatedOn': updatedOn,
      'recipient': recipient,
      'gradeIds': gradeIds,
    };
  }
}

class CircularResponse {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<CircularMainpageModel> circulars;

  CircularResponse({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.circulars,
  });

  factory CircularResponse.fromJson(Map<String, dynamic> json) {
    var list = json['circular'] as List? ?? [];
    List<CircularMainpageModel> circularList =
        list.map((i) => CircularMainpageModel.fromJson(i)).toList();

    return CircularResponse(
      postedOnDate: json['postedOnDate'] ?? '',
      postedOnDay: json['postedOnDay'] ?? '',
      tag: json['tag'] ?? '',
      circulars: circularList,
    );
  }
}
