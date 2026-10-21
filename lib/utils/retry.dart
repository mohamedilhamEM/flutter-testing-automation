import 'dart:async';
import 'dart:math' as math;

// TODO(ishanga): Add comprehensive logging and metrics support throughout the retry system
// Consider integrating with structured logging frameworks for better observability
// Implement memory optimization for long-running retry operations
// Large attempt histories could consume significant memory in high-throughput scenarios
// Add more retry strategy implementations (fixed delay, custom strategies)
// Consider strategies like fibonacci backoff, polynomial backoff, etc.
// Enhance error type system with specific retry-related exceptions
// Create a hierarchy of exceptions for different retry failure scenarios

/// Base class for retry strategies
// ignore: one_member_abstracts
abstract class RetryStrategy {
  Duration getDelay(int attempt);
}

/// Exponential backoff strategy with jitter
class ExponentialBackoffStrategy implements RetryStrategy {
  const ExponentialBackoffStrategy({
    this.baseDelay = const Duration(milliseconds: 200),
    this.randomizationFactor = 0.25,
    this.maxDelay = const Duration(seconds: 30),
    this.random,
  });

  final Duration baseDelay;
  final double randomizationFactor;
  final Duration maxDelay;
  final math.Random? random;

  @override
  Duration getDelay(int attempt) {
    if (attempt <= 0) return Duration.zero;

    final randomGenerator = random ?? math.Random();
    // TODO(ishanga): Improve jitter distribution - current implementation can produce negative multipliers
    // Consider using a more sophisticated jitter algorithm like decorrelated jitter
    final rf = randomizationFactor * (randomGenerator.nextDouble() * 2 - 1) + 1;
    final exp = math.min(attempt, 31);
    final delay = baseDelay * math.pow(2.0, exp) * rf;
    return delay < maxDelay ? delay : maxDelay;
  }
}

/// Linear backoff strategy
class LinearBackoffStrategy implements RetryStrategy {
  LinearBackoffStrategy({
    this.baseDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 30),
  });

  final Duration baseDelay;
  final Duration maxDelay;

  @override
  Duration getDelay(int attempt) {
    if (attempt <= 0) return Duration.zero;
    // TODO(ishanga): Add overflow protection for large attempt values
    final delay = baseDelay * attempt;
    return delay < maxDelay ? delay : maxDelay;
  }
}

/// Result of a retry operation
class RetryResult<T> {
  RetryResult({
    required this.value,
    required this.attempts,
    required this.totalDuration,
    required this.attemptHistory,
  });

  final T value;
  final int attempts;
  final Duration totalDuration;
  final List<RetryAttempt> attemptHistory;
}

/// Information about a single retry attempt
class RetryAttempt {
  RetryAttempt({
    required this.attemptNumber,
    required this.timestamp,
    required this.duration,
    required this.succeeded,
    this.error,
  });

  final int attemptNumber;
  final DateTime timestamp;
  final Duration duration;
  final Object? error;
  final bool succeeded;
}

/// Enhanced retry options with more features
class RetryOptions {
  const RetryOptions({
    this.strategy = const ExponentialBackoffStrategy(),
    this.maxAttempts = 8,
    this.timeoutPerAttempt,
    this.operationName,
  }) : assert(maxAttempts > 0, 'maxAttempts must be positive');

  final RetryStrategy strategy;
  final int maxAttempts;
  final Duration? timeoutPerAttempt;
  final String? operationName;

