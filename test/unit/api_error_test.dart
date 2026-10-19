import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiError.fromResponse (RFC7807)', () {
    test('approval-required carries approvalId and correlationId', () {
      final e = ApiError.fromResponse(403, {
        'type': 'https://dahab.travel/problems/approval-required',
        'title': 'Approval required',
        'status': 403,
        'detail': 'Queued for a second admin',
        'instance': '/api/operations/refund',
        'correlationId': 'c-123',
        'approvalId': 'ap_9',
      });
      expect(e.kind, ApiErrorKind.approvalRequired);
      expect(e.isApprovalRequired, isTrue);
      expect(e.approvalId, 'ap_9');
      expect(e.correlationId, 'c-123');
      expect(e.title, 'Approval required');
      expect(e.detail, 'Queued for a second admin');
      expect(e.instance, '/api/operations/refund');
      expect(e.suggestsStalePermissions, isFalse);
    });

    test('kill-switch, maintenance and view-as types win over status', () {
      expect(ApiError.fromResponse(503, {'type': '/problems/kill-switch'}).kind,
          ApiErrorKind.killSwitch);
      expect(ApiError.fromResponse(503, {'type': 'maintenance'}).kind, ApiErrorKind.maintenance);
      expect(ApiError.fromResponse(403, {'type': 'x/view-as-readonly'}).kind,
          ApiErrorKind.viewAsReadonly);
    });

    test('falls back to status codes', () {
      expect(ApiError.fromResponse(401, null).kind, ApiErrorKind.unauthorized);
      expect(ApiError.fromResponse(403, {'type': 'forbidden'}).kind, ApiErrorKind.forbidden);
      expect(ApiError.fromResponse(403, {}).suggestsStalePermissions, isTrue);
      expect(ApiError.fromResponse(404, {}).kind, ApiErrorKind.notFound);
      expect(ApiError.fromResponse(409, {}).kind, ApiErrorKind.conflict);
      expect(ApiError.fromResponse(400, {}).kind, ApiErrorKind.validation);
      expect(ApiError.fromResponse(422, {}).kind, ApiErrorKind.validation);
      expect(ApiError.fromResponse(503, {}).kind, ApiErrorKind.maintenance);
      expect(ApiError.fromResponse(500, {}).kind, ApiErrorKind.server);
      expect(ApiError.fromResponse(418, {}).kind, ApiErrorKind.unknown);
    });

    test('legacy { error, message } shape maps to title/detail', () {
      final e = ApiError.fromResponse(400, {'error': 'Bad', 'message': 'Missing reason'});
      expect(e.title, 'Bad');
      expect(e.detail, 'Missing reason');
    });

    test('correlation id falls back to response headers', () {
      final headers = Headers.fromMap({
        'x-correlation-id': ['h-1'],
      });
      expect(ApiError.fromResponse(500, {}, headers: headers).correlationId, 'h-1');
    });
  });

  group('ApiError.fromDio', () {
    final ro = RequestOptions(path: '/x');

    test('transport failures', () {
      expect(ApiError.fromDio(DioException.connectionTimeout(
              requestOptions: ro, timeout: const Duration(seconds: 1)))
          .kind, ApiErrorKind.timeout);
      expect(ApiError.fromDio(DioException.connectionError(requestOptions: ro, reason: 'x')).kind,
          ApiErrorKind.network);
      expect(ApiError.fromDio(DioException.requestCancelled(requestOptions: ro, reason: 'x')).kind,
          ApiErrorKind.cancelled);
      expect(const ApiError(kind: ApiErrorKind.network).isOffline, isTrue);
    });

    test('bad response is parsed as a problem body', () {
      final e = ApiError.fromDio(DioException.badResponse(
        statusCode: 403,
        requestOptions: ro,
        response: Response<dynamic>(
          requestOptions: ro,
          statusCode: 403,
          data: {'type': 'approval-required', 'approvalId': 'a1'},
        ),
      ));
      expect(e.kind, ApiErrorKind.approvalRequired);
      expect(e.approvalId, 'a1');
    });

    test('from() passes ApiError through and wraps other errors', () {
      const original = ApiError(kind: ApiErrorKind.conflict);
      expect(ApiError.from(original), same(original));
      expect(ApiError.from(StateError('boom')).kind, ApiErrorKind.unknown);
    });
  });
}
