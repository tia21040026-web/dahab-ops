import '../storage/key_value_store.dart';

class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.accessTokenExpiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? accessTokenExpiresAt;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        accessTokenExpiresAt: DateTime.tryParse('${json['accessTokenExpiresAt']}'),
      );
}

/// Holds the native token pair. Reads go to memory; writes go through to
/// secure storage so a cold start can restore the session.
class TokenStore {
  TokenStore(this._store);

  static const _kAccess = 'auth.accessToken';
  static const _kRefresh = 'auth.refreshToken';
  static const _kExpires = 'auth.accessTokenExpiresAt';

  final KeyValueStore _store;
  AuthTokens? _cache;
  bool _loaded = false;

  AuthTokens? get current => _cache;
  String? get accessToken => _cache?.accessToken;
  String? get refreshToken => _cache?.refreshToken;

  Future<AuthTokens?> load() async {
    if (_loaded) return _cache;
    final access = await _store.read(_kAccess);
    final refresh = await _store.read(_kRefresh);
    final expires = await _store.read(_kExpires);
    _loaded = true;
    if (access == null || refresh == null) return _cache = null;
    return _cache = AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      accessTokenExpiresAt: expires == null ? null : DateTime.tryParse(expires),
    );
  }

  Future<void> save(AuthTokens tokens) async {
    _cache = tokens;
    _loaded = true;
    await _store.write(_kAccess, tokens.accessToken);
    await _store.write(_kRefresh, tokens.refreshToken);
    await _store.write(_kExpires, tokens.accessTokenExpiresAt?.toIso8601String());
  }

  Future<void> clear() async {
    _cache = null;
    _loaded = true;
    await _store.delete(_kAccess);
    await _store.delete(_kRefresh);
    await _store.delete(_kExpires);
  }
}
