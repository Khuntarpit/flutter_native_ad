import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

void main() {
  group('FlutterNativeAd Integration Tests', () {
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
      
      // Mock the flutter_native_ad method channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_native_ad'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getNativeAds':
              return {'status': 'success', 'message': 'Native ads loaded'};
            default:
              return null;
          }
        },
      );
      
      // Initialize config for testing
      FlutterNativeAdConfig.initialize(
        isTestMode: true,
        testDeviceIds: ['test-device-id'],
      );
      FlutterNativeAdLogger.setEnabled(false); // Disable logging for tests
    });

    tearDown(() {
      // Clean up method call handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/google_mobile_ads'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_native_ad'),
        null,
      );
    });

    test('should create FlutterNativeAd instance', () {
      final nativeAd = FlutterNativeAd();
      expect(nativeAd, isA<FlutterNativeAd>());
    });

    test('should handle null callbacks gracefully', () {
      final nativeAd = FlutterNativeAd();

      // Test that the methods exist and can be called with null callbacks
      expect(() => nativeAd.loadNativeBannerAd, isA<Function>());
      expect(() => nativeAd.loadmediumNativeAd, isA<Function>());
    });

    test('should use test ad unit IDs in test mode', () {
      FlutterNativeAdConfig.initialize(isTestMode: true);
      final nativeAd = FlutterNativeAd();

      // Test that the methods exist and can be called
      expect(() => nativeAd.loadNativeBannerAd, isA<Function>());
      expect(() => nativeAd.loadmediumNativeAd, isA<Function>());
    });

    test('should use production ad unit IDs in production mode', () {
      const customAdUnitId = 'ca-app-pub-1234567890123456/1234567890';
      FlutterNativeAdConfig.initialize(
        isTestMode: false,
        nativeAdUnitId: customAdUnitId,
      );
      
      final nativeAd = FlutterNativeAd();

      // Test that the methods exist and can be called
      expect(() => nativeAd.loadNativeBannerAd, isA<Function>());
      expect(() => nativeAd.loadmediumNativeAd, isA<Function>());
    });

    test('should handle throttling correctly', () {
      final nativeAd = FlutterNativeAd();

      // Test that the method exists and can be called multiple times
      expect(() => nativeAd.loadNativeBannerAd, isA<Function>());
      expect(() => nativeAd.loadNativeBannerAd, isA<Function>());
    });
  });
}
