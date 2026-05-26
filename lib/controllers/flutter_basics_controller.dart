import 'package:get/get.dart';
import '../data/flutter_basics_data.dart';
import '../models/tutorial_model.dart';

class FlutterBasicsController extends GetxController {
  final tutorials = <TutorialModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTutorials();
  }

  void loadTutorials() {
    isLoading.value = true;
    tutorials.value = FlutterBasicsData.getAllTutorials();
    isLoading.value = false;
  }
}
