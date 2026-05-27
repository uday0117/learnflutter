import 'package:flutter/material.dart';

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

class WidgetParameter {
  final String name;
  final String type;
  final String description;
  final bool isRequired;
  final String? defaultValue;

  WidgetParameter({
    required this.name,
    required this.type,
    required this.description,
    this.isRequired = false,
    this.defaultValue,
  });
}

class WidgetReference {
  final String id;
  final String name;
  final String category; // Layout, Input, Display, etc.
  final String description;
  final String syntax;
  final List<WidgetParameter> parameters;
  final String codeExample;
  final Widget Function() previewBuilder;
  bool isFavorite;

  WidgetReference({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.syntax,
    required this.parameters,
    required this.codeExample,
    required this.previewBuilder,
    this.isFavorite = false,
  });
}
