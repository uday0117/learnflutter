import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/interview_questions_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/tutorial_card.dart';

class InterviewQuestionsScreen extends StatelessWidget {
  const InterviewQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InterviewQuestionsController());

    return Scaffold(
      appBar: AppBar(title: const Text('Interview Questions')),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        controller.filterByCategory(category);
                      },
                    );
                  }),
                );
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.filteredQuestions.length,
                itemBuilder: (context, index) {
                  final question = controller.filteredQuestions[index];
                  return TutorialCard(
                    title: question.question,
                    description:
                        'Category: ${question.category} • ${question.difficulty}',
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.questionDetail,
                        arguments: question,
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
