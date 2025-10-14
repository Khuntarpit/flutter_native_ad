# Flutter Native Ad Plugin

A comprehensive Flutter plugin that provides all types of Google AdMob ads in one package. This plugin supports Banner Ads, Interstitial Ads, Rewarded Ads, App Open Ads, and Native Ads (both small and medium sizes) for both Android and iOS platforms.

## Features

- 🎯 **All Ad Types**: Banner, Interstitial, Rewarded, App Open, Native Ads
- 🔧 **Easy Configuration**: Simple setup with test and production ad IDs
- 📱 **Cross Platform**: Full support for both Android and iOS
- 🎨 **Customizable**: Flexible ad unit ID configuration
- 🧪 **Test Mode**: Built-in Google test ad IDs for development
- 🔄 **Auto Retry**: Automatic retry mechanism for failed ad loads
- 📊 **Error Handling**: Comprehensive error handling and logging
- ⏱️ **Request Throttling**: Intelligent rate limiting to prevent "Too many requests" errors
- 🎯 **Smart Retry**: Exponential backoff for failed requests

## Supported Ad Types

1. **Banner Ads** - Small rectangular ads at the top or bottom of the screen
2. **Interstitial Ads** - Full-screen ads shown between content
3. **Rewarded Ads** - Full-screen ads that reward users for watching
4. **Rewarded Interstitial Ads** - Combination of interstitial and rewarded ads
5. **App Open Ads** - Full-screen ads shown when users open or return to the app
6. **Native Banner Ads** - Small native ads that blend with app content
7. **Native Medium Ads** - Medium-sized native ads with more content
8. **Native Video Ads** - Native ads with video content (Android only)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_native_ad: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Setup

### 1. Android Setup

Add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <!-- Google Mobile Ads App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
    </application>
</manifest>
```

### 2. iOS Setup

Add the following to your `ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
```

## Usage

### 1. Initialize the Plugin

```dart
import 'package:flutter_native_ad/flutter_native_ad.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeAds();
  }

  void _initializeAds() {
    // Initialize with test mode for development
    FlutterNativeAdConfig.initialize(
      isTestMode: true, // Set to false for production
      testDeviceIds: [
        "YOUR_TEST_DEVICE_ID", // Add your test device IDs here
      ],
      // Production ad unit IDs (set when ready for production)
      bannerAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      interstitialAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      rewardedAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      rewardedInterstitialAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      appOpenAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      nativeAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
      nativeVideoAdUnitId: "ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX",
    );
    
    FlutterNativeAd.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
```

### 2. Banner Ads

```dart
class BannerAdExample extends StatefulWidget {
  @override
  _BannerAdExampleState createState() => _BannerAdExampleState();
}

class _BannerAdExampleState extends State<BannerAdExample> {
  final _bannerAd = FlutterBannerAd();
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd.loadBannerAd(
      onAdLoaded: (_) {
        setState(() {
          _isBannerAdReady = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        print('Banner ad failed to load: ${error.message}');
        ad.dispose();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banner Ad Example')),
      body: Column(
        children: [
          // Your app content here
          Expanded(
            child: Center(
              child: Text('Your app content'),
            ),
          ),
          // Banner ad at the bottom
          if (_isBannerAdReady)
            Container(
              height: 50,
              child: _bannerAd.getBannerAd(),
            ),
        ],
      ),
    );
  }
}
```

### 3. Interstitial Ads

```dart
class InterstitialAdExample extends StatefulWidget {
  @override
  _InterstitialAdExampleState createState() => _InterstitialAdExampleState();
}

class _InterstitialAdExampleState extends State<InterstitialAdExample> {
  final _interstitialAd = FlutterInterstitialAd();

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    _interstitialAd.loadInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd.interstitialAd = ad;
        print('Interstitial ad loaded');
      },
      onAdFailedToLoad: (error) {
        print('Interstitial ad failed to load: ${error.message}');
      },
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd.interstitialAd != null) {
      _interstitialAd.interstitialAd!.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interstitial Ad Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showInterstitialAd,
          child: Text('Show Interstitial Ad'),
        ),
      ),
    );
  }
}
```

### 4. Rewarded Ads

```dart
class RewardedAdExample extends StatefulWidget {
  @override
  _RewardedAdExampleState createState() => _RewardedAdExampleState();
}

class _RewardedAdExampleState extends State<RewardedAdExample> {
  final _rewardedAd = FlutterRewardedAd();

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    _rewardedAd.loadRewardedAd(
      onAdLoaded: (ad) {
        print('Rewarded ad loaded');
      },
      onAdFailedToLoad: (error) {
        print('Rewarded ad failed to load: ${error.message}');
      },
    );
  }

  void _showRewardedAd() {
    _rewardedAd.rewardedAd.show(
      onUserEarnedReward: (ad, reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rewarded Ad Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showRewardedAd,
          child: Text('Show Rewarded Ad'),
        ),
      ),
    );
  }
}
```

### 5. Native Ads

```dart
class NativeAdExample extends StatefulWidget {
  @override
  _NativeAdExampleState createState() => _NativeAdExampleState();
}

