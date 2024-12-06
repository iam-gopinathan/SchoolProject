class NewsArticle {
  final String headline;
  final String newsContent;
  final String postedOn;
  final String filePath;
  final int count;

  NewsArticle({
    required this.headline,
    required this.newsContent,
    required this.postedOn,
    required this.filePath,
    required this.count,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      headline: json['headline'] ?? '',
      newsContent: json['newscontent'] ?? '',
      postedOn: json['postedOn'] ?? '',
      filePath: json['filepath'] ?? '',
      count: json['count'] ?? '',
    );
  }
}
