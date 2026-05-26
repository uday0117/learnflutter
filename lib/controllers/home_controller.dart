import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/category_data.dart';
import '../models/category_model.dart';

class HomeController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🏠 HomeController onInit');
    loadCategories();
  }

  void loadCategories() {
    isLoading.value = true;
    categories.value = CategoryData.getAllCategories();
    debugPrint('📚 Loaded ${categories.length} categories');
    isLoading.value = false;
  }

  void navigateToCategory(CategoryModel category) {
    debugPrint('🧭 Navigating to: ${category.title} → ${category.route}');
    Get.toNamed(category.route);
  }
}
