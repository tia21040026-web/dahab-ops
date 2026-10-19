import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_models.dart';
import 'converters.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

/// Row of `GET /api/admin/users` (`User & { lastSeenAt?, deviceCount }`).
@freezed
abstract class AdminUserRow with _$AdminUserRow {
  const AdminUserRow._();

  const factory AdminUserRow({
    required String id,
    required String email,
    String? name,
    String? phone,
    @Default('Traveler') String role,
    String? supplierId,
    @Default('active') String status,
    @LenientDateConverter() DateTime? createdAt,
    @LenientDateConverter() DateTime? lastSeenAt,
    @Default(0) int deviceCount,
  }) = _AdminUserRow;

  factory AdminUserRow.fromJson(Map<String, dynamic> json) => _$AdminUserRowFromJson(json);

  User get asUser => User(
        id: id,
        email: email,
        name: name,
        phone: phone,
        role: role,
        supplierId: supplierId,
        status: status,
        createdAt: createdAt,
      );
}

/// `Override = { permission, effect, createdBy, createdAt }`
@freezed
abstract class PermissionOverride with _$PermissionOverride {
  const factory PermissionOverride({
    required String permission,
    @Default('grant') String effect,
    @StringishConverter() String? createdBy,
    @LenientDateConverter() DateTime? createdAt,
  }) = _PermissionOverride;

  factory PermissionOverride.fromJson(Map<String, dynamic> json) =>
      _$PermissionOverrideFromJson(json);
}

/// `GET /api/admin/users/:id`.
@freezed
abstract class UserDetail with _$UserDetail {
  const factory UserDetail({
    required User user,
    String? roleId,
    @Default([]) List<PermissionOverride> overrides,
    @Default([]) List<String> effectivePermissions,
    @Default([]) List<DeviceSession> devices,
  }) = _UserDetail;

  factory UserDetail.fromJson(Map<String, dynamic> json) => _$UserDetailFromJson(json);
}

/// `POST /api/admin/users` response. `tempPassword` is shown once.
@freezed
abstract class InviteResult with _$InviteResult {
  const factory InviteResult({required User user, required String tempPassword}) = _InviteResult;

  factory InviteResult.fromJson(Map<String, dynamic> json) => _$InviteResultFromJson(json);
}

/// Catalogue entry from `GET /api/admin/permissions`.
@freezed
abstract class PermissionDef with _$PermissionDef {
  const PermissionDef._();

  const factory PermissionDef({
    required String key,
    @Default('other') String group,
    String? labelEn,
    String? labelAr,
    @Default(false) bool dangerous,
  }) = _PermissionDef;

  factory PermissionDef.fromJson(Map<String, dynamic> json) => _$PermissionDefFromJson(json);

  String label(bool arabic) => (arabic ? labelAr : labelEn) ?? labelEn ?? key;
}

@freezed
abstract class Role with _$Role {
  const factory Role({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isSystem,
    @Default([]) List<String> permissions,
    @Default(0) int userCount,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}

/// `GET /api/admin/settings` item. `value` is typed by [type].
@freezed
abstract class SettingItem with _$SettingItem {
  const SettingItem._();

  const factory SettingItem({
    required String key,
    Object? value,
    @Default('string') String type,
    @Default('general') String group,
    String? labelEn,
    String? labelAr,
    @Default(1) int version,
    @StringishConverter() String? updatedBy,
    @LenientDateConverter() DateTime? updatedAt,
  }) = _SettingItem;

  factory SettingItem.fromJson(Map<String, dynamic> json) => _$SettingItemFromJson(json);

  String label(bool arabic) => (arabic ? labelAr : labelEn) ?? labelEn ?? key;
}

@freezed
abstract class SettingVersion with _$SettingVersion {
  const factory SettingVersion({
    required int version,
    Object? value,
    @StringishConverter() String? updatedBy,
    @LenientDateConverter() DateTime? updatedAt,
    String? reason,
  }) = _SettingVersion;

  factory SettingVersion.fromJson(Map<String, dynamic> json) => _$SettingVersionFromJson(json);
}

/// `GET /api/admin/flags` item. `kind`: flag | killswitch | maintenance.
@freezed
abstract class FlagItem with _$FlagItem {
  const FlagItem._();

  const factory FlagItem({
    required String key,
    @Default('flag') String kind,
    @Default(false) bool enabled,
    int? rolloutPercent,
    @Default([]) List<String> roles,
    String? description,
    @StringishConverter() String? updatedBy,
    @LenientDateConverter() DateTime? updatedAt,
  }) = _FlagItem;

  factory FlagItem.fromJson(Map<String, dynamic> json) => _$FlagItemFromJson(json);

  bool get isKillSwitch => kind == 'killswitch';
  bool get isMaintenance => kind == 'maintenance';
}

/// `GET /api/admin/integrations` item.
@freezed
abstract class Integration with _$Integration {
  const factory Integration({
    required String id,
    required String name,
    @Default('unconfigured') String status,
    int? latencyMs,
    @LenientDateConverter() DateTime? checkedAt,
    @Default('sandbox') String mode,
    @Default(false) bool enabled,
    String? keyHint,
    String? detail,
  }) = _Integration;

  factory Integration.fromJson(Map<String, dynamic> json) => _$IntegrationFromJson(json);
}

@freezed
abstract class Approval with _$Approval {
  const factory Approval({
    required String id,
    required String action,
    String? summary,
    Object? payload,
    @StringishConverter() String? requestedBy,
    @LenientDateConverter() DateTime? requestedAt,
    @Default('pending') String status,
    @StringishConverter() String? decidedBy,
    @LenientDateConverter() DateTime? decidedAt,
    String? decisionNote,
  }) = _Approval;

  factory Approval.fromJson(Map<String, dynamic> json) => _$ApprovalFromJson(json);
}

/// `AuditEvent = { id, actor, actorRole, action, entityType, entityId,
/// before?, after?, reason?, device?, correlationId?, timestamp }`
@freezed
abstract class AuditEvent with _$AuditEvent {
  const factory AuditEvent({
    required String id,
    @StringishConverter() String? actor,
    String? actorRole,
    required String action,
    String? entityType,
    @StringishConverter() String? entityId,
    Object? before,
    Object? after,
    String? reason,
    @StringishConverter() String? device,
    String? correlationId,
    @LenientDateConverter() DateTime? timestamp,
  }) = _AuditEvent;

  factory AuditEvent.fromJson(Map<String, dynamic> json) => _$AuditEventFromJson(json);
}

/// `GET /api/search` item.
@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String type,
    required String id,
    required String title,
    String? subtitle,
    String? route,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
