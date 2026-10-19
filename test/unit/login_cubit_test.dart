import 'package:bloc_test/bloc_test.dart';
import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/core/platform/biometric_service.dart';
import 'package:dahab_ops/features/access/presentation/session_cubit.dart';
import 'package:dahab_ops/features/auth/presentation/login/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  late MockAuthRepository auth;
  late AuthEvents events;
  late SessionCubit session;

  setUp(() {
    auth = MockAuthRepository();
    events = AuthEvents();
    session = SessionCubit(auth, events);
  });

  tearDown(() async {
    await session.close();
    await events.dispose();
  });

  LoginCubit build({BiometricService biometrics = const NoopBiometricService()}) =>
      LoginCubit(auth, session, biometrics, FakeDeviceInfo());

  test('canSubmit needs email and password', () {
    expect(const LoginState().canSubmit, isFalse);
    expect(const LoginState(email: ' a@b.c ', password: 'x').canSubmit, isTrue);
    expect(const LoginState(email: 'a', password: 'x', status: LoginStatus.submitting).canSubmit,
        isFalse);
  });

  blocTest<LoginCubit, LoginState>(
    'init reads biometrics and device name',
    build: () => build(biometrics: const NoopBiometricService(available: true)),
    act: (c) => c.init(),
    expect: () => [const LoginState(faceIdAvailable: true, deviceName: 'Test Phone')],
  );

  blocTest<LoginCubit, LoginState>(
    'submit success signs the session in',
    build: () {
      when(() => auth.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => loginResponse(opsUser, ['ops.*']));
      return build();
    },
    act: (c) {
      c
        ..emailChanged('ops@dahab.travel')
        ..passwordChanged('secret');
      return c.submit();
    },
    skip: 2,
    expect: () => [
      const LoginState(email: 'ops@dahab.travel', password: 'secret', status: LoginStatus.submitting),
      const LoginState(email: 'ops@dahab.travel', password: 'secret', status: LoginStatus.success),
    ],
    verify: (_) {
      expect(session.state.isAuthenticated, isTrue);
      expect(session.can('ops.trips.view'), isTrue);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'submit failure exposes the error',
    build: () {
      when(() => auth.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(const ApiError(kind: ApiErrorKind.unauthorized, status: 401));
      return build();
    },
    seed: () => const LoginState(email: 'a@b.c', password: 'bad'),
    act: (c) => c.submit(),
    verify: (c) {
      expect(c.state.status, LoginStatus.failure);
      expect(c.state.error?.kind, ApiErrorKind.unauthorized);
      expect(session.state.isAuthenticated, isFalse);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'submit is a no-op without credentials',
    build: build,
    act: (c) => c.submit(),
    expect: () => <LoginState>[],
  );

  blocTest<LoginCubit, LoginState>(
    'biometric failure does not restore',
    build: () => build(biometrics: const NoopBiometricService(available: true, result: false)),
    act: (c) => c.unlockWithBiometrics(),
    verify: (c) {
      expect(c.state.status, LoginStatus.failure);
      verifyNever(() => auth.hasStoredSession());
    },
  );

  blocTest<LoginCubit, LoginState>(
    'biometric success restores the stored session',
    build: () {
      when(() => auth.hasStoredSession()).thenAnswer((_) async => true);
      when(() => auth.me()).thenAnswer((_) async => meResponse(opsUser, ['ops.*']));
      return build(biometrics: const NoopBiometricService(available: true));
    },
    act: (c) => c.unlockWithBiometrics(),
    verify: (c) => expect(c.state.status, LoginStatus.success),
  );
}
