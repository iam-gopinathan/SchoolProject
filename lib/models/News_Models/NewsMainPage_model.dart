// news_model.dart
class NewsmainpageModel {
  final String userType;
  final String name;
  final String rollNumber;
  final String time;
  final int id;
  final String headline;
  final String news;
  final String fileType;
  final String? filePath;
  final String status;
  final String isAlterAvailable;
  final String? updatedOn;

  NewsmainpageModel({
    required this.userType,
    required this.name,
    required this.rollNumber,
    required this.time,
    required this.id,
    required this.headline,
    required this.news,
    required this.fileType,
    this.filePath,
    required this.status,
    required this.isAlterAvailable,
    this.updatedOn,
  });

  // Factory constructor to parse JSON response
  factory NewsmainpageModel.fromJson(Map<String, dynamic> json) {
    return NewsmainpageModel(
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      time: json['time'] ?? '',
      id: json['id'] ?? 0,
      headline: json['headLine'] ?? '',
      news: json['news'] ?? '',
      fileType: json['fileType'] ?? '',
      filePath: json['filePath'],
      status: json['status'] ?? '',
      isAlterAvailable: json['isAlterAvilable'] ?? '',
      updatedOn: json['updatedOn'],
    );
  }
}

class NewsResponse {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<NewsmainpageModel> news;

  NewsResponse({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.news,
  });

  // Factory constructor to parse JSON response
  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['news'] as List;
    List<NewsmainpageModel> newsList =
        list.map((i) => NewsmainpageModel.fromJson(i)).toList();

    return NewsResponse(
      postedOnDate: json['postedOnDate'] ?? '',
      postedOnDay: json['postedOnDay'] ?? '',
      tag: json['tag'] ?? '',
      news: newsList,
    );
  }
}
