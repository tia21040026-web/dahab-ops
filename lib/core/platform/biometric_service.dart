import 'package:local_auth/local_auth.dart';

/// Biometric checks for app lock and dangerous confirmations.
abstract class BiometricService {
  Future<bool> isAvailable();

  /// True when the person passed (or the device has no biometrics and
  /// [requireHardware] is false).
  Future<bool> authenticate(String reason, {bool requireHardware = false});
}

class LocalAuthBiometricService implements BiometricService {
  LocalAuthBiometricService([LocalAuthentication? auth]) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason, {bool requireHardware = false}) async {
    if (!await isAvailable()) return !requireHardware;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }
}

/// Always passes. Used in tests and on simulators.
class NoopBiometricService implements BiometricService {
  const NoopBiometricService({this.available = false, this.result = true});

  final bool available;
  final bool result;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason, {bool requireHardware = false}) async => result;
}
