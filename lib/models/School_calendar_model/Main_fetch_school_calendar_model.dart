import 'package:intl/intl.dart';

class EventsResponse {
  final List<Event> todayEvents;
  final List<Event> upcomingEvents;
  final List<Event> allEvents;

  EventsResponse({
    required this.todayEvents,
    required this.upcomingEvents,
    required this.allEvents,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    return EventsResponse(
      todayEvents: (json['todayEvents'] as List<dynamic>?)
              ?.map((x) => Event.fromJson(x))
              .toList() ??
          [],
      upcomingEvents: (json['upcomingEvents'] as List<dynamic>?)
              ?.map((x) => Event.fromJson(x))
              .toList() ??
          [],
      allEvents: (json['allEvents'] as List<dynamic>?)
              ?.map((x) => Event.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayEvents': todayEvents.map((x) => x.toJson()).toList(),
      'upCommingEvents': upcomingEvents.map((x) => x.toJson()).toList(),
      'allEvents': allEvents.map((x) => x.toJson()).toList(),
    };
  }
}

class Event {
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
  final String? updatedOn;
  final String from;
  final String to;

  Event({
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
    this.updatedOn,
    required this.from,
    required this.to,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      userType: json['userType'] ?? '',
      rollNumber: json['rollnumber'] ?? '',
      headLine: json['headLine'] ?? '',
      description: json['description'] ?? '',
      fileType: json['filetype'] ?? '',
      fileName: json['filename'] ?? '',
      filePath: json['filepath'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      updatedOn: json['updatedOn'],
      from: json['from'] ?? '',
      to: json['to'] ?? '',
    );
  }

  // Convert fromDate and toDate to DateTime using the intl package
  DateTime get parsedFromDate => DateFormat('dd-MM-yyyy').parse(fromDate);
  DateTime get parsedToDate => DateFormat('dd-MM-yyyy').parse(toDate);

  // Check if event is within the selected date range
  bool isEventInRange(DateTime selectedDate) {
    return (parsedFromDate.isBefore(selectedDate) ||
            parsedFromDate.isAtSameMomentAs(selectedDate)) &&
        (parsedToDate.isAfter(selectedDate) ||
            parsedToDate.isAtSameMomentAs(selectedDate));
  }

  // Converts an Event object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userType': userType,
      'rollnumber': rollNumber,
      'headLine': headLine,
      'description': description,
      'filetype': fileType,
      'filename': fileName,
      'filepath': filePath,
      'fromDate': fromDate,
      'toDate': toDate,
      'updatedOn': updatedOn,
      'from': from,
      'to': to,
    };
  }
}
