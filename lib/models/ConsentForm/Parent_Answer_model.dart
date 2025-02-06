class ParentAnswerModel {
  final String id;
  final String answer;

  ParentAnswerModel({required this.id, required this.answer});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
    };
  }

  factory ParentAnswerModel.fromJson(Map<String, dynamic> json) {
    return ParentAnswerModel(
      id: json['id'],
      answer: json['answer'],
    );
  }
}
