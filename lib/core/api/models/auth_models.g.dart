// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  role: json['role'] as String? ?? 'Traveler',
  supplierId: json['supplierId'] as String?,
  status: json['status'] as String? ?? 'active',
  createdAt: const LenientDateConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': ?instance.name,
  'phone': ?instance.phone,
  'role': instance.role,
  'supplierId': ?instance.supplierId,
  'status': instance.status,
  'createdAt': ?const LenientDateConverter().toJson(instance.createdAt),
};

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  id: json['id'] as String,
  userId: json['userId'] as String?,
  role: json['role'] as String?,
  expiresAt: const LenientDateConverter().fromJson(json['expiresAt']),
  token: json['token'] as String?,
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'id': instance.id,
  'userId': ?instance.userId,
  'role': ?instance.role,
  'expiresAt': ?const LenientDateConverter().toJson(instance.expiresAt),
  'token': ?instance.token,
};

_ViewAs _$ViewAsFromJson(Map<String, dynamic> json) =>
    _ViewAs(userId: json['userId'] as String, email: json['email'] as String);

Map<String, dynamic> _$ViewAsToJson(_ViewAs instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
};

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      success: json['success'] as bool? ?? true,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      session: json['session'] == null
          ? null
          : Session.fromJson(json['session'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      accessTokenExpiresAt: const LenientDateConverter().fromJson(
        json['accessTokenExpiresAt'],
      ),
      refreshToken: json['refreshToken'] as String,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      flags:
          (json['flags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'user': instance.user.toJson(),
      'session': ?instance.session?.toJson(),
      'accessToken': instance.accessToken,
      'accessTokenExpiresAt': ?const LenientDateConverter().toJson(
        instance.accessTokenExpiresAt,
      ),
      'refreshToken': instance.refreshToken,
      'permissions': instance.permissions,
      'flags': instance.flags,
    };

_MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => _MeResponse(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  session: json['session'] == null
      ? null
      : Session.fromJson(json['session'] as Map<String, dynamic>),
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  flags:
      (json['flags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const {},
  viewAs: json['viewAs'] == null
      ? null
      : ViewAs.fromJson(json['viewAs'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MeResponseToJson(_MeResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'session': ?instance.session?.toJson(),
      'permissions': instance.permissions,
      'flags': instance.flags,
      'viewAs': ?instance.viewAs?.toJson(),
    };

_DeviceSession _$DeviceSessionFromJson(Map<String, dynamic> json) =>
    _DeviceSession(
      id: json['id'] as String,
      name: json['name'] as String?,
      platform: json['platform'] as String?,
      lastSeenAt: const LenientDateConverter().fromJson(json['lastSeenAt']),
      createdAt: const LenientDateConverter().fromJson(json['createdAt']),
      current: json['current'] as bool? ?? false,
    );

Map<String, dynamic> _$DeviceSessionToJson(_DeviceSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': ?instance.name,
      'platform': ?instance.platform,
      'lastSeenAt': ?const LenientDateConverter().toJson(instance.lastSeenAt),
      'createdAt': ?const LenientDateConverter().toJson(instance.createdAt),
      'current': instance.current,
    };
