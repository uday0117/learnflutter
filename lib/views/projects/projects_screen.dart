import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {'title': 'Todo App', 'description': 'Complete todo application'},
      {'title': 'Notes App', 'description': 'Note-taking application'},
      {'title': 'Expense Tracker', 'description': 'Track your expenses'},
      {'title': 'Weather App', 'description': 'Weather forecast app'},
      {'title': 'E-Commerce App', 'description': 'Full e-commerce solution'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.work),
              title: Text(project['title']!),
              subtitle: Text(project['description']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
