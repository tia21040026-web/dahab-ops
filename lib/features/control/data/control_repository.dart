import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/admin_models.dart';
import '../../../core/api/models/paged.dart';

/// `/api/admin` control surface: settings (+history/rollback), flags,
/// integrations, approvals, audit.
@lazySingleton
class ControlRepository {
  ControlRepository(this._api);

  final ApiClient _api;

  Future<List<SettingItem>> settings() async {
    final json = await _api.get('/api/admin/settings');
    return (((json['items'] as List?) ?? const []).whereType<Map>())
        .map((e) => SettingItem.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<SettingItem> setSetting(String key, Object? value, String reason) async {
    final json = await _api.put('/api/admin/settings/$key', body: {'value': value, 'reason': reason});
    return SettingItem.fromJson(json);
  }

  Future<List<SettingVersion>> settingHistory(String key) async {
    final json = await _api.get('/api/admin/settings/$key/history');
    final items = (json['items'] as List?) ?? (json as List? ?? const []);
    return items
        .whereType<Map>()
        .map((e) => SettingVersion.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<SettingItem> rollbackSetting(String key, int version, String reason) async {
    final json = await _api.post('/api/admin/settings/$key/rollback', body: {'version': version, 'reason': reason});
    return SettingItem.fromJson(json);
  }

  Future<List<FlagItem>> flags() async {
    final json = await _api.get('/api/admin/flags');
    return (((json['items'] as List?) ?? const []).whereType<Map>())
        .map((e) => FlagItem.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  /// Returns the updated flag (contract: `FlagItem`), or null when the
  /// server answered without one.
  Future<FlagItem?> setFlag(String key,
      {required bool enabled, int? rolloutPercent, List<String>? roles, required String reason}) async {
    final json = await _api.put('/api/admin/flags/$key', body: {
      'enabled': enabled,
      'rolloutPercent': rolloutPercent,
      'roles': roles,
      'reason': reason,
    });
    return json['key'] is String ? FlagItem.fromJson(json) : null;
  }

  Future<List<Integration>> integrations() async {
    final json = await _api.get('/api/admin/integrations');
    return (((json['items'] as List?) ?? const []).whereType<Map>())
        .map((e) => Integration.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<Integration> checkIntegration(String id) async {
    final json = await _api.post('/api/admin/integrations/$id/check');
    return Integration.fromJson(json);
  }

  Future<Integration> patchIntegration(String id,
      {bool? enabled, String? mode, required String reason}) async {
    final json = await _api.patch('/api/admin/integrations/$id', body: {
        'enabled': enabled,
      'mode': mode,
      'reason': reason,
    });
    return Integration.fromJson(json);
  }

  Future<List<Approval>> approvals({String status = 'pending'}) async {
    final json = await _api.get('/api/admin/approvals', query: {'status': status});
    final items = (json['items'] as List?) ?? const [];
    return items
        .whereType<Map>()
        .map((e) => Approval.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<void> decideApproval(String id, {required bool approve, String? note}) async {
    await _api.post('/api/admin/approvals/$id/decide', body: {
      'decision': approve ? 'approve' : 'reject',
      if (note != null && note.isNotEmpty) 'note': note,
    });
  }

  Future<Paged<AuditEvent>> audit({String? cursor, AuditFilter filter = const AuditFilter()}) async {
    return _api.getPaged<AuditEvent>(
      '/api/admin/audit',
      item: AuditEvent.fromJson,
      query: ListQuery(cursor: cursor, limit: 25),
      extra: filter.toQuery(),
    );
  }

  /// `/api/operations/audit-events` (ops.audit.view). Always sends `limit`
  /// so the server answers with the list shape, not the legacy one.
  Future<Paged<AuditEvent>> opsAudit({String? cursor, AuditFilter filter = const AuditFilter()}) async {
    final json = await _api.get('/api/operations/audit-events', query: {
      ...ListQuery(cursor: cursor, limit: 25).toQuery(),
      ...filter.toQuery(),
    });
    final rows = (json['items'] ?? json['auditEvents']) as List? ?? const [];
    return Paged<AuditEvent>(
      items: rows
          .whereType<Map>()
          .map((e) => AuditEvent.fromJson(_normaliseOpsAudit(e.cast<String, dynamic>())))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      total: (json['total'] as num?)?.toInt() ?? rows.length,
    );
  }

  /// Ops events carry `payload` instead of before/after.
  static Map<String, dynamic> _normaliseOpsAudit(Map<String, dynamic> e) => {
        ...e,
        'id': '${e['id'] ?? e['signature'] ?? e['timestamp']}',
        'action': '${e['action'] ?? 'event'}',
        if (e['after'] == null && e['payload'] != null) 'after': e['payload'],
      };

  /// Starts a read-only view-as on this session (`admin.viewas`).
  Future<void> startViewAs(String userId, String reason) =>
      _api.post('/api/admin/view-as', body: {'userId': userId, 'reason': reason});

  Future<void> endViewAs() => _api.delete('/api/admin/view-as');
}

/// Audit filters (contract § Admin: control). Empty values are not sent.
class AuditFilter {
  const AuditFilter({this.actor, this.action, this.entityType, this.entityId, this.from, this.to});

  final String? actor;
  final String? action;
  final String? entityType;
  final String? entityId;
  final DateTime? from;
  final DateTime? to;

  bool get isEmpty =>
      [actor, action, entityType, entityId].every((v) => v == null || v.isEmpty) &&
      from == null &&
      to == null;

  Map<String, dynamic> toQuery() => {
        if (actor?.isNotEmpty ?? false) 'actor': actor,
        if (action?.isNotEmpty ?? false) 'action': action,
        if (entityType?.isNotEmpty ?? false) 'entityType': entityType,
        if (entityId?.isNotEmpty ?? false) 'entityId': entityId,
        if (from != null) 'from': from!.toUtc().toIso8601String(),
        if (to != null) 'to': to!.toUtc().toIso8601String(),
      };
}
