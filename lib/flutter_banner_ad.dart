import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flutter_native_ad_config.dart';
import 'flutter_native_ad_throttler.dart';
import 'flutter_native_ad_logger.dart';

class FlutterBannerAd {
  //----------------------- BannerAd ----------------------//

  late BannerAd bannerAd;

  void loadBannerAd({
    String? adUnitId,
    AdEventCallback? onAdLoaded,
    AdLoadErrorCallback? onAdFailedToLoad,
  }) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getBannerAdUnitId();
    FlutterNativeAdLogger.banner('Starting banner ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.banner('Retrying banner ad load after throttling delay');
        loadBannerAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, creating banner ad...');

    bannerAd = BannerAd(
      adUnitId: adUnitIdToUse,
      request: const AdRequest(),
      size: AdSize.banner, // bannerAd size as per need
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          AdRequestThrottler.recordSuccess(adUnitIdToUse);
          FlutterNativeAdLogger.success('Successfully loaded!');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          AdRequestThrottler.recordFailure(adUnitIdToUse);
          FlutterNativeAdLogger.error('Failed to load - Code: ${error.code}, Message: ${error.message}');
          FlutterNativeAdLogger.debug('Error domain: ${error.domain}');
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
    
    FlutterNativeAdLogger.debug('Calling bannerAd.load()...');
    bannerAd.load();
  }

  Widget getBannerAd() {
    return AdWidget(ad: bannerAd);
  }
}
