import 'package:get/get.dart';
import '../data/widgets_data.dart';
import '../models/widget_model.dart';

class WidgetsController extends GetxController {
  final widgets = <WidgetModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWidgets();
  }

  void loadWidgets() {
    isLoading.value = true;
    widgets.value = WidgetsData.getAllWidgets();
    isLoading.value = false;
  }
}
