import 'package:flutter_test/flutter_test.dart';
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
    // TODO: implement getNativeAd
    throw UnimplementedError();
  }
}

void main() {
  final FlutterNativeAdPlatform initialPlatform =
      FlutterNativeAdPlatform.instance;

  test('$MethodChannelFlutterNativeAd is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNativeAd>());
  });

  test('getPlatformVersion', () async {
    // FlutterNativeAd flutterNativeAdPlugin = FlutterNativeAd();
    MockFlutterNativeAdPlatform fakePlatform = MockFlutterNativeAdPlatform();
    FlutterNativeAdPlatform.instance = fakePlatform;

    // expect(await flutterNativeAdPlugin.getPlatformVersion(), '42');
  });
}
