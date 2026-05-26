import 'package:flutter/material.dart';

class APIIntegrationScreen extends StatelessWidget {
  const APIIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'title': 'HTTP Package', 'description': 'Learn HTTP package'},
      {'title': 'Dio Package', 'description': 'Learn Dio for API calls'},
      {'title': 'REST API Calls', 'description': 'Master REST APIs'},
      {'title': 'JSON Parsing', 'description': 'Parse JSON data'},
      {'title': 'Error Handling', 'description': 'Handle API errors'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('API Integration')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.api),
              title: Text(topic['title']!),
              subtitle: Text(topic['description']!),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
