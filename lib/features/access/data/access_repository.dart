import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/models/admin_models.dart';
import '../../../core/api/models/paged.dart';

/// `/api/admin` access surface: users, roles, overrides, sessions.
@lazySingleton
class AccessRepository {
  AccessRepository(this._api);

  final ApiClient _api;

  Future<Paged<AdminUserRow>> users({String? q, String? role, String? status, String? cursor, int limit = 25}) async {
    return _api.getPaged<AdminUserRow>(
      '/api/admin/users',
      item: AdminUserRow.fromJson,
      query: ListQuery(cursor: cursor, limit: limit),
      extra: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (role != null && role.isNotEmpty) 'role': role,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
  }

  Future<UserDetail> userDetail(String id) async =>
      UserDetail.fromJson(await _api.get('/api/admin/users/$id'));

  Future<InviteResult> invite({
    required String email,
    required String name,
    String? phone,
    required String roleId,
    String? supplierId,
  }) async {
    final json = await _api.post('/api/admin/users', body: {
      'email': email,
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'roleId': roleId,
      if (supplierId != null && supplierId.isNotEmpty) 'supplierId': supplierId,
    });
    return InviteResult.fromJson(json);
  }

  Future<void> patchUser(String id,
      {String? roleId, String? status, String? supplierId, String? name, required String reason}) async {
    await _api.patch('/api/admin/users/$id', body: {
      'roleId': roleId,
      'status': status,
      'supplierId': supplierId,
      'name': name,
      'reason': reason,
    });
  }

  Future<List<PermissionOverride>> setOverrides(
      String id, List<PermissionOverride> overrides, String reason) async {
    final json = await _api.put('/api/admin/users/$id/overrides', body: {
      'overrides': [
        for (final o in overrides) {'permission': o.permission, 'effect': o.effect},
      ],
      'reason': reason,
    });
    return (((json['overrides'] as List?) ?? const []).whereType<Map>())
        .map((e) => PermissionOverride.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<int> revokeSessions(String id, String reason) async {
    final json = await _api.post('/api/admin/users/$id/revoke-sessions', body: {'reason': reason});
    return (json['revokedCount'] as num?)?.toInt() ?? 0;
  }

  Future<List<PermissionDef>> permissions() async {
    final json = await _api.get('/api/admin/permissions');
    return (((json['items'] as List?) ?? const []).whereType<Map>())
        .map((e) => PermissionDef.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<List<Role>> roles() async {
    final json = await _api.get('/api/admin/roles');
    return (((json['items'] as List?) ?? const []).whereType<Map>())
        .map((e) => Role.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<Role> updateRole(String id, {List<String>? permissions, required String reason}) async {
    final json = await _api.patch('/api/admin/roles/$id', body: {
      'permissions': permissions,
      'reason': reason,
    });
    return Role.fromJson(json);
  }

  Future<Role> createRole({required String name, String? description, List<String> permissions = const []}) async {
    final json = await _api.post('/api/admin/roles', body: {
      'name': name,
      'description': description,
      'permissions': permissions,
    });
    return Role.fromJson(json);
  }

  Future<void> deleteRole(String id, String reason) async {
    await _api.delete('/api/admin/roles/$id', body: {'reason': reason});
  }
}
