
/// Ad request throttler to prevent rate limiting
class AdRequestThrottler {
  static final Map<String, DateTime> _lastRequestTimes = {};
  static final Map<String, int> _failureCounts = {};
  static const int _minIntervalSeconds = 3; // Minimum 3 seconds between requests
  static const int _maxFailures = 3; // Max failures before longer delay
  static const int _extendedDelaySeconds = 30; // Extended delay after max failures

  /// Check if enough time has passed since last request for this ad unit
  static bool canMakeRequest(String adUnitId) {
    final now = DateTime.now();
    final lastRequest = _lastRequestTimes[adUnitId];
    final failureCount = _failureCounts[adUnitId] ?? 0;

    if (lastRequest == null) {
      return true;
    }

    final timeSinceLastRequest = now.difference(lastRequest).inSeconds;
    
    // If we've had too many failures, wait longer
    if (failureCount >= _maxFailures) {
      return timeSinceLastRequest >= _extendedDelaySeconds;
    }
    
    // Otherwise, use normal interval
    return timeSinceLastRequest >= _minIntervalSeconds;
  }

  /// Record a request attempt
  static void recordRequest(String adUnitId) {
    _lastRequestTimes[adUnitId] = DateTime.now();
  }

  /// Record a failed request
  static void recordFailure(String adUnitId) {
    _failureCounts[adUnitId] = (_failureCounts[adUnitId] ?? 0) + 1;
  }

  /// Record a successful request (reset failure count)
  static void recordSuccess(String adUnitId) {
    _failureCounts[adUnitId] = 0;
  }

  /// Get time until next request is allowed
  static int getTimeUntilNextRequest(String adUnitId) {
    final now = DateTime.now();
    final lastRequest = _lastRequestTimes[adUnitId];
    final failureCount = _failureCounts[adUnitId] ?? 0;

    if (lastRequest == null) {
      return 0;
    }

    final timeSinceLastRequest = now.difference(lastRequest).inSeconds;
    final requiredDelay = failureCount >= _maxFailures 
        ? _extendedDelaySeconds 
        : _minIntervalSeconds;

    return (requiredDelay - timeSinceLastRequest).clamp(0, requiredDelay);
  }

  /// Reset throttling for an ad unit
  static void reset(String adUnitId) {
    _lastRequestTimes.remove(adUnitId);
    _failureCounts.remove(adUnitId);
  }

  /// Reset all throttling
  static void resetAll() {
    _lastRequestTimes.clear();
    _failureCounts.clear();
  }
}
