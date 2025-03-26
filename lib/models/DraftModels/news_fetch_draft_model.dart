class NewsFetchDraftModel {
  final List<NewsData> data;

  NewsFetchDraftModel({required this.data});

  factory NewsFetchDraftModel.fromJson(Map<String, dynamic> json) {
    return NewsFetchDraftModel(
      data: (json['data'] as List)
          .map((item) => NewsData.fromJson(item))
          .toList(),
    );
  }
}

class NewsData {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<NewsItem> news;

  NewsData({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.news,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'] ?? '',
      news: (json['news'] as List)
          .map((item) => NewsItem.fromJson(item))
          .toList(),
    );
  }
}

class NewsItem {
  final String userType;
  final String name;
  final String rollNumber;
  final String time;
  final int id;
  final String headLine;
  final String? news;
  final String fileType;
  final String? filePath;
  final String status;
  final String isAlterAvilable;

  NewsItem({
    required this.userType,
    required this.name,
    required this.rollNumber,
    required this.time,
    required this.id,
    required this.headLine,
    this.news,
    required this.fileType,
    this.filePath,
    required this.status,
    required this.isAlterAvilable,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      userType: json['userType'],
      name: json['name'],
      rollNumber: json['rollNumber'],
      time: json['time'],
      id: json['id'],
      headLine: json['headLine'],
      news: json['news'],
      fileType: json['fileType'],
      filePath: json['filePath'],
      status: json['status'],
      isAlterAvilable: json['isAlterAvilable'],
    );
  }
}
