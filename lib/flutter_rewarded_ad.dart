
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FlutterRewardedAd {

  late RewardedAd rewardedAd;


  loadRewardedAd({
    String? adUnitId,
    required GenericAdEventCallback<RewardedAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    RewardedAd.load(
      adUnitId: adUnitId ?? "ca-app-pub-3940256099942544/5224354917",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad
      ),
    );
  }

  rewardedCallback({
    GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent,
    Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent}){
      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
          onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent);
    }
  }