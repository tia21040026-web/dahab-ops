import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/idempotency.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class OpsNotificationRow extends JsonRecord {
  const OpsNotificationRow(super.json);

  String get title => first(const ['title', 'type']);
  String get message => s('message');
  String get channel => s('channel');
  String get status => s('status');
  String get type => s('type');
  DateTime? get createdAt => d('createdAt');
  bool get read => b('read') || status == 'READ';
}

class SmsLog extends JsonRecord {
  const SmsLog(super.json);

  String get to => first(const ['recipientPhone', 'to']);
  String get name => first(const ['recipientName', 'recipientRole']);
  String get message => s('message');
  String get channel => s('channel');
  String get status => s('status');
  bool get simulated => b('simulated');
  String? get error => so('providerError');
  String? get bookingRef => so('referenceBookingId');
  DateTime? get at => d('timestamp');
}

class SmsResult {
  const SmsResult({required this.ok, required this.replayed});

  final bool ok;
  final bool replayed;
}

/// Notifications (read) and SMS (log + idempotent dispatch).
@lazySingleton
class MessagingRepository {
  MessagingRepository(this._api);

  final ApiClient _api;

  Future<Paged<OpsNotificationRow>> notifications(ListQuery q) async {
    final p = pagedFrom(await _api.get('/api/operations/notifications'), const ['notifications'],
        OpsNotificationRow.new);
    final channel = q.filters['channel'];
    return channel == null ? p : p.copyWith(items: p.items.where((n) => n.channel == channel).toList());
  }

  Future<Paged<SmsLog>> smsLogs(ListQuery q) async =>
      pagedFrom(await _api.get('/api/sms/logs', query: {'limit': 100}), const ['logs'], SmsLog.new);

  /// `POST /api/operations/sms-dispatch`. Reuse [idempotencyKey] when the
  /// person retries the same send; the server replays the first result.
  Future<SmsResult> sendSms({
    required String to,
    required String recipientName,
    required String message,
    String? bookingRef,
    required String idempotencyKey,
  }) async {
    final res = await _api.postRaw(
      '/api/operations/sms-dispatch',
      body: {
        'to': to,
        'recipientName': recipientName,
        'message': message,
        'bookingRef': bookingRef,
        },
      idempotencyKey: idempotencyKey,
    );
    final data = res.data;
    return SmsResult(
      ok: data is Map ? data['success'] != false : true,
      replayed: Idempotency.wasReplayed(res),
    );
  }
}
