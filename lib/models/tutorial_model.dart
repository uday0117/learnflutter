class TutorialModel {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String content;
  final String? codeExample;
  final String? output;
  final List<String> keyPoints;
  final String? imageUrl;
  final String category;
  final String difficulty;

  TutorialModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.content,
    this.codeExample,
    this.output,
    this.keyPoints = const [],
    this.imageUrl,
    this.category = '',
    this.difficulty = 'Beginner',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'title': title,
    'description': description,
    'content': content,
    'codeExample': codeExample,
    'output': output,
    'keyPoints': keyPoints,
    'imageUrl': imageUrl,
  };

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      id: json['id'],
      categoryId: json['categoryId'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      codeExample: json['codeExample'],
      output: json['output'],
      keyPoints: List<String>.from(json['keyPoints'] ?? []),
      imageUrl: json['imageUrl'],
    );
  }
}
