import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_integration_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';

class APIIntegrationScreen extends StatelessWidget {
  const APIIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorials = ApiIntegrationData.getAllTutorials();

    return Scaffold(
      appBar: AppBar(title: const Text('API Integration')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          final tutorial = tutorials[index];
          return TutorialCard(
            title: tutorial.title,
            description: tutorial.description,
            onTap: () {
              Get.toNamed(AppRoutes.flutterBasicsDetail, arguments: tutorial);
            },
          );
        },
      ),
    );
  }
}
