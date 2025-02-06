class ParentFeedbackUpdateModel {
  final int id;
  final String headLine;
  final String question;
  final String type;
  final String postedOn;

  ParentFeedbackUpdateModel({
    required this.id,
    required this.headLine,
    required this.question,
    required this.type,
    required this.postedOn,
  });

  // To convert data from JSON to model
  factory ParentFeedbackUpdateModel.fromJson(Map<String, dynamic> json) {
    return ParentFeedbackUpdateModel(
      id: json['id'],
      headLine: json['headLine'],
      question: json['question'],
      type: json['type'],
      postedOn: json['postedOn'],
    );
  }

  // To convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'headLine': headLine,
      'question': question,
      'type': type,
      'postedOn': postedOn,
    };
  }
}
