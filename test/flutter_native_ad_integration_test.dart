import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';
import 'package:flutter_native_ad/flutter_native_ad_config.dart';
import 'package:flutter_native_ad/flutter_native_ad_logger.dart';

void main() {
  group('FlutterNativeAd Integration Tests', () {
    setUp(() {
      // Initialize config for testing
      FlutterNativeAdConfig.initialize(
        isTestMode: true,
        testDeviceIds: ['test-device-id'],
      );
      FlutterNativeAdLogger.setEnabled(false); // Disable logging for tests
    });

    test('should create FlutterNativeAd instance', () {
      final nativeAd = FlutterNativeAd();
      expect(nativeAd, isA<FlutterNativeAd>());
    });

    test('should handle null callbacks gracefully', () {
      final nativeAd = FlutterNativeAd();

      expect(() => nativeAd.loadNativeBannerAd(
        onAdLoaded: null,
        onAdFailedToLoad: null,
      ), returnsNormally);

      expect(() => nativeAd.loadmediumNativeAd(
        onAdLoaded: null,
        onAdFailedToLoad: null,
      ), returnsNormally);
    });

    test('should use test ad unit IDs in test mode', () {
      FlutterNativeAdConfig.initialize(isTestMode: true);
      final nativeAd = FlutterNativeAd();

      expect(() => nativeAd.loadNativeBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);

      expect(() => nativeAd.loadmediumNativeAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });

    test('should use production ad unit IDs in production mode', () {
      const customAdUnitId = 'ca-app-pub-1234567890123456/1234567890';
      FlutterNativeAdConfig.initialize(
        isTestMode: false,
        nativeAdUnitId: customAdUnitId,
      );
      
      final nativeAd = FlutterNativeAd();

      expect(() => nativeAd.loadNativeBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);

      expect(() => nativeAd.loadmediumNativeAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });

    test('should handle throttling correctly', () {
      final nativeAd = FlutterNativeAd();

      // Multiple calls should not throw
      expect(() => nativeAd.loadNativeBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);

      expect(() => nativeAd.loadNativeBannerAd(
        onAdLoaded: (ad) {},
        onAdFailedToLoad: (ad, error) {},
      ), returnsNormally);
    });
  });
}
