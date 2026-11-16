import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'analytics_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // ── Production Ad Unit IDs ──────────────────────────────────────────
  static const String _prodAndroidBannerId =
      'ca-app-pub-1451522103593938/8796950476';
  static const String _prodIosBannerId =
      'ca-app-pub-1451522103593938/8796950476';

  static const String _prodAndroidInterstitialId =
      'ca-app-pub-1451522103593938/8546005746';
  static const String _prodIosInterstitialId =
      'ca-app-pub-1451522103593938/8546005746';

  static const String _prodAndroidRewardedId =
      'ca-app-pub-1451522103593938/8064623584';
  static const String _prodIosRewardedId =
      'ca-app-pub-1451522103593938/8064623584';

  // Dedicated App Open Ad Unit IDs
  static const String _prodAndroidAppOpenId =
      'ca-app-pub-1451522103593938/9257395921';
  static const String _prodIosAppOpenId =
      'ca-app-pub-1451522103593938/5575463023';

  // Dedicated Native Ad Unit IDs
  static const String _prodAndroidNativeId =
      'ca-app-pub-1451522103593938/4071254287';
  static const String _prodIosNativeId =
      'ca-app-pub-1451522103593938/4071254287';

  // ── Google Official Test Ad Unit IDs (for safe development / testing) ──
  static const String _testAndroidBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testIosBannerId =
      'ca-app-pub-3940256099942544/2934735716';

  static const String _testAndroidInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testIosInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';

  static const String _testAndroidRewardedId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testIosRewardedId =
      'ca-app-pub-3940256099942544/1712485313';

  static const String _testAndroidAppOpenId =
      'ca-app-pub-3940256099942544/9257395921';
  static const String _testIosAppOpenId =
      'ca-app-pub-3940256099942544/5575463023';

  static const String _testAndroidNativeId =
      'ca-app-pub-3940256099942544/2247696110';
  static const String _testIosNativeId =
      'ca-app-pub-3940256099942544/3986624511';

  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  // In debug mode, automatically use Google test units to prevent invalid-traffic policy strikes.
  // In release / production build, seamlessly serve live production ad units.
  static String get bannerAdUnitId => kDebugMode
      ? (_isAndroid ? _testAndroidBannerId : _testIosBannerId)
      : (_isAndroid ? _prodAndroidBannerId : _prodIosBannerId);

  static String get interstitialAdUnitId => kDebugMode
      ? (_isAndroid ? _testAndroidInterstitialId : _testIosInterstitialId)
      : (_isAndroid ? _prodAndroidInterstitialId : _prodIosInterstitialId);

  static String get rewardedAdUnitId => kDebugMode
      ? (_isAndroid ? _testAndroidRewardedId : _testIosRewardedId)
      : (_isAndroid ? _prodAndroidRewardedId : _prodIosRewardedId);

  static String get appOpenAdUnitId => kDebugMode
      ? (_isAndroid ? _testAndroidAppOpenId : _testIosAppOpenId)
      : (_isAndroid ? _prodAndroidAppOpenId : _prodIosAppOpenId);

  static String get nativeAdUnitId => kDebugMode
      ? (_isAndroid ? _testAndroidNativeId : _testIosNativeId)
      : (_isAndroid ? _prodAndroidNativeId : _prodIosNativeId);

  // ── Global Fullscreen Lock & Expiration Limits ──────────────────────
  bool _isShowingFullScreenAd = false;
  DateTime? _lastFullScreenDismissedTime;
  static const Duration minFullScreenCooldown = Duration(seconds: 90);
  static const Duration maxFullScreenAdAge = Duration(hours: 1);
  static const Duration maxAppOpenAdAge = Duration(hours: 4);

  bool get isFullScreenAdShowing => _isShowingFullScreenAd;

  bool get isCooldownActive {
    if (_lastFullScreenDismissedTime == null) return false;
    return DateTime.now().difference(_lastFullScreenDismissedTime!) <
        minFullScreenCooldown;
  }

  // ── Interstitial Frequency & Daily Caps ──────────────────────────────
  static const int maxInterstitialsPerSession = 4;
  static const int maxInterstitialsPerDay = 8;
  static const Duration minInterstitialInterval = Duration(seconds: 60);
  static const _dailyInterstitialDateKey = 'ad_daily_int_date';
  static const _dailyInterstitialCountKey = 'ad_daily_int_count';

  int _sessionInterstitials = 0;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool _isLoadingInterstitial = false;
  int _interstitialRetry = 0;
  DateTime? _interstitialLoadedAt;
  DateTime? _lastInterstitialTime;

  String _todayStr() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }

  int get _dailyInterstitialsCount {
    final today = _todayStr();
    if (_box.read<String>(_dailyInterstitialDateKey) != today) {
      _box.write(_dailyInterstitialDateKey, today);
      _box.write(_dailyInterstitialCountKey, 0);
      return 0;
    }
    return _box.read<int>(_dailyInterstitialCountKey) ?? 0;
  }

  void _recordInterstitialShown() {
    final today = _todayStr();
    final next = _dailyInterstitialsCount + 1;
    _box.write(_dailyInterstitialDateKey, today);
    _box.write(_dailyInterstitialCountKey, next);
    _sessionInterstitials++;
    _lastInterstitialTime = DateTime.now();
  }

  bool get canShowInterstitial {
    if (_sessionInterstitials >= maxInterstitialsPerSession) {
      debugPrint(
          '[AdService] Interstitial capped: session limit reached ($maxInterstitialsPerSession).');
      return false;
    }
    if (_dailyInterstitialsCount >= maxInterstitialsPerDay) {
      debugPrint(
          '[AdService] Interstitial capped: daily limit reached ($maxInterstitialsPerDay).');
      return false;
    }
    if (_lastInterstitialTime == null) return true;
    return DateTime.now().difference(_lastInterstitialTime!) >=
        minInterstitialInterval;
  }

  bool get _isInterstitialExpired =>
      _interstitialLoadedAt != null &&
      DateTime.now().difference(_interstitialLoadedAt!) > maxFullScreenAdAge;

  // ── Rewarded state ──────────────────────────────────────────────────
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  bool _isLoadingRewarded = false;
  int _rewardedRetry = 0;
  DateTime? _rewardedLoadedAt;

  bool get _isRewardedExpired =>
      _rewardedLoadedAt != null &&
      DateTime.now().difference(_rewardedLoadedAt!) > maxFullScreenAdAge;

  // ── App Open state ──────────────────────────────────────────────────
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdReady = false;
  bool _isLoadingAppOpen = false;
  int _appOpenRetry = 0;
  DateTime? _appOpenLoadedAt;
  DateTime? _lastBackgroundTime;

  bool get _isAppOpenExpired =>
      _appOpenLoadedAt != null &&
      DateTime.now().difference(_appOpenLoadedAt!) > maxAppOpenAdAge;

  bool get canShowAppOpenAd {
    if (isAdFree || _isShowingFullScreenAd || isCooldownActive) return false;
    // Suppress App Open ad if user is actively in a quiz or swiping flashcards
    final currentRoute = Get.currentRoute;
    if (currentRoute.contains('quiz') || currentRoute.contains('interview_swipe')) {
      return false;
    }
    return true;
  }

  // ── Ad-free pass (rewarded ad reward) ───────────────────────────────
  static const _adFreeUntilKey = 'ad_free_until';
  final _box = GetStorage();
  final Rx<DateTime?> adFreeUntil = Rxn<DateTime>();

  bool get isAdFree {
    final until = adFreeUntil.value;
    return until != null && DateTime.now().isBefore(until);
  }

  Duration get adFreeRemaining {
    final until = adFreeUntil.value;
    if (until == null || !DateTime.now().isBefore(until)) {
      return Duration.zero;
    }
    return until.difference(DateTime.now());
  }

  void grantAdFreePass({Duration duration = const Duration(minutes: 30)}) {
    final currentUntil = adFreeUntil.value;
    final baseTime =
        (currentUntil != null && currentUntil.isAfter(DateTime.now()))
            ? currentUntil
            : DateTime.now();
    adFreeUntil.value = baseTime.add(duration);
    _box.write(_adFreeUntilKey, adFreeUntil.value!.millisecondsSinceEpoch);
  }

  void _restoreAdFreePass() {
    final ms = _box.read<int>(_adFreeUntilKey);
    if (ms == null) return;
    final until = DateTime.fromMillisecondsSinceEpoch(ms);
    if (DateTime.now().isBefore(until)) {
      adFreeUntil.value = until;
    } else {
      _box.remove(_adFreeUntilKey);
      adFreeUntil.value = null;
    }
  }

  // ── Screen Entry Dwell Time & Counters ──────────────────────────────
  DateTime? _detailScreenEnterTime;
  int _detailScreenCounter = 0;
  int _interviewQuestionCounter = 0;

  void onDetailScreenEntered() {
    _detailScreenEnterTime = DateTime.now();
  }

  void _logAdFailure(String adType, AdError error) {
    AnalyticsService().logAdFailure(
      adType: adType,
      errorCode: '${error.code}',
      errorMessage: error.message,
    );
  }

  static String extractAdSourceName(Ad ad) {
    return ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName ?? 'admob';
  }

  // ── Initialization & UMP Consent ────────────────────────────────────
  bool _isMobileAdsInitialized = false;

  /// Returns whether the app is permitted to request ads under UMP consent.
  Future<bool> canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } catch (_) {
      return true; // Fallback if UMP platform channel is unavailable
    }
  }

  Future<void> initialize({bool debugEeaConsent = false}) async {
    _restoreAdFreePass();

    // 1. Setup RequestConfiguration (compliance & developer targeting)
    try {
      final configuration = RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
      );
      await MobileAds.instance.updateRequestConfiguration(configuration);
    } catch (e) {
      debugPrint('[AdService] RequestConfiguration error: $e');
    }

    // 2. Request UMP Consent first (EU / UK / Swiss compliance)
    final params = ConsentRequestParameters(
      consentDebugSettings: (kDebugMode && debugEeaConsent)
          ? ConsentDebugSettings(
              debugGeography: DebugGeography.debugGeographyEea,
            )
          : null,
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((loadAndShowError) async {
          if (loadAndShowError != null) {
            debugPrint('[AdService] UMP Form Error: ${loadAndShowError.message}');
          }
          await _onConsentResolved();
        });
      },
      (formError) async {
        debugPrint(
            '[AdService] UMP Consent Info Update Error: ${formError.message}');
        await _onConsentResolved();
      },
    );
  }

  Future<void> _onConsentResolved() async {
    final canRequest = await canRequestAds();
    if (canRequest && !_isMobileAdsInitialized) {
      _isMobileAdsInitialized = true;
      try {
        await MobileAds.instance.initialize();
        debugPrint('[AdService] Mobile Ads SDK initialized successfully.');
      } catch (e) {
        debugPrint('[AdService] Mobile Ads SDK init error: $e');
      }

      // Preload ads only when consent allows
      loadInterstitialAd();
      loadRewardedAd();
      if (!isAdFree) loadAppOpenAd();
    } else if (!canRequest) {
      debugPrint(
          '[AdService] Ads request not permitted under current consent choices.');
    }
  }

  /// Checks if privacy options (consent management) is required for the user's jurisdiction.
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      final status =
          await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  /// Presents the Google UMP privacy options form so users can update consent.
  Future<void> showPrivacyOptionsForm(
    BuildContext context, {
    void Function(String message)? onStatus,
  }) async {
    final isRequired = await isPrivacyOptionsRequired();
    if (!isRequired) {
      onStatus?.call('Privacy choices are not required in your region.');
      return;
    }
    ConsentForm.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        debugPrint('[AdService] Privacy options error: ${formError.message}');
        onStatus?.call(formError.message);
      } else {
        onStatus?.call('Privacy preferences updated.');
      }
    });
  }

  void onAppPaused() {
    _lastBackgroundTime = DateTime.now();
  }

  void onAppResumed() {
    if (_lastBackgroundTime == null) return;
    final away = DateTime.now().difference(_lastBackgroundTime!);
    _lastBackgroundTime = null;
    // 2-minute away threshold for warm resume app-open ads
    if (away.inSeconds >= 120 && canShowAppOpenAd) {
      showAppOpenAdIfAvailable();
    }
  }

  // ── Detail / Interview counters (triggered on screen exit) ──────────

  /// Safely handles exiting the detail screen.
  /// If an interstitial is due, presents it with a callback that pops after dismissal.
  void onDetailScreenExiting(VoidCallback onPop) {
    if (isAdFree) {
      onPop();
      return;
    }
    if (_detailScreenEnterTime != null) {
      final dwell = DateTime.now().difference(_detailScreenEnterTime!);
      _detailScreenEnterTime = null;
      if (dwell.inSeconds < 6) {
        // Quick glance / accidental bounce: do not trigger ad
        onPop();
        return;
      }
    }
    _detailScreenCounter++;
    if (_detailScreenCounter % 4 == 0 && canShowInterstitial && !isCooldownActive) {
      showInterstitialAdWithCallback(onPop);
    } else {
      onPop();
    }
  }

  /// Triggered at natural transitions (e.g. exiting detail screen).
  /// Requires minimum 5 seconds dwell time to avoid counting quick bounces.
  void incrementDetailScreenCounter() {
    if (isAdFree) return;
    if (_detailScreenEnterTime != null) {
      final dwell = DateTime.now().difference(_detailScreenEnterTime!);
      _detailScreenEnterTime = null;
      if (dwell.inSeconds < 5) {
        // Quick glance / accidental bounce: do not count towards ad trigger
        return;
      }
    }
    _detailScreenCounter++;
    if (_detailScreenCounter % 4 == 0) {
      showInterstitialAd();
    }
  }

  /// Safely handles exiting an interview question.
  /// If an interstitial is due, presents it with a callback that pops after dismissal.
  void onInterviewQuestionExiting(VoidCallback onPop) {
    if (isAdFree) {
      onPop();
      return;
    }
    _interviewQuestionCounter++;
    if (_interviewQuestionCounter % 4 == 0 && canShowInterstitial && !isCooldownActive) {
      showInterstitialAdWithCallback(onPop);
    } else {
      onPop();
    }
  }

  /// Triggered at natural transitions (e.g. exiting interview question).
  void incrementInterviewQuestionCounter() {
    if (isAdFree) return;
    _interviewQuestionCounter++;
    if (_interviewQuestionCounter % 4 == 0) {
      showInterstitialAd();
    }
  }

  // ── Banner Helper ───────────────────────────────────────────────────
  BannerAd createBannerAd({bool isCollapsible = false}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(
        extras: isCollapsible ? const {'collapsible': 'bottom'} : null,
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _logAdFailure('banner', error);
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          AnalyticsService().logAdImpression(
            adType: 'banner',
            value: valueMicros / 1000000.0,
            currency: currencyCode,
            adUnitId: ad.adUnitId,
            precision: precision.name,
            adSource: extractAdSourceName(ad),
          );
        },
      ),
    );
  }

  // ── Interstitial ────────────────────────────────────────────────────
  Future<void> loadInterstitialAd() async {
    if (!await canRequestAds()) return;
    if (_isLoadingInterstitial ||
        (_isInterstitialAdReady && !_isInterstitialExpired)) {
      return;
    }
    _isLoadingInterstitial = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _isLoadingInterstitial = false;
          _interstitialRetry = 0;
          _interstitialLoadedAt = DateTime.now();

          // Log Impression-Level Ad Revenue (ILR)
          ad.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
            AnalyticsService().logAdImpression(
              adType: 'interstitial',
              value: valueMicros / 1000000.0,
              currency: currencyCode,
              adUnitId: ad.adUnitId,
              precision: precision.name,
              adSource: extractAdSourceName(ad),
            );
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingFullScreenAd = false;
              _lastFullScreenDismissedTime = DateTime.now();
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingFullScreenAd = false;
              _lastFullScreenDismissedTime = DateTime.now();
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              _logAdFailure('interstitial_show', error);
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          _isLoadingInterstitial = false;
          _interstitialAd = null;
          _logAdFailure('interstitial_load', error);

          // Exponential backoff retry
          if (_interstitialRetry < 3) {
            _interstitialRetry++;
            final delaySeconds = 1 << _interstitialRetry; // 2s, 4s, 8s
            Future.delayed(
              Duration(seconds: delaySeconds),
              () => loadInterstitialAd(),
            );
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (isAdFree || _isShowingFullScreenAd || isCooldownActive) return;
    if (_isInterstitialExpired) {
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      loadInterstitialAd();
      return;
    }
    if (!canShowInterstitial) {
      debugPrint(
          '[AdService] Interstitial deferred to protect user experience.');
      return;
    }
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _recordInterstitialShown();
      _isShowingFullScreenAd = true;
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  /// Shows an interstitial ad and invokes [onComplete] after the ad is
  /// dismissed (or immediately if no ad is ready).
  void showInterstitialAdWithCallback(void Function() onComplete) {
    if (isAdFree || _isShowingFullScreenAd || isCooldownActive) {
      onComplete();
      return;
    }
    if (_isInterstitialExpired) {
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      loadInterstitialAd();
      onComplete();
      return;
    }
    if (!canShowInterstitial) {
      onComplete();
      return;
    }
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _recordInterstitialShown();
      _isShowingFullScreenAd = true;
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingFullScreenAd = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          _isShowingFullScreenAd = false;
          _lastFullScreenDismissedTime = DateTime.now();
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          loadInterstitialAd();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _isShowingFullScreenAd = false;
          _lastFullScreenDismissedTime = DateTime.now();
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          _logAdFailure('interstitial_show', error);
          loadInterstitialAd();
          onComplete();
        },
      );
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
      onComplete();
    }
  }

  // ── Rewarded ────────────────────────────────────────────────────────

  bool get isRewardedAdReady => _isRewardedAdReady && !_isRewardedExpired;

  Future<void> loadRewardedAd() async {
    if (!await canRequestAds()) return;
    if (_isLoadingRewarded || (_isRewardedAdReady && !_isRewardedExpired)) return;
    _isLoadingRewarded = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _isLoadingRewarded = false;
          _rewardedRetry = 0;
          _rewardedLoadedAt = DateTime.now();

          // Log Impression-Level Ad Revenue (ILR)
          ad.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
            AnalyticsService().logAdImpression(
              adType: 'rewarded',
              value: valueMicros / 1000000.0,
              currency: currencyCode,
              adUnitId: ad.adUnitId,
              precision: precision.name,
              adSource: extractAdSourceName(ad),
            );
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingFullScreenAd = false;
              _lastFullScreenDismissedTime = DateTime.now();
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              loadRewardedAd(); // preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingFullScreenAd = false;
              _lastFullScreenDismissedTime = DateTime.now();
              debugPrint('[AdService] Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              _logAdFailure('rewarded_show', error);
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Rewarded ad failed to load: $error');
          _isRewardedAdReady = false;
          _isLoadingRewarded = false;
          _rewardedAd = null;
          _logAdFailure('rewarded_load', error);

          if (_rewardedRetry < 3) {
            _rewardedRetry++;
            final delaySeconds = 1 << _rewardedRetry;
            Future.delayed(
              Duration(seconds: delaySeconds),
              () => loadRewardedAd(),
            );
          }
        },
      ),
    );
  }

  void showRewardedAd({
    required VoidCallback onRewarded,
    VoidCallback? onNotReady,
    BuildContext? context,
  }) {
    if (_isShowingFullScreenAd) {
      onNotReady?.call();
      return;
    }

    if (_isRewardedExpired) {
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _isRewardedAdReady = false;
      loadRewardedAd();
    }

    if (_isRewardedAdReady && _rewardedAd != null) {
      _isShowingFullScreenAd = true;
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded();
        },
      );
      return;
    }

    // Graceful fallback: If ad is currently loading, wait up to 3 seconds with a lightweight dialog
    if (_isLoadingRewarded && context != null && context.mounted) {
      _waitForRewardedAd(context, onRewarded, onNotReady);
      return;
    }

    // Reset retry counter on user action to ensure re-fetch
    _rewardedRetry = 0;
    loadRewardedAd();
    onNotReady?.call();
  }

  void _waitForRewardedAd(
    BuildContext context,
    VoidCallback onRewarded,
    VoidCallback? onNotReady,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'ad_loading'.tr.isNotEmpty
                        ? 'ad_loading'.tr
                        : 'Loading sponsor video...',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    int elapsedMs = 0;
    Timer.periodic(const Duration(milliseconds: 250), (timer) {
      elapsedMs += 250;
      if (!context.mounted) {
        timer.cancel();
        return;
      }

      if (_isRewardedAdReady && _rewardedAd != null) {
        timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
        _isShowingFullScreenAd = true;
        _rewardedAd!.show(
          onUserEarnedReward: (ad, reward) {
            onRewarded();
          },
        );
      } else if (elapsedMs >= 3000 || !_isLoadingRewarded) {
        timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
        onNotReady?.call();
      }
    });
  }

  // ── App Open ────────────────────────────────────────────────────────
  Future<void> loadAppOpenAd() async {
    if (!await canRequestAds()) return;
    if (isAdFree ||
        _isLoadingAppOpen ||
        (_isAppOpenAdReady && !_isAppOpenExpired)) {
      return;
    }
    _isLoadingAppOpen = true;

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenAdReady = true;
          _isLoadingAppOpen = false;
          _appOpenRetry = 0;
          _appOpenLoadedAt = DateTime.now();

          // Log Impression-Level Ad Revenue (ILR)
          ad.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
            AnalyticsService().logAdImpression(
              adType: 'app_open',
              value: valueMicros / 1000000.0,
              currency: currencyCode,
              adUnitId: ad.adUnitId,
              precision: precision.name,
              adSource: extractAdSourceName(ad),
            );
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingFullScreenAd = false;
              _lastFullScreenDismissedTime = DateTime.now();
              ad.dispose();
              _appOpenAd = null;
              _isAppOpenAdReady = false;
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingFullScreenAd = false;
              _lastFullScreenDismissedTime = DateTime.now();
              ad.dispose();
              _appOpenAd = null;
              _isAppOpenAdReady = false;
              _logAdFailure('app_open_show', error);
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAppOpenAdReady = false;
          _isLoadingAppOpen = false;
          _appOpenAd = null;
          _logAdFailure('app_open_load', error);

          if (_appOpenRetry < 3) {
            _appOpenRetry++;
            final delaySeconds = 1 << _appOpenRetry;
            Future.delayed(
              Duration(seconds: delaySeconds),
              () => loadAppOpenAd(),
            );
          }
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable({VoidCallback? onDismissed}) {
    if (!canShowAppOpenAd) {
      onDismissed?.call();
      return;
    }

    if (_isAppOpenExpired) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _isAppOpenAdReady = false;
      loadAppOpenAd();
      onDismissed?.call();
      return;
    }

    if (_isAppOpenAdReady && _appOpenAd != null) {
      _isShowingFullScreenAd = true;
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingFullScreenAd = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          _isShowingFullScreenAd = false;
          _lastFullScreenDismissedTime = DateTime.now();
          ad.dispose();
          _appOpenAd = null;
          _isAppOpenAdReady = false;
          loadAppOpenAd();
          onDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _isShowingFullScreenAd = false;
          _lastFullScreenDismissedTime = DateTime.now();
          ad.dispose();
          _appOpenAd = null;
          _isAppOpenAdReady = false;
          _logAdFailure('app_open_show', error);
          loadAppOpenAd();
          onDismissed?.call();
        },
      );
      _appOpenAd!.show();
    } else {
      loadAppOpenAd();
      onDismissed?.call();
    }
  }

  // ── Cleanup ─────────────────────────────────────────────────────────
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
  }
}
