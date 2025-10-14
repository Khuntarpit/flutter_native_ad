import 'package:flutter/foundation.dart';
import 'package:flutter_native_ad/flutter_native_ad.dart';

/// Production configuration example
/// This shows how to disable logging for production builds
class ProductionConfig {
  static void configureForProduction() {
    // Disable logging for production builds
    FlutterNativeAdLogger.setEnabled(false);
    FlutterNativeAdLogger.setDebugMode(false);
    
    // Switch to production mode
    FlutterNativeAdConfig.instance.switchToProduction();
  }
  
  static void configureForDebug() {
    // Enable logging for debug builds
    FlutterNativeAdLogger.setEnabled(true);
    FlutterNativeAdLogger.setDebugMode(kDebugMode);
    
    // Switch to test mode
    FlutterNativeAdConfig.instance.switchToTestMode();
  }
  
  static void configureForTesting() {
    // Enable logging but use test ads
    FlutterNativeAdLogger.setEnabled(true);
    FlutterNativeAdLogger.setDebugMode(true);
    
    // Keep in test mode
    FlutterNativeAdConfig.instance.switchToTestMode();
  }
}
