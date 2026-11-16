import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';
import '../services/analytics_service.dart';

class NativeAdWidget extends StatefulWidget {
  final TemplateType templateType;
  final double? customHeight;
  final VoidCallback? onAdLoaded;

  const NativeAdWidget({
    super.key,
    this.templateType = TemplateType.medium,
    this.customHeight,
    this.onAdLoaded,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget>
    with AutomaticKeepAliveClientMixin {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;
  int _retryCount = 0;
  Timer? _retryTimer;
  StreamSubscription? _adFreeSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _adFreeSubscription = AdService().adFreeUntil.listen((until) {
      if (AdService().isAdFree && mounted) {
        _cleanupAd();
        setState(() {});
      } else if (!AdService().isAdFree && mounted && _nativeAd == null && !_isAdLoading) {
        _loadAd();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_nativeAd == null && !_isAdLoading && !AdService().isAdFree) {
      _loadAd();
    }
  }

  void _cleanupAd() {
    _retryTimer?.cancel();
    _nativeAd?.dispose();
    _nativeAd = null;
    _isAdLoaded = false;
    _isAdLoading = false;
  }

  Future<void> _loadAd() async {
    if (AdService().isAdFree || _isAdLoading || !mounted) return;
    if (!await AdService().canRequestAds()) return;
    if (!mounted) return;

    _isAdLoading = true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    final templateStyle = NativeTemplateStyle(
      templateType: widget.templateType,
      mainBackgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      cornerRadius: 16.0,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: Colors.white,
        backgroundColor: primaryColor,
        style: NativeTemplateFontStyle.bold,
        size: 14.0,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        style: NativeTemplateFontStyle.bold,
        size: 15.0,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: isDark ? Colors.white70 : Colors.black87,
        style: NativeTemplateFontStyle.normal,
        size: 13.0,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: isDark ? Colors.white60 : Colors.black54,
        style: NativeTemplateFontStyle.normal,
        size: 11.0,
      ),
    );

    _nativeAd?.dispose();

    _nativeAd = NativeAd(
      adUnitId: AdService.nativeAdUnitId,
      request: const AdRequest(),
      nativeTemplateStyle: templateStyle,
      listener: NativeAdListener(
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
            adType: 'native',
            errorCode: '${error.code}',
            errorMessage: error.message,
          );

          if (!mounted) return;

          setState(() {
            _nativeAd = null;
            _isAdLoaded = false;
            _isAdLoading = false;
          });

          // Exponential backoff retry (max 2 retries: 15s, 30s)
          if (_retryCount < 2 && !AdService().isAdFree) {
            _retryCount++;
            final delay = Duration(seconds: _retryCount * 15);
            _retryTimer?.cancel();
            _retryTimer = Timer(delay, () {
              if (mounted && _nativeAd == null) {
                _loadAd();
              }
            });
          }
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          AnalyticsService().logAdImpression(
            adType: 'native',
            value: valueMicros / 1000000.0,
            currency: currencyCode,
            adUnitId: ad.adUnitId,
            precision: precision.name,
            adSource: AdService.extractAdSourceName(ad),
          );
        },
      ),
    );

    _nativeAd!.load();
  }

  @override
  void dispose() {
    _adFreeSubscription?.cancel();
    _cleanupAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (AdService().isAdFree) {
      return const SizedBox.shrink();
    }

    final double defaultHeight =
        widget.templateType == TemplateType.small ? 90.0 : 330.0;
    final double height = widget.customHeight ?? defaultHeight;

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      child: _isAdLoaded && _nativeAd != null
          ? AnimatedOpacity(
              opacity: _isAdLoaded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
              child: Container(
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AdWidget(ad: _nativeAd!),
                ),
              ),
            )
          : const SizedBox(width: double.infinity, height: 0),
    );
  }
}
