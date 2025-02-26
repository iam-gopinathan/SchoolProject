// class NewsApprovalModel {
//   List<NewsItem> post;

//   NewsApprovalModel({required this.post});

//   factory NewsApprovalModel.fromJson(Map<String, dynamic> json) {
//     return NewsApprovalModel(
//       post: (json['post'] as List).map((e) => NewsItem.fromJson(e)).toList(),
//     );
//   }
// }

// class NewsItem {
//   String status;
//   String createdByUserType;
//   String createdByName;
//   String createdByRollNumber;
//   String onDate;
//   String onDay;
//   String onTime;
//   int id;
//   String headLine;
//   String news;
//   String fileType;
//   String filePath;
//   String? requestFor;

//   NewsItem({
//     required this.status,
//     required this.createdByUserType,
//     required this.createdByName,
//     required this.createdByRollNumber,
//     required this.onDate,
//     required this.onDay,
//     required this.onTime,
//     required this.id,
//     required this.headLine,
//     required this.news,
//     required this.fileType,
//     required this.filePath,
//     this.requestFor,
//   });

//   factory NewsItem.fromJson(Map<String, dynamic> json) {
//     return NewsItem(
//       status: json['status'] ?? '',
//       createdByUserType: json['createdByUserType'] ?? '',
//       createdByName: json['createdByName'] ?? '',
//       createdByRollNumber: json['createdByRollNumber'] ?? '',
//       onDate: json['onDate'] ?? '',
//       onDay: json['onDay'] ?? '',
//       onTime: json['onTime'] ?? '',
//       id: json['id'] ?? '',
//       headLine: json['headLine'] ?? '',
//       news: json['news'] ?? '',
//       fileType: json['fileType'] ?? '',
//       filePath: json['filePath'] ?? '',
//       requestFor: json['requestFor'] ?? '',
//     );
//   }
// // }
// class NewsApprovalModel {
//   List<NewsItem> post;
//   List<NewsItem> schedule;

//   NewsApprovalModel({required this.post, required this.schedule});

//   factory NewsApprovalModel.fromJson(Map<String, dynamic> json) {
//     return NewsApprovalModel(
//       post:
//           (json['post'] as List?)?.map((e) => NewsItem.fromJson(e)).toList() ??
//               [],
//       schedule: (json['schedule'] as List?)
//               ?.map((e) => NewsItem.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
// }

// class NewsItem {
//   String status;
//   String createdByUserType;
//   String createdByName;
//   String createdByRollNumber;
//   String onDate;
//   String onDay;
//   String onTime;
//   int id;
//   String headLine;
//   String news;
//   String fileType;
//   String? filePath;
//   String? requestFor;

//   NewsItem({
//     required this.status,
//     required this.createdByUserType,
//     required this.createdByName,
//     required this.createdByRollNumber,
//     required this.onDate,
//     required this.onDay,
//     required this.onTime,
//     required this.id,
//     required this.headLine,
//     required this.news,
//     required this.fileType,
//     this.filePath,
//     this.requestFor,
//   });

//   factory NewsItem.fromJson(Map<String, dynamic> json) {
//     return NewsItem(
//       status: json['status'] ?? '',
//       createdByUserType: json['createdByUserType'] ?? '',
//       createdByName: json['createdByName'] ?? '',
//       createdByRollNumber: json['createdByRollNumber'] ?? '',
//       onDate: json['onDate'] ?? '',
//       onDay: json['onDay'] ?? '',
//       onTime: json['onTime'] ?? '',
//       id: json['id'] ?? 0,
//       headLine: json['headLine'] ?? '',
//       news: json['news'] ?? '',
//       fileType: json['fileType'] ?? '',
//       filePath: json['filePath'],
//       requestFor: json['requestFor'],
//     );
//   }
// }
class NewsApprovalModel {
  List<NewsItem> post;
  List<NewsItem> schedule;

  NewsApprovalModel({required this.post, required this.schedule});

  factory NewsApprovalModel.fromJson(Map<String, dynamic> json) {
    return NewsApprovalModel(
      post:
          (json['post'] as List?)?.map((e) => NewsItem.fromJson(e)).toList() ??
              [],
      schedule: (json['schedule'] as List?)
              ?.map((e) => NewsItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class NewsItem {
  String status;
  String createdByUserType;
  String createdByName;
  String createdByRollNumber;
  String onDate;
  String onDay;
  String onTime;
  int id;
  String headLine;
  String news;
  String fileType;
  String? filePath;
  String? requestFor;

  NewsItem({
    required this.status,
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
    this.filePath,
    this.requestFor,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      status: json['status'] ?? '',
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
      filePath: json['filePath'], // Nullable, so it's fine to leave it as it is
      requestFor:
          json['requestFor'], // Nullable, so it's fine to leave it as it is
    );
  }
}
