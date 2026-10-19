import 'package:json_annotation/json_annotation.dart';

/// Accepts a string, number or `{ email | name | id }` object and returns a
/// display string. The contract types actors loosely (`actor`, `requestedBy`).
class StringishConverter implements JsonConverter<String?, Object?> {
  const StringishConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is num || json is bool) return json.toString();
    if (json is Map) {
      return (json['email'] ?? json['name'] ?? json['id'])?.toString();
    }
    return json.toString();
  }

  @override
  Object? toJson(String? object) => object;
}

/// Lenient ISO-8601 / epoch-millis date parsing.
class LenientDateConverter implements JsonConverter<DateTime?, Object?> {
  const LenientDateConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  @override
  Object? toJson(DateTime? object) => object?.toIso8601String();
}
