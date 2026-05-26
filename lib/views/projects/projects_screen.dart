import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/tutorial_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'Todo App',
        'description': 'Complete todo application with local storage',
        'icon': Icons.checklist,
      },
      {
        'title': 'Notes App',
        'description': 'Note-taking application with rich text editor',
        'icon': Icons.note_outlined,
      },
      {
        'title': 'Expense Tracker',
        'description': 'Track your expenses with charts and analytics',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'title': 'Weather App',
        'description': 'Weather forecast app with beautiful UI',
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'title': 'E-Commerce App',
        'description': 'Full e-commerce solution with cart and checkout',
        'icon': Icons.shopping_cart_outlined,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Projects'), elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return TweenAnimationBuilder<double>(
            key: ValueKey(project['title']),
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: TutorialCard(
              title: project['title'] as String,
              description: project['description'] as String,
              onTap: () {
                Get.snackbar(
                  'Coming Soon',
                  'This project will be available soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
