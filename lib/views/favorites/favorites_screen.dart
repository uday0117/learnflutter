import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../widgets/empty_state.dart';

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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final favoriteId = controller.favorites[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text('Favorite Item #$favoriteId'),
                subtitle: const Text('Tap to view details'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => controller.toggleFavorite(favoriteId),
                ),
                onTap: () {
                  // Navigate to detail based on favoriteId
                },
              ),
            );
          },
        );
      }),
    );
  }
}
