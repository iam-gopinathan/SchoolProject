import 'package:intl/intl.dart';

class News {
  final String headline;
  final String newsContent;
  final DateTime postedOn;
  final String filePath;
  final int count;
  final String fileType;

  News({
    required this.headline,
    required this.newsContent,
    required this.postedOn,
    required this.filePath,
    required this.count,
    required this.fileType,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      headline: json['headline'],
      newsContent: json['newscontent'],
      postedOn: DateFormat("dd-MM-yyyy").parse(json['postedOn']),
      filePath: json['filepath'],
      count: json['count'],
      fileType: json['filetype'],
    );
  }
}
