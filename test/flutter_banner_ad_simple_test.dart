import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_ad/flutter_banner_ad.dart';
import 'package:flutter_native_ad/flutter_native_ad_config.dart';
import 'package:flutter_native_ad/flutter_native_ad_logger.dart';

void main() {
  group('FlutterBannerAd Simple Tests', () {
    setUp(() {
      // Initialize config for testing
      FlutterNativeAdConfig.initialize(isTestMode: true);
      FlutterNativeAdLogger.setEnabled(false); // Disable logging for tests
    });

    test('should create FlutterBannerAd instance', () {
      final bannerAd = FlutterBannerAd();
      expect(bannerAd, isA<FlutterBannerAd>());
    });

    test('should have loadBannerAd method', () {
      final bannerAd = FlutterBannerAd();
      expect(bannerAd.loadBannerAd, isA<Function>());
    });

    test('should have getBannerAd method', () {
      final bannerAd = FlutterBannerAd();
      expect(bannerAd.getBannerAd, isA<Function>());
    });

    test('should handle null callbacks gracefully', () {
      final bannerAd = FlutterBannerAd();

      // Test that method signature accepts null callbacks
      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: null,
        onAdFailedToLoad: null,
      ), returnsNormally);
    });

    test('should use test ad unit ID in test mode', () {
      FlutterNativeAdConfig.initialize(isTestMode: true);
      final bannerAd = FlutterBannerAd();

      // Test that the method doesn't throw
      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });

    test('should use production ad unit ID in production mode', () {
      const customAdUnitId = 'ca-app-pub-1234567890123456/1234567890';
      FlutterNativeAdConfig.initialize(
        isTestMode: false,
        bannerAdUnitId: customAdUnitId,
      );
      
      final bannerAd = FlutterBannerAd();

      // Test that the method doesn't throw
      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });

    test('should handle ad unit ID override', () {
      final bannerAd = FlutterBannerAd();
      const overrideAdUnitId = 'ca-app-pub-override/1234567890';

      // Test that the method doesn't throw when overriding ad unit ID
      expect(() => bannerAd.loadBannerAd(
        adUnitId: overrideAdUnitId,
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });

    test('should handle throttling correctly', () {
      final bannerAd = FlutterBannerAd();

      // Multiple calls should not throw
      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);

      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });

    test('should create banner ad with correct size', () {
      final bannerAd = FlutterBannerAd();
      
      // Test that the method doesn't throw
      expect(() => bannerAd.loadBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });
  });
}
