import 'package:intl/intl.dart';

class ImportanteventMainpageModel {
  final int id;
  final String userType;
  final String rollNumber;
  final String headLine;
  final String description;
  final String fileType;
  final String fileName;
  final String filePath;
  final String fromDate;
  final String toDate;
  final String from;
  final String to;

  ImportanteventMainpageModel({
    required this.id,
    required this.userType,
    required this.rollNumber,
    required this.headLine,
    required this.description,
    required this.fileType,
    required this.fileName,
    required this.filePath,
    required this.fromDate,
    required this.toDate,
    required this.from,
    required this.to,
  });

  // Convert fromDate and toDate to DateTime using the intl package
  // DateTime get parsedFromDate => DateFormat('dd-MM-yyyy').parse(fromDate);
  // DateTime get parsedToDate => DateFormat('dd-MM-yyyy').parse(toDate);

  DateTime get parsedFromDate => DateFormat('dd-MM-yyyy').parseUtc(fromDate);
  DateTime get parsedToDate => DateFormat('dd-MM-yyyy').parseUtc(toDate);

  // Check if event is within the selected date range
  bool isEventInRange(DateTime selectedDate) {
    return (parsedFromDate.isBefore(selectedDate) ||
            parsedFromDate.isAtSameMomentAs(selectedDate)) &&
        (parsedToDate.isAfter(selectedDate) ||
            parsedToDate.isAtSameMomentAs(selectedDate));
  }

  factory ImportanteventMainpageModel.fromJson(Map<String, dynamic> json) {
    return ImportanteventMainpageModel(
      id: json['id'] ?? '',
      userType: json['userType'] ?? '',
      rollNumber: json['rollnumber'] ?? '',
      headLine: json['headLine'] ?? '',
      description: json['description'] ?? '',
      fileType: json['filetype'] ?? '',
      fileName: json['filename'] ?? '',
      filePath: json['filepath'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
    );
  }
}

class EventsResponsess {
  final List<ImportanteventMainpageModel> todayEvents;
  final List<ImportanteventMainpageModel> upComingEvents;
  final List<ImportanteventMainpageModel> allEvents;

  EventsResponsess({
    required this.todayEvents,
    required this.upComingEvents,
    required this.allEvents,
  });

  factory EventsResponsess.fromJson(Map<String, dynamic> json) {
    return EventsResponsess(
      todayEvents: (json['todayEvents'] as List)
          .map((event) => ImportanteventMainpageModel.fromJson(event))
          .toList(),
      upComingEvents: (json['upCommingEvents'] as List)
          .map((event) => ImportanteventMainpageModel.fromJson(event))
          .toList(),
      allEvents: (json['allEvents'] as List)
          .map((event) => ImportanteventMainpageModel.fromJson(event))
          .toList(),
    );
  }
}
