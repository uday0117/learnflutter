import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/widgets_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/tutorial_card.dart';

class WidgetsScreen extends StatelessWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WidgetsController());
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Widgets'), elevation: 0),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading widgets...');
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            key: const ValueKey('widgets_list'),
            padding: const EdgeInsets.all(16),
            itemCount: controller.widgets.length,
            itemBuilder: (context, index) {
              final widget = controller.widgets[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(widget.id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Obx(
                  () => TutorialCard(
                    title: widget.name,
                    description: widget.description,
                    onTap: () =>
                        Get.toNamed(AppRoutes.widgetDetail, arguments: widget),
                    trailing: IconButton(
                      icon: Icon(
                        favoritesController.isFavorite(widget.id)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: favoritesController.isFavorite(widget.id)
                            ? Colors.red
                            : null,
                      ),
                      onPressed: () =>
                          favoritesController.toggleFavorite(widget.id),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
