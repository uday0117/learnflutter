import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/flutter_basics_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/tutorial_card.dart';

class FlutterBasicsScreen extends StatelessWidget {
  const FlutterBasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlutterBasicsController());
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Basics'), elevation: 0),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading tutorials...');
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            key: const ValueKey('flutter_basics_list'),
            padding: const EdgeInsets.all(16),
            itemCount: controller.tutorials.length,
            itemBuilder: (context, index) {
              final tutorial = controller.tutorials[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(tutorial.id),
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
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
