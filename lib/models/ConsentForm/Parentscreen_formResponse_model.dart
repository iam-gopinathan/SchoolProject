class ConsentParentResponse {
  final List<ConsentDataParent> data;

  ConsentParentResponse({required this.data});

  factory ConsentParentResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ConsentDataParent> dataList =
        list.map((item) => ConsentDataParent.fromJson(item)).toList();

    return ConsentParentResponse(data: dataList);
  }
}

class ConsentDataParent {
  final String postedOnDate;
  final String postedOnDay;
  final String tag;
  final List<Parent> fromParents;

  ConsentDataParent({
    required this.postedOnDate,
    required this.postedOnDay,
    required this.tag,
    required this.fromParents,
  });

  factory ConsentDataParent.fromJson(Map<String, dynamic> json) {
    var list = json['fromParents'] as List;
    List<Parent> parentsList =
        list.map((item) => Parent.fromJson(item)).toList();

    return ConsentDataParent(
      postedOnDate: json['postedOnDate'],
      postedOnDay: json['postedOnDay'],
      tag: json['tag'],
      fromParents: parentsList,
    );
  }
}

class Parent {
  final int id;
  final String questionID;
  final String heading;
  final String question;
  final String grade;
  final String section;
  final String rollNumber;
  final String name;
  final String? answer;
  final String? answeredOn;
  final String isAlterAvailable;

  Parent({
    required this.id,
    required this.questionID,
    required this.heading,
    required this.question,
    required this.grade,
    required this.section,
    required this.rollNumber,
    required this.name,
    this.answer,
    this.answeredOn,
    required this.isAlterAvailable,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      questionID: json['questionID'],
      heading: json['heading'],
      question: json['question'],
      grade: json['grade'],
      section: json['section'],
      rollNumber: json['rollNumber'],
      name: json['name'],
      answer: json['answer'],
      answeredOn: json['answeredOn'],
      isAlterAvailable: json['isAlterAvailable'],
    );
  }
}
