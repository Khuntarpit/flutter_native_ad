import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Logger class for Flutter Native Ad plugin
/// Provides controlled logging that can be enabled/disabled
class FlutterNativeAdLogger {
  static bool _isDebugMode = kDebugMode; // Default to debug mode in debug builds
  static bool _isEnabled = true; // Can be manually controlled
  
  /// Enable or disable logging
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }
  
  /// Check if logging is enabled
  static bool get isEnabled => _isEnabled && _isDebugMode;
  
  /// Set debug mode (useful for production builds)
  static void setDebugMode(bool debugMode) {
    _isDebugMode = debugMode;
  }
  
  /// Log initialization messages
  static void init(String message) {
    if (isEnabled) {
      log('🚀 [AD INIT] $message');
    }
  }
  
  /// Log configuration messages
  static void config(String message) {
    if (isEnabled) {
      log('⚙️ [AD CONFIG] $message');
    }
  }
  
  /// Log success messages
  static void success(String message) {
    if (isEnabled) {
      log('✅ [AD SUCCESS] $message');
    }
  }
  
  /// Log error messages
  static void error(String message) {
    if (isEnabled) {
      log('❌ [AD ERROR] $message');
    }
  }
  
  /// Log warning messages
  static void warning(String message) {
    if (isEnabled) {
      log('⚠️ [AD WARNING] $message');
    }
  }
  
  /// Log info messages
  static void info(String message) {
    if (isEnabled) {
      log('ℹ️ [AD INFO] $message');
    }
  }
  
  /// Log debug messages
  static void debug(String message) {
    if (isEnabled) {
      log('🔍 [AD DEBUG] $message');
    }
  }
  
  /// Log banner ad messages
  static void banner(String message) {
    if (isEnabled) {
      log('📢 [BANNER AD] $message');
    }
  }
  
  /// Log interstitial ad messages
  static void interstitial(String message) {
    if (isEnabled) {
      log('📱 [INTERSTITIAL AD] $message');
    }
  }
  
  /// Log rewarded ad messages
  static void rewarded(String message) {
    if (isEnabled) {
      log('🎯 [REWARDED AD] $message');
    }
  }
  
  /// Log app open ad messages
  static void appOpen(String message) {
    if (isEnabled) {
      log('🚪 [APP OPEN AD] $message');
    }
  }
  
  /// Log native ad messages
  static void native(String message) {
    if (isEnabled) {
      log('📱 [NATIVE AD] $message');
    }
  }
  
  /// Log screen messages
  static void screen(String message) {
    if (isEnabled) {
      log('🏠 [SCREEN] $message');
    }
  }
  
  /// Log throttling messages
  static void throttling(String message) {
    if (isEnabled) {
      log('⏳ [THROTTLING] $message');
    }
  }
  
  /// Log helpful tips
  static void tip(String message) {
    if (isEnabled) {
      log('💡 [TIP] $message');
    }
  }
}
