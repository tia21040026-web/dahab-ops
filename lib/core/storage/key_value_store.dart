import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small async key-value store. Production uses the platform keychain /
/// keystore; tests use [MemoryKeyValueStore].
abstract class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);
  Future<void> delete(String key);
}

class SecureKeyValueStore implements KeyValueStore {
  SecureKeyValueStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      // A keystore reset (restore from backup, OS upgrade) must not crash the
      // app; it simply means "signed out".
      return null;
    }
  }

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) return delete(key);
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class MemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete(String key) async => values.remove(key);
}
