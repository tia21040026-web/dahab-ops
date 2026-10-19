import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

/// A support message (flat rows, one `reply` each).
class SupportMessage extends JsonRecord {
  const SupportMessage(super.json);

  String get traveler => first(const ['travelerName', 'travelerEmail', 'travelerPhone'], '—');
  String get message => s('message');
  String get status => s('status', 'OPEN');
  String get category => s('category');
  bool get urgent => b('urgent');
  String? get bookingRef => so('bookingRef');
  String? get reply => so('reply');
  String? get repliedBy => so('repliedBy');
  DateTime? get repliedAt => d('repliedAt');
  DateTime? get createdAt => d('createdAt');
  String? get phone => so('travelerPhone');
  String? get email => so('travelerEmail');

  static const statuses = ['OPEN', 'ESCALATED', 'IN_PROGRESS', 'ANSWERED', 'CLOSED'];
}

@lazySingleton
class SupportRepository {
  SupportRepository(this._api);

  final ApiClient _api;

  Future<Paged<SupportMessage>> messages(ListQuery q) async {
    final p = pagedFrom(await _api.get('/api/support/messages'), const ['messages'], SupportMessage.new);
    final status = q.filters['status'];
    final text = q.q?.toLowerCase();
    final items = p.items
        .where((m) => status == null || m.status == status)
        .where((m) =>
            text == null ||
            text.isEmpty ||
            m.message.toLowerCase().contains(text) ||
            m.traveler.toLowerCase().contains(text))
        .toList();
    return Paged(items: items, total: items.length);
  }

  Future<SupportMessage> reply(String id, String reply) async {
    final json = await _api.post('/api/support/messages/$id/reply', body: {'reply': reply});
    return SupportMessage((json['message'] as Map?)?.cast<String, dynamic>() ?? json);
  }
}
