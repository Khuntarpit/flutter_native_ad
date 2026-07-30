import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'flutter_native_ad_config.dart';
import 'flutter_native_ad_throttler.dart';
import 'flutter_native_ad_logger.dart';

export 'flutter_interstitial_ad.dart';
export 'flutter_banner_ad.dart';
export 'flutter_rewarded_ad.dart';
export 'flutter_open_ad.dart';
export 'flutter_native_ad_config.dart';
export 'flutter_native_ad_throttler.dart';
export 'flutter_native_ad_logger.dart';

class FlutterNativeAd {
  FlutterNativeAd();
  late NativeAd nativeAd;
  late NativeAd mediumNativeAd;

  static Future<void> init({List<String>? testDeviceIds}) async {
    FlutterNativeAdLogger.init('Initializing MobileAds SDK...');
    
    // Initialize MobileAds SDK if not already initialized
    await MobileAds.instance.initialize();
    FlutterNativeAdLogger.success('MobileAds SDK initialized successfully');
    
    // Set up test device configuration
    final deviceIds = testDeviceIds ?? ["BC754A812958EE7FF20599662417762B"];
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: deviceIds));
    FlutterNativeAdLogger.config('Test device IDs configured: $deviceIds');
    
    // Add additional debug information
    FlutterNativeAdLogger.debug('Current test mode: ${FlutterNativeAdConfig.instance.isTestMode}');
    FlutterNativeAdLogger.debug('Banner ad unit ID: ${FlutterNativeAdConfig.instance.getBannerAdUnitId()}');
    FlutterNativeAdLogger.debug('Native ad unit ID: ${FlutterNativeAdConfig.instance.getNativeAdUnitId()}');
    FlutterNativeAdLogger.debug('Interstitial ad unit ID: ${FlutterNativeAdConfig.instance.getInterstitialAdUnitId()}');
    
    // Initialize native ads
    FlutterNativeAdLogger.native('Setting up native ad method channel...');
    const methodChannel = MethodChannel("flutter_native_ad");
    Map<String, String> nativeID = {
      "nativeVideoID": FlutterNativeAdConfig.instance.getNativeVideoAdUnitId()
    };
    FlutterNativeAdLogger.debug('Native video ad unit ID: ${nativeID["nativeVideoID"]}');
    
    try {
      await methodChannel.invokeMethod("getNativeAds", nativeID);
      FlutterNativeAdLogger.success('Native ad method channel setup completed');
    } catch (e) {
      FlutterNativeAdLogger.error('Error setting up native ad method channel: $e');
    }
  }

  Future<void> testDevice({List<String>? testDeviceIds}) async {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: testDeviceIds ?? ["BC754A812958EE7FF20599662417762B"]));
  }

  Future<void> invokeNativeAd({String? nativeVideoID}) async {
    const methodChannel = MethodChannel("flutter_native_ad");

    Map<String, String> nativeID = {
      "nativeVideoID": nativeVideoID ?? FlutterNativeAdConfig.instance.getNativeVideoAdUnitId()
    };
    await methodChannel.invokeMethod("getNativeAds", nativeID);
  }

  void loadNativeBannerAd(
      {String? adUnitId,
      AdEventCallback? onAdLoaded,
      Function(Ad ad, LoadAdError error)? onAdFailedToLoad}) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getNativeAdUnitId();
    FlutterNativeAdLogger.native('Starting native banner ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.native('Retrying native banner ad load after throttling delay');
        loadNativeBannerAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, creating NativeAd...');

    nativeAd = NativeAd(
      adUnitId: adUnitIdToUse,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          AdRequestThrottler.recordSuccess(adUnitIdToUse);
          FlutterNativeAdLogger.success('Successfully loaded!');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          AdRequestThrottler.recordFailure(adUnitIdToUse);
          FlutterNativeAdLogger.error('Failed to load - Code: ${error.code}, Message: ${error.message}');
          FlutterNativeAdLogger.debug('Error domain: ${error.domain}');
          
          // Provide helpful information about common errors
          if (error.code == 3) {
            FlutterNativeAdLogger.tip('"No fill" error - This is normal for test ads!');
            FlutterNativeAdLogger.tip('Google may not have ads available for this ad unit right now.');
            FlutterNativeAdLogger.tip('Try again in a few minutes or check your AdMob console setup.');
          }
          
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
    
    FlutterNativeAdLogger.debug('Calling nativeAd.load()...');
    nativeAd.load();
  }

  void loadmediumNativeAd(
      {String? adUnitId,
      AdEventCallback? onAdLoaded,
      Function(Ad ad, LoadAdError error)? onAdFailedToLoad}) {
    final adUnitIdToUse = adUnitId ?? FlutterNativeAdConfig.instance.getNativeAdUnitId();
    FlutterNativeAdLogger.native('Starting native medium ad load with ID: $adUnitIdToUse');
    
    // Check if we can make a request (throttling)
    if (!AdRequestThrottler.canMakeRequest(adUnitIdToUse)) {
      final delay = AdRequestThrottler.getTimeUntilNextRequest(adUnitIdToUse);
      FlutterNativeAdLogger.throttling('Request throttled. Retrying in $delay seconds.');
      
      // Schedule retry
      Future.delayed(Duration(seconds: delay), () {
        FlutterNativeAdLogger.native('Retrying native medium ad load after throttling delay');
        loadmediumNativeAd(
          adUnitId: adUnitId,
          onAdLoaded: onAdLoaded,
          onAdFailedToLoad: onAdFailedToLoad,
        );
      });
      return;
    }

    // Record the request attempt
    AdRequestThrottler.recordRequest(adUnitIdToUse);
    FlutterNativeAdLogger.debug('Request recorded, creating NativeAd...');

    mediumNativeAd = NativeAd(
      adUnitId: adUnitIdToUse,
      factoryId: 'listTileMedium',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          AdRequestThrottler.recordSuccess(adUnitIdToUse);
          FlutterNativeAdLogger.success('Successfully loaded!');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          AdRequestThrottler.recordFailure(adUnitIdToUse);
          FlutterNativeAdLogger.error('Failed to load - Code: ${error.code}, Message: ${error.message}');
          FlutterNativeAdLogger.debug('Error domain: ${error.domain}');
          
          // Provide helpful information about common errors
          if (error.code == 3) {
            FlutterNativeAdLogger.tip('"No fill" error - This is normal for test ads!');
            FlutterNativeAdLogger.tip('Google may not have ads available for this ad unit right now.');
            FlutterNativeAdLogger.tip('Try again in a few minutes or check your AdMob console setup.');
          }
          
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
    
    FlutterNativeAdLogger.debug('Calling mediumNativeAd.load()...');
    mediumNativeAd.load();
  }

  Widget getnativeBannerAD() {
    return AdWidget(ad: nativeAd);
  }

  Widget getMediumNativeAD() {
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
