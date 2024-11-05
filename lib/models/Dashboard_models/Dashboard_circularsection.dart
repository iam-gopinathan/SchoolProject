import 'package:intl/intl.dart';

class Circular {
  final String headline;
  final String circularcontent;
  final DateTime postedOn;
  final String filePath;
  final int count;

  Circular({
    required this.headline,
    required this.circularcontent,
    required this.postedOn,
    required this.filePath,
    required this.count,
  });

  factory Circular.fromJson(Map<String, dynamic> json) {
    return Circular(
      headline: json['headline'] ?? '',
      circularcontent: json['circularcontent'] ?? '',
      postedOn: DateFormat("dd-MM-yyyy").parse(json['postedOn'] ?? ""),
      filePath: json['filepath'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
