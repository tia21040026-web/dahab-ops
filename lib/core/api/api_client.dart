import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../env/env.dart';
import 'api_error.dart';
import 'auth_events.dart';
import 'auth_interceptor.dart';
import 'idempotency.dart';
import 'models/paged.dart';
import 'retry_interceptor.dart';
import 'token_store.dart';

typedef Json = Map<String, dynamic>;

/// Dio without the auth interceptor, used for `/api/auth/refresh`.
Dio createBareDio(EnvConfig env) => Dio(BaseOptions(
      baseUrl: env.apiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'X-Dahab-Client': 'native', 'Accept': 'application/json'},
      contentType: Headers.jsonContentType,
    ));

/// The app's Dio: auth (+ single-flight refresh), retry for idempotent
/// reads, and header-free logging in dev.
Dio createApiDio({
  required EnvConfig env,
  required TokenStore tokens,
  required Dio refreshDio,
  required AuthEvents events,
}) {
  final dio = createBareDio(env);
  final auth = AuthInterceptor(tokens: tokens, refreshDio: refreshDio, events: events)
    ..attach(dio);
  final retry = RetryInterceptor()..attach(dio);
  dio.interceptors.addAll([
    auth,
    retry,
    if (env.logHttp && kDebugMode)
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        logPrint: (o) => debugPrint('[http] $o'),
      ),
  ]);
  return dio;
}

/// Thin typed wrapper. Every failure surfaces as [ApiError].
class ApiClient {
  ApiClient(this.dio);

  final Dio dio;

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      throw ApiError.fromDio(e);
    }
  }

  Json _asJson(Object? data) {
    if (data is Map) return data.cast<String, dynamic>();
    if (data == null || (data is String && data.isEmpty)) return <String, dynamic>{};
    return {'data': data};
  }

  Future<Json> get(String path, {Map<String, dynamic>? query, Options? options}) =>
      _guard(() async =>
          _asJson((await dio.get<dynamic>(path, queryParameters: query, options: options)).data));

  Future<Response<dynamic>> getRaw(String path,
          {Map<String, dynamic>? query, Options? options}) =>
      _guard(() => dio.get<dynamic>(path, queryParameters: query, options: options));

  Future<Paged<T>> getPaged<T>(
    String path, {
    required T Function(Json json) item,
    ListQuery? query,
    Map<String, dynamic>? extra,
  }) async {
    final json = await get(path, query: {...?query?.toQuery(), ...?extra});
    return Paged<T>.fromJson(json, (o) => item((o as Map).cast<String, dynamic>()));
  }

  /// Mutations. Pass [idempotencyKey] for dangerous actions (money / messages)
  /// so a retry of the same intent is replayed, not repeated.
  Future<Json> post(String path, {Object? body, String? idempotencyKey}) => _guard(() async =>
      _asJson((await dio.post<dynamic>(path, data: body, options: _opts(idempotencyKey))).data));

  /// Like [post] but returns the raw response (headers such as
  /// `Idempotent-Replay`).
  Future<Response<dynamic>> postRaw(String path, {Object? body, String? idempotencyKey}) =>
      _guard(() => dio.post<dynamic>(path, data: body, options: _opts(idempotencyKey)));

  Future<Json> put(String path, {Object? body, String? idempotencyKey}) => _guard(() async =>
      _asJson((await dio.put<dynamic>(path, data: body, options: _opts(idempotencyKey))).data));

  Future<Json> patch(String path, {Object? body, String? idempotencyKey}) => _guard(() async =>
      _asJson((await dio.patch<dynamic>(path, data: body, options: _opts(idempotencyKey))).data));

  Future<Json> delete(String path, {Object? body, String? idempotencyKey}) => _guard(() async =>
      _asJson((await dio.delete<dynamic>(path, data: body, options: _opts(idempotencyKey))).data));

  Options? _opts(String? key) => key == null ? null : Idempotency.options(key: key);
}
