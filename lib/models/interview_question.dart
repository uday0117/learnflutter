enum QuestionLevel { beginner, intermediate, advanced }

class InterviewQuestion {
  final String id;
  final String question;
  final String answer;
  final String? codeExample;
  final QuestionLevel level;
  final String category;

  const InterviewQuestion({
    required this.id,
    required this.question,
    required this.answer,
    this.codeExample,
    required this.level,
    required this.category,
  });
}
