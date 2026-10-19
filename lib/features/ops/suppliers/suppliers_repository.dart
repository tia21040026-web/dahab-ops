import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

/// Catalogue supplier merged with its reliability row.
class OpsSupplier extends JsonRecord {
  const OpsSupplier(super.json, [this.reliability = const {}]);

  final Map<String, dynamic> reliability;

  String name(bool arabic) =>
      arabic ? first(const ['businessNameAr', 'businessName'], id) : first(const ['businessName'], id);
  String get category => s('category');
  String get tier => s('tier');
  String get status => s('status');
  String get area => s('area');
  String get phone => s('phone');
  num? get rating => n('rating');
  int get reviews => i('reviewCount');
  String get license => s('licenseNumber');
  String get verification => s('verificationStatus');

  num? get confirmationRate => reliability['confirmationRate'] as num?;
  num? get rejectionRate => reliability['rejectionRate'] as num?;
  int get totalBookings => (reliability['totalBookings'] as num?)?.toInt() ?? 0;
  int get pendingCount => (reliability['pendingCount'] as num?)?.toInt() ?? 0;

  @override
  List<Object?> get props => [json, reliability];
}

@lazySingleton
class SuppliersRepository {
  SuppliersRepository(this._api);

  final ApiClient _api;

  Future<Paged<OpsSupplier>> suppliers(ListQuery q) async {
    final results = await Future.wait([
      _api.get('/api/suppliers'),
      _api.get('/api/operations/supplier-reliability').catchError((Object _) => <String, dynamic>{}),
    ]);
    final rel = {
      for (final r in listOfMaps(results[1]['suppliers'])) '${r['supplierId']}': r,
    };
    final status = q.filters['status'];
    final text = q.q?.toLowerCase() ?? '';
    final items = [
      for (final m in listOfMaps(results[0]['suppliers']))
        OpsSupplier(m, rel['${m['id']}'] ?? const {}),
    ]
        .where((s) => status == null || s.status == status)
        .where((s) => text.isEmpty || s.name(false).toLowerCase().contains(text) || s.area.toLowerCase().contains(text))
        .toList();
    return Paged(items: items, total: items.length);
  }
}
