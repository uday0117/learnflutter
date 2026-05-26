import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/state_management_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';

class StateManagementScreen extends StatelessWidget {
  const StateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorials = StateManagementData.getAllTutorials();

    return Scaffold(
      appBar: AppBar(title: const Text('State Management')),
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
