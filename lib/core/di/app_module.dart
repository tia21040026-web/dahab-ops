import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../env/env.dart';
import '../../features/access/presentation/session_cubit.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/app_lock/app_lock_cubit.dart';
import '../api/api_client.dart';
import '../api/auth_events.dart';
import '../api/token_store.dart';
import '../connectivity/connectivity_cubit.dart';
import '../platform/biometric_service.dart';
import '../platform/device_info_service.dart';
import '../preferences/preferences_cubit.dart';
import '../realtime/realtime_service.dart';
import '../router/app_router.dart';
import '../router/auth_guard.dart';
import '../storage/key_value_store.dart';

/// Third-party and app-wide singletons.
@module
abstract class AppModule {
  @singleton
  EnvConfig get env => EnvConfig.fromDefines();

  @singleton
  KeyValueStore get keyValueStore => SecureKeyValueStore();

  @singleton
  TokenStore tokenStore(KeyValueStore store) => TokenStore(store);

  @singleton
  AuthEvents get authEvents => AuthEvents();

  @Named('refresh')
  @singleton
  Dio refreshDio(EnvConfig env) => createBareDio(env);

  @singleton
  Dio dio(EnvConfig env, TokenStore tokens, @Named('refresh') Dio refreshDio, AuthEvents events) =>
      createApiDio(env: env, tokens: tokens, refreshDio: refreshDio, events: events);

  @singleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);

  @singleton
  RealtimeService realtime(Dio dio) => RealtimeService(dio);

  @singleton
  DeviceInfoService get deviceInfo => PluginDeviceInfoService();

  @singleton
  BiometricService get biometrics => LocalAuthBiometricService();

  @singleton
  Connectivity get connectivity => Connectivity();

  @singleton
  SessionCubit session(AuthRepository auth, AuthEvents events) => SessionCubit(auth, events);

  @singleton
  PreferencesCubit preferences(KeyValueStore store) => PreferencesCubit(store);

  @singleton
  ConnectivityCubit connectivityCubit(Connectivity c) => ConnectivityCubit(c);

  @singleton
  AppLockCubit appLock(BiometricService biometrics) => AppLockCubit(biometrics);

  @singleton
  AuthGuard authGuard(SessionCubit session) => AuthGuard(session);

  @singleton
  AppRouter appRouter(AuthGuard guard) => AppRouter(guard: guard);
}
