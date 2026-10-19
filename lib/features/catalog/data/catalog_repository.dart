import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error.dart';
import '../../../core/api/models/json_record.dart';
import '../../../core/api/models/paged.dart';
import '../../access/presentation/session_cubit.dart';
import '../../cms/cms_repository.dart';
import 'catalog_models.dart';

/// 422 `.../incomplete` → the field keys the server wants filled.
List<String> missingFromError(Object e) {
  if (e is! ApiError) return const [];
  final body = e.body;
  if (body is Map && body['missing'] is List) return [for (final k in body['missing'] as List) '$k'];
  return const [];
}

bool isIncomplete(Object e) =>
    e is ApiError && (e.status == 422 || (e.type ?? '').endsWith('/incomplete')) && missingFromError(e).isNotEmpty;

/// 409 on PATCH (stale `If-Match`) or on DELETE (`.../in-use`).
bool isConflict(Object e) => e is ApiError && (e.status == 409 || e.kind == ApiErrorKind.conflict);

bool isInUse(Object e) => isConflict(e) && ((e as ApiError).type ?? '').endsWith('/in-use');

/// Catalogue CRUD (`docs/CATALOG_API_CONTRACT.md`). Staff use
/// `/api/admin/catalog`, suppliers `/api/supplier/catalog` (scoped to their
/// own records server-side).
class CatalogRepository {
  CatalogRepository(this._api, {this.supplier = false, this.uploadOverride});

  /// Picks the surface from the signed-in role.
  factory CatalogRepository.forSession(SessionState s) =>
      CatalogRepository(GetIt.I<ApiClient>(), supplier: s.isSupplier);

  final ApiClient _api;
  final bool supplier;
  /// Test seam for [uploadImage].
  final Future<String> Function(Uint8List bytes, String filename, String mimeType)? uploadOverride;

  String get base => supplier ? '/api/supplier/catalog' : '/api/admin/catalog';

  List<CatalogTypeSchema>? _schemaCache;

  Future<List<CatalogTypeSchema>> schema({bool refresh = false}) async {
    if (!refresh && _schemaCache != null) return _schemaCache!;
    final json = await _api.get('$base/schema');
    return _schemaCache = [for (final t in listOfMaps(json['types'])) CatalogTypeSchema.fromJson(t)];
  }

  Future<CatalogTypeSchema?> schemaFor(String type) async =>
      (await schema()).where((t) => t.type == type).firstOrNull;

  Future<Paged<CatalogItem>> list(String type, ListQuery q) async =>
      pagedFrom(await _api.get('$base/$type', query: q.toQuery()), const ['items'], CatalogItem.new);

  /// Count for one type (`limit=1`, reads `total`). The home uses [summary].
  Future<int> count(String type, {String? status}) async {
    final p = await list(type, ListQuery(limit: 1, filters: {'status': status}));
    return p.total;
  }

  /// `GET {base}/summary`: per-type counts in one call, keyed by type.
  /// `total` excludes archived records.
  Future<Map<String, CatalogTypeSummary>> summary() async {
    final json = await _api.get('$base/summary');
    return {
      for (final t in listOfMaps(json['types']))
        if (t['type'] is String) t['type'] as String: CatalogTypeSummary.fromJson(t),
    };
  }

  Future<CatalogDetail> get(String type, String id) async =>
      CatalogDetail.fromJson(await _api.get('$base/$type/$id'));

  /// Unwraps `{ item, queuedForApproval, approvalId? }`. A queued write
  /// (202) is flagged on the returned record ([CatalogItem.queuedForApproval]).
  CatalogItem _item(Json json) {
    final item = json['item'] is Map ? (json['item'] as Map).cast<String, dynamic>() : json;
    if (json['queuedForApproval'] != true) return CatalogItem(item);
    return CatalogItem({
      ...item,
      CatalogItem.queuedKey: true,
      if (json['approvalId'] != null) CatalogItem.approvalKey: '${json['approvalId']}',
    });
  }

  /// New records are always drafts.
  Future<CatalogItem> create(String type, Json body) async => _item(await _api.post('$base/$type', body: body));

