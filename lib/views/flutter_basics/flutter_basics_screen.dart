import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flutter_basics_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';
import '../../widgets/loading_widget.dart';

class FlutterBasicsScreen extends StatelessWidget {
  const FlutterBasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlutterBasicsController());
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Basics')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading tutorials...');
        }

        return ListView.builder(
          itemCount: controller.tutorials.length,
          itemBuilder: (context, index) {
            final tutorial = controller.tutorials[index];
            return Obx(
              () => TutorialCard(
                title: tutorial.title,
                description: tutorial.description,
                onTap: () => Get.toNamed(
                  AppRoutes.flutterBasicsDetail,
                  arguments: tutorial,
                ),
                trailing: IconButton(
                  icon: Icon(
                    favoritesController.isFavorite(tutorial.id)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: favoritesController.isFavorite(tutorial.id)
                        ? Colors.red
                        : null,
                  ),
                  onPressed: () =>
                      favoritesController.toggleFavorite(tutorial.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
