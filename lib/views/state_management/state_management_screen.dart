import 'package:flutter/material.dart';

class StateManagementScreen extends StatelessWidget {
  const StateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'title': 'GetX', 'description': 'Learn GetX state management'},
      {'title': 'Provider', 'description': 'Learn Provider pattern'},
      {'title': 'Riverpod', 'description': 'Learn Riverpod'},
      {'title': 'Bloc', 'description': 'Learn Bloc pattern'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('State Management')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.settings_input_component),
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
