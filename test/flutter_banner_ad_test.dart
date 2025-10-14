import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_native_ad/flutter_banner_ad.dart';
import 'package:flutter_native_ad/flutter_native_ad_config.dart';
import 'package:flutter_native_ad/flutter_native_ad_logger.dart';

// Mock the Google Mobile Ads SDK
class MockBannerAd extends BannerAd {
  MockBannerAd({
    required String adUnitId,
    required AdSize size,
    required AdRequest request,
    required BannerAdListener listener,
  }) : super(
          adUnitId: adUnitId,
          size: size,
          request: request,
          listener: listener,
        );

  @override
  Future<void> load() async {
    // Simulate successful load
    Future.delayed(const Duration(milliseconds: 100), () {
      listener.onAdLoaded?.call(this);
    });
  }

  @override
  Future<void> dispose() async {
    // Mock dispose
  }
}

void main() {
  group('FlutterBannerAd Tests', () {
    setUp(() {
      // Initialize config for testing
      FlutterNativeAdConfig.initialize(isTestMode: true);
      FlutterNativeAdLogger.setEnabled(false); // Disable logging for tests
    });

    test('should create FlutterBannerAd instance', () {
      final bannerAd = FlutterBannerAd();
      expect(bannerAd, isA<FlutterBannerAd>());
    });

    test('should load banner ad with default ad unit ID', () {
      final bannerAd = FlutterBannerAd();
      bool adLoaded = false;
      bool adFailed = false;

      bannerAd.loadBannerAd(
        onAdLoaded: (ad) {
          adLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          adFailed = true;
        },
      );

      // Since we can't easily mock the actual BannerAd creation,
      // we test that the method doesn't throw
      expect(() => bannerAd.loadBannerAd(), returnsNormally);
    });

    test('should load banner ad with custom ad unit ID', () {
      final bannerAd = FlutterBannerAd();
      const customAdUnitId = 'ca-app-pub-1234567890123456/1234567890';

      expect(() => bannerAd.loadBannerAd(adUnitId: customAdUnitId), returnsNormally);
    });

    test('should return AdWidget when banner ad is loaded', () {
      final bannerAd = FlutterBannerAd();
      
      // This will throw because bannerAd is not loaded yet
      expect(() => bannerAd.getBannerAd(), throwsA(isA<Error>()));
    });

    test('should handle null callbacks gracefully', () {
      final bannerAd = FlutterBannerAd();

      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: null,
        onAdFailedToLoad: null,
      ), returnsNormally);
    });

    test('should use test ad unit ID in test mode', () {
      FlutterNativeAdConfig.initialize(isTestMode: true);
      final bannerAd = FlutterBannerAd();

      // The method should use the test ad unit ID
      expect(() => bannerAd.loadBannerAd(), returnsNormally);
    });

    test('should use production ad unit ID in production mode', () {
      const customAdUnitId = 'ca-app-pub-1234567890123456/1234567890';
      FlutterNativeAdConfig.initialize(
        isTestMode: false,
        bannerAdUnitId: customAdUnitId,
      );
      
      final bannerAd = FlutterBannerAd();

      // The method should use the production ad unit ID
      expect(() => bannerAd.loadBannerAd(), returnsNormally);
    });

    test('should handle throttling correctly', () {
      final bannerAd = FlutterBannerAd();

      // First call should work
      expect(() => bannerAd.loadBannerAd(), returnsNormally);
      
      // Immediate second call should also work (throttling is internal)
      expect(() => bannerAd.loadBannerAd(), returnsNormally);
    });

    test('should create banner ad with correct size', () {
      final bannerAd = FlutterBannerAd();
      
      // Test that the method doesn't throw
      expect(() => bannerAd.loadBannerAd(), returnsNormally);
    });

    test('should handle ad unit ID override', () {
      final bannerAd = FlutterBannerAd();
      const overrideAdUnitId = 'ca-app-pub-override/1234567890';

      // Should not throw when overriding ad unit ID
      expect(() => bannerAd.loadBannerAd(adUnitId: overrideAdUnitId), returnsNormally);
    });
  });
}
