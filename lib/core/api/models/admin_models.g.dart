// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUserRow _$AdminUserRowFromJson(Map<String, dynamic> json) =>
    _AdminUserRow(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'Traveler',
      supplierId: json['supplierId'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: const LenientDateConverter().fromJson(json['createdAt']),
      lastSeenAt: const LenientDateConverter().fromJson(json['lastSeenAt']),
      deviceCount: (json['deviceCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdminUserRowToJson(_AdminUserRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': ?instance.name,
      'phone': ?instance.phone,
      'role': instance.role,
      'supplierId': ?instance.supplierId,
      'status': instance.status,
      'createdAt': ?const LenientDateConverter().toJson(instance.createdAt),
      'lastSeenAt': ?const LenientDateConverter().toJson(instance.lastSeenAt),
      'deviceCount': instance.deviceCount,
    };

_PermissionOverride _$PermissionOverrideFromJson(Map<String, dynamic> json) =>
    _PermissionOverride(
      permission: json['permission'] as String,
      effect: json['effect'] as String? ?? 'grant',
      createdBy: const StringishConverter().fromJson(json['createdBy']),
      createdAt: const LenientDateConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$PermissionOverrideToJson(_PermissionOverride instance) =>
    <String, dynamic>{
      'permission': instance.permission,
      'effect': instance.effect,
      'createdBy': ?const StringishConverter().toJson(instance.createdBy),
      'createdAt': ?const LenientDateConverter().toJson(instance.createdAt),
    };

_UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => _UserDetail(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  roleId: json['roleId'] as String?,
  overrides:
      (json['overrides'] as List<dynamic>?)
          ?.map((e) => PermissionOverride.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  effectivePermissions:
      (json['effectivePermissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  devices:
      (json['devices'] as List<dynamic>?)
          ?.map((e) => DeviceSession.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserDetailToJson(_UserDetail instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'roleId': ?instance.roleId,
      'overrides': instance.overrides.map((e) => e.toJson()).toList(),
      'effectivePermissions': instance.effectivePermissions,
      'devices': instance.devices.map((e) => e.toJson()).toList(),
    };

_InviteResult _$InviteResultFromJson(Map<String, dynamic> json) =>
    _InviteResult(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tempPassword: json['tempPassword'] as String,
    );

Map<String, dynamic> _$InviteResultToJson(_InviteResult instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'tempPassword': instance.tempPassword,
    };

_PermissionDef _$PermissionDefFromJson(Map<String, dynamic> json) =>
    _PermissionDef(
      key: json['key'] as String,
      group: json['group'] as String? ?? 'other',
      labelEn: json['labelEn'] as String?,
      labelAr: json['labelAr'] as String?,
      dangerous: json['dangerous'] as bool? ?? false,
    );

Map<String, dynamic> _$PermissionDefToJson(_PermissionDef instance) =>
    <String, dynamic>{
      'key': instance.key,
      'group': instance.group,
      'labelEn': ?instance.labelEn,
      'labelAr': ?instance.labelAr,
      'dangerous': instance.dangerous,
    };

_Role _$RoleFromJson(Map<String, dynamic> json) => _Role(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isSystem: json['isSystem'] as bool? ?? false,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  userCount: (json['userCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RoleToJson(_Role instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': ?instance.description,
  'isSystem': instance.isSystem,
  'permissions': instance.permissions,
  'userCount': instance.userCount,
};

_SettingItem _$SettingItemFromJson(Map<String, dynamic> json) => _SettingItem(
  key: json['key'] as String,
  value: json['value'],
  type: json['type'] as String? ?? 'string',
  group: json['group'] as String? ?? 'general',
  labelEn: json['labelEn'] as String?,
  labelAr: json['labelAr'] as String?,
  version: (json['version'] as num?)?.toInt() ?? 1,
  updatedBy: const StringishConverter().fromJson(json['updatedBy']),
  updatedAt: const LenientDateConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$SettingItemToJson(_SettingItem instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': ?instance.value,
      'type': instance.type,
      'group': instance.group,
      'labelEn': ?instance.labelEn,
      'labelAr': ?instance.labelAr,
      'version': instance.version,
      'updatedBy': ?const StringishConverter().toJson(instance.updatedBy),
      'updatedAt': ?const LenientDateConverter().toJson(instance.updatedAt),
    };

_SettingVersion _$SettingVersionFromJson(Map<String, dynamic> json) =>
    _SettingVersion(
      version: (json['version'] as num).toInt(),
      value: json['value'],
      updatedBy: const StringishConverter().fromJson(json['updatedBy']),
      updatedAt: const LenientDateConverter().fromJson(json['updatedAt']),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$SettingVersionToJson(_SettingVersion instance) =>
    <String, dynamic>{
      'version': instance.version,
      'value': ?instance.value,
      'updatedBy': ?const StringishConverter().toJson(instance.updatedBy),
      'updatedAt': ?const LenientDateConverter().toJson(instance.updatedAt),
      'reason': ?instance.reason,
    };

_FlagItem _$FlagItemFromJson(Map<String, dynamic> json) => _FlagItem(
  key: json['key'] as String,
  kind: json['kind'] as String? ?? 'flag',
  enabled: json['enabled'] as bool? ?? false,
  rolloutPercent: (json['rolloutPercent'] as num?)?.toInt(),
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  description: json['description'] as String?,
  updatedBy: const StringishConverter().fromJson(json['updatedBy']),
  updatedAt: const LenientDateConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$FlagItemToJson(_FlagItem instance) => <String, dynamic>{
  'key': instance.key,
  'kind': instance.kind,
  'enabled': instance.enabled,
  'rolloutPercent': ?instance.rolloutPercent,
  'roles': instance.roles,
  'description': ?instance.description,
  'updatedBy': ?const StringishConverter().toJson(instance.updatedBy),
  'updatedAt': ?const LenientDateConverter().toJson(instance.updatedAt),
};

_Integration _$IntegrationFromJson(Map<String, dynamic> json) => _Integration(
  id: json['id'] as String,
  name: json['name'] as String,
  status: json['status'] as String? ?? 'unconfigured',
  latencyMs: (json['latencyMs'] as num?)?.toInt(),
  checkedAt: const LenientDateConverter().fromJson(json['checkedAt']),
  mode: json['mode'] as String? ?? 'sandbox',
  enabled: json['enabled'] as bool? ?? false,
  keyHint: json['keyHint'] as String?,
  detail: json['detail'] as String?,
);

Map<String, dynamic> _$IntegrationToJson(_Integration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'latencyMs': ?instance.latencyMs,
      'checkedAt': ?const LenientDateConverter().toJson(instance.checkedAt),
      'mode': instance.mode,
      'enabled': instance.enabled,
      'keyHint': ?instance.keyHint,
      'detail': ?instance.detail,
    };

_Approval _$ApprovalFromJson(Map<String, dynamic> json) => _Approval(
  id: json['id'] as String,
  action: json['action'] as String,
  summary: json['summary'] as String?,
  payload: json['payload'],
  requestedBy: const StringishConverter().fromJson(json['requestedBy']),
  requestedAt: const LenientDateConverter().fromJson(json['requestedAt']),
  status: json['status'] as String? ?? 'pending',
  decidedBy: const StringishConverter().fromJson(json['decidedBy']),
  decidedAt: const LenientDateConverter().fromJson(json['decidedAt']),
  decisionNote: json['decisionNote'] as String?,
);

Map<String, dynamic> _$ApprovalToJson(_Approval instance) => <String, dynamic>{
  'id': instance.id,
  'action': instance.action,
  'summary': ?instance.summary,
  'payload': ?instance.payload,
  'requestedBy': ?const StringishConverter().toJson(instance.requestedBy),
  'requestedAt': ?const LenientDateConverter().toJson(instance.requestedAt),
  'status': instance.status,
  'decidedBy': ?const StringishConverter().toJson(instance.decidedBy),
  'decidedAt': ?const LenientDateConverter().toJson(instance.decidedAt),
  'decisionNote': ?instance.decisionNote,
};

_AuditEvent _$AuditEventFromJson(Map<String, dynamic> json) => _AuditEvent(
  id: json['id'] as String,
  actor: const StringishConverter().fromJson(json['actor']),
  actorRole: json['actorRole'] as String?,
  action: json['action'] as String,
  entityType: json['entityType'] as String?,
  entityId: const StringishConverter().fromJson(json['entityId']),
  before: json['before'],
  after: json['after'],
  reason: json['reason'] as String?,
  device: const StringishConverter().fromJson(json['device']),
  correlationId: json['correlationId'] as String?,
  timestamp: const LenientDateConverter().fromJson(json['timestamp']),
);

Map<String, dynamic> _$AuditEventToJson(_AuditEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actor': ?const StringishConverter().toJson(instance.actor),
      'actorRole': ?instance.actorRole,
      'action': instance.action,
      'entityType': ?instance.entityType,
      'entityId': ?const StringishConverter().toJson(instance.entityId),
      'before': ?instance.before,
      'after': ?instance.after,
      'reason': ?instance.reason,
      'device': ?const StringishConverter().toJson(instance.device),
      'correlationId': ?instance.correlationId,
      'timestamp': ?const LenientDateConverter().toJson(instance.timestamp),
    };

_SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    _SearchResult(
      type: json['type'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      route: json['route'] as String?,
    );

Map<String, dynamic> _$SearchResultToJson(_SearchResult instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'title': instance.title,
      'subtitle': ?instance.subtitle,
      'route': ?instance.route,
    };
