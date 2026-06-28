import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  // ── Ad Unit ID getters ──────────────────────────────────────────────
  static String get bannerAdUnitId =>
      Platform.isAndroid ? _androidBannerId : _iosBannerId;

  static String get interstitialAdUnitId =>
      Platform.isAndroid ? _androidInterstitialId : _iosInterstitialId;

  static String get rewardedAdUnitId =>
      Platform.isAndroid ? _androidRewardedId : _iosRewardedId;

  // ── Interstitial state ──────────────────────────────────────────────
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  // ── Rewarded state ──────────────────────────────────────────────────
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  // Prevents overlapping load calls
  bool _isLoadingRewarded = false;

  // ── Counters ────────────────────────────────────────────────────────
  int _detailScreenCounter = 0;
  int _interviewQuestionCounter = 0;

  // ── Initialisation ──────────────────────────────────────────────────
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // ── Detail / Interview counters ─────────────────────────────────────

  /// Show interstitial every 5 widget detail-screen visits.
  void incrementDetailScreenCounter() {
    _detailScreenCounter++;
    if (_detailScreenCounter % 5 == 0) {
      showInterstitialAd();
    }
  }

  /// Show interstitial every 5 interview questions viewed.
  void incrementInterviewQuestionCounter() {
    _interviewQuestionCounter++;
    if (_interviewQuestionCounter % 5 == 0) {
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
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      loadInterstitialAd();
    }
  }

  /// Shows an interstitial ad and invokes [onComplete] after the ad is
  /// dismissed (or immediately if no ad is ready).
  void showInterstitialAdWithCallback(void Function() onComplete) {
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
        onAdLoaded: (ad) {          _rewardedAd = ad;
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
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Rewarded ad failed to load: $error');
          _isRewardedAdReady = false;
          _isLoadingRewarded = false;
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

  // ── Cleanup ─────────────────────────────────────────────────────────
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
