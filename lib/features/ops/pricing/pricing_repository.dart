import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

class Sku extends JsonRecord {
  const Sku(super.json);

  String title(bool arabic) => arabic ? first(const ['titleAr', 'title'], id) : first(const ['title'], id);
  String get serviceType => s('serviceType');
  num get basePriceEGP => n('basePriceEGP') ?? 0;
  int get capacity => i('maxCapacityPerSlot');
  bool get active => b('active', true);
  String get supplier => s('supplierName');
  int get slots => i('slotCount');

  Sku withPrice(num price) => Sku({...json, 'basePriceEGP': price});
}

class InventorySlot extends JsonRecord {
  const InventorySlot(super.json);

  String get date => s('date');
  String get time => s('timeSlot');
  int get total => i('totalCapacity');
  int get reserved => i('reservedCapacity');
  int get held => i('heldCapacity');
  num get priceEGP => n('priceEGP') ?? 0;
  String get status => s('status');

  InventorySlot withPrice(num price) => InventorySlot({...json, 'priceEGP': price});
}

/// Pricing & inventory (`/api/admin/pricing/*`). Price edits carry a reason
/// for the audit log.
@lazySingleton
class PricingRepository {
  PricingRepository(this._api);

  final ApiClient _api;

  Future<Paged<Sku>> skus(ListQuery q) async => pagedFrom(
      await _api.get('/api/admin/pricing/skus', query: {
        if (q.filters['serviceType'] != null) 'serviceType': q.filters['serviceType'],
      }),
      const ['skus'],
      Sku.new);

  Future<void> setSkuPrice(String id, num price, String reason) =>
      _api.put('/api/admin/pricing/sku/$id', body: {'basePriceEGP': price, 'reason': reason});

  Future<List<InventorySlot>> inventory(String skuId) async {
    final now = DateTime.now();
    String day(DateTime d) => d.toIso8601String().substring(0, 10);
    final json = await _api.get('/api/admin/pricing/inventory', query: {
      'skuId': skuId,
      'startDate': day(now),
      'endDate': day(now.add(const Duration(days: 30))),
    });
    return [for (final m in listOfMaps(json['slots'])) InventorySlot(m)];
  }

  Future<void> setSlotPrice(String slotId, num price, String reason) =>
      _api.put('/api/admin/pricing/inventory/$slotId', body: {'priceEGP': price, 'reason': reason});
}
