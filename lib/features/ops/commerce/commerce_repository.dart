import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class LedgerEntry extends JsonRecord {
  const LedgerEntry(super.json);

  String get type => s('type');
  num get amountEGP => n('amountEGP') ?? 0;
  String get bookingRef => s('bookingRef');
  String get debit => s('debitAccount');
  String get credit => s('creditAccount');
  String get status => s('status');
  DateTime? get at => d('timestamp');
  String get transactionId => s('transactionId');
  String get hash => s('signatureHash');
  bool get isRefund => type.toUpperCase().contains('REFUND');
}

class PaymentsSummary {
  const PaymentsSummary({
    this.captured = 0,
    this.refunded = 0,
    this.commission = 0,
    this.entries = 0,
    this.escrow = 0,
    this.ledgerValid,
    this.failed = const [],
  });

  final num captured;
  final num refunded;
  final num commission;
  final int entries;
  final num escrow;
  final bool? ledgerValid;
  final List<FailedPayment> failed;
}

class FailedPayment extends JsonRecord {
  const FailedPayment(super.json);

  String get bookingRef => s('bookingRef');
  num get amountEGP => n('amountEGP') ?? 0;
  String get paymentState => s('paymentState');
}

/// Commerce: `/api/commerce/ledger`, `/api/operations/payments`. Refunds are
/// the ledger's `REFUND_ISSUED` entries (no dedicated list endpoint).
@lazySingleton
class CommerceRepository {
  CommerceRepository(this._api);

  final ApiClient _api;

  Future<Paged<LedgerEntry>> ledger(ListQuery q) async {
    final p = pagedFrom(await _api.get('/api/commerce/ledger'), const ['entries'], LedgerEntry.new);
    final kind = q.filters['kind'];
    final items = p.items
        .where((e) => kind != 'refunds' || e.isRefund)
        .toList()
      ..sort((a, b) => (b.at ?? DateTime(0)).compareTo(a.at ?? DateTime(0)));
    return Paged(items: items, total: items.length);
  }

  Future<PaymentsSummary> summary() async {
    final results = await Future.wait([
      _api.get('/api/operations/payments'),
      _api.get('/api/commerce/ledger/verify').catchError((Object _) => <String, dynamic>{}),
    ]);
    final pay = results[0];
    final verify = results[1];
    final s = (pay['summary'] as Map?)?.cast<String, dynamic>() ?? const {};
    num n(Object? v) => v is num ? v : 0;
    return PaymentsSummary(
      captured: n(s['totalCapturedEGP']),
      refunded: n(s['totalRefundedEGP']),
      commission: n(s['totalCommissionEGP']),
      entries: n(s['entryCount']).toInt(),
      escrow: n(verify['escrowBalanceEGP']),
      ledgerValid: verify['valid'] is bool ? verify['valid'] as bool : null,
      failed: [for (final m in listOfMaps(pay['failedPayments'])) FailedPayment(m)],
    );
  }
}
