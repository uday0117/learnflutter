class Category {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji or icon name
  final String color; // hex color
  final String route;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class Topic {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String difficulty; // beginner, intermediate, advanced
  final String content; // markdown or html content
  final List<CodeExample> codeExamples;
  bool isFavorite;

  Topic({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.content,
    required this.codeExamples,
    this.isFavorite = false,
  });
}

class CodeExample {
  final String title;
  final String code;
  final String language; // dart, flutter, etc.
  final String? explanation;

  CodeExample({
    required this.title,
    required this.code,
    required this.language,
    this.explanation,
  });
}
