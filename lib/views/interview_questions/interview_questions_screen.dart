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
      appBar: AppBar(title: const Text('Interview Questions'), elevation: 0),
      body: Column(
        children: [
          // Modern Category Filter Section
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Obx(() {
                return Row(
                  children: controller.categories.map((category) {
                    final isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            controller.filterByCategory(category);
                          },
                          selectedColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                          elevation: isSelected ? 2 : 0,
                          pressElevation: 4,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),
          // Questions List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredQuestions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No questions found',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ListView.builder(
                  key: ValueKey(controller.selectedCategory.value),
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredQuestions.length,
                  itemBuilder: (context, index) {
                    final question = controller.filteredQuestions[index];
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(question.id),
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
                        title: question.question,
                        description:
                            'Category: ${question.category} • ${question.difficulty}',
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.questionDetail,
                            arguments: question,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
