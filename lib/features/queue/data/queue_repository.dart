import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../booking/data/booking_models.dart';

/// Queue item kinds. Only kinds backed by a real endpoint exist — there is
/// no "late checkout" or "photo review" item because the backend exposes no
/// endpoint for them.
enum QueueKind { refundApproval, supplierConfirm, transferTask, paymentIssue, support }

/// One priority-sorted action-queue row.
class QueueItem extends Equatable {
  const QueueItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.severity,
    this.entityRef,
    this.amountEGP,
    this.at,
    this.slaDueAt,
  });

  final String id;
  final QueueKind kind;
  final String title;
  final String subtitle;

  /// 0 normal, 1 warning, 2 critical.
  final int severity;
  final String? entityRef;
  final double? amountEGP;
  final DateTime? at;
  final DateTime? slaDueAt;

  bool get isCritical => severity >= 2;

  @override
  List<Object?> get props => [id, kind, title, subtitle, severity, entityRef, amountEGP, at, slaDueAt];
}

/// The action queue, composed from real endpoints:
/// pending approvals (refunds above threshold), unconfirmed bookings,
/// driver-less transfers, failed payments and urgent notifications.
@lazySingleton
class QueueRepository {
  QueueRepository(this._api);

  final ApiClient _api;

  /// Open items after the last load; drives the Queue tab badge.
  final ValueNotifier<int> openCount = ValueNotifier<int>(0);

  Future<List<QueueItem>> load() async {
    final items = <QueueItem>[];
    await Future.wait([
      _approvals(items).catchError((_) {}),
      _confirms(items).catchError((_) {}),
      _transfers(items).catchError((_) {}),
      _payments(items).catchError((_) {}),
      _support(items).catchError((_) {}),
    ]);
    items.sort((a, b) {
      final sev = b.severity.compareTo(a.severity);
      if (sev != 0) return sev;
      final atA = a.at?.millisecondsSinceEpoch ?? 0;
      final atB = b.at?.millisecondsSinceEpoch ?? 0;
      return atA.compareTo(atB);
    });
    openCount.value = items.length;
    return items;
  }

  Future<void> _approvals(List<QueueItem> out) async {
    final json = await _api.get('/api/admin/approvals', query: {'status': 'pending'});
    final list = ((json['items'] as List?) ?? const []).whereType<Map>().toList();
    for (final e in list) {
      final m = e.cast<String, dynamic>();
      final action = '${m['action'] ?? ''}';
      final summary = '${m['summary'] ?? action}';
      out.add(QueueItem(
        id: 'approval:${m['id']}',
        kind: QueueKind.refundApproval,
        title: action == 'refund' ? 'Refund needs a second admin' : 'Approval needed: $action',
        subtitle: summary,
        severity: 2,
        entityRef: _refOf(m['payload']),
        at: _dt(m['requestedAt']),
      ));
    }
  }

  Future<void> _confirms(List<QueueItem> out) async {
    final json = await _api.get('/api/operations/bookings', query: {'limit': 200});
    final list = ((json['bookings'] as List?) ?? const []).whereType<Map>().toList();
    for (final e in list) {
      final b = Booking.fromJson(e.cast<String, dynamic>());
      if (!b.needsSupplierConfirm) continue;
      out.add(QueueItem(
        id: 'confirm:${b.id}',
        kind: QueueKind.supplierConfirm,
        title: 'Supplier confirmation overdue',
        // The ref is rendered separately by the tile (entityRef); keeping it
        // out of the subtitle avoids showing it twice.
        subtitle: b.travelerName,
        severity: _ageHours(b.createdAt) > 2 ? 1 : 0,
        entityRef: b.bookingRef,
        at: b.createdAt,
      ));
    }
  }

  Future<void> _transfers(List<QueueItem> out) async {
    final json = await _api.get('/api/operations/transfers');
    final list = ((json['transfers'] as List?) ?? const []).whereType<Map>().toList();
    for (final e in list) {
      final b = Booking.fromJson(e.cast<String, dynamic>());
      if (b.driverName != null && b.driverName!.isNotEmpty) continue;
      final pickup = b.scheduledAt;
      final soon = pickup != null && pickup.difference(DateTime.now()).inHours < 6;
      out.add(QueueItem(
        id: 'transfer:${b.id}',
        kind: QueueKind.transferTask,
        title: 'Driver not checked in',
        subtitle: b.pickupLocation ?? b.serviceType,
        severity: soon ? 2 : 1,
        entityRef: b.bookingRef,
        at: b.createdAt,
        slaDueAt: pickup,
      ));
    }
  }

  Future<void> _payments(List<QueueItem> out) async {
    final json = await _api.get('/api/operations/payments');
    final list = ((json['failedPayments'] as List?) ?? const []).whereType<Map>().toList();
    for (final e in list) {
      final m = e.cast<String, dynamic>();
      out.add(QueueItem(
        id: 'payment:${m['id']}',
        kind: QueueKind.paymentIssue,
        title: 'Payment issue: ${m['paymentState'] ?? 'failed'}',
        subtitle: '${_money(m['amountEGP'])} EGP',
        severity: 1,
        entityRef: '${m['bookingRef'] ?? ''}',
        amountEGP: (m['amountEGP'] is num) ? (m['amountEGP'] as num).toDouble() : null,
      ));
    }
  }

  Future<void> _support(List<QueueItem> out) async {
    final json = await _api.get('/api/operations/notifications');
    final list = ((json['notifications'] as List?) ?? const []).whereType<Map>().toList();
    for (final e in list) {
      final n = OpsNotification.fromJson(e.cast<String, dynamic>());
      if (n.read || !n.isUrgent) continue;
      out.add(QueueItem(
        id: 'support:${n.id}',
        kind: QueueKind.support,
        title: n.title.isEmpty ? 'Support message' : n.title,
        subtitle: n.body,
        severity: 1,
        at: n.createdAt,
      ));
    }
  }

  static String? _refOf(Object? payload) {
    if (payload is Map) {
      final m = payload.cast<String, dynamic>();
      for (final k in const ['bookingId', 'bookingRef']) {
        if (m[k] is String && (m[k] as String).isNotEmpty) return m[k] as String;
      }
    }
    return null;
  }

  static DateTime? _dt(Object? v) => v is String ? DateTime.tryParse(v) : null;

  static double _ageHours(DateTime? at) =>
      at == null ? 0 : DateTime.now().difference(at).inMinutes / 60.0;

  static String _money(Object? v) => v is num ? (v.toInt().toString()) : '—';
}
