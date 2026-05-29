class WidgetModel {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String syntax;
  final String sourceCode;
  final String usage;
  final List<WidgetProperty> properties;

  WidgetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.syntax,
    required this.sourceCode,
    required this.usage,
    required this.properties,
  });
}

class WidgetProperty {
  final String name;
  final String description;

  WidgetProperty({required this.name, required this.description});
}
