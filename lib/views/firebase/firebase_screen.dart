import 'package:flutter/material.dart';

class FirebaseScreen extends StatelessWidget {
  const FirebaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'title': 'Firebase Setup', 'description': 'Setup Firebase in Flutter'},
      {'title': 'Authentication', 'description': 'User authentication'},
      {'title': 'Firestore', 'description': 'Cloud Firestore database'},
      {'title': 'Cloud Storage', 'description': 'Store files in cloud'},
      {'title': 'Push Notifications', 'description': 'FCM notifications'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.cloud),
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
