import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';

import '../controllers/engagement_controller.dart';
import '../data/widgets_data.dart';

class ProgressController extends GetxController {
  static const _viewedKey = 'viewed_widgets';
  static const _recentKey = 'recently_viewed';
  static const _reviewKey = 'review_requested';
  static const _totalDetailViews = 'total_detail_views';

  final _box = GetStorage();
  final InAppReview _inAppReview = InAppReview.instance;

  // Set of widget IDs the user has viewed at least once
  final RxSet<String> viewedWidgetIds = <String>{}.obs;

  // Ordered list of recently viewed widget IDs (max 15)
  final RxList<String> recentlyViewedIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final viewedList = _box.read<List>(_viewedKey) ?? [];
    viewedWidgetIds.addAll(viewedList.map((e) => e.toString()));

    final recentList = _box.read<List>(_recentKey) ?? [];
    recentlyViewedIds.addAll(recentList.map((e) => e.toString()));
  }

  void markAsViewed(String widgetId) {
    viewedWidgetIds.add(widgetId);
    _box.write(_viewedKey, viewedWidgetIds.toList());

    // Update recently viewed (most-recent first, no duplicates)
    recentlyViewedIds.remove(widgetId);
    recentlyViewedIds.insert(0, widgetId);
    if (recentlyViewedIds.length > 15) {
      recentlyViewedIds.removeLast();
    }
    _box.write(_recentKey, recentlyViewedIds.toList());

    // Increment total views and possibly request review
    final views = (_box.read<int>(_totalDetailViews) ?? 0) + 1;
    _box.write(_totalDetailViews, views);
    _maybeRequestReview(views);

    if (Get.isRegistered<EngagementController>()) {
      Get.find<EngagementController>().recordWidgetView();
    }
  }

  Future<void> _maybeRequestReview(int views) async {
    // Ask for review after 7 views, once per install
    if (views == 7 && !(_box.read<bool>(_reviewKey) ?? false)) {
      final available = await _inAppReview.isAvailable();
      if (available) {
        _box.write(_reviewKey, true);
        await _inAppReview.requestReview();
      }
    }
  }

  bool isViewed(String widgetId) => viewedWidgetIds.contains(widgetId);

  int get viewedCount => viewedWidgetIds.length;

  int get totalWidgets => WidgetsData.getAllWidgets().length;

  double get progressPercent =>
      totalWidgets == 0 ? 0 : viewedCount / totalWidgets;

  String get progressLabel {
    final pct = progressPercent;
    if (pct >= 1.0) return 'completed';
    if (pct >= 0.75) return 'almost_there';
    if (pct >= 0.4) return 'great_progress';
    return 'keep_learning';
  }

  /// Returns the WidgetModels for recently viewed IDs, preserving order
  List<String> get recentIds => List.unmodifiable(recentlyViewedIds);

  void clearProgress() {
    viewedWidgetIds.clear();
    recentlyViewedIds.clear();
    _box.remove(_viewedKey);
    _box.remove(_recentKey);
    _box.remove(_totalDetailViews);
  }
}
