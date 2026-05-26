import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/ui_example_model.dart';
import '../../widgets/code_viewer.dart';
import '../../controllers/favorites_controller.dart';

class UIExampleDetailScreen extends StatelessWidget {
  const UIExampleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UIExampleModel example = Get.arguments;
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(example.title),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                favoritesController.isFavorite(example.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () => favoritesController.toggleFavorite(example.id),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example.description,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(example.category),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                    ),
                  ],
                ),
              ),
            ),
            if (example.features.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Features',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: example.features.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(feature)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Source Code',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CodeViewer(code: example.sourceCode),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
