import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';

import '../data/widgets_data.dart';
import '../services/deep_link_service.dart';
import 'analytics_service.dart';

/// Syncs streak & widget-of-the-day to the Android home screen widget.
class HomeWidgetService {
  static final HomeWidgetService _instance = HomeWidgetService._internal();
  factory HomeWidgetService() => _instance;
  HomeWidgetService._internal();

  static const androidProvider = 'LearnFlutterWidgetProvider';
  static const _streakKey = 'streak';
  static const _widgetNameKey = 'widget_name';
  static const _widgetIdKey = 'widget_id';
  static const _progressKey = 'progress';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (!GetPlatform.isAndroid) return;

    try {
      await HomeWidget.setAppGroupId('group.learnflutter');
      await HomeWidget.registerInteractivityCallback(_backgroundCallback);

      HomeWidget.widgetClicked.listen((uri) {
        if (uri != null) {
          DeepLinkService().handleUri(uri);
          AnalyticsService().logEvent('home_widget_tap');
        }
      });
    } catch (e) {
      debugPrint('[HomeWidget] init failed: $e');
    }
  }

  Future<void> update({
    required int streak,
    required int progressPercent,
  }) async {
    if (!GetPlatform.isAndroid) return;

    final allWidgets = WidgetsData.getAllWidgets();
    final dayIndex =
        DateTime.now().difference(DateTime(2024, 1, 1)).inDays %
            allWidgets.length;
    final wotd = allWidgets[dayIndex];

    try {
      await HomeWidget.saveWidgetData<int>(_streakKey, streak);
      await HomeWidget.saveWidgetData<int>(_progressKey, progressPercent);
      await HomeWidget.saveWidgetData<String>(_widgetNameKey, wotd.name);
      await HomeWidget.saveWidgetData<String>(_widgetIdKey, wotd.id);

      await HomeWidget.updateWidget(
        name: androidProvider,
        androidName: androidProvider,
        qualifiedAndroidName:
            'com.uksolutions.learnflutter.$androidProvider',
      );
    } catch (e) {
      debugPrint('[HomeWidget] update failed: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundCallback(Uri? uri) async {
    if (uri != null) {
      debugPrint('[HomeWidget] background tap: $uri');
    }
  }
}
