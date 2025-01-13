class ReceivedconsentModel {
  String rollNumber;
  String studentName;
  String className;
  List<String> section;
  String profile;
  dynamic responses;
  dynamic responsesOn;
  String postedOnDate;
  String postedOnDay;
  String question;
  List<ConsentForm> consentForms;

  ReceivedconsentModel({
    required this.rollNumber,
    required this.studentName,
    required this.className,
    required this.section,
    required this.profile,
    this.responses,
    this.responsesOn,
    required this.postedOnDate,
    required this.postedOnDay,
    required this.question,
    required this.consentForms,
  });

  factory ReceivedconsentModel.fromJson(Map<String, dynamic> json) {
    return ReceivedconsentModel(
      rollNumber: json['rollNumber'] ?? '',
      studentName: json['studentName'] ?? '',
      className: json['class'] ?? '',
      section: List<String>.from(json['section'] ?? []),
      profile: json['profile'] ?? '',
      responses: json['responses'] ?? '',
      responsesOn: json['responsesOn'] ?? '',
      postedOnDate: json['postedOnDate'] ?? '',
      postedOnDay: json['postedOnDay'] ?? '',
      question: json['question'] ?? '',
      consentForms: (json['consentForm'] as List<dynamic>?)
              ?.map((e) => ConsentForm.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rollNumber': rollNumber,
      'studentName': studentName,
      'class': className,
      'section': section,
      'profile': profile,
      'responses': responses,
      'responsesOn': responsesOn,
      'postedOnDate': postedOnDate,
      'postedOnDay': postedOnDay,
      'question': question,
      'consentForm': consentForms.map((e) => e.toJson()).toList(),
    };
  }
}

class ConsentForm {
  String userType;
  String name;
  String rollNumber;
  String time;
  int questionId;
  String heading;
  String question;
  int gradeId;
  List<String> section;
  String status;
  String isAlterAvilable;
  List<ResponseAnswer> responseAnswers;

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
    required this.isAlterAvilable,
    required this.responseAnswers,
  });

  factory ConsentForm.fromJson(Map<String, dynamic> json) {
    return ConsentForm(
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      time: json['time'] ?? '',
      questionId: json['questionId'] is int
          ? json['questionId']
          : int.tryParse(json['questionId'].toString()) ??
              0, // Safe integer parsing
      heading: json['heading'] ?? '',
      question: json['question'] ?? '',
      gradeId: json['gradeId'] is int
          ? json['gradeId']
          : int.tryParse(json['gradeId'].toString()) ??
              0, // Safe integer parsing
      section: List<String>.from(json['section'] ?? []),
      status: json['status'] ?? '',
      isAlterAvilable: json['isAlterAvilable'] ?? '',
      responseAnswers: (json['responseAnswers'] as List<dynamic>?)
              ?.map((e) => ResponseAnswer.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'name': name,
      'rollNumber': rollNumber,
      'time': time,
      'questionId': questionId,
      'heading': heading,
      'question': question,
      'gradeId': gradeId,
      'section': section,
      'status': status,
      'isAlterAvilable': isAlterAvilable,
      'responseAnswers': responseAnswers.map((e) => e.toJson()).toList(),
    };
  }
}

class ResponseAnswer {
  String rollNumber;
  String studentName;
  String className;
  String section;
  String profile;
  dynamic responses;
  dynamic responsesOn;

  ResponseAnswer({
    required this.rollNumber,
    required this.studentName,
    required this.className,
    required this.section,
    required this.profile,
    this.responses,
    this.responsesOn,
  });

  factory ResponseAnswer.fromJson(Map<String, dynamic> json) {
    return ResponseAnswer(
      rollNumber: json['rollNumber'] ?? '',
      studentName: json['studentName'] ?? '',
      className: json['class'] ?? '',
      section: json['section'] ?? '',
      profile: json['profile'] ?? '',
      responses: json['responses'] ?? '',
      responsesOn: json['responsesOn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rollNumber': rollNumber,
      'studentName': studentName,
      'class': className,
      'section': section,
      'profile': profile,
      'responses': responses,
      'responsesOn': responsesOn,
    };
  }
}
