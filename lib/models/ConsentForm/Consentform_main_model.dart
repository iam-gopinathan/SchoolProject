class ConsentFetchResponse {
  final List<ConsentData> data;

  ConsentFetchResponse({required this.data});

  factory ConsentFetchResponse.fromJson(Map<String, dynamic> json) {
    return ConsentFetchResponse(
      data: (json['data'] as List)
          .map((item) => ConsentData.fromJson(item))
          .toList(),
    );
  }
}

class ConsentData {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<ConsentForm> consentForm;

  ConsentData({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.consentForm,
  });

  factory ConsentData.fromJson(Map<String, dynamic> json) {
    return ConsentData(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'],
      consentForm: (json['consentForm'] as List)
          .map((item) => ConsentForm.fromJson(item))
          .toList(),
    );
  }
}

class ConsentForm {
  final String userType;
  final String name;
  final String rollNumber;
  final String time;
  final int questionId;
  final String heading;
  final String question;
  final String gradeId;
  final List<String> section;
  final String status;
  final String isAlterAvailable;

  ConsentForm({
    required this.userType,
    required this.name,
    required this.rollNumber,
    required this.time,
    required this.questionId,
    required this.heading,
    required this.question,
    required this.gradeId,
    required this.section,
    required this.status,
    required this.isAlterAvailable,
  });

  factory ConsentForm.fromJson(Map<String, dynamic> json) {
    return ConsentForm(
      userType: json['userType'],
      name: json['name'],
      rollNumber: json['rollNumber'],
      time: json['time'],
      questionId: json['questionId'],
      heading: json['heading'],
      question: json['question'],
      gradeId: json['gradeId'],
      section: List<String>.from(json['section']),
      status: json['status'],
      isAlterAvailable: json['isAlterAvilable'],
    );
  }
}
