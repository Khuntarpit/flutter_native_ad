import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_native_ad_method_channel.dart';

abstract class FlutterNativeAdPlatform extends PlatformInterface {
  /// Constructs a FlutterNativeAdPlatform.
  FlutterNativeAdPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNativeAdPlatform _instance = MethodChannelFlutterNativeAd();

  /// The default instance of [FlutterNativeAdPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNativeAd].
  static FlutterNativeAdPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNativeAdPlatform] when
  /// they register themselves.
  static set instance(FlutterNativeAdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getNativeAd() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
