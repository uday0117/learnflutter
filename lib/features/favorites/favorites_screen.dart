import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/favorites_controller.dart';
import '../../core/models/app_models.dart';
import '../../core/services/data_service.dart';
import '../dart_basics/dart_basics_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('❤️ Favorites')),
      body: Obx(() {
        if (favController.favoriteTopicIds.isEmpty) {
          return _buildEmptyState(context);
        }

        final allTopics = [
          ...AppData.getDartBasicsTopics(),
          ...AppData.getFlutterBasicsTopics(),
          ...AppData.getWidgetReferenceTopics(),
          ...AppData.getUIExamplesTopics(),
          ...AppData.getInterviewTopics(),
          ...AppData.getLearningPathTopics(),
          ...AppData.getChallengesTopics(),
        ];

        final favoriteTopics = allTopics
            .where((topic) => favController.isFavorite(topic.id))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteTopics.length,
          itemBuilder: (context, index) {
            final topic = favoriteTopics[index];
            return _FavoriteTopicCard(
              topic: topic,
              categoryName: _getCategoryName(topic.categoryId),
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap ❤️ on any topic to save it here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String categoryId) {
    final categories = AppData.getCategories();
    final category = categories.firstWhere((cat) => cat.id == categoryId);
    return category.title;
  }
}

class _FavoriteTopicCard extends StatelessWidget {
  final Topic topic;
  final String categoryName;

  const _FavoriteTopicCard({required this.topic, required this.categoryName});

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

  @override
  Widget build(BuildContext context) {
    final FavoritesController favController = Get.find();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => TopicDetailScreen(topic: topic));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(
                        topic.difficulty,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      topic.difficulty.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getDifficultyColor(topic.difficulty),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        favController.isFavorite(topic.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favController.isFavorite(topic.id)
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () {
                        favController.toggleFavorite(topic.id);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                topic.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                topic.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
