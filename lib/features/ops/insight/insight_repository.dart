import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';

enum KnowledgeKind { gaps, conflicts, review, stale }

class KnowledgeItem extends JsonRecord {
  const KnowledgeItem(super.json, this.kind);

  final KnowledgeKind kind;

  String get title => first(const ['title', 'category', 'entity', 'field', 'key', 'type'], id);
  String get body => first(const ['description', 'summary', 'value', 'reason']);
  String get severity => s('severity');
  String get status => s('status');
  DateTime? get at => d('detectedAt') ?? d('createdAt') ?? d('lastVerifiedAt');
}

class Opportunity extends JsonRecord {
  const Opportunity(super.json);

  String get title => s('title');
  String get description => s('description');
  String get category => s('category');
  num? get confidence => n('confidence');
  String get status => s('status');
  String get evidence {
    final e = json['evidence'];
    if (e is List) return e.map((x) => x is Map ? (x['summary'] ?? x['text'] ?? x).toString() : '$x').join('\n');
    return e?.toString() ?? '';
  }
}

class MarketOverview extends JsonRecord {
  const MarketOverview(super.json);

  int get suppliers => i('totalSuppliers');
  int get offers => i('totalOffers');
  int get observations => i('totalPriceObservations');
  int get changes => i('recentChangeEventsCount');
  int get pendingReviews => i('pendingReviewCount');
  int get activeSources => i('activeSourcesCount');
  num? get freshness => n('freshnessScore');
}

class PriceObservation extends JsonRecord {
  const PriceObservation(super.json);

  num get price => n('priceEGP') ?? n('price') ?? n('amountEGP') ?? 0;
  DateTime? get at => d('observedAt') ?? d('timestamp') ?? d('createdAt');
  String get label => first(const ['offerTitle', 'title', 'category', 'serviceType']);
}

class SourceHealth extends JsonRecord {
  const SourceHealth(super.json);

  String get source => first(const ['sourceReference', 'sourceId']);
  String get status => s('healthStatus');
  int? get latencyMs => n('latencyMs')?.toInt();
  int get failures => i('consecutiveFailures');
  DateTime? get lastSuccess => d('lastSuccess');
}

/// Knowledge (`/api/dahab/admin/*`), opportunities
/// (`/api/intelligence/opportunities`) and market intelligence
/// (`/api/market/*`). All read-only here.
@lazySingleton
class InsightRepository {
  InsightRepository(this._api);

  final ApiClient _api;

  Future<Paged<KnowledgeItem>> knowledge(ListQuery q) async {
    final kind = KnowledgeKind.values.byName('${q.filters['kind'] ?? 'gaps'}');
    final (path, key) = switch (kind) {
      KnowledgeKind.gaps => ('gaps', 'gaps'),
      KnowledgeKind.conflicts => ('conflicts', 'conflicts'),
      KnowledgeKind.review => ('review-queue', 'queue'),
      KnowledgeKind.stale => ('stale-facts', 'staleFacts'),
    };
    return pagedFrom(await _api.get('/api/dahab/admin/$path'), [key], (m) => KnowledgeItem(m, kind));
  }

  Future<Paged<Opportunity>> opportunities(ListQuery q) async => pagedFrom(
      await _api.get('/api/intelligence/opportunities'), const ['opportunities'], Opportunity.new);

  Future<MarketOverview> marketOverview() async {
    final json = await _api.get('/api/market/ops/overview');
    return MarketOverview((json['overview'] as Map?)?.cast<String, dynamic>() ?? json);
  }

  Future<List<PriceObservation>> priceHistory() async => [
        for (final m in listOfMaps((await _api.get('/api/market/price-history'))['observations']))
          PriceObservation(m),
      ];

  Future<List<SourceHealth>> sourcesHealth() async => [
        for (final m in listOfMaps((await _api.get('/api/market/sources/health'))['health'])) SourceHealth(m),
      ];

  Future<void> refreshMarket() => _api.post('/api/market/refresh',
      body: {'ingestionMode': 'MANUAL_REFRESH', 'triggerSource': 'dahab-ops'});
}
