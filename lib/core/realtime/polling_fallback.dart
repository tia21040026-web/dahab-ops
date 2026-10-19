import 'dart:async';

import 'server_event.dart';

/// Emits [ServerEvent.pollTick] on an interval while SSE is unavailable, so
/// screens that refresh on events keep moving on hostile networks.
class PollingFallback {
  PollingFallback({this.interval = const Duration(seconds: 30)});

  final Duration interval;
  final _ticks = StreamController<ServerEvent>.broadcast();
  Timer? _timer;

  Stream<ServerEvent> get ticks => _ticks.stream;
  bool get isActive => _timer != null;

  void start({bool immediately = true}) {
    if (_timer != null) return;
    if (immediately && !_ticks.isClosed) _ticks.add(ServerEvent.pollTick());
    _timer = Timer.periodic(interval, (_) {
      if (!_ticks.isClosed) _ticks.add(ServerEvent.pollTick());
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> dispose() async {
    stop();
    await _ticks.close();
  }
}
