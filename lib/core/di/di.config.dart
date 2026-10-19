// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dahab_ops/core/api/api_client.dart' as _i1045;
import 'package:dahab_ops/core/api/auth_events.dart' as _i748;
import 'package:dahab_ops/core/api/token_store.dart' as _i946;
import 'package:dahab_ops/core/connectivity/connectivity_cubit.dart' as _i739;
import 'package:dahab_ops/core/di/app_module.dart' as _i930;
import 'package:dahab_ops/core/platform/biometric_service.dart' as _i161;
import 'package:dahab_ops/core/platform/device_info_service.dart' as _i684;
import 'package:dahab_ops/core/preferences/preferences_cubit.dart' as _i217;
import 'package:dahab_ops/core/realtime/realtime_service.dart' as _i699;
import 'package:dahab_ops/core/router/app_router.dart' as _i562;
import 'package:dahab_ops/core/router/auth_guard.dart' as _i975;
import 'package:dahab_ops/core/storage/key_value_store.dart' as _i124;
import 'package:dahab_ops/env/env.dart' as _i419;
import 'package:dahab_ops/features/access/data/access_repository.dart' as _i740;
import 'package:dahab_ops/features/access/presentation/session_cubit.dart'
    as _i250;
import 'package:dahab_ops/features/access/presentation/user_detail_cubit.dart'
    as _i152;
import 'package:dahab_ops/features/access/presentation/users_cubit.dart'
    as _i12;
import 'package:dahab_ops/features/auth/data/auth_repository.dart' as _i394;
import 'package:dahab_ops/features/auth/presentation/app_lock/app_lock_cubit.dart'
    as _i533;
import 'package:dahab_ops/features/auth/presentation/login/login_cubit.dart'
    as _i210;
import 'package:dahab_ops/features/booking/data/booking_repository.dart'
    as _i84;
import 'package:dahab_ops/features/booking/presentation/booking_detail_cubit.dart'
    as _i609;
import 'package:dahab_ops/features/cms/cms_repository.dart' as _i691;
import 'package:dahab_ops/features/cms/content_repository.dart' as _i76;
import 'package:dahab_ops/features/control/data/control_repository.dart'
    as _i85;
import 'package:dahab_ops/features/control/presentation/control_cubit.dart'
    as _i459;
import 'package:dahab_ops/features/ops/commerce/commerce_repository.dart'
    as _i788;
import 'package:dahab_ops/features/ops/dining/dining_repository.dart' as _i841;
import 'package:dahab_ops/features/ops/exceptions/exceptions_repository.dart'
    as _i1042;
import 'package:dahab_ops/features/ops/insight/insight_repository.dart'
    as _i768;
import 'package:dahab_ops/features/ops/live/live_repository.dart' as _i937;
import 'package:dahab_ops/features/ops/messaging/messaging_repository.dart'
    as _i499;
import 'package:dahab_ops/features/ops/pricing/pricing_repository.dart'
    as _i513;
import 'package:dahab_ops/features/ops/stays/stays_repository.dart' as _i702;
import 'package:dahab_ops/features/ops/suppliers/suppliers_repository.dart'
    as _i799;
import 'package:dahab_ops/features/ops/support/support_repository.dart'
    as _i300;
import 'package:dahab_ops/features/ops/system/system_repository.dart' as _i911;
import 'package:dahab_ops/features/pulse/data/overview_repository.dart'
    as _i529;
import 'package:dahab_ops/features/pulse/presentation/pulse_cubit.dart'
    as _i447;
import 'package:dahab_ops/features/queue/data/queue_repository.dart' as _i844;
import 'package:dahab_ops/features/queue/presentation/queue_cubit.dart'
    as _i858;
import 'package:dahab_ops/features/refund/data/refund_repository.dart' as _i348;
import 'package:dahab_ops/features/search/data/search_repository.dart' as _i268;
import 'package:dahab_ops/features/supplier/data/supplier_portal_repository.dart'
    as _i854;
import 'package:dahab_ops/features/supplier/data/supplier_repository.dart'
    as _i301;
