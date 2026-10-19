// Dart does not allow a private name as a named parameter, so the private
// fields below cannot be initializing formals (`this._tokens`). The explicit
// assignments are the only way to keep them private.
// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:dio/dio.dart';

import 'api_error.dart';
import 'auth_events.dart';
import 'token_store.dart';

/// Native auth for every request.
///
/// * Sends `X-Dahab-Client: native` and `Authorization: Bearer <access>`.
/// * On 401 it refreshes once (single flight: concurrent 401s share one
///   `POST /api/auth/refresh`), then replays the request with the new token.
/// * If refresh is rejected the tokens are cleared and [AuthEvent.loggedOut]
///   is emitted. A refresh that fails because the network is down keeps the
///   session: the user is offline, not signed out.
/// * A plain 403 emits [AuthEvent.permissionsStale] so the session re-reads
///   `/api/auth/me`. Policy 403s (approval queue, view-as) do not.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStore tokens,
    required Dio refreshDio,
    required AuthEvents events,
  }) : _tokens = tokens, _refreshDio = refreshDio, _events = events;

  static const refreshPath = '/api/auth/refresh';
  static const skipAuthKey = 'dahab.skipAuth';
  static const retriedKey = 'dahab.authRetried';

  final TokenStore _tokens;
  final Dio _refreshDio;
  final AuthEvents _events;

  /// The client requests are replayed on (the one this interceptor is on).
  Dio? _owner;
  Future<_RefreshOutcome>? _inflight;

  void attach(Dio owner) => _owner = owner;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Dahab-Client'] = 'native';
    final token = _tokens.accessToken;
    if (options.extra[skipAuthKey] != true && token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final req = err.requestOptions;

    if (status == 401 &&
        req.extra[skipAuthKey] != true &&
        req.extra[retriedKey] != true &&
        !req.path.endsWith(refreshPath)) {
      final sent = req.headers['Authorization'] as String?;
      final outcome = await _refreshSingleFlight(sent);
      if (outcome.tokens == null) {
        if (outcome.fatal) {
          await _tokens.clear();
          _events.emit(AuthEvent.loggedOut);
        }
        return handler.next(err);
      }
      final replay = req.copyWith(
        headers: {...req.headers, 'Authorization': 'Bearer ${outcome.tokens!.accessToken}'},
        extra: {...req.extra, retriedKey: true},
      );
      try {
        final owner = _owner;
        if (owner == null) return handler.next(err);
        final response = await owner.fetch<dynamic>(replay);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    if (status == 403) {
      final apiError = ApiError.fromResponse(status, err.response?.data);
      if (apiError.kind == ApiErrorKind.forbidden) {
        _events.emit(AuthEvent.permissionsStale);
      }
    }
    handler.next(err);
  }

  Future<_RefreshOutcome> _refreshSingleFlight(String? sentAuthorization) {
    // A refresh already finished after this request left: reuse its token.
    final current = _tokens.current;
    if (_inflight == null &&
        current != null &&
        sentAuthorization != null &&
        sentAuthorization != 'Bearer ${current.accessToken}') {
      return Future.value(_RefreshOutcome(current, fatal: false));
    }
    return _inflight ??= _refresh().whenComplete(() => _inflight = null);
  }

  Future<_RefreshOutcome> _refresh() async {
    final refreshToken = _tokens.refreshToken;
    if (refreshToken == null) return const _RefreshOutcome(null, fatal: true);
    try {
      final res = await _refreshDio.post<dynamic>(
        refreshPath,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'X-Dahab-Client': 'native'}),
      );
      final data = res.data;
      if (data is! Map) return const _RefreshOutcome(null, fatal: true);
      final tokens = AuthTokens.fromJson(data.cast<String, dynamic>());
      await _tokens.save(tokens);
      return _RefreshOutcome(tokens, fatal: false);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final rejected = code != null && code >= 400 && code < 500;
      return _RefreshOutcome(null, fatal: rejected);
    } catch (_) {
      return const _RefreshOutcome(null, fatal: true);
    }
  }
}

class _RefreshOutcome {
  const _RefreshOutcome(this.tokens, {required this.fatal});
  final AuthTokens? tokens;

  /// True when the server rejected the refresh token (session is over).
  final bool fatal;
}
