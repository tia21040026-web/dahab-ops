/// Build environments.
///
/// Pick one at build time:
///   fvm flutter run --dart-define=DAHAB_ENV=staging
/// Override the API origin for any environment (e.g. a LAN IP for a device):
///   fvm flutter run --dart-define=DAHAB_API_BASE=http://192.168.1.20:3000
enum AppEnvironment { dev, staging, prod }

class EnvConfig {
  const EnvConfig({
    required this.environment,
    required this.apiBase,
    required this.webBase,
    this.logHttp = false,
  });

  final AppEnvironment environment;

  /// Origin only (no `/api`); paths in the app start with `/api/...`.
  final String apiBase;

  /// Web command center origin, used for "open on the web" links.
  final String webBase;
  final bool logHttp;

  bool get isProd => environment == AppEnvironment.prod;

  /// Android emulator reaches the host machine on 10.0.2.2.
  static const dev = EnvConfig(
    environment: AppEnvironment.dev,
    apiBase: 'http://10.0.2.2:3000',
    webBase: 'http://10.0.2.2:3000',
    logHttp: true,
  );

  static const staging = EnvConfig(
    environment: AppEnvironment.staging,
    apiBase: 'https://staging.dahab.travel',
    webBase: 'https://staging.dahab.travel',
  );

  static const prod = EnvConfig(
    environment: AppEnvironment.prod,
    apiBase: 'https://dahab.travel',
    webBase: 'https://dahab.travel',
  );

  static const _envName = String.fromEnvironment('DAHAB_ENV', defaultValue: 'dev');
  static const _apiOverride = String.fromEnvironment('DAHAB_API_BASE');

  static EnvConfig fromDefines() {
    final base = switch (_envName) {
      'prod' || 'production' => prod,
      'staging' => staging,
      _ => dev,
    };
    if (_apiOverride.isEmpty) return base;
    return EnvConfig(
      environment: base.environment,
      apiBase: _apiOverride,
      webBase: _apiOverride,
      logHttp: base.logHttp,
    );
  }
}
