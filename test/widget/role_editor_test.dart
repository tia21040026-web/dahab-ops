import 'package:auto_route/auto_route.dart';
import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/core/api/models/admin_models.dart';
import 'package:dahab_ops/core/design/app_theme.dart';
import 'package:dahab_ops/core/design/components/instrument.dart';
import 'package:dahab_ops/core/design/dahab_tokens.dart';
import 'package:dahab_ops/core/platform/biometric_service.dart';
import 'package:dahab_ops/core/router/app_router.gr.dart';
import 'package:dahab_ops/features/access/data/access_repository.dart';
import 'package:dahab_ops/features/access/presentation/session_cubit.dart';
import 'package:dahab_ops/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';
import '../helpers/pump_app.dart';

class _MockAccess extends Mock implements AccessRepository {}

class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: RoleEditorRoute.page, path: '/')];
}

/// The matrix must never move under the user's finger: a toggle that shifts
/// the list sends the next tap to a different row (a test once saved
/// `supplier.inventory.view` removed instead of the intended key).
void main() {
  late _MockAccess access;

  setUpAll(setUpTestFonts);

  setUp(() {
    access = _MockAccess();
    GetIt.I
      ..registerSingleton<AccessRepository>(access)
      ..registerSingleton<BiometricService>(const NoopBiometricService());
  });

  tearDown(() => GetIt.I.reset());

  // 6 groups x 8 keys: taller than the phone viewport.
  final groups = ['bookings', 'catalog', 'cms', 'ops', 'refunds', 'supplier'];
  final catalog = [
    for (final g in groups)
      for (var i = 0; i < 8; i++) PermissionDef(key: '$g.k$i.view', group: g, labelEn: '$g $i'),
  ];
  final original = ['bookings.k0.view', 'ops.k3.view', 'supplier.k2.view', 'supplier.k5.view'];
  final role = Role(id: 'r1', name: 'Desk', permissions: original);

  Future<SessionCubit> pumpEditor(WidgetTester tester) async {
    // Samsung 1080x2340 @ 2.625.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    when(() => access.roles()).thenAnswer((_) async => [role]);
    when(() => access.permissions()).thenAnswer((_) async => catalog);
    final auth = MockAuthRepository();
    when(() => auth.me()).thenAnswer((_) async => meResponse(adminUser, const ['*']));
    final session = SessionCubit(auth, AuthEvents())..signedIn(loginResponse(adminUser, const ['*']));
    final router = _Router();
    const locale = Locale('en');
    await tester.pumpWidget(BlocProvider<SessionCubit>.value(
      value: session,
      child: MaterialApp.router(
        theme: AppTheme.build(DahabThemeId.abyss, locale),
        locale: locale,
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router.config(deepLinkBuilder: (_) => DeepLink([RoleEditorRoute(roleId: 'r1')])),
      ),
    ));
    await tester.pumpAndSettle();
    return session;
  }

  Finder sw(String key) => find.byKey(ValueKey('perm-switch-$key'));

  testWidgets('toggling a row never moves the list; the next tap lands on the row aimed at',
      (tester) async {
    await pumpEditor(tester);
    final list = find.byKey(const PageStorageKey('role-matrix'));
    expect(list, findsOneWidget);

    // Scroll so both rows are mid-screen with content above them.
    const a = 'supplier.k1.view';
    const b = 'supplier.k5.view';
    await tester.scrollUntilVisible(sw(b), 300, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    expect(sw(a).hitTestable(), findsOneWidget);

    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable).first);
    final offsetBefore = scrollable.position.pixels;
    final bBefore = tester.getCenter(sw(b));

    await tester.tap(sw(a));
    await tester.pumpAndSettle();

    expect(scrollable.position.pixels, offsetBefore, reason: 'toggle A must not scroll');
    expect(tester.getCenter(sw(b)), bBefore, reason: 'row B must stay where the user saw it');

    // Tap where B was before A toggled: must hit B.
    await tester.tapAt(bBefore);
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, offsetBefore);

    expect(tester.widget<DgSwitch>(sw(a)).value, isTrue, reason: 'A was granted');
    expect(tester.widget<DgSwitch>(sw(b)).value, isFalse, reason: 'B was revoked');
    expect(find.text('2 unsaved changes'), findsOneWidget);

    // Save and check exactly A and B changed.
    List<String>? saved;
    when(() => access.updateRole('r1', permissions: any(named: 'permissions'), reason: any(named: 'reason')))
        .thenAnswer((inv) async {
      saved = inv.namedArguments[#permissions] as List<String>;
      return role.copyWith(permissions: saved!);
    });
    await tester.tap(find.text('Save role'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('danger.reason')), 'matrix test');
    await tester.pump();
    await tester.tap(find.byKey(const Key('danger.confirm')));
    // The root route cannot pop, so the save spinner stays; don't settle.
    await tester.pump(const Duration(milliseconds: 500));

    final expected = {...original}
      ..add(a)
      ..remove(b);
    expect(saved?.toSet(), expected);
  });

  testWidgets('at the end of the list, undoing a toggle (0 changes) keeps rows in place', (tester) async {
    await pumpEditor(tester);
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable).first);
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pumpAndSettle();

    const a = 'supplier.k6.view';
    const b = 'supplier.k4.view';
    // On, scroll to the very end, then off again: the save bar must not come
    // and go and resize the viewport (that clamped the offset and shifted rows).
    await tester.tap(sw(a));
    await tester.pumpAndSettle();
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pumpAndSettle();
    final offsetBefore = scrollable.position.pixels;
    final bBefore = tester.getCenter(sw(b));
    await tester.tap(sw(a));
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, offsetBefore);
    expect(tester.getCenter(sw(b)), bBefore);

    await tester.tapAt(bBefore);
    await tester.pumpAndSettle();
    expect(tester.widget<DgSwitch>(sw(b)).value, isTrue, reason: 'the tap hit B, not a neighbour');
    expect(tester.widget<DgSwitch>(sw(a)).value, isFalse);
    expect(find.text('1 unsaved change'), findsOneWidget);
  });
}
