class UIExampleModel {
  final String id;
  final String title;
  final String description;
  final String sourceCode;
  final String? imageUrl;
  final List<String> features;
  final String category;

  UIExampleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sourceCode,
    this.imageUrl,
    this.features = const [],
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'sourceCode': sourceCode,
    'imageUrl': imageUrl,
    'features': features,
    'category': category,
  };

  factory UIExampleModel.fromJson(Map<String, dynamic> json) {
    return UIExampleModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      sourceCode: json['sourceCode'],
      imageUrl: json['imageUrl'],
      features: List<String>.from(json['features'] ?? []),
      category: json['category'],
    );
  }
}
