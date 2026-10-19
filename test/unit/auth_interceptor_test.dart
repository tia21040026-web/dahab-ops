import 'dart:async';

import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/core/api/auth_interceptor.dart';
import 'package:dahab_ops/core/api/token_store.dart';
import 'package:dahab_ops/core/storage/key_value_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_adapter.dart';

void main() {
  late TokenStore tokens;
  late AuthEvents events;
  late List<AuthEvent> emitted;
  late StreamSubscription<AuthEvent> sub;

  setUp(() async {
    tokens = TokenStore(MemoryKeyValueStore());
    await tokens.save(const AuthTokens(accessToken: 'old', refreshToken: 'r1'));
    events = AuthEvents();
    emitted = [];
    sub = events.stream.listen(emitted.add);
  });

  tearDown(() async {
    await sub.cancel();
    await events.dispose();
  });

  /// API that accepts only `Bearer new`.
  FakeAdapter api() => FakeAdapter((o) async {
        final auth = o.headers['Authorization'];
        if (auth == 'Bearer new') return FakeReply(200, {'ok': true, 'path': o.path});
        return const FakeReply(401, {'type': 'unauthorized', 'status': 401});
      });

  Dio build(FakeAdapter apiAdapter, FakeAdapter refreshAdapter) {
    final dio = fakeDio(apiAdapter);
    final refreshDio = fakeDio(refreshAdapter);
    final auth = AuthInterceptor(tokens: tokens, refreshDio: refreshDio, events: events)
      ..attach(dio);
    dio.interceptors.add(auth);
    return dio;
  }

  test('sends native header and bearer token', () async {
    final apiAdapter = FakeAdapter((o) async => const FakeReply(200, {'ok': true}));
    final dio = build(apiAdapter, FakeAdapter((_) async => const FakeReply(500)));
    await dio.get<dynamic>('/api/x');
    final sent = apiAdapter.requests.single;
    expect(sent.headers['X-Dahab-Client'], 'native');
    expect(sent.headers['Authorization'], 'Bearer old');
  });

  test('concurrent 401s share one refresh (single flight) and replay', () async {
    final apiAdapter = api();
    final refreshAdapter = FakeAdapter((o) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return const FakeReply(200, {'accessToken': 'new', 'refreshToken': 'r2'});
    });
    final dio = build(apiAdapter, refreshAdapter);

    final results = await Future.wait([
      dio.get<dynamic>('/api/a'),
      dio.get<dynamic>('/api/b'),
      dio.get<dynamic>('/api/c'),
    ]);

    expect(refreshAdapter.requests, hasLength(1));
    expect(refreshAdapter.requests.single.path, AuthInterceptor.refreshPath);
    expect(refreshAdapter.requests.single.data, {'refreshToken': 'r1'});
    expect(results.map((r) => r.statusCode), everyElement(200));
    expect(tokens.accessToken, 'new');
    expect(tokens.refreshToken, 'r2');
    expect(emitted, isEmpty);
  });

  test('rejected refresh clears tokens and emits loggedOut', () async {
    final refreshAdapter =
        FakeAdapter((_) async => const FakeReply(401, {'type': 'invalid-refresh'}));
    final dio = build(api(), refreshAdapter);

    await expectLater(
      dio.get<dynamic>('/api/a'),
      throwsA(isA<DioException>()
          .having((e) => e.response?.statusCode, 'status', 401)),
    );
    await Future<void>.delayed(Duration.zero);
    expect(tokens.current, isNull);
    expect(emitted, [AuthEvent.loggedOut]);
  });

  test('refresh failing on the network keeps the session', () async {
    final refreshAdapter = FakeAdapter((o) async => throw DioException.connectionError(
        requestOptions: o, reason: 'offline'));
    final dio = build(api(), refreshAdapter);

    await expectLater(dio.get<dynamic>('/api/a'), throwsA(isA<DioException>()));
    expect(tokens.refreshToken, 'r1');
    expect(emitted, isEmpty);
  });

  test('plain 403 emits permissionsStale, approval 403 does not', () async {
    final apiAdapter = FakeAdapter((o) async => o.path == '/api/plain'
        ? const FakeReply(403, {'type': 'forbidden', 'status': 403})
        : const FakeReply(403, {'type': 'https://dahab.travel/problems/approval-required'}));
    final dio = build(apiAdapter, FakeAdapter((_) async => const FakeReply(500)));

    await expectLater(dio.get<dynamic>('/api/plain'), throwsA(isA<DioException>()));
    await expectLater(dio.get<dynamic>('/api/approval'), throwsA(isA<DioException>()));
    await Future<void>.delayed(Duration.zero);
    expect(emitted, [AuthEvent.permissionsStale]);
  });
}
