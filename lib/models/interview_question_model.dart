class InterviewQuestionModel {
  final String id;
  final String category;
  final String question;
  final String answer;
  final String? codeExample;
  final String difficulty; // beginner, intermediate, advanced

  InterviewQuestionModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    this.codeExample,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'question': question,
    'answer': answer,
    'codeExample': codeExample,
    'difficulty': difficulty,
  };

  factory InterviewQuestionModel.fromJson(Map<String, dynamic> json) {
    return InterviewQuestionModel(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      answer: json['answer'],
      codeExample: json['codeExample'],
      difficulty: json['difficulty'],
    );
  }
}
