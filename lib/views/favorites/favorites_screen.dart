import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../data/flutter_basics_data.dart';
import '../../data/projects_data.dart';
import '../../models/tutorial_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/tutorial_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          Obx(() {
            if (controller.favorites.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Clear Favorites'),
                      content: const Text('Remove all favorites?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.clearFavorites();
                            Get.back();
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border,
            title: 'No Favorites Yet',
            message: 'Start adding your favorite tutorials to see them here',
            action: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Browse Tutorials'),
            ),
          );
        }

        // Collect all tutorials from all data sources
        final allTutorials = <TutorialModel>[
          ...FlutterBasicsData.getAllTutorials(),
          ...ProjectsData.getAllProjects(),
        ];

        // Filter to show only favorites
        final favoriteTutorials = allTutorials
            .where((tutorial) => controller.isFavorite(tutorial.id))
            .toList();

        if (favoriteTutorials.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border,
            title: 'No Favorites Found',
            message: 'Your favorited items may have been removed',
            action: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Browse Tutorials'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteTutorials.length,
          itemBuilder: (context, index) {
            final tutorial = favoriteTutorials[index];
            return TutorialCard(
              title: tutorial.title,
              description: '${tutorial.category} • ${tutorial.difficulty}',
              onTap: () {
                // Navigate to detail screen
                Get.toNamed(
                  tutorial.category == 'Interview Questions'
                      ? AppRoutes.questionDetail
                      : AppRoutes.flutterBasicsDetail,
                  arguments: tutorial,
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => controller.toggleFavorite(tutorial.id),
              ),
            );
          },
        );
      }),
    );
  }
}
