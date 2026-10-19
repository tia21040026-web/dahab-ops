import 'package:bloc_test/bloc_test.dart';
import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/features/access/domain/permissions.dart';
import 'package:dahab_ops/features/access/presentation/session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  group('Permissions.grants', () {
    test('exact and global *', () {
      expect(Permissions.grants('*', 'admin.users.manage'), isTrue);
      expect(Permissions.grants('ops.trips.view', 'ops.trips.view'), isTrue);
      expect(Permissions.grants('ops.trips.view', 'ops.trips.manage'), isFalse);
    });

    test('trailing * matches one or more remaining segments', () {
      expect(Permissions.grants('ops.*', 'ops.trips.view'), isTrue);
      expect(Permissions.grants('ops.*', 'ops'), isFalse);
      expect(Permissions.grants('ops.*', 'admin.users.view'), isFalse);
      expect(Permissions.grants('cms.content.*', 'cms.content.publish'), isTrue);
    });

    test('inner * matches exactly one segment', () {
      expect(Permissions.grants('supplier.*.view', 'supplier.inbox.view'), isTrue);
      expect(Permissions.grants('supplier.*.view', 'supplier.inbox.respond'), isFalse);
      expect(Permissions.grants('supplier.*.view', 'supplier.view'), isFalse);
    });
  });

  group('SessionCubit.can', () {
    late MockAuthRepository auth;
    late AuthEvents events;

    setUp(() {
      auth = MockAuthRepository();
      events = AuthEvents();
    });

    tearDown(() => events.dispose());

    test('admin with * can everything', () {
      final c = SessionCubit(auth, events)..signedIn(loginResponse(adminUser, ['*']));
      expect(c.can('admin.users.manage'), isTrue);
      expect(c.can('ops.commerce.refund'), isTrue);
      expect(c.canAny(['x.y.z']), isTrue);
      c.close();
    });

    test('supplier gets only supplier keys', () {
      final c = SessionCubit(auth, events)..signedIn(loginResponse(supplierUser, ['supplier.*']));
      expect(c.state.isSupplier, isTrue);
      expect(c.can('supplier.inbox.respond'), isTrue);
      expect(c.can('supplier.revenue.view'), isTrue);
      expect(c.can('ops.overview.view'), isFalse);
      expect(c.can('admin.users.view'), isFalse);
      c.close();
    });

    test('operations role default grants', () {
      final c = SessionCubit(auth, events)
        ..signedIn(loginResponse(opsUser, ['ops.*', 'cms.content.*', 'market.view', 'supplier.*.view']));
      expect(c.can('ops.exceptions.resolve'), isTrue);
      expect(c.can('cms.content.edit'), isTrue);
      expect(c.can('market.manage'), isFalse);
      expect(c.can('supplier.inventory.view'), isTrue);
      expect(c.can('supplier.inventory.edit'), isFalse);
      expect(c.canAny(['admin.users.view', 'market.view']), isTrue);
      c.close();
    });

    test('empty permissions deny', () {
      final c = SessionCubit(auth, events);
      expect(c.can('ops.overview.view'), isFalse);
      c.close();
    });
  });

  group('SessionCubit lifecycle', () {
    late MockAuthRepository auth;
    late AuthEvents events;

    setUp(() {
      auth = MockAuthRepository();
      events = AuthEvents();
    });

    tearDown(() => events.dispose());

    blocTest<SessionCubit, SessionState>(
      'restore without stored session is unauthenticated',
      build: () {
        when(() => auth.hasStoredSession()).thenAnswer((_) async => false);
        return SessionCubit(auth, events);
      },
      act: (c) => c.restore(),
      // The first emit (clearing restoreError) is delivered even when equal.
      expect: () => [
        const SessionState(),
        const SessionState(status: SessionStatus.unauthenticated),
      ],
    );

    blocTest<SessionCubit, SessionState>(
      'restore applies /me',
      build: () {
        when(() => auth.hasStoredSession()).thenAnswer((_) async => true);
        when(() => auth.me()).thenAnswer((_) async => meResponse(opsUser, ['ops.*']));
        return SessionCubit(auth, events);
      },
      act: (c) => c.restore(),
      skip: 1,
      verify: (c) {
        expect(c.state.isAuthenticated, isTrue);
        expect(c.can('ops.trips.view'), isTrue);
      },
    );

    blocTest<SessionCubit, SessionState>(
      'restore offline keeps unknown + restoreError',
      build: () {
        when(() => auth.hasStoredSession()).thenAnswer((_) async => true);
        when(() => auth.me()).thenThrow(const ApiError(kind: ApiErrorKind.network));
        return SessionCubit(auth, events);
      },
      act: (c) => c.restore(),
      verify: (c) {
        expect(c.state.status, SessionStatus.unknown);
        expect(c.state.restoreError?.kind, ApiErrorKind.network);
      },
    );

    test('loggedOut auth event signs out with expired reason', () async {
      final c = SessionCubit(auth, events)..signedIn(loginResponse(opsUser, ['ops.*']));
      events.emit(AuthEvent.loggedOut);
      await Future<void>.delayed(Duration.zero);
      expect(c.state.status, SessionStatus.unauthenticated);
      expect(c.state.signOutReason, SignOutReason.expired);
      await c.close();
    });

    test('permissionsStale re-reads /me', () async {
      when(() => auth.me()).thenAnswer((_) async => meResponse(opsUser, ['ops.trips.view']));
      final c = SessionCubit(auth, events)..signedIn(loginResponse(opsUser, ['ops.*']));
      events.emit(AuthEvent.permissionsStale);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      verify(() => auth.me()).called(1);
      expect(c.can('ops.exceptions.view'), isFalse);
      await c.close();
    });
  });
}
