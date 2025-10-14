import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_ad/flutter_native_ad_logger.dart';

void main() {
  group('FlutterNativeAdLogger Tests', () {
    setUp(() {
      // Reset logger state before each test
      FlutterNativeAdLogger.setEnabled(true);
      FlutterNativeAdLogger.setDebugMode(true);
    });

    tearDown(() {
      // Reset logger state after each test
      FlutterNativeAdLogger.setEnabled(true);
      FlutterNativeAdLogger.setDebugMode(true);
    });

    test('should be enabled by default in debug mode', () {
      expect(FlutterNativeAdLogger.isEnabled, true);
    });

    test('should disable logging when setEnabled(false)', () {
      FlutterNativeAdLogger.setEnabled(false);
      expect(FlutterNativeAdLogger.isEnabled, false);
    });

    test('should disable logging when setDebugMode(false)', () {
      FlutterNativeAdLogger.setDebugMode(false);
      expect(FlutterNativeAdLogger.isEnabled, false);
    });

    test('should enable logging when both enabled and debug mode are true', () {
      FlutterNativeAdLogger.setEnabled(true);
      FlutterNativeAdLogger.setDebugMode(true);
      expect(FlutterNativeAdLogger.isEnabled, true);
    });

    test('should disable logging when either enabled or debug mode is false', () {
      FlutterNativeAdLogger.setEnabled(true);
      FlutterNativeAdLogger.setDebugMode(false);
      expect(FlutterNativeAdLogger.isEnabled, false);

      FlutterNativeAdLogger.setEnabled(false);
      FlutterNativeAdLogger.setDebugMode(true);
      expect(FlutterNativeAdLogger.isEnabled, false);
    });

    group('Logging Methods', () {
      test('init should log when enabled', () {
        // This test verifies the method doesn't throw
        expect(() => FlutterNativeAdLogger.init('Test message'), returnsNormally);
      });

      test('config should log when enabled', () {
        expect(() => FlutterNativeAdLogger.config('Test message'), returnsNormally);
      });

      test('success should log when enabled', () {
        expect(() => FlutterNativeAdLogger.success('Test message'), returnsNormally);
      });

      test('error should log when enabled', () {
        expect(() => FlutterNativeAdLogger.error('Test message'), returnsNormally);
      });

      test('warning should log when enabled', () {
        expect(() => FlutterNativeAdLogger.warning('Test message'), returnsNormally);
      });

      test('info should log when enabled', () {
        expect(() => FlutterNativeAdLogger.info('Test message'), returnsNormally);
      });

      test('debug should log when enabled', () {
        expect(() => FlutterNativeAdLogger.debug('Test message'), returnsNormally);
      });

      test('banner should log when enabled', () {
        expect(() => FlutterNativeAdLogger.banner('Test message'), returnsNormally);
      });

      test('interstitial should log when enabled', () {
        expect(() => FlutterNativeAdLogger.interstitial('Test message'), returnsNormally);
      });

      test('rewarded should log when enabled', () {
        expect(() => FlutterNativeAdLogger.rewarded('Test message'), returnsNormally);
      });

      test('appOpen should log when enabled', () {
        expect(() => FlutterNativeAdLogger.appOpen('Test message'), returnsNormally);
      });

      test('native should log when enabled', () {
        expect(() => FlutterNativeAdLogger.native('Test message'), returnsNormally);
      });

      test('screen should log when enabled', () {
        expect(() => FlutterNativeAdLogger.screen('Test message'), returnsNormally);
      });

      test('throttling should log when enabled', () {
        expect(() => FlutterNativeAdLogger.throttling('Test message'), returnsNormally);
      });

      test('tip should log when enabled', () {
        expect(() => FlutterNativeAdLogger.tip('Test message'), returnsNormally);
      });
    });

    group('Disabled Logging', () {
      setUp(() {
        FlutterNativeAdLogger.setEnabled(false);
      });

      test('all logging methods should not throw when disabled', () {
        expect(() => FlutterNativeAdLogger.init('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.config('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.success('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.error('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.warning('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.info('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.debug('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.banner('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.interstitial('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.rewarded('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.appOpen('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.native('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.screen('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.throttling('Test'), returnsNormally);
        expect(() => FlutterNativeAdLogger.tip('Test'), returnsNormally);
      });
    });
  });
}
