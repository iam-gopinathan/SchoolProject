class ParentEmojifeedbackModel {
  final int id;
  final String answer;

  ParentEmojifeedbackModel({required this.id, required this.answer});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
    };
  }

  factory ParentEmojifeedbackModel.fromJson(Map<String, dynamic> json) {
    return ParentEmojifeedbackModel(
      id: json['id'],
      answer: json['answer'],
    );
  }
}