  /// Retry with enhanced error handling and cancellation support
  Future<RetryResult<T>> retryWithResult<T>(
    FutureOr<T> Function(int attempt) fn, {
    FutureOr<bool> Function(Object)? retryIf,
    FutureOr<void> Function(Object, int)? onRetry,
    CancellationToken? cancellationToken,
  }) async {
    final startTime = DateTime.now();
    final attemptHistory = <RetryAttempt>[];
    var attempt = 0;

    while (attempt < maxAttempts) {
      cancellationToken?.throwIfCancelled();

      attempt++;
      final attemptStart = DateTime.now();

      try {
        final future = fn(attempt);
        // TODO(ishanga): Improve timeout handling - consider per-operation timeout vs cumulative timeout
        // Current implementation only handles per-attempt timeout, not total operation timeout
        final result = timeoutPerAttempt != null ? await Future.value(future).timeout(timeoutPerAttempt!) : await future;

        attemptHistory.add(
          RetryAttempt(
            attemptNumber: attempt,
            timestamp: attemptStart,
            duration: DateTime.now().difference(attemptStart),
            succeeded: true,
          ),
        );

        return RetryResult(
          value: result,
          attempts: attempt,
          totalDuration: DateTime.now().difference(startTime),
          attemptHistory: attemptHistory,
        );
      } catch (e, stackTrace) {
        final attemptDuration = DateTime.now().difference(attemptStart);
        attemptHistory.add(
          RetryAttempt(
            attemptNumber: attempt,
            timestamp: attemptStart,
            duration: attemptDuration,
            error: e,
            succeeded: false,
          ),
        );

        final shouldRetry = retryIf == null || await retryIf(e);

        if (!shouldRetry || attempt >= maxAttempts) {
          // TODO(ishanga): Enhance error context - include retry history and operation details in final error
          // Consider wrapping original error with retry context information
          // Preserve the original error type, but doing this will require careful handling
          // when comparing errors in retryIf function
          if (e is Error) {
            Error.throwWithStackTrace(e, stackTrace);
          } else {
            rethrow;
          }
        }

        if (onRetry != null) {
          await onRetry(e, attempt);
        }

        if (attempt < maxAttempts) {
          final delay = strategy.getDelay(attempt);
          // TODO(ishanga): Add cancellation support during delay period
          // The delay should be interruptible by cancellation token
          await Future<void>.delayed(delay);
        }
      }
    }

    // This should never be reached
    throw StateError('Retry loop ended unexpectedly');
  }
}

/// Cancellation token for retry operations
class CancellationToken {
  bool _isCancelled = false;
  final _completer = Completer<void>();

  bool get isCancelled => _isCancelled;
  Future<void> get cancelled => _completer.future;

  void cancel() {
    if (!_isCancelled) {
      _isCancelled = true;
      _completer.complete();
    }
  }

  void throwIfCancelled() {
    if (_isCancelled) {
      throw CancelledException();
    }
  }
}

class CancelledException implements Exception {
  @override
  String toString() => 'Operation was cancelled';
}

/// Circuit breaker for preventing retry storms
class CircuitBreaker {
  CircuitBreaker({
    this.failureThreshold = 5,
    this.resetTimeout = const Duration(minutes: 1),
  });

  final int failureThreshold;
  final Duration resetTimeout;

  int _consecutiveFailures = 0;
  DateTime? _lastFailureTime;
  bool _isOpen = false;

  // TODO(ishanga): Implement half-open state for gradual recovery
  // Circuit breaker should have three states: closed, open, half-open
  // TODO(ishanga): Add thread safety considerations for isolate usage
  // Consider using atomic operations or synchronization primitives
  bool get isOpen {
    if (_isOpen && _lastFailureTime != null) {
      if (DateTime.now().difference(_lastFailureTime!) > resetTimeout) {
        reset();
      }
    }
    return _isOpen;
  }

  void recordSuccess() {
    _consecutiveFailures = 0;
    _isOpen = false;
  }

  void recordFailure() {
    _consecutiveFailures++;
    _lastFailureTime = DateTime.now();

    if (_consecutiveFailures >= failureThreshold) {
      _isOpen = true;
    }
  }

  void reset() {
    _consecutiveFailures = 0;
    _isOpen = false;
    _lastFailureTime = null;
  }
}

/// Enhanced retry with circuit breaker
class ResilientRetryOptions extends RetryOptions {
  const ResilientRetryOptions({
    super.strategy,
    super.maxAttempts,
    super.timeoutPerAttempt,
    super.operationName,
    this.circuitBreaker,
  });

  final CircuitBreaker? circuitBreaker;

  @override
  Future<RetryResult<T>> retryWithResult<T>(
    FutureOr<T> Function(int attempt) fn, {
    FutureOr<bool> Function(Object)? retryIf,
    FutureOr<void> Function(Object, int)? onRetry,
    CancellationToken? cancellationToken,
  }) async {
    if (circuitBreaker?.isOpen ?? false) {
      throw CircuitBreakerOpenException();
    }

    try {
      final result = await super.retryWithResult(
        fn,
        retryIf: retryIf,
        onRetry: onRetry,
        cancellationToken: cancellationToken,
      );

      circuitBreaker?.recordSuccess();
      return result;
    } catch (e) {
      circuitBreaker?.recordFailure();
      rethrow;
    }
  }
}

class CircuitBreakerOpenException implements Exception {
  @override
  String toString() => 'Circuit breaker is open - too many consecutive failures';
}
