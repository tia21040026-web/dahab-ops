import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'polling_fallback.dart';
import 'server_event.dart';
import 'sse_client.dart';

/// App-wide realtime feed: SSE first, polling ticks after repeated failures,
/// paused while the app is backgrounded.
class RealtimeService with WidgetsBindingObserver {
  RealtimeService(Dio dio, {SseClient? sse, PollingFallback? polling})
      : _sse = sse ?? SseClient(dio),
        _polling = polling ?? PollingFallback() {
    _subs
      ..add(_sse.events.listen(_out.add))
      ..add(_polling.ticks.listen(_out.add))
      ..add(_sse.statusChanges.listen(_onSseStatus));
  }

  /// Consecutive SSE failures before polling takes over.
  static const fallbackAfter = 3;

  final SseClient _sse;
  final PollingFallback _polling;
  final _out = StreamController<ServerEvent>.broadcast();
  final _subs = <StreamSubscription<Object?>>[];
  final ValueNotifier<RealtimeStatus> status = ValueNotifier(RealtimeStatus.idle);
  bool _observing = false;

  Stream<ServerEvent> get events => _out.stream;

  /// Events for the given topics (poll ticks always pass).
  Stream<ServerEvent> on(Set<String> topics) =>
      events.where((e) => e.synthetic || topics.contains(e.topic));

  void _onSseStatus(RealtimeStatus s) {
    if (s == RealtimeStatus.live) {
      _polling.stop();
      status.value = RealtimeStatus.live;
      return;
    }
    if (s == RealtimeStatus.reconnecting && _sse.consecutiveFailures >= fallbackAfter) {
      _polling.start();
      status.value = RealtimeStatus.polling;
      return;
    }
    if (!_polling.isActive) status.value = s;
  }

  void start(List<String> topics) {
    if (!_observing) {
      WidgetsBinding.instance.addObserver(this);
      _observing = true;
    }
    _sse.start(topics);
  }

  void stop() {
    _sse.stop();
    _polling.stop();
    status.value = RealtimeStatus.idle;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _sse.pause();
        _polling.stop();
      case AppLifecycleState.resumed:
        _sse.resume();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> dispose() async {
    if (_observing) WidgetsBinding.instance.removeObserver(this);
    for (final s in _subs) {
      await s.cancel();
    }
    await _sse.dispose();
    await _polling.dispose();
    await _out.close();
  }
}
