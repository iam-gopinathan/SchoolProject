class NewsUpdateModel {
  final int id;
  final String rollNumber;
  final String userType;
  final String headLine;
  final String news;
  final String file;
  final String fileType;
  final String link;
  final String status;
  final String? scheduleOn;
  final String postedOn;
  final String? updatedOn;

  NewsUpdateModel({
    required this.id,
    required this.rollNumber,
    required this.userType,
    required this.headLine,
    required this.news,
    required this.file,
    required this.fileType,
    required this.link,
    required this.status,
    this.scheduleOn,
    required this.postedOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rollNumber': rollNumber,
      'userType': userType,
      'headLine': headLine,
      'news': news,
      'file': file,
      'fileType': fileType,
      'link': link,
      'status': status,
      'scheduleOn': scheduleOn,
      'postedOn': postedOn,
      'updatedOn': updatedOn,
    };
  }

  factory NewsUpdateModel.fromJson(Map<String, dynamic> json) {
    return NewsUpdateModel(
      id: json['id'],
      rollNumber: json['rollNumber'],
      userType: json['userType'],
      headLine: json['headLine'],
      news: json['news'],
      file: json['file'],
      fileType: json['fileType'],
      link: json['link'],
      status: json['status'],
      scheduleOn: json['scheduleOn'],
      postedOn: json['postedOn'],
      updatedOn: json['updatedOn'],
    );
  }
}
