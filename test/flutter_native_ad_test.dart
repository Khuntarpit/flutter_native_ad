import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_ad/flutter_native_ad_platform_interface.dart';
import 'package:flutter_native_ad/flutter_native_ad_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNativeAdPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNativeAdPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getNativeAd() {
    return Future.value('mock-native-ad');
  }
}

void main() {
  group('FlutterNativeAd Platform Tests', () {
    final FlutterNativeAdPlatform initialPlatform =
        FlutterNativeAdPlatform.instance;

    test('$MethodChannelFlutterNativeAd is the default instance', () {
      expect(initialPlatform, isInstanceOf<MethodChannelFlutterNativeAd>());
    });

    test('getPlatformVersion returns correct version', () async {
      MockFlutterNativeAdPlatform fakePlatform = MockFlutterNativeAdPlatform();
      FlutterNativeAdPlatform.instance = fakePlatform;

      expect(await fakePlatform.getPlatformVersion(), '42');
    });

    test('getNativeAd returns mock ad', () async {
      MockFlutterNativeAdPlatform fakePlatform = MockFlutterNativeAdPlatform();
      FlutterNativeAdPlatform.instance = fakePlatform;

      expect(await fakePlatform.getNativeAd(), 'mock-native-ad');
    });

    test('platform interface is properly implemented', () {
      MockFlutterNativeAdPlatform fakePlatform = MockFlutterNativeAdPlatform();
      expect(fakePlatform, isA<FlutterNativeAdPlatform>());
    });
  });

  group('Method Channel Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      // Mock the method channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_native_ad'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getPlatformVersion':
              return '42';
            case 'getNativeAds':
              return 'mock-native-ad';
            default:
              return null;
          }
        },
      );
    });

    tearDown(() {
      // Clean up method call handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter_native_ad'),
        null,
      );
    });

    test('MethodChannelFlutterNativeAd can be instantiated', () {
      final platform = MethodChannelFlutterNativeAd();
      expect(platform, isA<MethodChannelFlutterNativeAd>());
    });

    test('getPlatformVersion returns string', () async {
      final platform = MethodChannelFlutterNativeAd();
      final result = await platform.getPlatformVersion();
      expect(result, isA<String>());
    });

    test('getNativeAd returns string', () async {
      final platform = MethodChannelFlutterNativeAd();
      final result = await platform.getNativeAd();
      expect(result, isA<String>());
    });
  });
}
