
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FlutterBannerAd{

  //----------------------- BannerAd ----------------------//

  late BannerAd bannerAd;

  loadBannerAd({
    String? adUnitId,
    AdEventCallback? onAdLoaded,
    AdLoadErrorCallback? onAdFailedToLoad,
  }) {
    bannerAd = BannerAd(
      adUnitId: adUnitId ?? 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner, // bannerAd size as per need
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
    bannerAd.load();
  }

  Widget getBannerAd(){
    return AdWidget(ad: bannerAd);
  }
}

