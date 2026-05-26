import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: Icons.code,
      color: Colors.blue,
      route: '',
    );
  }
}
