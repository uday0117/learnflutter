import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/widgets_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';
import '../../widgets/loading_widget.dart';

class WidgetsScreen extends StatelessWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WidgetsController());
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Widgets')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading widgets...');
        }

        return ListView.builder(
          itemCount: controller.widgets.length,
          itemBuilder: (context, index) {
            final widget = controller.widgets[index];
            return Obx(
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
            );
          },
        );
      }),
    );
  }
}
