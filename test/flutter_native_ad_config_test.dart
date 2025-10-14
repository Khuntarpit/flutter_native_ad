import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_ad/flutter_native_ad_config.dart';

void main() {
  group('FlutterNativeAdConfig Tests', () {
    setUp(() {
      // Reset config before each test
      FlutterNativeAdConfig.initialize(
        isTestMode: true,
        testDeviceIds: null,
      );
    });

    test('should be singleton', () {
      final instance1 = FlutterNativeAdConfig.instance;
      final instance2 = FlutterNativeAdConfig.instance;
      expect(instance1, same(instance2));
    });

    test('should initialize with test mode by default', () {
      expect(FlutterNativeAdConfig.instance.isTestMode, true);
    });

    test('should initialize with production mode when specified', () {
      FlutterNativeAdConfig.initialize(isTestMode: false);
      expect(FlutterNativeAdConfig.instance.isTestMode, false);
    });

    test('should return test ad unit IDs in test mode', () {
      expect(FlutterNativeAdConfig.instance.getBannerAdUnitId(), 
          'ca-app-pub-3940256099942544/6300978111');
      expect(FlutterNativeAdConfig.instance.getInterstitialAdUnitId(), 
          'ca-app-pub-3940256099942544/1033173712');
      expect(FlutterNativeAdConfig.instance.getRewardedAdUnitId(), 
          'ca-app-pub-3940256099942544/5224354917');
      expect(FlutterNativeAdConfig.instance.getRewardedInterstitialAdUnitId(), 
          'ca-app-pub-3940256099942544/5354046379');
      expect(FlutterNativeAdConfig.instance.getAppOpenAdUnitId(), 
          'ca-app-pub-3940256099942544/9257395921');
      expect(FlutterNativeAdConfig.instance.getNativeAdUnitId(), 
          'ca-app-pub-3940256099942544/2247696110');
      expect(FlutterNativeAdConfig.instance.getNativeVideoAdUnitId(), 
          'ca-app-pub-3940256099942544/1044960115');
    });

    test('should return production ad unit IDs when set', () {
      const customBannerId = 'ca-app-pub-1234567890123456/1234567890';
      const customInterstitialId = 'ca-app-pub-1234567890123456/0987654321';
      
      FlutterNativeAdConfig.initialize(
        isTestMode: false,
        bannerAdUnitId: customBannerId,
        interstitialAdUnitId: customInterstitialId,
      );

      expect(FlutterNativeAdConfig.instance.getBannerAdUnitId(), customBannerId);
      expect(FlutterNativeAdConfig.instance.getInterstitialAdUnitId(), customInterstitialId);
    });

    test('should fallback to test IDs when production IDs not set', () {
      FlutterNativeAdConfig.initialize(isTestMode: false);
      
      expect(FlutterNativeAdConfig.instance.getBannerAdUnitId(), 
          'ca-app-pub-3940256099942544/6300978111');
      expect(FlutterNativeAdConfig.instance.getInterstitialAdUnitId(), 
          'ca-app-pub-3940256099942544/1033173712');
    });

    test('should store and return test device IDs', () {
      const testDeviceIds = ['device1', 'device2', 'device3'];
      
      FlutterNativeAdConfig.initialize(testDeviceIds: testDeviceIds);
      
      expect(FlutterNativeAdConfig.instance.getTestDeviceIds(), testDeviceIds);
    });

    test('should switch to production mode', () {
      FlutterNativeAdConfig.instance.switchToProduction();
      expect(FlutterNativeAdConfig.instance.isTestMode, false);
    });

    test('should switch to test mode', () {
      FlutterNativeAdConfig.initialize(isTestMode: false);
      FlutterNativeAdConfig.instance.switchToTestMode();
      expect(FlutterNativeAdConfig.instance.isTestMode, true);
    });

    test('should handle null test device IDs', () {
      FlutterNativeAdConfig.initialize(testDeviceIds: null);
      expect(FlutterNativeAdConfig.instance.getTestDeviceIds(), null);
    });

    test('should handle empty test device IDs list', () {
      FlutterNativeAdConfig.initialize(testDeviceIds: []);
      expect(FlutterNativeAdConfig.instance.getTestDeviceIds(), []);
    });
  });
}
