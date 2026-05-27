import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/services/data_service.dart';
import '../dart_basics/dart_basics_screen.dart';
import '../flutter_basics/flutter_basics_screen.dart';
import '../settings/settings_screen.dart';
import '../ui_examples/ui_examples_screen.dart';
import '../widgets/widget_reference_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = AppData.getCategories();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'LearnFlutter',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Master Dart & Flutter Development',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO: Implement search
                    Get.snackbar('Coming Soon', 'Search feature');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_outline),
                  onPressed: () {
                    // TODO: Implement favorites
                    Get.snackbar('Coming Soon', 'Favorites feature');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    Get.to(() => const SettingsScreen());
                  },
                ),
              ],
            ),

            // Category Grid
            SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = categories[index];
                  return _CategoryCard(category: category);
                }, childCount: categories.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          if (category.id == '1') {
            // Navigate to Dart Basics
            Get.to(() => const DartBasicsScreen());
          } else if (category.id == '2') {
            // Navigate to Flutter Basics
            Get.to(() => const FlutterBasicsScreen());
          } else if (category.id == '3') {
            // Navigate to Widget Reference
            Get.to(() => const WidgetReferenceScreen());
          } else if (category.id == '4') {
            // Navigate to UI Examples
            Get.to(() => const UIExamplesScreen());
          } else {
            // TODO: Implement other categories
            Get.snackbar(
              'Coming Soon',
              '${category.title} will be available soon!',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const Spacer(),
              // Title
              Text(
                category.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
