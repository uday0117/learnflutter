import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/services/data_service.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = AppData.getChallengesTopics();

    return Scaffold(
      appBar: AppBar(title: const Text('⚡ Code Challenges')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return _TopicCard(topic: topic);
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _getDifficultyColor(topic.difficulty);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Get.to(() => TopicDetailScreen(topic: topic));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      topic.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      topic.difficulty.toUpperCase(),
                      style: TextStyle(
                        color: difficultyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                topic.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class TopicDetailScreen extends StatelessWidget {
  final topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        actions: [
          IconButton(
            icon: Icon(
              topic.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              // TODO: Toggle favorite
              Get.snackbar('Favorite', 'Feature coming soon!');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content
            Text(topic.content, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 30),

            // Code Examples
            if (topic.codeExamples.isNotEmpty) ...[
              Text(
                'Code Examples',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...topic.codeExamples.map(
                (example) => _CodeExampleCard(example: example),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CodeExampleCard extends StatelessWidget {
  final example;

  const _CodeExampleCard({required this.example});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  example.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white70),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: example.code));
                    Get.snackbar(
                      'Copied!',
                      'Code copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              example.code,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
          // Explanation
          if (example.explanation != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                example.explanation!,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}
