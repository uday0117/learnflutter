import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../routes/app_routes.dart';

class CategoryData {
  static List<CategoryModel> getAllCategories() {
    return [
      CategoryModel(
        id: '1',
        title: 'Flutter Basics',
        description: 'Learn the fundamentals of Flutter development',
        icon: Icons.lightbulb_outline,
        color: const Color(0xFF02569B),
        route: AppRoutes.flutterBasics,
      ),
      CategoryModel(
        id: '2',
        title: 'Flutter Widgets',
        description: 'Explore Flutter widgets with examples',
        icon: Icons.widgets_outlined,
        color: const Color(0xFF13B9FD),
        route: AppRoutes.flutterWidgets,
      ),
      CategoryModel(
        id: '3',
        title: 'UI Examples',
        description: 'Beautiful UI screens and examples',
        icon: Icons.phone_android_outlined,
        color: const Color(0xFF54C5F8),
        route: AppRoutes.uiExamples,
      ),
      CategoryModel(
        id: '4',
        title: 'Projects',
        description: 'Complete project source code',
        icon: Icons.work_outline,
        color: const Color(0xFF00897B),
        route: AppRoutes.projects,
      ),
      CategoryModel(
        id: '5',
        title: 'Interview Questions',
        description: 'Prepare for Flutter interviews',
        icon: Icons.question_answer_outlined,
        color: const Color(0xFFE53935),
        route: AppRoutes.interviewQuestions,
      ),
    ];
  }
}
