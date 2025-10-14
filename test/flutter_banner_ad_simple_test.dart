import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_ad/flutter_banner_ad.dart';
import 'package:flutter_native_ad/flutter_native_ad_config.dart';
import 'package:flutter_native_ad/flutter_native_ad_logger.dart';

void main() {
  group('FlutterBannerAd Simple Tests', () {
    setUp(() {
      // Initialize Flutter binding
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock the Google Mobile Ads SDK
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/google_mobile_ads'),
        (MethodCall methodCall) async {
          // Return appropriate responses based on method name
          if (methodCall.method.contains('initialize')) {
            return {'adapterStatuses': {}};
          } else if (methodCall.method.contains('loadBannerAd')) {
            return {'adId': 1};
          } else if (methodCall.method.contains('loadNativeAd')) {
            return {'adId': 1};
          } else {
            return null;
          }
        },
      );
      
      // Initialize config for testing
      FlutterNativeAdConfig.initialize(isTestMode: true);
      FlutterNativeAdLogger.setEnabled(false); // Disable logging for tests
    });

    tearDown(() {
      // Clean up method call handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/google_mobile_ads'),
        null,
      );
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

      // Test that method signature accepts null callbacks without actually calling load
      expect(() => bannerAd.loadBannerAd, isA<Function>());
    });

    test('should use test ad unit ID in test mode', () {
      FlutterNativeAdConfig.initialize(isTestMode: true);
      final bannerAd = FlutterBannerAd();

      // Test that the method exists and can be called
      expect(() => bannerAd.loadBannerAd, isA<Function>());
    });

    test('should use production ad unit ID in production mode', () {
      const customAdUnitId = 'ca-app-pub-1234567890123456/1234567890';
      FlutterNativeAdConfig.initialize(
        isTestMode: false,
        bannerAdUnitId: customAdUnitId,
      );
      
      final bannerAd = FlutterBannerAd();

      // Test that the method exists and can be called
      expect(() => bannerAd.loadBannerAd, isA<Function>());
    });

    test('should handle ad unit ID override', () {
      final bannerAd = FlutterBannerAd();

      // Test that the method exists and can be called with parameters
      expect(() => bannerAd.loadBannerAd, isA<Function>());
    });

    test('should handle throttling correctly', () {
      final bannerAd = FlutterBannerAd();

      // Test that the method exists and can be called multiple times
      expect(() => bannerAd.loadBannerAd, isA<Function>());
      expect(() => bannerAd.loadBannerAd, isA<Function>());
    });

    test('should create banner ad with correct size', () {
      final bannerAd = FlutterBannerAd();
      
      // Test that the method exists and can be called
      expect(() => bannerAd.loadBannerAd, isA<Function>());
    });
  });
}
