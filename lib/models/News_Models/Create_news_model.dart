class CreateNewsModel {
  String headline;
  String news;
  String userType;
  String rollNumber;
  String postedOn;
  String status;
  String scheduleOn;
  String draftedOn;
  String fileType;
  String file;
  String link;

  CreateNewsModel({
    required this.headline,
    required this.news,
    required this.userType,
    required this.rollNumber,
    required this.postedOn,
    required this.status,
    required this.scheduleOn,
    required this.draftedOn,
    required this.fileType,
    required this.file,
    required this.link,
  });

  // copyWith method to add or modify fields
  CreateNewsModel copyWith({
    String? headline,
    String? news,
    String? userType,
    String? rollNumber,
    String? postedOn,
    String? status,
    String? scheduleOn,
    String? draftedOn,
    String? fileType,
    String? file,
    String? link,
  }) {
    return CreateNewsModel(
      headline: headline ?? this.headline,
      news: news ?? this.news,
      userType: userType ?? this.userType,
      rollNumber: rollNumber ?? this.rollNumber,
      postedOn: postedOn ?? this.postedOn,
      status: status ?? this.status,
      scheduleOn: scheduleOn ?? this.scheduleOn,
      draftedOn: draftedOn ?? this.draftedOn,
      fileType: fileType ?? this.fileType,
      file: file ?? this.file,
      link: link ?? this.link,
    );
  }

  // Convert a CreateNewsModel object into a Map (for API request)
  Map<String, dynamic> toJson() {
    return {
      'HeadLine': headline,
      'News': news,
      'UserType': userType,
      'RollNumber': rollNumber,
      'PostedOn': postedOn,
      'Status': status,
      'ScheduleOn': scheduleOn,
      'DraftedOn': draftedOn,
      'FileType': fileType,
      'File': file,
      'Link': link,
    };
  }
}
