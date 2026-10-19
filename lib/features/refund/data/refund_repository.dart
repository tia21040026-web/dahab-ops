import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error.dart';

/// Result of a refund request: executed now, or queued for a second admin.
class RefundOutcome extends Equatable {
  const RefundOutcome.executed({required this.refundId, required this.amountEGP})
      : approvalId = null;

  const RefundOutcome.queued({required this.approvalId, required this.amountEGP}) : refundId = null;

  final String? refundId;
  final String? approvalId;
  final double amountEGP;

  bool get needsApproval => approvalId != null;

  @override
  List<Object?> get props => [refundId, approvalId, amountEGP];
}

/// `POST /api/operations/refund` with an idempotency key. Amounts above
/// `commerce.refundApprovalThresholdEgp` answer 403 `approval-required` and
/// surface as [RefundOutcome.queued] instead of an error.
@lazySingleton
class RefundRepository {
  RefundRepository(this._api);

  final ApiClient _api;
  static const _uuid = Uuid();

  Future<RefundOutcome> request({
    required String bookingRef,
    required double amountEGP,
    required String reason,
    String? idempotencyKey,
  }) async {
    final key = idempotencyKey ?? _uuid.v4();
    try {
      final json = await _api.post(
        '/api/operations/refund',
        body: {'bookingRef': bookingRef, 'amountEGP': amountEGP, 'reason': reason},
        idempotencyKey: key,
      );
      return RefundOutcome.executed(
        refundId: '${json['refundId'] ?? ''}',
        amountEGP: (json['amountEGP'] is num) ? (json['amountEGP'] as num).toDouble() : amountEGP,
      );
    } on ApiError catch (e) {
      if (e.kind == ApiErrorKind.approvalRequired) {
        return RefundOutcome.queued(approvalId: e.approvalId ?? '', amountEGP: amountEGP);
      }
      rethrow;
    }
  }
}
