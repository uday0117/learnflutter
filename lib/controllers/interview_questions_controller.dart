import 'package:get/get.dart';
import '../data/interview_questions_data.dart';
import '../models/interview_question_model.dart';

class InterviewQuestionsController extends GetxController {
  final questions = <InterviewQuestionModel>[].obs;
  final filteredQuestions = <InterviewQuestionModel>[].obs;
  final selectedCategory = 'All'.obs;
  final isLoading = false.obs;

  final categories = ['All', 'Flutter', 'Dart', 'GetX', 'Firebase'];

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  void loadQuestions() {
    isLoading.value = true;
    questions.value = InterviewQuestionsData.getAllQuestions();
    filteredQuestions.value = questions;
    isLoading.value = false;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      filteredQuestions.value = questions;
    } else {
      filteredQuestions.value = questions
          .where((q) => q.category == category)
          .toList();
    }
  }
}
