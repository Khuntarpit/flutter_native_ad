import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_ad/flutter_native_ad_method_channel.dart';

void main() {
  MethodChannelFlutterNativeAd platform = MethodChannelFlutterNativeAd();
  const MethodChannel channel = MethodChannel('flutter_native_ad');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
