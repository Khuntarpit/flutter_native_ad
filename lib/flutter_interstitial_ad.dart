
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FlutterInterstitialAd{

  InterstitialAd? interstitialAd;
  RewardedInterstitialAd? rewardedInterstitial;

   loadInterstitialAd({
    String? adUnitId,
    required GenericAdEventCallback<InterstitialAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: adUnitId ?? "ca-app-pub-3940256099942544/1033173712",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  loadRewardedInterstitialAd({
    String? adUnitId,
    required GenericAdEventCallback<RewardedInterstitialAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
}) {
    RewardedInterstitialAd.load(
        adUnitId: adUnitId ?? "ca-app-pub-3940256099942544/5354046379",
        request: AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        ));
  }

  rewardedInterstitialCallback({GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent,Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent}){
    rewardedInterstitial?.fullScreenContentCallback = FullScreenContentCallback(
    onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
    onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent);
  }



}