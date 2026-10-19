import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import '../api/retry_interceptor.dart';
import 'server_event.dart';
import 'sse_parser.dart';

enum RealtimeStatus { idle, connecting, live, reconnecting, polling, paused }

/// SSE over a Dio byte stream (`GET /api/stream?topics=...`).
///
/// Sends the Bearer token through the app Dio's auth interceptor, resumes
/// from `Last-Event-ID`, reconnects with capped exponential backoff, and can
/// be paused while the app is in the background.
class SseClient {
  SseClient(
    this._dio, {
    this.path = '/api/stream',
    this.baseBackoff = const Duration(seconds: 1),
    this.maxBackoff = const Duration(seconds: 30),
    this.idleTimeout = const Duration(seconds: 60),
    Random? random,
  }) : _random = random ?? Random();

  final Dio _dio;
  final String path;
  final Duration baseBackoff;
  final Duration maxBackoff;

  /// Must exceed the server heartbeat (25 s).
  final Duration idleTimeout;
  final Random _random;

  final _events = StreamController<ServerEvent>.broadcast();
  final _status = StreamController<RealtimeStatus>.broadcast();

  RealtimeStatus _current = RealtimeStatus.idle;
  List<String> _topics = const [];
  String? lastEventId;
  CancelToken? _cancel;
  bool _running = false;
  bool _paused = false;
  int consecutiveFailures = 0;
  Duration? _serverRetry;
  Completer<void>? _wake;

  Stream<ServerEvent> get events => _events.stream;
  Stream<RealtimeStatus> get statusChanges => _status.stream;
  RealtimeStatus get status => _current;

  void _set(RealtimeStatus s) {
    if (_current == s) return;
    _current = s;
    if (!_status.isClosed) _status.add(s);
  }

  void start(List<String> topics) {
    _topics = topics;
    if (_running) {
      _restart();
      return;
    }
    _running = true;
    _paused = false;
    unawaited(_loop());
  }

  void _restart() {
    _cancel?.cancel('restart');
    if (_wake?.isCompleted == false) _wake?.complete();
  }

  void pause() {
    if (!_running || _paused) return;
    _paused = true;
    _cancel?.cancel('paused');
    _set(RealtimeStatus.paused);
  }

  void resume() {
    if (!_running || !_paused) return;
    _paused = false;
    consecutiveFailures = 0;
    unawaited(_loop());
  }

  void stop() {
    _running = false;
    _paused = false;
    _cancel?.cancel('stopped');
    if (_wake?.isCompleted == false) _wake?.complete();
    lastEventId = null;
    _set(RealtimeStatus.idle);
  }

  Duration backoffFor(int failures) {
    if (_serverRetry != null && failures <= 1) return _serverRetry!;
    final ms = baseBackoff.inMilliseconds * pow(2, min(failures, 10));
    final capped = min(ms.toInt(), maxBackoff.inMilliseconds);
    return Duration(milliseconds: capped + _random.nextInt(capped ~/ 4 + 1));
  }

  bool _looping = false;

  Future<void> _loop() async {
    if (_looping) return;
    _looping = true;
    try {
      while (_running && !_paused) {
        _set(consecutiveFailures == 0 ? RealtimeStatus.connecting : RealtimeStatus.reconnecting);
        final cancel = _cancel = CancelToken();
        try {
          final res = await _dio.get<ResponseBody>(
            path,
            queryParameters: {'topics': _topics.join(',')},
            cancelToken: cancel,
            options: Options(
              responseType: ResponseType.stream,
              receiveTimeout: idleTimeout,
              headers: {
                'Accept': 'text/event-stream',
                'Cache-Control': 'no-cache',
                if (lastEventId != null) 'Last-Event-ID': lastEventId,
              },
              extra: {RetryInterceptor.disableKey: true},
            ),
          );
          final body = res.data;
          if (body == null) throw StateError('empty stream');
          consecutiveFailures = 0;
          _set(RealtimeStatus.live);
          await for (final frame in body.stream.cast<List<int>>().transform(const SseParser())) {
            if (frame.id != null) lastEventId = frame.id;
            if (frame.retry != null) _serverRetry = Duration(milliseconds: frame.retry!);
            if (frame.data.isEmpty && frame.event == null) continue;
            if (!_events.isClosed) _events.add(ServerEvent.fromFrame(frame));
          }
          // Server closed the stream cleanly; reconnect promptly.
          consecutiveFailures = 1;
        } on DioException catch (e) {
          if (CancelToken.isCancel(e)) {
            if (!_running || _paused) break;
            continue; // restarted with new topics
          }
          consecutiveFailures++;
        } catch (_) {
          consecutiveFailures++;
        }
        if (!_running || _paused) break;
        _set(RealtimeStatus.reconnecting);
        final wake = _wake = Completer<void>();
        await Future.any([Future<void>.delayed(backoffFor(consecutiveFailures)), wake.future]);
      }
    } finally {
      _looping = false;
    }
  }

  Future<void> dispose() async {
    stop();
    await _events.close();
    await _status.close();
  }
}
