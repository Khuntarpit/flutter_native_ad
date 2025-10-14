import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flutter_native_ad_config.dart';
import 'flutter_native_ad_throttler.dart';
import 'flutter_native_ad_logger.dart';

class FlutterAdOpenAd {
  AppOpenAd? appOpenAd;

  loadAppOpenAd({
    String? adUnitId,
    required GenericAdEventCallback<AppOpenAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getAppOpenAdUnitId();
    FlutterNativeAdLogger.appOpen('Starting app open ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.appOpen('Retrying app open ad load after throttling delay');
        loadAppOpenAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, calling AppOpenAd.load()...');

    AppOpenAd.load(
      adUnitId: adUnitIdToUse,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          AdRequestThrottler.recordSuccess(adUnitIdToUse);
          FlutterNativeAdLogger.success('Successfully loaded!');
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          AdRequestThrottler.recordFailure(adUnitIdToUse);
          FlutterNativeAdLogger.error('Failed to load - Code: ${error.code}, Message: ${error.message}');
          FlutterNativeAdLogger.debug('Error domain: ${error.domain}');
          onAdFailedToLoad(error);
        },
      ),
    );
  }

  appOpenAdCallback(
      {Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent,
      GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent}) {
    appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent,
      onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
    );
  }
}
