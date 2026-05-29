import 'package:flutter/material.dart';

class WidgetCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int widgetCount;

  WidgetCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.widgetCount,
  });
}
