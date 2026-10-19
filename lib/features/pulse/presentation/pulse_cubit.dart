import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../../../core/realtime/realtime_service.dart';
import '../../../core/realtime/server_event.dart';
import '../../queue/data/queue_repository.dart';
import '../data/overview_repository.dart';

enum PulseStatus { initial, loading, ready, failure }

class PulseState extends Equatable {
  const PulseState({
    this.status = PulseStatus.initial,
    this.data,
    this.preview = const [],
    this.error,
  });

  final PulseStatus status;
  final PulseData? data;
  final List<QueueItem> preview;
  final ApiError? error;

  PulseState copyWith({
    PulseStatus? status,
    PulseData? data,
    List<QueueItem>? preview,
    ApiError? error,
  }) =>
      PulseState(
        status: status ?? this.status,
        data: data ?? this.data,
        preview: preview ?? this.preview,
        error: error,
      );

  @override
  List<Object?> get props => [status, data, preview, error];
}

/// Pulse (home): overview KPIs + top action items, refreshed on SSE events.
@injectable
class PulseCubit extends Cubit<PulseState> {
  PulseCubit(this._overview, this._queue, this._realtime) : super(const PulseState());

  final OverviewRepository _overview;
  final QueueRepository _queue;
  final RealtimeService _realtime;

  StreamSubscription<ServerEvent>? _events;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    _realtime.start(const ['ops', 'notifications']);
    _events = _realtime.events.listen((_) => unawaited(refresh(silent: true)));
    await refresh();
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: PulseStatus.loading, error: null));
    try {
      final results = await Future.wait([_overview.load(), _queue.load()]);
      if (isClosed) return;
      emit(state.copyWith(
        status: PulseStatus.ready,
        data: results[0] as PulseData,
        preview: ((results[1] as List<QueueItem>).take(3)).toList(),
        error: null,
      ));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: state.data == null ? PulseStatus.failure : PulseStatus.ready, error: e));
    }
  }

  @override
  Future<void> close() async {
    await _events?.cancel();
    return super.close();
  }
}
