import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class DiningOrder extends JsonRecord {
  const DiningOrder(super.json);

  String get ref => s('orderRef', id);
  String venue(bool arabic) {
    final v = json['venue'];
    if (v is Map) {
      return '${(arabic ? v['nameAr'] : null) ?? v['nameEn'] ?? v['name'] ?? s('venueId')}';
    }
    return s('venueId');
  }

  String get status => s('status');
  String get fulfillment => s('fulfillment');
  int? get etaMinutes => n('etaMinutes')?.toInt();
  String get notes => s('notes');
  DateTime? get createdAt => d('createdAt');
  num get totalEGP => (m('priceBreakdown')['totalEGP'] as num?) ?? 0;
  List<Map<String, dynamic>> get lines => l('lines');
  String get address => '${m('deliveryLocation')['addressText'] ?? m('deliveryLocation')['labelEn'] ?? ''}';

  /// The next status in the kitchen flow, if any.
  String? get next => switch (status) {
        'PENDING_CONFIRMATION' => 'CONFIRMED',
        'CONFIRMED' => 'PREPARING',
        'PREPARING' => fulfillment == 'PICKUP' ? 'READY_FOR_PICKUP' : 'OUT_FOR_DELIVERY',
        'PREPARING' => fulfillment == 'PICKUP' ? 'READY_FOR_PICKUP' : 'OUT_FOR_DELIVERY',
        'READY_FOR_PICKUP' => 'DELIVERED',
        'OUT_FOR_DELIVERY' => 'DELIVERED',
        _ => null,
      };

  bool get cancellable => const {'PENDING_CONFIRMATION', 'CONFIRMED', 'PREPARING'}.contains(status);

  static const statuses = [
    'PENDING_CONFIRMATION',
    'CONFIRMED',
    'PREPARING',
    'OUT_FOR_DELIVERY',
    'DELIVERED',
    'CANCELLED',
  ];
}

@lazySingleton
class DiningRepository {
  DiningRepository(this._api);

  final ApiClient _api;

  Future<Paged<DiningOrder>> orders(ListQuery q) async {
    final p = pagedFrom(await _api.get('/api/dining/orders'), const ['orders'], DiningOrder.new);
    final status = q.filters['status'];
    return status == null ? p : p.copyWith(items: p.items.where((o) => o.status == status).toList());
  }

  Future<DiningOrder> setStatus(String id, String status, {String? reason}) async {
    final json = await _api.post('/api/dining/orders/$id/status',
        body: {'status': status, 'reason': reason ?? null});
    return DiningOrder((json['order'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<DiningOrder> cancel(String id, String reason) async {
    final json = await _api.post('/api/dining/orders/$id/cancel', body: {'reason': reason});
    return DiningOrder((json['order'] as Map?)?.cast<String, dynamic>() ?? json);
  }
}
