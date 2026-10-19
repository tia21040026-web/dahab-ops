import 'package:equatable/equatable.dart';

import '../api_client.dart';
import 'converters.dart';
import 'paged.dart';

/// A read-mostly server row kept as JSON with typed accessors.
///
/// The ops endpoints predate the contract and differ in shape (`trips`,
/// `bookings`, `items`…); wrapping keeps every field the server sends
/// without a codegen model per legacy endpoint.
abstract class JsonRecord extends Equatable {
  const JsonRecord(this.json);

  final Json json;

  String s(String key, [String fallback = '']) {
    final v = json[key];
    if (v == null) return fallback;
    return const StringishConverter().fromJson(v) ?? fallback;
  }

  String? so(String key) {
    final v = json[key];
    if (v == null) return null;
    final r = const StringishConverter().fromJson(v);
    return (r == null || r.isEmpty) ? null : r;
  }

  num? n(String key) {
    final v = json[key];
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  int i(String key, [int fallback = 0]) => n(key)?.toInt() ?? fallback;

  bool b(String key, [bool fallback = false]) {
    final v = json[key];
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v == 'true' || v == '1';
    return fallback;
  }

  DateTime? d(String key) => const LenientDateConverter().fromJson(json[key]);

  Json m(String key) {
    final v = json[key];
    return v is Map ? v.cast<String, dynamic>() : const <String, dynamic>{};
  }

  List<Json> l(String key) => listOfMaps(json[key]);

  /// First non-empty string among [keys].
  String first(List<String> keys, [String fallback = '']) {
    for (final k in keys) {
      final v = so(k);
      if (v != null) return v;
    }
    return fallback;
  }

  String get id => first(const ['id', 'bookingRef', 'orderRef', 'key'], '');

  @override
  List<Object?> get props => [json];
}

List<Json> listOfMaps(Object? v) =>
    v is List ? v.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList() : const [];

/// Reads a list out of a legacy (`{ trips: [...] }`) or contract
/// (`{ items, nextCursor, total }`) response.
Paged<T> pagedFrom<T>(Json json, List<String> keys, T Function(Json) item) {
  List<Json> rows = const [];
  if (json['items'] is List) {
    rows = listOfMaps(json['items']);
  } else {
    for (final k in keys) {
      if (json[k] is List) {
        rows = listOfMaps(json[k]);
        break;
      }
    }
    if (rows.isEmpty && json['data'] is List) rows = listOfMaps(json['data']);
  }
  final total = json['total'] ?? json['count'];
  return Paged<T>(
    items: rows.map(item).toList(),
    nextCursor: json['nextCursor'] as String?,
    total: total is num ? total.toInt() : rows.length,
  );
}
