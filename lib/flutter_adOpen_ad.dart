
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FlutterAdOpenAd{
  AppOpenAd? appOpenAd;


  loadAppOpenAd({
    String? adUnitId,
    required GenericAdEventCallback<AppOpenAd> onAdLoaded,
    required FullScreenAdLoadErrorCallback onAdFailedToLoad,
  }) {
    AppOpenAd.load(
      adUnitId: adUnitId ?? "ca-app-pub-3940256099942544/3419835294",
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad : onAdFailedToLoad
      ),
    );
  }

  appOpenAdCallback( {
    Function(Ad ad, AdError error)? onAdFailedToShowFullScreenContent,
    GenericAdEventCallback<Ad>? onAdDismissedFullScreenContent}){
    appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdFailedToShowFullScreenContent: onAdFailedToShowFullScreenContent,
      onAdDismissedFullScreenContent: onAdDismissedFullScreenContent,
    );

  }

}