import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../../booking/data/booking_models.dart';
import '../data/supplier_repository.dart';

enum InboxTab { pending, confirmed, declined }

enum InboxStatus { initial, loading, ready, failure }

class SupplierInboxState extends Equatable {
  const SupplierInboxState({
    this.status = InboxStatus.initial,
    this.dashboard,
    this.tab = InboxTab.pending,
    this.error,
    this.workingId,
  });

  final InboxStatus status;
  final SupplierDashboard? dashboard;
  final InboxTab tab;
  final ApiError? error;
  final String? workingId;

  List<Booking> get shown {
    final d = dashboard;
    if (d == null) return const [];
    return switch (tab) {
      InboxTab.pending => d.pending(),
      InboxTab.confirmed => d.active.where((b) => !b.needsSupplierConfirm).toList(),
      InboxTab.declined => d.past.where((b) => b.supplierState == 'REJECTED' || b.supplierState == 'CANCELLED').toList(),
    };
  }

  SupplierInboxState copyWith({
    InboxStatus? status,
    SupplierDashboard? dashboard,
    InboxTab? tab,
    ApiError? error,
    String? workingId,
  }) =>
      SupplierInboxState(
        status: status ?? this.status,
        dashboard: dashboard ?? this.dashboard,
        tab: tab ?? this.tab,
        error: error,
        workingId: workingId,
      );

  @override
  List<Object?> get props => [status, dashboard, tab, error?.toString(), workingId];
}

/// Supplier inbox: pending confirmations with accept/decline wired to
/// `POST /api/suppliers/bookings/:id/respond`.
@injectable
class SupplierInboxCubit extends Cubit<SupplierInboxState> {
  SupplierInboxCubit(this._repo) : super(const SupplierInboxState());

  final SupplierRepository _repo;
  String? _supplierId;
  String? _actingSupplierId;

  Future<void> load({required String supplierId, String? actingSupplierId}) async {
    _supplierId = supplierId;
    _actingSupplierId = actingSupplierId;
    emit(state.copyWith(status: InboxStatus.loading, error: null));
    try {
      final d = await _repo.dashboard(supplierId);
      if (isClosed) return;
      emit(state.copyWith(status: InboxStatus.ready, dashboard: d));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: InboxStatus.failure, error: e));
    }
  }

  Future<void> refresh() async {
    final id = _supplierId;
    if (id == null) return;
    try {
      final d = await _repo.dashboard(id);
      if (isClosed) return;
      emit(state.copyWith(status: InboxStatus.ready, dashboard: d, error: null));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(error: e));
    }
  }

  void setTab(InboxTab tab) => emit(state.copyWith(tab: tab));

  Future<bool> respond(Booking booking, {required bool accept, String? reason}) async {
    emit(state.copyWith(workingId: booking.id, error: null));
    try {
      await _repo.respond(
        bookingId: booking.id,
        accept: accept,
        reason: reason,
        supplierId: _actingSupplierId,
      );
      await refresh();
      return true;
    } on ApiError catch (e) {
      emit(state.copyWith(error: e, workingId: null));
      return false;
    } finally {
      if (!isClosed) emit(state.copyWith(workingId: null));
    }
  }
}