  /// Partial update guarded by `If-Match: <updatedAt>`; 409 when stale.
  Future<CatalogItem> patch(String type, String id, Json body, {String? ifMatch}) async {
    try {
      final r = await _api.dio.patch<dynamic>('$base/$type/$id',
          data: body, options: Options(headers: {'If-Match': ifMatch}));
      final data = r.data;
      return _item(data is Map ? data.cast<String, dynamic>() : <String, dynamic>{...body, 'id': id});
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  /// `publish` · `hide` · `archive` · `restore`. Archive needs a reason.
  Future<CatalogItem> transition(String type, String id, String action, {String? reason}) async =>
      _item(await _api.post('$base/$type/$id/$action', body: {'reason': reason}));

  Future<CatalogItem> publish(String type, String id) => transition(type, id, 'publish');

  Future<void> delete(String type, String id, {required String reason}) =>
      _api.delete('$base/$type/$id', body: {'reason': reason});

  Future<CatalogItem> duplicate(String type, String id) async => _item(await _api.post('$base/$type/$id/duplicate'));

  Future<Json> bulk(String type, {required List<String> ids, required String action, Object? value, String? reason}) =>
      _api.post('$base/$type/bulk', body: {'ids': ids, 'action': action, 'value': value, 'reason': reason});

  // ── Children ────────────────────────────────────────────────────────────

  Future<List<CatalogItem>> children(String type, String id, String child) async {
    final json = await _api.get('$base/$type/$id/$child');
    return pagedFrom(json, [child, 'items'], CatalogItem.new).items;
  }

  Future<CatalogItem> addChild(String type, String id, String child, Json body) async =>
      _item(await _api.post('$base/$type/$id/$child', body: body));

  Future<CatalogItem> patchChild(String type, String id, String child, String childId, Json body) async =>
      _item(await _api.patch('$base/$type/$id/$child/$childId', body: body));

  Future<void> deleteChild(String type, String id, String child, String childId, {String? reason}) =>
      _api.delete('$base/$type/$id/$child/$childId', body: {'reason': reason});

  // ── Hotel rates ─────────────────────────────────────────────────────────

  Future<List<RateNight>> rates(String hotelId, {String? roomId, required DateTime from, required DateTime to}) async {
    final json = await _api.get('$base/hotel/$hotelId/rates',
        query: {'roomId': roomId, 'from': isoDate(from), 'to': isoDate(to)});
    return [for (final m in listOfMaps(json['nights'])) RateNight.fromJson(m)];
  }

  /// Returns `{ applied, queuedForApproval, approvalId? }`; see
  /// [isQueuedForApproval]. `from` and `to` are inclusive.
  Future<Json> setRates(
    String hotelId, {
    required String roomId,
    required DateTime from,
    required DateTime to,
    num? nightlyEGP,
    bool? closed,
    List<int>? weekdays,
    String? reason,
  }) =>
      _api.put('$base/hotel/$hotelId/rates', body: {
        'roomId': roomId,
        'from': isoDate(from),
        'to': isoDate(to),
        'nightlyEGP': nightlyEGP,
        'closed': closed,
        if (weekdays != null && weekdays.length < 7) 'weekdays': weekdays,
        'reason': reason,
      });

  // ── Activity slots ──────────────────────────────────────────────────────

  Future<List<SlotRow>> slots(String activityId, {required DateTime from, required DateTime to}) async {
    final json = await _api.get('$base/activity/$activityId/slots', query: {'from': isoDate(from), 'to': isoDate(to)});
    return pagedFrom(json, const ['slots'], SlotRow.fromJson).items;
  }

  Future<Json> setSlots(
    String activityId, {
    required DateTime from,
    required DateTime to,
    List<String> times = const [],
    int? capacity,
    List<int>? weekdays,
    bool? closed,
  }) =>
      _api.put('$base/activity/$activityId/slots', body: {
        'from': isoDate(from),
        'to': isoDate(to),
        'times': times,
        'capacity': capacity,
        if (weekdays != null && weekdays.length < 7) 'weekdays': weekdays,
        'closed': closed,
      });

  // ── Media ───────────────────────────────────────────────────────────────

  /// Staff upload through `POST /api/admin/content/media/upload`, suppliers
  /// through `POST /api/supplier/catalog/media/upload` (same body and
  /// response). Returns `asset.original_url` for `images[]`.
  Future<String> uploadImage(Uint8List bytes, String filename, String mimeType) async {
    final o = uploadOverride;
    if (o != null) return o(bytes, filename, mimeType);
    if (supplier) {
      // The server sets `category: supplier` and tags the asset itself.
      final json = await _api.post('$base/media/upload', body: {
        'dataUrl': 'data:$mimeType;base64,${base64Encode(bytes)}',
        'filename': filename,
      });
      final asset = json['asset'] is Map ? (json['asset'] as Map).cast<String, dynamic>() : json;
      return '${asset['original_url'] ?? asset['url'] ?? ''}';
    }
    final asset = await GetIt.I<CmsRepository>()
        .uploadImage(bytes: bytes, filename: filename, mimeType: mimeType, category: 'catalog');
    return asset.url;
  }
}

/// True when a write answered 202 `{ queuedForApproval: true }`: nothing
/// is applied until a staff member approves.
bool isQueuedForApproval(Object? json) => json is Map && json['queuedForApproval'] == true;
