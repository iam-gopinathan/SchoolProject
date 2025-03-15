class EditNewsModel {
  final int? id;
  final String headline;
  final String news;
  final String fileType;
  String file;
  final String link;
  final String postedOn;
  final String status;
  final String? scheduleOn;
  final String? draftedOn;
  final String? updatedOn;
  final String? rollNumber; // Add rollNumber here
  final String? userType; // Add userType here
  final String? filepath;
  String? scheduleOnRailwayTime;

  EditNewsModel({
    this.id,
    required this.headline,
    required this.news,
    required this.fileType,
    required this.file,
    required this.link,
    required this.postedOn,
    required this.status,
    this.scheduleOn,
    this.draftedOn,
    this.updatedOn,
    this.rollNumber, // Add rollNumber to the constructor
    this.userType, // Add userType to the constructor
    this.filepath,
    this.scheduleOnRailwayTime,
  });

  factory EditNewsModel.fromJson(Map<String, dynamic> json) {
    return EditNewsModel(
        id: json['id'],
        headline: json['headLine'] ?? '',
        news: json['news'] ?? '',
        fileType: json['filetype'] ?? '',
        file: json['filepath'] ?? '',
        link: json['filename'] ?? '',
        postedOn: json['postedOn'] ?? '',
        status: json['status'] ?? '',
        scheduleOn: json['scheduleOn'],
        draftedOn: json['draftedOn'],
        updatedOn: json['updatedOn'],
        rollNumber:
            json['rollNumber'], // Ensure rollNumber is included in the JSON
        userType: json['userType'], // Ensure userType is included in the JSON

        filepath: json['filepath'],
        scheduleOnRailwayTime: json['scheduleOnRailwayTime'] ?? '');
  }
}
