class EditCircularModels {
  final int id;
  final String headLine;
  final String circular;
  final String fileType;
  final String filePath;
  final String postedOnDate;
  final String postedOnDay;
  final String? updatedOn;
  final List<int> gradeIds;
  final String recipient;

  EditCircularModels({
    required this.id,
    required this.headLine,
    required this.circular,
    required this.fileType,
    required this.filePath,
    required this.postedOnDate,
    required this.postedOnDay,
    this.updatedOn,
    required this.gradeIds,
    required this.recipient,
  });

  factory EditCircularModels.fromJson(Map<String, dynamic> json) {
    String postedOn = json['postedOn'] ?? '';
    List<String> postedOnParts = postedOn.split(' ');

    return EditCircularModels(
      id: json['id'] ?? 0,
      headLine: json['headLine'] ?? '',
      circular: json['circular'] ?? '',
      fileType: json['filetype'] ?? '',
      filePath: json['filepath'] ?? '',
      postedOnDate: postedOnParts.isNotEmpty ? postedOnParts[0] : '',
      postedOnDay: postedOnParts.length > 1 ? postedOnParts[1] : '',
      updatedOn: json['updatedOn'],
      gradeIds: List<int>.from(json['gradeIds'] ?? []),
      recipient: json['recipient'] ?? '',
    );
  }
}
