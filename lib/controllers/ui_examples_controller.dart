import 'package:get/get.dart';
import '../data/ui_examples_data.dart';
import '../models/ui_example_model.dart';

class UIExamplesController extends GetxController {
  final examples = <UIExampleModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadExamples();
  }

  void loadExamples() {
    isLoading.value = true;
    examples.value = UIExamplesData.getAllUIExamples();
    isLoading.value = false;
  }
}
