import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import 'booking_models.dart';

/// A booking with its supplier name and a ledger derived from real numbers:
/// the captured amount plus the commission rule (server setting when
/// readable, 15% otherwise), so payout and net are always consistent.
class BookingDetail {
  const BookingDetail({
    required this.booking,
    required this.supplierName,
    required this.supplierReliability,
    required this.commissionRate,
    required this.rows,
  });

  final Booking booking;
  final String supplierName;
  final String supplierReliability;
  final double commissionRate;
  final List<LedgerRow> rows;
}

class LedgerRow {
  const LedgerRow({required this.label, required this.amount, this.negative = false});

  final String label;
  final double amount;
  final bool negative;
}

/// `GET /api/operations/bookings` (found by ref client-side) joined with the
/// supplier directory and the commerce settings.
@lazySingleton
class BookingRepository {
  BookingRepository(this._api);

  final ApiClient _api;

  Future<BookingDetail> byRef(String ref) async {
    final results = await Future.wait([
      _api.get('/api/operations/bookings', query: {'limit': 500}),
      _api.get('/api/suppliers').catchError((_) => <String, dynamic>{'suppliers': []}),
      _api.get('/api/admin/settings').catchError((_) => <String, dynamic>{'items': []}),
    ]);
    final bookings = (((results[0] as Map)['bookings'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => Booking.fromJson(e.cast<String, dynamic>()))
        .toList();
    final booking = bookings.firstWhere(
      (b) => b.bookingRef == ref || b.id == ref || b.confirmationCode == ref,
      orElse: () => throw BookingNotFound(ref),
    );

    String supplierName = booking.supplierId;
    final suppliers = (((results[1] as Map)['suppliers'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
    final match = suppliers.where((s) => '${s['id']}' == booking.supplierId).toList();
    if (match.isNotEmpty) supplierName = '${match.first['businessName'] ?? booking.supplierId}';

    var rate = 0.15;
    final items = (((results[2] as Map)['items'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
    for (final s in items) {
      if (s['key'] == 'commerce.commissionRate' && s['value'] is num) {
        rate = (s['value'] as num).toDouble();
      }
    }

    final commission = booking.amountEGP * rate;
    final payout = booking.amountEGP - commission;
    return BookingDetail(
      booking: booking,
      supplierName: supplierName,
      supplierReliability: '',
      commissionRate: rate,
      rows: [
        LedgerRow(label: 'charge', amount: booking.amountEGP),
        LedgerRow(label: 'commission', amount: commission, negative: true),
        LedgerRow(label: 'payout', amount: payout),
        LedgerRow(label: 'net', amount: commission),
      ],
    );
  }
}

class BookingNotFound implements Exception {
  BookingNotFound(this.ref);
  final String ref;
}
