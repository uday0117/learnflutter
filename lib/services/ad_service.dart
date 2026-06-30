import 'dart:io';

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
  static const String _androidBannerId =
      'ca-app-pub-1451522103593938/8796950476';
  static const String _iosBannerId = 'ca-app-pub-1451522103593938/8796950476';

  static const String _androidInterstitialId =
      'ca-app-pub-1451522103593938/8546005746';
  static const String _iosInterstitialId =
      'ca-app-pub-1451522103593938/8546005746';

  static const String _androidRewardedId =
      'ca-app-pub-1451522103593938/8064623584';
  static const String _iosRewardedId =
      'ca-app-pub-1451522103593938/8064623584';

  static const String _androidAppOpenId =
      'ca-app-pub-1451522103593938/8546005746';
  static const String _iosAppOpenId =
      'ca-app-pub-1451522103593938/8546005746';

  // ── Ad Unit ID getters ──────────────────────────────────────────────
  static String get bannerAdUnitId =>
      Platform.isAndroid ? _androidBannerId : _iosBannerId;

  static String get interstitialAdUnitId =>
      Platform.isAndroid ? _androidInterstitialId : _iosInterstitialId;

  static String get rewardedAdUnitId =>
      Platform.isAndroid ? _androidRewardedId : _iosRewardedId;

  static String get appOpenAdUnitId =>
      Platform.isAndroid ? _androidAppOpenId : _iosAppOpenId;

  // ── Interstitial state ──────────────────────────────────────────────
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  // ── Rewarded state ──────────────────────────────────────────────────
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  // Prevents overlapping load calls
  bool _isLoadingRewarded = false;

  // ── App Open state ──────────────────────────────────────────────────
  AppOpenAd? _appOpenAd;
  bool _isAppOpenAdReady = false;
  bool _isShowingAppOpenAd = false;
  DateTime? _lastBackgroundTime;

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
    if (away.inMinutes >= 3) {
      showAppOpenAdIfAvailable();
    }
    _lastBackgroundTime = null;
  }

  // ── Detail / Interview counters ─────────────────────────────────────

  /// Show interstitial every 3 widget detail-screen visits.
  void incrementDetailScreenCounter() {
    if (isAdFree) return;
    _detailScreenCounter++;
    if (_detailScreenCounter % 3 == 0) {
      showInterstitialAd();
    }
  }

  /// Show interstitial every 3 interview questions viewed.
  void incrementInterviewQuestionCounter() {
    if (isAdFree) return;
    _interviewQuestionCounter++;
    if (_interviewQuestionCounter % 3 == 0) {
      showInterstitialAd();
    }
  }

  // ── Banner ──────────────────────────────────────────────────────────
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _logAdFailure('banner', error);
        },
        onAdOpened: (ad) {},
        onAdClosed: (ad) {},
      ),
    );
  }

  // ── Interstitial ────────────────────────────────────────────────────
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdReady = false;
              _logAdFailure('interstitial_show', error);
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
          _logAdFailure('interstitial_load', error);
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (isAdFree) return;
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  /// Shows an interstitial ad and invokes [onComplete] after the ad is
  /// dismissed (or immediately if no ad is ready).
  void showInterstitialAdWithCallback(void Function() onComplete) {
    if (isAdFree) {
      onComplete();
      return;
    }
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialAdReady = false;
          loadInterstitialAd();
          onComplete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
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

  /// Whether a rewarded ad is loaded and ready to show.
  bool get isRewardedAdReady => _isRewardedAdReady;

  /// Pre-loads a rewarded ad so it is ready for immediate display.
  void loadRewardedAd() {
    if (_isLoadingRewarded || _isRewardedAdReady) return;
    _isLoadingRewarded = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _isLoadingRewarded = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              loadRewardedAd(); // preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              _isLoadingRewarded = false;
              _logAdFailure('rewarded_show', error);
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Rewarded ad failed to load: $error');
          _isRewardedAdReady = false;
          _isLoadingRewarded = false;
          _logAdFailure('rewarded_load', error);
        },
      ),
    );
  }

  /// Shows the rewarded ad.
  ///
  /// [onRewarded]  – called when the user earns the reward (watched fully).
  /// [onNotReady]  – called when no ad is available (so the caller can give
  ///                 feedback or fall back gracefully).
  void showRewardedAd({
    required VoidCallback onRewarded,
    VoidCallback? onNotReady,
  }) {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      loadRewardedAd();
      onNotReady?.call();
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewarded();
      },
    );
    // Dismiss / fail callbacks are handled in fullScreenContentCallback
    // set inside loadRewardedAd(); the next load is triggered there too.
  }

  // ── App Open ────────────────────────────────────────────────────────
  void loadAppOpenAd() {
    if (isAdFree) return;

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenAdReady = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _isShowingAppOpenAd = true;
            },
            onAdDismissedFullScreenContent: (ad) {
              _isShowingAppOpenAd = false;
              ad.dispose();
              _isAppOpenAdReady = false;
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _isShowingAppOpenAd = false;
              ad.dispose();
              _isAppOpenAdReady = false;
              _logAdFailure('app_open_show', error);
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAppOpenAdReady = false;
          _logAdFailure('app_open_load', error);
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (isAdFree || _isShowingAppOpenAd) return;
    if (_isAppOpenAdReady && _appOpenAd != null) {
      _appOpenAd!.show();
    } else {
      loadAppOpenAd();
    }
  }

  // ── Cleanup ─────────────────────────────────────────────────────────
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _appOpenAd?.dispose();
  }
}
