import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../models/tutorial_model.dart';
import '../../widgets/code_viewer.dart';

class FlutterBasicsDetailScreen extends StatelessWidget {
  const FlutterBasicsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TutorialModel tutorial = Get.arguments;
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(tutorial.title),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                favoritesController.isFavorite(tutorial.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favoritesController.isFavorite(tutorial.id)
                    ? Colors.red
                    : null,
              ),
              onPressed: () => favoritesController.toggleFavorite(tutorial.id),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tutorial.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              tutorial.description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(
              tutorial.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (tutorial.keyPoints.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Key Points',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...tutorial.keyPoints.map(
                (point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (tutorial.codeExample != null) ...[
              const SizedBox(height: 24),
              Text(
                'Code Example',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CodeViewer(code: tutorial.codeExample!),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
