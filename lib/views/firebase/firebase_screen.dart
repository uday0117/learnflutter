import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/firebase_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';

class FirebaseScreen extends StatelessWidget {
  const FirebaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorials = FirebaseData.getAllTutorials();

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase')),
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
