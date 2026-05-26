class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String overview;
  final String architecture;
  final Map<String, String> folderStructure;
  final List<ProjectFile> sourceFiles;
  final List<String> features;
  final String? imageUrl;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.overview,
    required this.architecture,
    required this.folderStructure,
    required this.sourceFiles,
    this.features = const [],
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'overview': overview,
    'architecture': architecture,
    'folderStructure': folderStructure,
    'sourceFiles': sourceFiles.map((f) => f.toJson()).toList(),
    'features': features,
    'imageUrl': imageUrl,
  };

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      overview: json['overview'],
      architecture: json['architecture'],
      folderStructure: Map<String, String>.from(json['folderStructure']),
      sourceFiles: (json['sourceFiles'] as List)
          .map((f) => ProjectFile.fromJson(f))
          .toList(),
      features: List<String>.from(json['features'] ?? []),
      imageUrl: json['imageUrl'],
    );
  }
}

class ProjectFile {
  final String fileName;
  final String filePath;
  final String content;

  ProjectFile({
    required this.fileName,
    required this.filePath,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'filePath': filePath,
    'content': content,
  };

  factory ProjectFile.fromJson(Map<String, dynamic> json) {
    return ProjectFile(
      fileName: json['fileName'],
      filePath: json['filePath'],
      content: json['content'],
    );
  }
}
