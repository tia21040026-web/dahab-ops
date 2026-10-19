import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

/// Retries idempotent reads (GET/HEAD) on transport failures and 502/503/504
/// with exponential backoff and jitter. Never retries writes: those carry an
/// `Idempotency-Key` and are retried explicitly by the user.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 400),
    Random? random,
    Future<void> Function(Duration)? sleep,
  })  : _random = random ?? Random(),
        _sleep = sleep ?? Future<void>.delayed;

  static const attemptKey = 'dahab.retryAttempt';
  static const disableKey = 'dahab.noRetry';

  final int maxAttempts;
  final Duration baseDelay;
  final Random _random;
  final Future<void> Function(Duration) _sleep;
  Dio? _owner;

  void attach(Dio owner) => _owner = owner;

  bool _retryable(DioException e) {
    final method = e.requestOptions.method.toUpperCase();
    if (method != 'GET' && method != 'HEAD') return false;
    if (e.requestOptions.extra[disableKey] == true) return false;
    if (e.requestOptions.responseType == ResponseType.stream) return false;
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        if (code == 503) {
          // Kill switch / maintenance answers are deliberate; do not hammer.
          final data = e.response?.data;
          final type = data is Map ? '${data['type']}' : '';
          if (type.contains('kill-switch') || type.contains('maintenance')) return false;
        }
        return code == 502 || code == 503 || code == 504;
      default:
        return false;
    }
  }

  Duration delayFor(int attempt) {
    final exp = baseDelay * pow(2, attempt - 1).toInt();
    final jitter = Duration(milliseconds: _random.nextInt(baseDelay.inMilliseconds ~/ 2 + 1));
    return exp + jitter;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final owner = _owner;
    final attempt = (err.requestOptions.extra[attemptKey] as int?) ?? 1;
    if (owner == null || attempt >= maxAttempts || !_retryable(err)) {
      return handler.next(err);
    }
    await _sleep(delayFor(attempt));
    final next = err.requestOptions.copyWith(
      extra: {...err.requestOptions.extra, attemptKey: attempt + 1},
    );
    try {
      return handler.resolve(await owner.fetch<dynamic>(next));
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
