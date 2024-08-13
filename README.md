# flutter_native_ad

[![Pub Version](https://img.shields.io/pub/v/flutter_native_ad.svg)](https://pub.dev/packages/flutter_native_ad)

The `flutter_native_ad` package is a powerful and easy-to-use Flutter plugin for integrating a variety of ad formats into your Flutter applications. This plugin supports banner ads, interstitial ads, rewarded ads, app open ads, native medium ads, native banner ads, and video native ads. It's designed to provide seamless ad experiences while maximizing your app's revenue.

## Features

- **Banner Ad**:  Display standard banner ads within your app.
- **Interstitial Ad**:  Show full-screen ads at natural transition points in your app.
- **Rewarded Ad**:  Reward users for watching video ads or interacting with ads.
- **App Open Ad**:  Display ads when users open your app.
- **Native Medium Ad**:  Show ads that blend seamlessly with your app’s content.
- **Native Banner Ad**:  Display smaller, content-rich banner ads.
- **Video Native Ad**:  Integrate video ads that match the look and feel of your app.

## Installation

Add `flutter_native_ad` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_native_ad: ^latest_version
```

- Install it - You can install packages from the command line:

```sh
flutter pub get
```

## Android Specific Setup
### Update your AndroidManifest.xml

Add your AdMob App ID to your app's AndroidManifest.xml file by adding the `<meta-data>` tag shown below. You can find your App ID in the AdMob UI. For android:value insert your own AdMob App ID in quotes, as shown below.

You can use these test App ID's from Admob for development:
```
Android: ca-app-pub-3940256099942544~3347511713 
```

```xml
<manifest>
  <application>
    <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-3940256099942544~3347511713"/>
  </application>
</manifest>
```

### Initialize the plugin

First thing to do before attempting to show any ads is to initialize the plugin. You can do this in the earliest starting point of your app, your `main` function:

```dart
import 'package:admob_flutter/admob_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  FlutterNativeAd.init();
  // Or add a list of test ids.
  // FlutterNativeAd.init(testDeviceIds: ['YOUR DEVICE ID']);
}
```

### Banner Ad
```dart
final _adBanner = FlutterBannerAd();
var isBannerAdReady = false;

// load banner ad request in initState
 await _adBanner.loadBannerAd(adUnitId: "Your Banner ID",
      onAdLoaded: (_) {
        isBannerAdReady = true;
        setState(()=>"");
      },
      onAdFailedToLoad: (ad, err) {
        print('Failed to load a banner ad: ${err.message}');
        isBannerAdReady = false;
        ad.dispose();
      },
    );

// show banner ad widget in UI anywhere you want!

Container(height: 50,child: isBannerAdReady ?_adBanner.getBannerAd() : SizedBox.shrink())
```

### Interstitial Ad
```dart
  bool isInterstitialAdReady = false;
  final _interstitialAd = FlutterInterstitialAd();

// load interstitial ad request in initState
 await _interstitialAd.loadInterstitialAd(
      adUnitId: "Your Interstitial Ad ID",
      onAdLoaded: (ad) {
      _interstitialAd.interstitialAd = ad;
      isInterstitialAdReady = true;
    },
      onAdFailedToLoad: (err) {
        print('Failed to load an interstitial ad: ${err.message}');
        isInterstitialAdReady = false;
        _loadInterStitialAd();
      },
    );

// show interstitial ad anywhere you want!

 if(isInterstitialAdReady){
   await _interstitialAd.interstitialAd?.show();
 }
```

### App Open Ad
```dart
  bool isAppOpenAdAdReady = false;
  final _adOpenAd = FlutterAdOpenAd();

// load app open ad request in initState
    await _adOpenAd.loadAppOpenAd(
      adUnitId: "Your Open Ad ID",
      onAdLoaded:(ad) {
        print('$ad loaded');
        _adOpenAd.appOpenAd = ad;
        isAppOpenAdAdReady = true;
      },
      onAdFailedToLoad:   (error) {
        isAppOpenAdAdReady = false;
        print('AppOpenAd failed to load: $error');
        loadAd();
      },
    );

// show app open ad anywhere you want!

 if(isAppOpenAdAdReady){
   await _adOpenAd.appOpenAd?.show();
 }
```

### Medium Native Ad
```dart
  bool isMediumNativeAdReady = false;
  final _ad = FlutterNativeAd();

// load medium native ad request in initState
await _ad.loadmediumNativeAd(
      adUnitId: "Your Native Ad ID",
      onAdLoaded: (ad) {
        isMediumNativeAdReady = true;
        setState(()=>"");
      },
      onAdFailedToLoad:(ad, error) {
        _ad.loadmediumNativeAd();
        isMediumNativeAdReady = false;
        ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');
      },
    );

// show medium native ad widget in UI anywhere you want!

Container(height: 255,child: isMediumNativeAdReady ?_ad.getMediumNativeAD() : SizedBox.shrink())
```

### Native Banner Ad
```dart
   bool isNativeAdReady = false;
  final _ad = FlutterNativeAd();

// load native banner ad request in initState
    await _ad.loadNativeBannerAd(
      adUnitId: "Your Native Banner Ad ID",
      onAdLoaded: (ad) {
        isNativeAdReady = true;
        setState(()=>"");
      },
      onAdFailedToLoad:(ad, error) {
        _ad.loadNativeBannerAd();
        isNativeAdReady = false;
        ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');
      },
    );

// show native banner ad widget in UI anywhere you want!

Container(height: 102,child: isNativeAdReady?_ad.getnativeBannerAD() :SizedBox.shrink())
```

### Rewarded Ad
```dart
  final _rewardedAd = FlutterRewardedAd();
  bool isRewardedAdReady = false;

// load rewarded ad request in initState
  await _rewardedAd.loadRewardedAd(
      adUnitId: "Your Rewarded Ad ID",
      onAdLoaded: ( ad) {
        _rewardedAd.rewardedAd = ad;
        isRewardedAdReady = true;
      },
      onAdFailedToLoad: (error) {
        print('Failed to load a rewarded ad: ${error.message}');
        isRewardedAdReady = false;
        loadAds();
      },
    );

// show rewarded ad anywhere you want!

 if(isRewardedAdReady){
   await _rewardedAd.rewardedAd.show(onUserEarnedReward: (ad, reward) {});
 }
```

### Native Video Ad
```dart
 final _ad = FlutterNativeAd();

// sshow video native ad widget in UI anywhere you want!

Container(height: 255,child:  _ad.addVideoNativeAD(context))
```