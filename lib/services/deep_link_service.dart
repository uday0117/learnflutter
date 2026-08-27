import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/widgets_data.dart';
import '../screens/home_screen.dart';
import '../screens/widget_detail_screen.dart';
import 'analytics_service.dart';

/// Handles deep links via HTTPS (ukrsolutions.in) and custom scheme (learnflutter://).
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  static const scheme = 'learnflutter';
  static const websiteHost = 'ukrsolutions.in';
  static const websiteBase = 'https://$websiteHost';
  static const widgetPathPrefix = '/learnflutter/widget';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.uksolutions.learnflutter';

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  String? _pendingWidgetId;
  bool _initialized = false;

  /// Primary shareable link — works in WhatsApp, Twitter, etc.
  static String widgetLink(String widgetId) =>
      '$websiteBase$widgetPathPrefix/$widgetId';

  /// Custom scheme fallback (home screen widget, legacy shares).
  static String widgetAppScheme(String widgetId) =>
      '$scheme://widget/$widgetId';

  /// Share text with HTTPS link + Play Store fallback.
  static String widgetShareText({
    required String name,
    required String description,
    required String widgetId,
  }) {
    return '📱 Flutter Widget — $name\n\n'
        '$description\n\n'
        '👉 ${widgetLink(widgetId)}\n\n'
        'Download free: $playStoreUrl';
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) _queueLink(initial);

      _sub = _appLinks.uriLinkStream.listen(
        _queueLink,
        onError: (e) => debugPrint('[DeepLink] stream error: $e'),
      );
    } catch (e) {
      debugPrint('[DeepLink] init failed: $e');
    }
  }

  void _queueLink(Uri uri) {
    final widgetId = _parseWidgetId(uri);
    if (widgetId == null) return;
    _pendingWidgetId = widgetId;
    AnalyticsService().logEvent('deep_link_received', parameters: {
      'widget_id': widgetId,
      'source': uri.scheme == 'https' ? 'web' : 'scheme',
    });
    _tryNavigate();
  }

  String? _parseWidgetId(Uri uri) {
    // https://ukrsolutions.in/learnflutter/widget/text
    if (uri.scheme == 'https' &&
        uri.host == websiteHost &&
        uri.path.startsWith(widgetPathPrefix)) {
      final segment = uri.path
          .substring(widgetPathPrefix.length)
          .replaceFirst('/', '')
          .split('/')
          .firstOrNull;
      if (segment != null && segment.isNotEmpty) return segment;
    }

    // learnflutter://widget/text
    if (uri.scheme == scheme && uri.host == 'widget') {
      if (uri.pathSegments.isNotEmpty) return uri.pathSegments.first;
      return uri.path.replaceFirst('/', '').split('/').firstOrNull;
    }

    return null;
  }

  /// Call after splash/onboarding completes to open any pending deep link.
  void handlePendingLink() {
    _tryNavigate();
  }

  /// Handle a URI directly (e.g. from home screen widget tap).
  void handleUri(Uri uri) {
    _queueLink(uri);
  }

  void _tryNavigate() {
    final id = _pendingWidgetId;
    if (id == null) return;
    if (Get.context == null) return;

    final widget = WidgetsData.getWidgetById(id);
    _pendingWidgetId = null;

    if (widget == null) {
      Get.off(() => const HomeScreen());
      Get.snackbar(
        'Widget not found',
        'This widget may have been removed. Browse all widgets on Home.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    AnalyticsService().logEvent('deep_link_opened', parameters: {
      'widget_id': id,
      'widget_name': widget.name,
    });

    Get.off(() => const HomeScreen());
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.to(() => WidgetDetailScreen(widgetModel: widget));
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
