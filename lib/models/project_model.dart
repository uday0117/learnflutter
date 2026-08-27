class ProjectModel {
  final String id;
  final String name;
  final String description;
  final List<String> features;
  final List<String> libraries;
  final String difficulty;
  final String folderStructure;
  final String sourceCode;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.features,
    required this.libraries,
    required this.difficulty,
    required this.folderStructure,
    required this.sourceCode,
  });
}
