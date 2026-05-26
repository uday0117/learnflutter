import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/ui_examples_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';

class UIExamplesScreen extends StatelessWidget {
  const UIExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UIExamplesController());

    return Scaffold(
      appBar: AppBar(title: const Text('UI Examples'), elevation: 0),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            key: const ValueKey('ui_examples_list'),
            padding: const EdgeInsets.all(16),
            itemCount: controller.examples.length,
            itemBuilder: (context, index) {
              final example = controller.examples[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(example.id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: TutorialCard(
                  title: example.title,
                  description: example.description,
                  onTap: () {
                    Get.toNamed(AppRoutes.uiExampleDetail, arguments: example);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
