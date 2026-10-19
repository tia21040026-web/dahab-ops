import 'package:injectable/injectable.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_error.dart';
import '../../../core/api/models/auth_models.dart';
import '../../../core/api/token_store.dart';
import '../../../core/platform/device_info_service.dart';

/// Native auth against the ops contract (§ Auth).
@lazySingleton
class AuthRepository {
  AuthRepository(this._api, this._tokens, this._device);

  final ApiClient _api;
  final TokenStore _tokens;
  final DeviceInfoService _device;

  Future<bool> hasStoredSession() async => (await _tokens.load()) != null;

  Future<LoginResponse> login({required String email, required String password}) async {
    final device = await _device.describe();
    final json = await _api.post('/api/auth/login', body: {
      'email': email.trim(),
      'password': password,
      'device': {'name': device.name, 'platform': device.platform},
    });
    if (json['accessToken'] == null || json['refreshToken'] == null) {
      // A web-shaped response means the native header did not reach the server.
      throw const ApiError(kind: ApiErrorKind.unknown, detail: 'native tokens missing');
    }
    final r = LoginResponse.fromJson(json);
    await _tokens.save(AuthTokens(
      accessToken: r.accessToken,
      refreshToken: r.refreshToken,
      accessTokenExpiresAt: r.accessTokenExpiresAt,
    ));
    return r;
  }

  Future<MeResponse> me() async => MeResponse.fromJson(await _api.get('/api/auth/me'));

  /// Best effort server sign-out, then always clears local tokens.
  Future<void> logout() async {
    try {
      await _api.post('/api/auth/logout', body: {
        if (_tokens.refreshToken != null) 'refreshToken': _tokens.refreshToken,
      });
    } on ApiError catch (_) {
      // Offline or already expired: local sign-out still happens.
    } finally {
      await _tokens.clear();
    }
  }

  Future<void> clearLocal() => _tokens.clear();

  Future<List<DeviceSession>> devices() async {
    final json = await _api.get('/api/auth/devices');
    final items = (json['items'] as List?) ?? const [];
    return items
        .whereType<Map<dynamic, dynamic>>()
        .map((e) => DeviceSession.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<void> revokeDevice(String id) => _api.delete('/api/auth/devices/$id');

  /// Registers this device session's push token (`POST /api/devices`).
  Future<void> registerPushToken(String fcmToken) async {
    final device = await _device.describe();
    await _api.post('/api/devices', body: {'fcmToken': fcmToken, 'platform': device.platform});
  }
}
