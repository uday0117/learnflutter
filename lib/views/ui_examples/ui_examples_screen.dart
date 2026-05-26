import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/ui_examples_controller.dart';
import '../../widgets/tutorial_card.dart';
import '../../routes/app_routes.dart';

class UIExamplesScreen extends StatelessWidget {
  const UIExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UIExamplesController());

    return Scaffold(
      appBar: AppBar(title: const Text('UI Examples')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.examples.length,
          itemBuilder: (context, index) {
            final example = controller.examples[index];
            return TutorialCard(
              title: example.title,
              description: example.description,
              onTap: () {
                Get.toNamed(AppRoutes.uiExampleDetail, arguments: example);
              },
            );
          },
        );
      }),
    );
  }
}
