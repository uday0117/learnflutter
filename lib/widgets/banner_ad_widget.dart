import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';
import '../services/analytics_service.dart';

class BannerAdWidget extends StatefulWidget {
  final VoidCallback? onAdLoaded;
  final double? customWidth;
  final bool isCollapsible;

  const BannerAdWidget({
    super.key,
    this.onAdLoaded,
    this.customWidth,
    this.isCollapsible = false,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;
  int _retryCount = 0;
  Timer? _retryTimer;
  StreamSubscription? _adFreeSubscription;

  @override
  void initState() {
    super.initState();
    // Reactively watch ad-free pass status to immediately dispose ad if activated
    _adFreeSubscription = AdService().adFreeUntil.listen((until) {
      if (AdService().isAdFree && mounted) {
        _cleanupAd();
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null && !_isAdLoading && !AdService().isAdFree) {
      _loadAd();
    }
  }

  void _cleanupAd() {
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
    _isAdLoading = false;
  }

  Future<void> _loadAd() async {
    if (AdService().isAdFree || _isAdLoading || !mounted) return;

    _isAdLoading = true;
    final screenWidth = MediaQuery.of(context).size.width.truncate();
    final int bannerWidth = widget.customWidth != null
        ? widget.customWidth!.truncate().clamp(100, screenWidth)
        : screenWidth;

    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(bannerWidth);

    if (!mounted) {
      _isAdLoading = false;
      return;
    }

    if (size == null) {
      debugPrint('[BannerAdWidget] Unable to get height of anchored banner.');
      _isAdLoading = false;
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: size,
      request: AdRequest(
        extras: widget.isCollapsible ? const {'collapsible': 'bottom'} : null,
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          _retryCount = 0;
          setState(() {
            _isAdLoaded = true;
            _isAdLoading = false;
          });
          widget.onAdLoaded?.call();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          AnalyticsService().logAdFailure(
            adType: 'banner',
            errorCode: '${error.code}',
            errorMessage: error.message,
          );

          if (!mounted) return;

          setState(() {
            _bannerAd = null;
            _isAdLoaded = false;
            _isAdLoading = false;
          });

          // Exponential backoff retry on transient failure (max 2 retries: 15s, 30s)
          if (_retryCount < 2 && !AdService().isAdFree) {
            _retryCount++;
            final delay = Duration(seconds: _retryCount * 15);
            _retryTimer?.cancel();
            _retryTimer = Timer(delay, () {
              if (mounted && _bannerAd == null) {
                _loadAd();
              }
            });
          }
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          AnalyticsService().logAdImpression(
            adType: 'banner',
            value: valueMicros / 1000000.0,
            currency: currencyCode,
            adUnitId: ad.adUnitId,
            precision: precision.name,
          );
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _adFreeSubscription?.cancel();
    _cleanupAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AdService().isAdFree) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      child: _isAdLoaded && _bannerAd != null
          ? AnimatedOpacity(
              opacity: _isAdLoaded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
              child: Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : const SizedBox(width: double.infinity, height: 0),
    );
  }
}
