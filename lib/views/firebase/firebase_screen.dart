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
      appBar: AppBar(
        title: const Text('Firebase'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          final tutorial = tutorials[index];
          return TweenAnimationBuilder<double>(
            key: ValueKey(tutorial.id),
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: TutorialCard(
              title: tutorial.title,
              description: tutorial.description,
              onTap: () {
                Get.toNamed(AppRoutes.flutterBasicsDetail, arguments: tutorial);
              },
            ),
          );
        },
      ),
    );
  }
}
