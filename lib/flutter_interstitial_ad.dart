import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flutter_native_ad_config.dart';
import 'flutter_native_ad_throttler.dart';
import 'flutter_native_ad_logger.dart';

class FlutterInterstitialAd {
  InterstitialAd? interstitialAd;
  RewardedInterstitialAd? rewardedInterstitial;

  loadInterstitialAd({
    String? adUnitId,
    required GenericAdEventCallback<InterstitialAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getInterstitialAdUnitId();
    FlutterNativeAdLogger.interstitial('Starting interstitial ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.interstitial('Retrying interstitial ad load after throttling delay');
        loadInterstitialAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, calling InterstitialAd.load()...');

    InterstitialAd.load(
      adUnitId: adUnitIdToUse,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
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

  loadRewardedInterstitialAd({
    String? adUnitId,
    required GenericAdEventCallback<RewardedInterstitialAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getRewardedInterstitialAdUnitId();
    FlutterNativeAdLogger.interstitial('Starting rewarded interstitial ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.interstitial('Retrying rewarded interstitial ad load after throttling delay');
        loadRewardedInterstitialAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, calling RewardedInterstitialAd.load()...');

    RewardedInterstitialAd.load(
        adUnitId: adUnitIdToUse,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
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
        ));
  }

  rewardedInterstitialCallback(
      {GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent,
      Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent}) {
    rewardedInterstitial?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
        onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent);
  }
}
