import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_ad/flutter_native_ad_method_channel.dart';

void main() {
  group('MethodChannelFlutterNativeAd Tests', () {
    MethodChannelFlutterNativeAd platform = MethodChannelFlutterNativeAd();
    const MethodChannel channel = MethodChannel('flutter_native_ad');

    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';
          case 'getNativeAds':
            return 'Native ads loaded successfully';
          default:
            throw PlatformException(
              code: 'UNIMPLEMENTED',
              message: 'Method not implemented',
            );
        }
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel,null);
    });

    test('getPlatformVersion returns correct version', () async {
      expect(await platform.getPlatformVersion(), '42');
    });

    test('getNativeAd returns success response', () async {
      final result = await platform.getNativeAd();
      expect(result, isA<String>());
    });

    test('handles platform exceptions gracefully', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        throw PlatformException(
          code: 'TEST_ERROR',
          message: 'Test error message',
        );
      });

      expect(() async => await platform.getPlatformVersion(), 
          throwsA(isA<PlatformException>()));
    });

    test('handles null responses', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        return null;
      });

      expect(await platform.getPlatformVersion(), isNull);
    });

    test('handles different method calls', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getPlatformVersion') {
          return 'Android 13';
        } else if (methodCall.method == 'getNativeAds') {
          return 'Multiple ads loaded';
        }
        return null;
      });

      expect(await platform.getPlatformVersion(), 'Android 13');
    });
  });
}
