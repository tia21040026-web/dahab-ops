import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../booking/data/booking_models.dart';

/// Supplier dashboard + inbox actions, all against `/api/suppliers/*`.
/// The acting supplier comes from the session for suppliers; Operations and
/// Admin may name a supplier explicitly.
class SupplierDashboard {
  const SupplierDashboard({
    required this.supplier,
    required this.active,
    required this.past,
    required this.pendingCount,
    required this.confirmedCount,
    required this.totalEarningsEGP,
    required this.escrowPendingEGP,
    required this.reliabilityScore,
  });

  final SupplierLite supplier;
  final List<Booking> active;
  final List<Booking> past;
  final int pendingCount;
  final int confirmedCount;
  final double totalEarningsEGP;
  final double escrowPendingEGP;
  final double? reliabilityScore;

  List<Booking> pending() => active.where((b) => b.needsSupplierConfirm).toList();
}

@lazySingleton
class SupplierRepository {
  SupplierRepository(this._api);

  final ApiClient _api;

  Future<SupplierDashboard> dashboard(String supplierId) async {
    final json = await _api.get('/api/suppliers/$supplierId/dashboard');
    Booking list(Object? v) => Booking.fromJson((v as Map).cast<String, dynamic>());
    final active = ((json['activeBookings'] as List?) ?? const []).map(list).toList();
    final past = ((json['pastBookings'] as List?) ?? const []).map(list).toList();
    final stats = ((json['stats'] as Map?) ?? const {}).cast<String, dynamic>();
    final s = (json['supplier'] as Map?)?.cast<String, dynamic>() ?? {'id': supplierId};
    num n(Object? v) => v is num ? v : 0;
    final dash = SupplierDashboard(
      supplier: SupplierLite(
        id: '${s['id'] ?? supplierId}',
        businessName: '${s['businessName'] ?? s['displayName'] ?? supplierId}',
        category: '${s['category'] ?? ''}',
        status: '${s['status'] ?? ''}',
      ),
      active: active,
      past: past,
      pendingCount: (stats['pendingActionCount'] as num?)?.toInt() ?? active.where((b) => b.needsSupplierConfirm).length,
      confirmedCount: (stats['confirmedCount'] as num?)?.toInt() ?? 0,
      totalEarningsEGP: n(stats['totalEarningsEGP']).toDouble(),
      escrowPendingEGP: n(stats['escrowPendingEGP']).toDouble(),
      reliabilityScore: stats['reliabilityScore'] is num ? (stats['reliabilityScore'] as num).toDouble() : null,
    );
    pendingCount.value = dash.pending().length;
    return dash;
  }

  /// Pending confirmations after the last load; drives the Inbox tab badge.
  final ValueNotifier<int> pendingCount = ValueNotifier<int>(0);

  Future<Booking> respond({
    required String bookingId,
    required bool accept,
    String? reason,
    String? supplierId,
  }) async {
    final json = await _api.post(
      '/api/suppliers/bookings/$bookingId/respond',
      body: {
        'action': accept ? 'ACCEPT' : 'REJECT',
        if (reason case final r? when r.isNotEmpty) 'reason': r,
        'supplierId': supplierId,
      },
    );
    return Booking.fromJson((json['booking'] as Map).cast<String, dynamic>());
  }

  Future<Booking> updateStatus({
    required String bookingId,
    required String supplierState,
    Map<String, dynamic>? resource,
  }) async {
    final json = await _api.post(
      '/api/suppliers/bookings/$bookingId/status',
      body: {'supplierState': supplierState, 'resource': resource},
    );
    return Booking.fromJson((json['booking'] as Map).cast<String, dynamic>());
  }
}
