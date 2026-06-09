import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // Ad Unit IDs
  static const String _androidBannerId =
      'ca-app-pub-1451522103593938/8796950476';
  static const String _iosBannerId = 'ca-app-pub-1451522103593938/8796950476';

  static const String _androidInterstitialId =
      'ca-app-pub-1451522103593938/8546005746';
  static const String _iosInterstitialId =
      'ca-app-pub-1451522103593938/8546005746';

  // Test Ad Unit IDs (for testing purposes)
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';

  // Flag to use test ads (set to false for production)
  static const bool _useTestAds = false;

  // Get Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (_useTestAds) return _testBannerId;
    return Platform.isAndroid ? _androidBannerId : _iosBannerId;
  }

  // Get Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (_useTestAds) return _testInterstitialId;
    return Platform.isAndroid ? _androidInterstitialId : _iosInterstitialId;
  }

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _detailScreenCounter = 0;

  // Initialize Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
  }

  // Increment detail screen counter and show ad every 3 visits
  void incrementDetailScreenCounter() {
    _detailScreenCounter++;
    // Show ad every 3 visits for production
    if (_detailScreenCounter % 3 == 0) {
      showInterstitialAd();
    }
  }

  // Create Banner Ad
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Ad loaded successfully
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdOpened: (ad) {
          // Ad opened
        },
        onAdClosed: (ad) {
          // Ad closed
        },
      ),
    );
  }

  // Load Interstitial Ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              // Ad showed
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              // Load a new ad
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdReady = false;
              // Load a new ad
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

  // Show Interstitial Ad
  void showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      // Ad not ready, try to load
      loadInterstitialAd();
    }
  }

  // Dispose ads
  void dispose() {
    _interstitialAd?.dispose();
  }
}
