import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flutter_native_ad_config.dart';
import 'flutter_native_ad_throttler.dart';
import 'flutter_native_ad_logger.dart';

class FlutterRewardedAd {
  late RewardedAd rewardedAd;

  loadRewardedAd({
    String? adUnitId,
    required GenericAdEventCallback<RewardedAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getRewardedAdUnitId();
    FlutterNativeAdLogger.rewarded('Starting rewarded ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.rewarded('Retrying rewarded ad load after throttling delay');
        loadRewardedAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, calling RewardedAd.load()...');

    RewardedAd.load(
      adUnitId: adUnitIdToUse,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
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

  rewardedCallback(
      {GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent,
      Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent}) {
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
        onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent);
  }
}
