import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';
import '../data/widgets_data.dart';
import '../widgets/banner_ad_widget.dart';
import 'widget_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
        if (favoritesController.favoriteIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_outline,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Save your favorite widgets',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        final favoriteWidgets = WidgetsData.getAllWidgets()
            .where((w) => favoritesController.isFavorite(w.id))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteWidgets.length,
          itemBuilder: (context, index) {
            final widget = favoriteWidgets[index];
            final category = WidgetsData.getCategories().firstWhere(
              (c) => c.id == widget.categoryId,
            );

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: category.color, size: 28),
                ),
                title: Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    favoritesController.toggleFavorite(widget.id);
                  },
                ),
                onTap: () {
                  Get.to(() => WidgetDetailScreen(widgetModel: widget));
                },
              ),
            );
          },
        );
      }),
          ),
          const Center(child: BannerAdWidget()),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
