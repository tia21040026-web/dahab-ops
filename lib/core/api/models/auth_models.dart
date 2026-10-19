import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// `User = { id, email, name, phone, role, supplierId?, status, createdAt }`
@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    String? name,
    String? phone,
    @Default('Traveler') String role,
    String? supplierId,
    @Default('active') String status,
    @LenientDateConverter() DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get displayName => (name == null || name!.trim().isEmpty) ? email : name!;
  bool get isSuspended => status == 'suspended';
  bool get isSupplier => role == 'Supplier';
  bool get isAdmin => role == 'Admin';

  String get initials {
    final source = displayName.trim();
    if (source.isEmpty) return '?';
    final parts = source.split(RegExp(r'[\s@._-]+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return (parts[0][0] + parts[1][0]).toUpperCase();
    return source.substring(0, source.length >= 2 ? 2 : 1).toUpperCase();
  }
}

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    String? userId,
    String? role,
    @LenientDateConverter() DateTime? expiresAt,
    String? token,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}

@freezed
abstract class ViewAs with _$ViewAs {
  const factory ViewAs({required String userId, required String email}) = _ViewAs;

  factory ViewAs.fromJson(Map<String, dynamic> json) => _$ViewAsFromJson(json);
}

/// `POST /api/auth/login` (native).
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @Default(true) bool success,
    required User user,
    Session? session,
    required String accessToken,
    @LenientDateConverter() DateTime? accessTokenExpiresAt,
    required String refreshToken,
    @Default([]) List<String> permissions,
    @Default({}) Map<String, bool> flags,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}

/// `GET /api/auth/me`.
@freezed
abstract class MeResponse with _$MeResponse {
  const factory MeResponse({
    required User user,
    Session? session,
    @Default([]) List<String> permissions,
    @Default({}) Map<String, bool> flags,
    ViewAs? viewAs,
  }) = _MeResponse;

  factory MeResponse.fromJson(Map<String, dynamic> json) => _$MeResponseFromJson(json);
}

/// One of the caller's device sessions (`GET /api/auth/devices`), also used
/// for a user's devices in admin detail.
@freezed
abstract class DeviceSession with _$DeviceSession {
  const factory DeviceSession({
    required String id,
    String? name,
    String? platform,
    @LenientDateConverter() DateTime? lastSeenAt,
    @LenientDateConverter() DateTime? createdAt,
    @Default(false) bool current,
  }) = _DeviceSession;

  factory DeviceSession.fromJson(Map<String, dynamic> json) => _$DeviceSessionFromJson(json);
}
