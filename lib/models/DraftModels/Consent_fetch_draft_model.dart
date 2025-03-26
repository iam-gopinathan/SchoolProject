class ConsentFetchDraftModel {
  List<ConsentData>? data;

  ConsentFetchDraftModel({this.data});

  factory ConsentFetchDraftModel.fromJson(Map<String, dynamic> json) {
    return ConsentFetchDraftModel(
      data: json['data'] != null
          ? List<ConsentData>.from(
              json['data'].map((x) => ConsentData.fromJson(x)))
          : null,
    );
  }
}

class ConsentData {
  String? postedOnDate;
  String? postedOnDay;
  String? tag;
  List<ConsentForm>? consentForm;

  ConsentData(
      {this.postedOnDate, this.postedOnDay, this.tag, this.consentForm});

  factory ConsentData.fromJson(Map<String, dynamic> json) {
    return ConsentData(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'],
      consentForm: json['consentForm'] != null
          ? List<ConsentForm>.from(
              json['consentForm'].map((x) => ConsentForm.fromJson(x)))
          : null,
    );
  }
}

class ConsentForm {
  String? userType;
  String? name;
  String? rollNumber;
  String? time;
  int? questionId;
  String? heading;
  String? question;
  String? gradeId;
  List<String>? section;
  String? status;
  String? isAlterAvailable;

  ConsentForm({
    this.userType,
    this.name,
    this.rollNumber,
    this.time,
    this.questionId,
    this.heading,
    this.question,
    this.gradeId,
    this.section,
    this.status,
    this.isAlterAvailable,
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
      section:
          json['section'] != null ? List<String>.from(json['section']) : null,
      status: json['status'],
      isAlterAvailable: json['isAlterAvilable'],
    );
  }
}