import 'package:dahab_ops/features/supplier/presentation/supplier_inbox_cubit.dart'
    as _i264;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.singleton<_i419.EnvConfig>(() => appModule.env);
    gh.singleton<_i124.KeyValueStore>(() => appModule.keyValueStore);
    gh.singleton<_i748.AuthEvents>(() => appModule.authEvents);
    gh.singleton<_i684.DeviceInfoService>(() => appModule.deviceInfo);
    gh.singleton<_i161.BiometricService>(() => appModule.biometrics);
    gh.singleton<_i895.Connectivity>(() => appModule.connectivity);
    gh.singleton<_i361.Dio>(
      () => appModule.refreshDio(gh<_i419.EnvConfig>()),
      instanceName: 'refresh',
    );
    gh.singleton<_i533.AppLockCubit>(
      () => appModule.appLock(gh<_i161.BiometricService>()),
    );
    gh.singleton<_i946.TokenStore>(
      () => appModule.tokenStore(gh<_i124.KeyValueStore>()),
    );
    gh.singleton<_i217.PreferencesCubit>(
      () => appModule.preferences(gh<_i124.KeyValueStore>()),
    );
    gh.singleton<_i361.Dio>(
      () => appModule.dio(
        gh<_i419.EnvConfig>(),
        gh<_i946.TokenStore>(),
        gh<_i361.Dio>(instanceName: 'refresh'),
        gh<_i748.AuthEvents>(),
      ),
    );
    gh.singleton<_i739.ConnectivityCubit>(
      () => appModule.connectivityCubit(gh<_i895.Connectivity>()),
    );
    gh.singleton<_i1045.ApiClient>(() => appModule.apiClient(gh<_i361.Dio>()));
    gh.singleton<_i699.RealtimeService>(
      () => appModule.realtime(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i394.AuthRepository>(
      () => _i394.AuthRepository(
        gh<_i1045.ApiClient>(),
        gh<_i946.TokenStore>(),
        gh<_i684.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i250.SessionCubit>(
      () =>
          appModule.session(gh<_i394.AuthRepository>(), gh<_i748.AuthEvents>()),
    );
    gh.lazySingleton<_i529.OverviewRepository>(
      () => _i529.OverviewRepository(
        gh<_i1045.ApiClient>(),
        gh<_i124.KeyValueStore>(),
      ),
    );
    gh.lazySingleton<_i740.AccessRepository>(
      () => _i740.AccessRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i84.BookingRepository>(
      () => _i84.BookingRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i691.CmsRepository>(
      () => _i691.CmsRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i76.ContentRepository>(
      () => _i76.ContentRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i85.ControlRepository>(
      () => _i85.ControlRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i788.CommerceRepository>(
      () => _i788.CommerceRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i841.DiningRepository>(
      () => _i841.DiningRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i1042.ExceptionsRepository>(
      () => _i1042.ExceptionsRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i768.InsightRepository>(
      () => _i768.InsightRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i937.LiveRepository>(
      () => _i937.LiveRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i499.MessagingRepository>(
      () => _i499.MessagingRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i513.PricingRepository>(
      () => _i513.PricingRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i702.StaysRepository>(
      () => _i702.StaysRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i799.SuppliersRepository>(
      () => _i799.SuppliersRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i300.SupportRepository>(
      () => _i300.SupportRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i911.SystemRepository>(
      () => _i911.SystemRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i844.QueueRepository>(
      () => _i844.QueueRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i348.RefundRepository>(
      () => _i348.RefundRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i268.SearchRepository>(
      () => _i268.SearchRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i854.SupplierPortalRepository>(
      () => _i854.SupplierPortalRepository(gh<_i1045.ApiClient>()),
    );
    gh.lazySingleton<_i301.SupplierRepository>(
      () => _i301.SupplierRepository(gh<_i1045.ApiClient>()),
    );
    gh.factory<_i264.SupplierInboxCubit>(
      () => _i264.SupplierInboxCubit(gh<_i301.SupplierRepository>()),
    );
    gh.factory<_i447.PulseCubit>(
      () => _i447.PulseCubit(
        gh<_i529.OverviewRepository>(),
        gh<_i844.QueueRepository>(),
        gh<_i699.RealtimeService>(),
      ),
    );
    gh.factory<_i858.QueueCubit>(
      () => _i858.QueueCubit(
        gh<_i844.QueueRepository>(),
        gh<_i699.RealtimeService>(),
      ),
    );
    gh.factory<_i12.UsersCubit>(
      () => _i12.UsersCubit(gh<_i740.AccessRepository>()),
    );
    gh.factory<_i210.LoginCubit>(
      () => _i210.LoginCubit(
        gh<_i394.AuthRepository>(),
        gh<_i250.SessionCubit>(),
        gh<_i161.BiometricService>(),
        gh<_i684.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i975.AuthGuard>(
      () => appModule.authGuard(gh<_i250.SessionCubit>()),
    );
    gh.factory<_i609.BookingDetailCubit>(
      () => _i609.BookingDetailCubit(gh<_i84.BookingRepository>()),
    );
    gh.factory<_i459.ControlCubit>(
      () => _i459.ControlCubit(gh<_i85.ControlRepository>()),
    );
    gh.factory<_i152.UserDetailCubit>(
      () => _i152.UserDetailCubit(
        gh<_i740.AccessRepository>(),
        gh<_i85.ControlRepository>(),
      ),
    );
    gh.singleton<_i562.AppRouter>(
      () => appModule.appRouter(gh<_i975.AuthGuard>()),
    );
    return this;
  }
}

class _$AppModule extends _i930.AppModule {}
