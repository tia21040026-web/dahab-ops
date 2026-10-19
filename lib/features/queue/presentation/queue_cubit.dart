import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../../../core/realtime/realtime_service.dart';
import '../../../core/realtime/server_event.dart';
import '../data/queue_repository.dart';

enum QueueFilter { all, critical, suppliers, payments, support }

enum QueueStatus { initial, loading, ready, failure }

class QueueState extends Equatable {
  const QueueState({
    this.status = QueueStatus.initial,
    this.items = const [],
    this.filter = QueueFilter.all,
    this.error,
    this.snoozed = const {},
  });

  final QueueStatus status;
  final List<QueueItem> items;
  final QueueFilter filter;
  final ApiError? error;

  /// Item ids hidden until the timestamp (epoch ms).
  final Map<String, int> snoozed;

  List<QueueItem> get visible {
    final now = DateTime.now().millisecondsSinceEpoch;
    return items.where((e) {
      final until = snoozed[e.id];
      if (until != null && until > now) return false;
      return switch (filter) {
        QueueFilter.all => true,
        QueueFilter.critical => e.isCritical,
        QueueFilter.suppliers =>
          e.kind == QueueKind.supplierConfirm || e.kind == QueueKind.transferTask,
        QueueFilter.payments =>
          e.kind == QueueKind.paymentIssue || e.kind == QueueKind.refundApproval,
        QueueFilter.support => e.kind == QueueKind.support,
      };
    }).toList();
  }

  int get criticalCount => items.where((e) => e.isCritical).length;

  /// Items [f] would show, snoozed ones excluded (chip counts).
  int countFor(QueueFilter f) => copyWith(filter: f).visible.length;

  QueueState copyWith({
    QueueStatus? status,
    List<QueueItem>? items,
    QueueFilter? filter,
    ApiError? error,
    Map<String, int>? snoozed,
  }) =>
      QueueState(
        status: status ?? this.status,
        items: items ?? this.items,
        filter: filter ?? this.filter,
        error: error,
        snoozed: snoozed ?? this.snoozed,
      );

  @override
  List<Object?> get props => [status, items, filter, error, snoozed];
}

/// Priority-sorted action queue. Snooze is a local 1-hour hide; resolving an
/// item always navigates to the screen that performs the real backend action.
@injectable
class QueueCubit extends Cubit<QueueState> {
  QueueCubit(this._repo, this._realtime) : super(const QueueState());

  final QueueRepository _repo;
  final RealtimeService _realtime;

  StreamSubscription<ServerEvent>? _events;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    _realtime.start(const ['ops', 'support', 'approvals']);
    _events = _realtime.events.listen((_) => unawaited(refresh(silent: true)));
    await refresh();
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: QueueStatus.loading, error: null));
    try {
      final items = await _repo.load();
      if (isClosed) return;
      emit(state.copyWith(status: QueueStatus.ready, items: items, error: null));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: state.items.isEmpty ? QueueStatus.failure : QueueStatus.ready, error: e));
    }
  }

  void setFilter(QueueFilter f) => emit(state.copyWith(filter: f));

  void snooze(QueueItem item) {
    final next = Map<String, int>.of(state.snoozed)
      ..[item.id] = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;
    emit(state.copyWith(snoozed: next));
  }

  @override
  Future<void> close() async {
    await _events?.cancel();
    return super.close();
  }
}
