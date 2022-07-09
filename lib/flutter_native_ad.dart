
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

export 'flutter_interstitial_ad.dart';
export 'flutter_banner_ad.dart';
export 'flutter_rewarded_ad.dart';
export 'flutter_adOpen_ad.dart';

class FlutterNativeAd {
  FlutterNativeAd();
  late NativeAd nativeAd;
  late NativeAd mediumNativeAd;

  FlutterNativeAd.init(){
    testDevice();
    invokeNativeAd();
  }

  testDevice() async{
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ["BC754A812958EE7FF20599662417762B"]));
  }

  invokeNativeAd({String? nativeVideoID}) async{
    final methodChannel = MethodChannel("flutter_native_ad");

    Map<String, String> nativeID = {"nativeVideoID": nativeVideoID ?? "ca-app-pub-3940256099942544/1044960115"};
    await methodChannel.invokeMethod("getNativeAds",nativeID);
  }

  loadNativeBannerAd({String? adUnitId, AdEventCallback? onAdLoaded, Function(Ad ad, LoadAdError error)? onAdFailedToLoad}) {
    nativeAd = NativeAd(
      adUnitId: adUnitId ?? 'ca-app-pub-3940256099942544/2247696110',
      // AdHelper.nativeAdUnitId ?? "ca-app-pub-3940256099942544/2247696110",
      factoryId: 'listTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad
      ),
    );

    nativeAd.load();
  }

  loadmediumNativeAd({String? adUnitId, AdEventCallback? onAdLoaded, Function(Ad ad, LoadAdError error)? onAdFailedToLoad}) {
    mediumNativeAd = NativeAd(
      adUnitId: adUnitId ?? "ca-app-pub-3940256099942544/2247696110",
      factoryId: 'listTileMedium',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad
      ),
    );
    mediumNativeAd.load();

  }


  Widget getnativeBannerAD(){
    return AdWidget(ad: nativeAd);
  }

  Widget getMediumNativeAD(){
    return AdWidget(ad: mediumNativeAd);
  }

  Widget addVideoNativeAD(BuildContext context) {
    const String viewType = '<platform-view-type>';
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return AndroidView(
      viewType: viewType,
      // layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}