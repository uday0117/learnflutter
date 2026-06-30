import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Centralized Firebase Analytics + Crashlytics (free Spark plan).
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;
  bool _initialized = false;

  bool get isEnabled => _initialized;

  FirebaseAnalyticsObserver? get navigatorObserver {
    final analytics = _analytics;
    if (analytics == null) return null;
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      // Skip collection in debug builds to keep dashboards clean.
      final collect = !kDebugMode;
      await _analytics!.setAnalyticsCollectionEnabled(collect);
      await _crashlytics!.setCrashlyticsCollectionEnabled(collect);

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        _crashlytics?.recordFlutterFatalError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics?.recordError(error, stack, fatal: true);
        return true;
      };

      _initialized = true;
      await logEvent('app_start');
    } catch (e, stack) {
      debugPrint('[AnalyticsService] Firebase init failed: $e');
      debugPrint('$stack');
    }
  }

  Future<void> setUserProperties({
    String? themeMode,
    String? locale,
    int? widgetsViewed,
    int? quizTotalPlayed,
  }) async {
    if (!_initialized) return;
    final crashlytics = _crashlytics!;
    final analytics = _analytics!;

    if (themeMode != null) {
      await analytics.setUserProperty(name: 'theme_mode', value: themeMode);
      await crashlytics.setCustomKey('theme_mode', themeMode);
    }
    if (locale != null) {
      await analytics.setUserProperty(name: 'app_locale', value: locale);
      await crashlytics.setCustomKey('app_locale', locale);
    }
    if (widgetsViewed != null) {
      await crashlytics.setCustomKey('widgets_viewed', widgetsViewed);
    }
    if (quizTotalPlayed != null) {
      await crashlytics.setCustomKey('quiz_total_played', quizTotalPlayed);
    }
  }

  Future<void> logScreenView(String screenName) async {
    if (!_initialized) return;
    await _analytics!.logScreenView(screenName: screenName);
  }

  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (!_initialized) return;
    await _analytics!.logEvent(name: name, parameters: parameters);
  }

  /// Non-fatal errors (ad failures, network issues, etc.).
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
    Map<String, Object>? context,
  }) async {
    if (!_initialized) return;

    if (context != null) {
      for (final entry in context.entries) {
        await _crashlytics!.setCustomKey(entry.key, entry.value);
      }
    }
    if (reason != null) {
      await _crashlytics!.log(reason);
    }

    await _crashlytics!.recordError(
      exception,
      stack ?? StackTrace.current,
      reason: reason,
      fatal: fatal,
    );

    await logEvent(
      'app_error',
      parameters: {
        'error_type': exception.runtimeType.toString(),
        if (reason != null) 'reason': reason,
        'fatal': fatal ? 1 : 0,
        ...?context,
      },
    );
  }

  Future<void> logWidgetViewed({
    required String widgetId,
    required String widgetName,
    String? category,
  }) async {
    await logEvent(
      'widget_viewed',
      parameters: {
        'widget_id': widgetId,
        'widget_name': widgetName,
        if (category != null) 'category': category,
      },
    );
  }

  Future<void> logQuizCompleted({
    required int score,
    required int totalQuestions,
    required int lifetimePlayed,
  }) async {
    await logEvent(
      'quiz_completed',
      parameters: {
        'score': score,
        'total_questions': totalQuestions,
        'lifetime_played': lifetimePlayed,
      },
    );
  }

  Future<void> logAdFailure({
    required String adType,
    required String errorCode,
    required String errorMessage,
  }) async {
    await logEvent(
      'ad_failure',
      parameters: {
        'ad_type': adType,
        'error_code': errorCode,
        'error_message': errorMessage,
      },
    );
    await recordError(
      Exception('Ad failure: $adType'),
      StackTrace.current,
      reason: '$errorCode — $errorMessage',
      context: {'ad_type': adType, 'error_code': errorCode},
    );
  }

  Future<void> logFavoriteToggled({
    required String widgetId,
    required bool isFavorite,
  }) async {
    await logEvent(
      'favorite_toggled',
      parameters: {
        'widget_id': widgetId,
        'is_favorite': isFavorite ? 1 : 0,
      },
    );
  }

  Future<void> logTabSelected(String tabName) async {
    await logEvent('tab_selected', parameters: {'tab_name': tabName});
  }
}
