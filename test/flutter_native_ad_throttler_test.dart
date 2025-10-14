import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_native_ad/flutter_native_ad_throttler.dart';

void main() {
  group('AdRequestThrottler Tests', () {
    setUp(() {
      // Reset throttler state before each test
      AdRequestThrottler.resetAll();
    });

    test('should allow first request immediately', () {
      const adUnitId = 'test-ad-unit-id';
      expect(AdRequestThrottler.canMakeRequest(adUnitId), true);
    });

    test('should throttle subsequent requests within minimum interval', () {
      const adUnitId = 'test-ad-unit-id';
      
      // First request should be allowed
      expect(AdRequestThrottler.canMakeRequest(adUnitId), true);
      AdRequestThrottler.recordRequest(adUnitId);
      
      // Immediate second request should be throttled
      expect(AdRequestThrottler.canMakeRequest(adUnitId), false);
    });

    test('should allow request after minimum interval', () async {
      const adUnitId = 'test-ad-unit-id';
      
      // First request
      AdRequestThrottler.recordRequest(adUnitId);
      expect(AdRequestThrottler.canMakeRequest(adUnitId), false);
      
      // Wait for minimum interval (3 seconds)
      await Future.delayed(const Duration(seconds: 4));
      
      // Should be allowed now
      expect(AdRequestThrottler.canMakeRequest(adUnitId), true);
    });

    test('should track failures and increase delay', () {
      const adUnitId = 'test-ad-unit-id';
      
      // Record multiple failures
      AdRequestThrottler.recordFailure(adUnitId);
      AdRequestThrottler.recordFailure(adUnitId);
      AdRequestThrottler.recordFailure(adUnitId);
      
      // Should now require extended delay (but only if a request was made)
      AdRequestThrottler.recordRequest(adUnitId);
      expect(AdRequestThrottler.getTimeUntilNextRequest(adUnitId), 30);
    });

    test('should reset failure count on success', () {
      const adUnitId = 'test-ad-unit-id';
      
      // Record failures
      AdRequestThrottler.recordFailure(adUnitId);
      AdRequestThrottler.recordFailure(adUnitId);
      AdRequestThrottler.recordFailure(adUnitId);
      
      // Record success
      AdRequestThrottler.recordSuccess(adUnitId);
      
      // Should reset to normal interval
      expect(AdRequestThrottler.getTimeUntilNextRequest(adUnitId), 0);
    });

    test('should track different ad unit IDs independently', () {
      const adUnitId1 = 'test-ad-unit-id-1';
      const adUnitId2 = 'test-ad-unit-id-2';
      
      // Record request for first ad unit
      AdRequestThrottler.recordRequest(adUnitId1);
      expect(AdRequestThrottler.canMakeRequest(adUnitId1), false);
      
      // Second ad unit should still be allowed
      expect(AdRequestThrottler.canMakeRequest(adUnitId2), true);
    });

    test('should return correct time until next request', () {
      const adUnitId = 'test-ad-unit-id';
      
      // No previous request
      expect(AdRequestThrottler.getTimeUntilNextRequest(adUnitId), 0);
      
      // Record request
      AdRequestThrottler.recordRequest(adUnitId);
      
      // Should return time remaining (should be 3 seconds)
      final timeRemaining = AdRequestThrottler.getTimeUntilNextRequest(adUnitId);
      expect(timeRemaining, greaterThan(0));
      expect(timeRemaining, lessThanOrEqualTo(3));
    });

    test('should handle extended delay after multiple failures', () {
      const adUnitId = 'test-ad-unit-id';
      
      // Record multiple failures to trigger extended delay
      for (int i = 0; i < 5; i++) {
        AdRequestThrottler.recordFailure(adUnitId);
      }
      
      // Record a request to trigger the extended delay
      AdRequestThrottler.recordRequest(adUnitId);
      
      // Should require extended delay
      expect(AdRequestThrottler.getTimeUntilNextRequest(adUnitId), 30);
    });

    test('should reset all state', () {
      const adUnitId1 = 'test-ad-unit-id-1';
      const adUnitId2 = 'test-ad-unit-id-2';
      
      // Record requests and failures
      AdRequestThrottler.recordRequest(adUnitId1);
      AdRequestThrottler.recordFailure(adUnitId2);
      AdRequestThrottler.recordFailure(adUnitId2);
      
      // Reset all
      AdRequestThrottler.resetAll();
      
      // Both should be allowed now
      expect(AdRequestThrottler.canMakeRequest(adUnitId1), true);
      expect(AdRequestThrottler.canMakeRequest(adUnitId2), true);
      expect(AdRequestThrottler.getTimeUntilNextRequest(adUnitId1), 0);
      expect(AdRequestThrottler.getTimeUntilNextRequest(adUnitId2), 0);
    });

    test('should handle success after throttling', () {
      const adUnitId = 'test-ad-unit-id';
      
      // Record request
      AdRequestThrottler.recordRequest(adUnitId);
      expect(AdRequestThrottler.canMakeRequest(adUnitId), false);
      
      // Record success (this resets failure count but doesn't clear throttling)
      AdRequestThrottler.recordSuccess(adUnitId);
      
      // Should still be throttled until time passes
      expect(AdRequestThrottler.canMakeRequest(adUnitId), false);
    });

    test('should handle failure after throttling', () {
      const adUnitId = 'test-ad-unit-id';
      
      // Record request
      AdRequestThrottler.recordRequest(adUnitId);
      expect(AdRequestThrottler.canMakeRequest(adUnitId), false);
      
      // Record failure
      AdRequestThrottler.recordFailure(adUnitId);
      
      // Should still be throttled
      expect(AdRequestThrottler.canMakeRequest(adUnitId), false);
    });
  });
}
