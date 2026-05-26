class WidgetModel {
  final String id;
  final String name;
  final String description;
  final String explanation;
  final List<WidgetParameter> parameters;
  final String codeExample;
  final String? output;

  WidgetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.explanation,
    required this.parameters,
    required this.codeExample,
    this.output,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'explanation': explanation,
    'parameters': parameters.map((p) => p.toJson()).toList(),
    'codeExample': codeExample,
    'output': output,
  };

  factory WidgetModel.fromJson(Map<String, dynamic> json) {
    return WidgetModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      explanation: json['explanation'],
      parameters: (json['parameters'] as List)
          .map((p) => WidgetParameter.fromJson(p))
          .toList(),
      codeExample: json['codeExample'],
      output: json['output'],
    );
  }
}

class WidgetParameter {
  final String name;
  final String type;
  final String description;
  final bool isRequired;

  WidgetParameter({
    required this.name,
    required this.type,
    required this.description,
    this.isRequired = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'description': description,
    'isRequired': isRequired,
  };

  factory WidgetParameter.fromJson(Map<String, dynamic> json) {
    return WidgetParameter(
      name: json['name'],
      type: json['type'],
      description: json['description'],
      isRequired: json['isRequired'] ?? false,
    );
  }
}