class _NativeAdExampleState extends State<NativeAdExample> {
  final _nativeAd = FlutterNativeAd();
  bool _isNativeAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd.loadNativeBannerAd(
      onAdLoaded: (ad) {
        setState(() {
          _isNativeAdReady = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        print('Native ad failed to load: ${error.message}');
        ad.dispose();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Native Ad Example')),
      body: Column(
        children: [
          // Your app content here
          Expanded(
            child: ListView(
              children: [
                // Your list items here
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
                // Native ad in the list
                if (_isNativeAdReady)
                  Container(
                    height: 100,
                    child: _nativeAd.getnativeBannerAD(),
                  ),
                ListTile(title: Text('Item 3')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Configuration

### Test Mode vs Production Mode

The plugin automatically uses Google's test ad IDs when `isTestMode` is set to `true`. For production, set `isTestMode` to `false` and provide your actual ad unit IDs.

### Test Device IDs

To test ads on your device during development, add your device's test ID:

```dart
FlutterNativeAdConfig.initialize(
  isTestMode: true,
  testDeviceIds: [
    "YOUR_TEST_DEVICE_ID", // Get this from AdMob console
  ],
);
```

### Switching Between Test and Production

```dart
// Switch to production mode
FlutterNativeAdConfig.instance.switchToProduction();

// Switch back to test mode
FlutterNativeAdConfig.instance.switchToTestMode();
```

## Error Handling

The plugin includes comprehensive error handling with automatic retry mechanisms. All ad loading methods include error callbacks that provide detailed error information.

## Request Throttling

The plugin includes an intelligent request throttling system to prevent rate limiting errors:

- **Rate Limiting**: Prevents "Too many recently failed requests" errors
- **Smart Delays**: 3-second minimum delay between requests, 30-second delay after multiple failures
- **Per Ad Unit**: Throttling is tracked per ad unit ID
- **Automatic Retry**: Failed requests are automatically retried after appropriate delays
- **Reset Function**: `AdRequestThrottler.resetAll()` to clear throttling state

### Throttling Configuration

```dart
// Reset throttling (useful when app starts)
AdRequestThrottler.resetAll();

// Check if request is allowed
bool canRequest = AdRequestThrottler.canMakeRequest(adUnitId);

// Get time until next request
int delaySeconds = AdRequestThrottler.getTimeUntilNextRequest(adUnitId);
```

## Debug Logging

The plugin includes a comprehensive logging system that can be controlled for different build types:

### Logger Features

- **Controlled Logging**: Enable/disable logging based on build type
- **Categorized Logs**: Different log types for different purposes
- **Production Ready**: Automatically disabled in production builds
- **Debug Information**: Detailed logs for troubleshooting

### Log Types

```dart
FlutterNativeAdLogger.init('Initialization messages');
FlutterNativeAdLogger.config('Configuration messages');
FlutterNativeAdLogger.success('Success messages');
FlutterNativeAdLogger.error('Error messages');
FlutterNativeAdLogger.warning('Warning messages');
FlutterNativeAdLogger.info('Info messages');
FlutterNativeAdLogger.debug('Debug messages');
FlutterNativeAdLogger.banner('Banner ad messages');
FlutterNativeAdLogger.interstitial('Interstitial ad messages');
FlutterNativeAdLogger.rewarded('Rewarded ad messages');
FlutterNativeAdLogger.appOpen('App open ad messages');
FlutterNativeAdLogger.native('Native ad messages');
FlutterNativeAdLogger.screen('Screen navigation messages');
FlutterNativeAdLogger.throttling('Throttling messages');
FlutterNativeAdLogger.tip('Helpful tips and suggestions');
```

### Production Configuration

```dart
// For production builds - disable all logging
FlutterNativeAdLogger.setEnabled(false);
FlutterNativeAdLogger.setDebugMode(false);

// For debug builds - enable logging
FlutterNativeAdLogger.setEnabled(true);
FlutterNativeAdLogger.setDebugMode(kDebugMode);

// For testing - enable logging with test ads
FlutterNativeAdLogger.setEnabled(true);
FlutterNativeAdLogger.setDebugMode(true);
```

### Example Usage

```dart
import 'package:flutter_native_ad/flutter_native_ad.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure logging based on build type
  if (kReleaseMode) {
    // Production build - disable logging
    FlutterNativeAdLogger.setEnabled(false);
    FlutterNativeAdLogger.setDebugMode(false);
  } else {
    // Debug build - enable logging
    FlutterNativeAdLogger.setEnabled(true);
    FlutterNativeAdLogger.setDebugMode(true);
  }
  
  runApp(MyApp());
}
```

### Log Output Examples

```
🚀 [AD INIT] Starting ad initialization...
⚙️ [AD CONFIG] FlutterNativeAdConfig initialized in TEST mode
✅ [AD SUCCESS] MobileAds SDK initialized successfully
📱 [NATIVE AD] Starting native banner ad load with ID: ca-app-pub-3940256099942544/2247696110
🔍 [AD DEBUG] Request recorded, creating NativeAd...
❌ [AD ERROR] Failed to load - Code: 3, Message: No fill
💡 [TIP] "No fill" error - This is normal for test ads!
```

## Platform Support

- ✅ Android (API 21+)
- ✅ iOS (iOS 11.0+)

## Dependencies

- `google_mobile_ads: ^6.0.0`
- `plugin_platform_interface: ^2.1.8`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.