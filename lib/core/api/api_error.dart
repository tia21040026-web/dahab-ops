import 'dart:io';

import 'package:dio/dio.dart';

/// What went wrong, in terms the UI can act on.
enum ApiErrorKind {
  network,
  timeout,
  cancelled,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  approvalRequired,
  killSwitch,
  maintenance,
  viewAsReadonly,
  server,
  unknown,
}

/// RFC7807 problem details (`{ type, title, status, detail, instance,
/// correlationId }`) mapped to an [ApiErrorKind].
class ApiError implements Exception {
  const ApiError({
    required this.kind,
    this.status,
    this.type,
    this.title,
    this.detail,
    this.instance,
    this.correlationId,
    this.approvalId,
    this.body,
  });

  final ApiErrorKind kind;
  final int? status;
  final String? type;
  final String? title;
  final String? detail;
  final String? instance;
  final String? correlationId;

  /// Set when the action was queued for a second admin (403 approval-required).
  final String? approvalId;
  final Object? body;

  bool get isApprovalRequired => kind == ApiErrorKind.approvalRequired;
  bool get isOffline => kind == ApiErrorKind.network || kind == ApiErrorKind.timeout;

  /// Whether a 403 means "your permissions changed" rather than a policy
  /// answer (approval queue, view-as) that refreshing would not fix.
  bool get suggestsStalePermissions =>
      kind == ApiErrorKind.forbidden && status == 403;

  static ApiErrorKind _kindFromType(String? type, int? status) {
    final t = type ?? '';
    if (t.endsWith('/approval-required') || t == 'approval-required') {
      return ApiErrorKind.approvalRequired;
    }
    if (t.endsWith('/kill-switch') || t == 'kill-switch') return ApiErrorKind.killSwitch;
    if (t.endsWith('/maintenance') || t == 'maintenance') return ApiErrorKind.maintenance;
    if (t.endsWith('/view-as-readonly') || t == 'view-as-readonly') {
      return ApiErrorKind.viewAsReadonly;
    }
    return switch (status) {
      401 => ApiErrorKind.unauthorized,
      403 => ApiErrorKind.forbidden,
      404 => ApiErrorKind.notFound,
      409 => ApiErrorKind.conflict,
      400 || 422 => ApiErrorKind.validation,
      503 => ApiErrorKind.maintenance,
      final s? when s >= 500 => ApiErrorKind.server,
      _ => ApiErrorKind.unknown,
    };
  }

  /// Parses a problem body. Accepts the RFC7807 shape and the older
  /// `{ error, message }` shape some endpoints still return.
  factory ApiError.fromResponse(int? status, Object? data, {Headers? headers}) {
    final map = data is Map ? data.cast<String, dynamic>() : const <String, dynamic>{};
    final type = map['type'] as String?;
    String? str(Object? v) => v?.toString();
    return ApiError(
      kind: _kindFromType(type, status),
      status: status ?? (map['status'] is int ? map['status'] as int : null),
      type: type,
      title: str(map['title'] ?? map['error']),
      detail: str(map['detail'] ?? map['message']),
      instance: str(map['instance']),
      correlationId: str(map['correlationId']) ??
          headers?.value('x-correlation-id') ??
          headers?.value('x-request-id'),
      approvalId: str(map['approvalId']),
      body: data,
    );
  }

  factory ApiError.fromDio(DioException e) {
    final inner = e.error;
    if (inner is ApiError) return inner;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiError(kind: ApiErrorKind.timeout);
      case DioExceptionType.cancel:
        return const ApiError(kind: ApiErrorKind.cancelled);
      case DioExceptionType.connectionError:
        return const ApiError(kind: ApiErrorKind.network);
      case DioExceptionType.badResponse:
        final r = e.response;
        return ApiError.fromResponse(r?.statusCode, r?.data, headers: r?.headers);
      case DioExceptionType.badCertificate:
        return const ApiError(kind: ApiErrorKind.network, title: 'bad-certificate');
      case DioExceptionType.unknown:
        if (inner is SocketException || inner is HttpException) {
          return const ApiError(kind: ApiErrorKind.network);
        }
        return ApiError(kind: ApiErrorKind.unknown, detail: e.message);
    }
  }

  static ApiError from(Object error) {
    if (error is ApiError) return error;
    if (error is DioException) return ApiError.fromDio(error);
    return ApiError(kind: ApiErrorKind.unknown, detail: error.toString());
  }

  @override
  String toString() => 'ApiError($kind, status: $status, type: $type, '
      'detail: $detail, correlationId: $correlationId)';
}
