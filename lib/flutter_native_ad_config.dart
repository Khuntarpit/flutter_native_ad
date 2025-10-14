
/// Configuration class for Flutter Native Ad plugin
/// Handles both test and production ad unit IDs
class FlutterNativeAdConfig {
  static FlutterNativeAdConfig? _instance;
  static FlutterNativeAdConfig get instance => _instance ??= FlutterNativeAdConfig._();
  
  FlutterNativeAdConfig._();

  // Test Ad Unit IDs (Google's test IDs)
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedInterstitialAdUnitId = 'ca-app-pub-3940256099942544/5354046379';
  static const String _testAppOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
  static const String _testNativeVideoAdUnitId = 'ca-app-pub-3940256099942544/1044960115';

  // Production Ad Unit IDs (to be set by user)
  String? _bannerAdUnitId;
  String? _interstitialAdUnitId;
  String? _rewardedAdUnitId;
  String? _rewardedInterstitialAdUnitId;
  String? _appOpenAdUnitId;
  String? _nativeAdUnitId;
  String? _nativeVideoAdUnitId;

  // Test device IDs
  List<String>? _testDeviceIds;
  
  // Whether to use test ads
  bool _isTestMode = true;

  /// Initialize the configuration
  /// [isTestMode] - Set to true for test ads, false for production ads
  /// [testDeviceIds] - List of test device IDs for production testing
  /// [bannerAdUnitId] - Production banner ad unit ID
  /// [interstitialAdUnitId] - Production interstitial ad unit ID
  /// [rewardedAdUnitId] - Production rewarded ad unit ID
  /// [rewardedInterstitialAdUnitId] - Production rewarded interstitial ad unit ID
  /// [appOpenAdUnitId] - Production app open ad unit ID
  /// [nativeAdUnitId] - Production native ad unit ID
  /// [nativeVideoAdUnitId] - Production native video ad unit ID
  static void initialize({
    bool isTestMode = true,
    List<String>? testDeviceIds,
    String? bannerAdUnitId,
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    String? rewardedInterstitialAdUnitId,
    String? appOpenAdUnitId,
    String? nativeAdUnitId,
    String? nativeVideoAdUnitId,
  }) {
    final config = instance;
    config._isTestMode = isTestMode;
    config._testDeviceIds = testDeviceIds;
    config._bannerAdUnitId = bannerAdUnitId;
    config._interstitialAdUnitId = interstitialAdUnitId;
    config._rewardedAdUnitId = rewardedAdUnitId;
    config._rewardedInterstitialAdUnitId = rewardedInterstitialAdUnitId;
    config._appOpenAdUnitId = appOpenAdUnitId;
    config._nativeAdUnitId = nativeAdUnitId;
    config._nativeVideoAdUnitId = nativeVideoAdUnitId;
  }

  /// Get the appropriate ad unit ID based on test mode
  String getBannerAdUnitId() => _isTestMode ? _testBannerAdUnitId : (_bannerAdUnitId ?? _testBannerAdUnitId);
  String getInterstitialAdUnitId() => _isTestMode ? _testInterstitialAdUnitId : (_interstitialAdUnitId ?? _testInterstitialAdUnitId);
  String getRewardedAdUnitId() => _isTestMode ? _testRewardedAdUnitId : (_rewardedAdUnitId ?? _testRewardedAdUnitId);
  String getRewardedInterstitialAdUnitId() => _isTestMode ? _testRewardedInterstitialAdUnitId : (_rewardedInterstitialAdUnitId ?? _testRewardedInterstitialAdUnitId);
  String getAppOpenAdUnitId() => _isTestMode ? _testAppOpenAdUnitId : (_appOpenAdUnitId ?? _testAppOpenAdUnitId);
  String getNativeAdUnitId() => _isTestMode ? _testNativeAdUnitId : (_nativeAdUnitId ?? _testNativeAdUnitId);
  String getNativeVideoAdUnitId() => _isTestMode ? _testNativeVideoAdUnitId : (_nativeVideoAdUnitId ?? _testNativeVideoAdUnitId);

  /// Get test device IDs
  List<String>? getTestDeviceIds() => _testDeviceIds;

  /// Check if in test mode
  bool get isTestMode => _isTestMode;

  /// Switch to production mode
  void switchToProduction() {
    _isTestMode = false;
  }

  /// Switch to test mode
  void switchToTestMode() {
    _isTestMode = true;
  }
}
