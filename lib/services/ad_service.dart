import 'dart:async';

import 'package:flutter/foundation.dart';
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

  static const String _prodAndroidAppOpenId =
      'ca-app-pub-1451522103593938/8546005746';
  static const String _prodIosAppOpenId =
      'ca-app-pub-1451522103593938/8546005746';

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

  // ── Global Fullscreen Lock & Expiration Limits ──────────────────────
  bool _isShowingFullScreenAd = false;
  static const Duration maxFullScreenAdAge = Duration(hours: 1);
  static const Duration maxAppOpenAdAge = Duration(hours: 4);

  // ── Interstitial state ──────────────────────────────────────────────
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool _isLoadingInterstitial = false;
  int _interstitialRetry = 0;
  DateTime? _interstitialLoadedAt;
  DateTime? _lastInterstitialTime;
  static const Duration minInterstitialInterval = Duration(seconds: 60);

  bool get canShowInterstitial {
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

  void grantAdFreePass({Duration duration = const Duration(hours: 1)}) {
    adFreeUntil.value = DateTime.now().add(duration);
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

  // ── Counters ────────────────────────────────────────────────────────
  int _detailScreenCounter = 0;
  int _interviewQuestionCounter = 0;

  void _logAdFailure(String adType, AdError error) {
    AnalyticsService().logAdFailure(
      adType: adType,
      errorCode: '${error.code}',
      errorMessage: error.message,
    );
  }

  // ── Initialisation ──────────────────────────────────────────────────
  Future<void> initialize() async {
    _restoreAdFreePass();
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadRewardedAd();
    if (!isAdFree) loadAppOpenAd();
  }

  void onAppPaused() {
    _lastBackgroundTime = DateTime.now();
  }

  void onAppResumed() {
    if (_lastBackgroundTime == null) return;
    final away = DateTime.now().difference(_lastBackgroundTime!);
    _lastBackgroundTime = null;
    if (away.inMinutes >= 3 && !_isShowingFullScreenAd && !isAdFree) {
      showAppOpenAdIfAvailable();
    }
  }

  // ── Detail / Interview counters (triggered on screen exit) ──────────

  /// Triggered at natural transitions (e.g. exiting detail screen).
  void incrementDetailScreenCounter() {
    if (isAdFree) return;
    _detailScreenCounter++;
    if (_detailScreenCounter % 3 == 0) {
      showInterstitialAd();
    }
  }

  /// Triggered at natural transitions (e.g. exiting interview question).
  void incrementInterviewQuestionCounter() {
    if (isAdFree) return;
    _interviewQuestionCounter++;
    if (_interviewQuestionCounter % 3 == 0) {
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
          );
        },
      ),
    );
  }

  // ── Interstitial ────────────────────────────────────────────────────
  void loadInterstitialAd() {
    if (_isLoadingInterstitial || (_isInterstitialAdReady && !_isInterstitialExpired)) {
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
            );
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingFullScreenAd = false;
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingFullScreenAd = false;
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
    if (isAdFree || _isShowingFullScreenAd) return;
    if (_isInterstitialExpired) {
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isInterstitialAdReady = false;
      loadInterstitialAd();
      return;
    }
    if (!canShowInterstitial) {
      debugPrint('[AdService] Interstitial deferred to protect user experience (60s cooldown).');
      return;
    }
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _lastInterstitialTime = DateTime.now();
      _isShowingFullScreenAd = true;
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  /// Shows an interstitial ad and invokes [onComplete] after the ad is
  /// dismissed (or immediately if no ad is ready).
  void showInterstitialAdWithCallback(void Function() onComplete) {
    if (isAdFree || _isShowingFullScreenAd) {
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
      _lastInterstitialTime = DateTime.now();
      _isShowingFullScreenAd = true;
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingFullScreenAd = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          _isShowingFullScreenAd = false;
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          loadInterstitialAd();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _isShowingFullScreenAd = false;
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

  void loadRewardedAd() {
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
            );
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingFullScreenAd = false;
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              loadRewardedAd(); // preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingFullScreenAd = false;
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
      onNotReady?.call();
      return;
    }

    if (!_isRewardedAdReady || _rewardedAd == null) {
      loadRewardedAd();
      onNotReady?.call();
      return;
    }

    _isShowingFullScreenAd = true;
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewarded();
      },
    );
  }

  // ── App Open ────────────────────────────────────────────────────────
  void loadAppOpenAd() {
    if (isAdFree || _isLoadingAppOpen || (_isAppOpenAdReady && !_isAppOpenExpired)) return;
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
            );
          };

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingFullScreenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingFullScreenAd = false;
              ad.dispose();
              _appOpenAd = null;
              _isAppOpenAdReady = false;
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingFullScreenAd = false;
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
    if (isAdFree || _isShowingFullScreenAd) {
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
          ad.dispose();
          _appOpenAd = null;
          _isAppOpenAdReady = false;
          loadAppOpenAd();
          onDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _isShowingFullScreenAd = false;
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
