import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_native_ad_platform_interface.dart';

/// An implementation of [FlutterNativeAdPlatform] that uses method channels.
class MethodChannelFlutterNativeAd extends FlutterNativeAdPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_native_ad');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future getNativeAds() async {
    await methodChannel.invokeMethod<String>('getNativeAds');
  }
}
