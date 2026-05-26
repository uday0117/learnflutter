import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../models/interview_question_model.dart';
import '../../widgets/code_viewer.dart';

class QuestionDetailScreen extends StatelessWidget {
  const QuestionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InterviewQuestionModel question = Get.arguments;
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Detail'),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                favoritesController.isFavorite(question.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () => favoritesController.toggleFavorite(question.id),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(question.category),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(question.difficulty.toUpperCase()),
                  backgroundColor: _getDifficultyColor(question.difficulty),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Question',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Answer',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  question.answer,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            if (question.codeExample != null) ...[
              const SizedBox(height: 24),
              Text(
                'Code Example',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              CodeViewer(code: question.codeExample!),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green.withValues(alpha: 0.2);
      case 'intermediate':
        return Colors.orange.withValues(alpha: 0.2);
      case 'advanced':
        return Colors.red.withValues(alpha: 0.2);
      default:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }
}
