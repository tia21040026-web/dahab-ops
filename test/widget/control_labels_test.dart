import 'package:auto_route/auto_route.dart';
import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/core/api/models/admin_models.dart';
import 'package:dahab_ops/core/api/models/paged.dart';
import 'package:dahab_ops/core/design/app_theme.dart';
import 'package:dahab_ops/core/design/components/confirm_danger_sheet.dart';
import 'package:dahab_ops/core/design/components/dahab_button.dart';
import 'package:dahab_ops/core/design/components/dahab_text_field.dart';
import 'package:dahab_ops/core/design/dahab_tokens.dart';
import 'package:dahab_ops/core/platform/biometric_service.dart';
import 'package:dahab_ops/core/router/app_router.gr.dart';
import 'package:dahab_ops/features/access/presentation/role_labels.dart';
import 'package:dahab_ops/features/access/presentation/session_cubit.dart';
import 'package:dahab_ops/features/control/data/control_repository.dart';
import 'package:dahab_ops/features/control/presentation/control_cubit.dart';
import 'package:dahab_ops/features/control/presentation/flag_labels.dart';
import 'package:dahab_ops/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';
import '../helpers/pump_app.dart';

class _MockControl extends Mock implements ControlRepository {}

class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ControlRoute.page, path: '/'),
        AutoRoute(page: AppExperienceRoute.page, path: '/app-experience'),
      ];
}

class _SingleRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [AutoRoute(page: AppExperienceRoute.page, path: '/')];
}

void main() {
  final ar = lookupAppLocalizations(const Locale('ar'));
  final en = lookupAppLocalizations(const Locale('en'));

  group('FlagLabels', () {
    const keys = [
      'killswitch.payments',
      'killswitch.bookings',
      'killswitch.ai',
      'killswitch.sms',
      'killswitch.supplierSignup',
      'system.maintenance',
    ];

    test('known keys get localized titles and descriptions, never the raw key', () {
      for (final k in keys) {
        final f = FlagItem(key: k, kind: 'killswitch', description: 'Stops outbound SMS.');
        for (final l in [ar, en]) {
          expect(FlagLabels.title(l, f), isNot(contains('killswitch')));
          expect(FlagLabels.title(l, f), isNot(contains('.')));
          expect(FlagLabels.description(l, f), isNotNull);
          expect(FlagLabels.description(l, f), isNot(endsWith('.')));
        }
      }
      const sms = FlagItem(key: 'killswitch.sms', kind: 'killswitch');
      expect(FlagLabels.title(ar, sms), 'الرسائل النصية الصادرة');
      expect(FlagLabels.title(en, sms), 'Outbound SMS');
      expect(FlagLabels.title(ar, const FlagItem(key: 'killswitch.ai')), isNot('Ai'));
    });

    test('unknown keys fall back to the description without trailing punctuation', () {
      const f = FlagItem(key: 'killswitch.fax', kind: 'killswitch', description: 'Stops faxes.');
      expect(FlagLabels.title(ar, f), 'Stops faxes');
      expect(FlagLabels.description(ar, f), 'Stops faxes');
      expect(FlagLabels.title(en, const FlagItem(key: 'killswitch.fax')), 'Fax');
    });
  });

  group('RoleLabels', () {
    test('a wildcard role reads "all permissions", not "one permission"', () {
      expect(RoleLabels.permissions(ar, const ['*']), 'كل الصلاحيات');
      expect(RoleLabels.permissions(en, const ['*']), 'All permissions');
      expect(RoleLabels.permissions(en, const ['a.b', 'c.d']), '2 permissions');
    });

    test('system roles are localized; custom roles keep their name', () {
      expect(
        ['Traveler', 'Supplier', 'Operations', 'Product', 'Admin'].map((n) => RoleLabels.name(ar, n)),
        ['مسافر', 'مورد', 'التشغيل', 'المنتج', 'مسؤول'],
      );
      expect(RoleLabels.of(ar, const Role(id: 'r', name: 'Admin', isSystem: true)), 'مسؤول');
      expect(RoleLabels.of(ar, const Role(id: 'r', name: 'Night desk')), 'Night desk');
    });
  });

  test('the list separator follows the locale', () {
    expect(['غير مهيأ', 'تجريبي'].join(ar.listSeparator), 'غير مهيأ، تجريبي');
    expect(['Unconfigured', 'Sandbox'].join(en.listSeparator), 'Unconfigured, Sandbox');
  });


group('ControlPage (Arabic)', () {
  late _MockControl repo;

  setUpAll(setUpTestFonts);

  setUp(() {
    repo = _MockControl();
    GetIt.I
      ..registerFactory<ControlCubit>(() => ControlCubit(repo)..resolveUser = (id) async => 'Mona Admin')
      ..registerSingleton<BiometricService>(const NoopBiometricService());
    when(() => repo.settings()).thenAnswer((_) async => const []);
    when(() => repo.approvals()).thenAnswer((_) async => const []);
    when(() => repo.audit()).thenAnswer((_) async => const Paged<AuditEvent>());
    when(() => repo.integrations()).thenAnswer((_) async => const [
          Integration(id: 'paymob', name: 'Paymob', status: 'unconfigured', mode: 'sandbox'),
        ]);
    when(() => repo.flags()).thenAnswer((_) async => [
          const FlagItem(key: 'killswitch.payments', kind: 'killswitch', description: 'Stops checkout.'),
          FlagItem(
            key: 'killswitch.sms',
            kind: 'killswitch',
            enabled: true,
            description: 'Stops outbound SMS.',
            updatedBy: 'u9',
            updatedAt: DateTime.now().toUtc(),
          ),
        ]);
  });

  tearDown(() => GetIt.I.reset());

  Future<void> pumpHub(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final session = SessionCubit(MockAuthRepository(), AuthEvents())
      ..signedIn(loginResponse(adminUser, const ['*']));
    const locale = Locale('ar');
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
        routerConfig: _Router().config(),
      ),
    ));
    // Fixed pumps: the hero status dot pulses forever, so pumpAndSettle
    // would never settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
  }

  testWidgets('the hub shows the live verdict and the localized tiles', (tester) async {
    await pumpHub(tester);

    // One switch engaged: the hero names it without any raw key.
    expect(find.text(ar.ccKillsOn(1)), findsOneWidget);
    expect(find.textContaining('killswitch'), findsNothing);
    expect(find.text(ar.ccAllClear), findsNothing);

    // Tiles read localized and gate nothing away from an Admin.
    expect(find.text(ar.ccTileExperience), findsOneWidget);
    expect(find.text(ar.ccTileHomepage), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('a quiet platform reads all-clear', (tester) async {
    when(() => repo.flags()).thenAnswer((_) async => [
          const FlagItem(key: 'killswitch.sms', kind: 'killswitch'),
        ]);
    await pumpHub(tester);
    expect(find.text(ar.ccAllClear), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
});

group('AppExperiencePage (Arabic)', () {
  late _MockControl repo;

  setUpAll(setUpTestFonts);

  setUp(() {
    repo = _MockControl();
    GetIt.I
      ..registerFactory<ControlCubit>(() => ControlCubit(repo)..resolveUser = (id) async => 'Mona Admin')
      ..registerSingleton<BiometricService>(const NoopBiometricService());
    when(() => repo.settings()).thenAnswer((_) async => [
          const SettingItem(
            key: 'system.maintenanceMessage',
            type: 'json',
            group: 'system',
            value: {'en': 'Down for maintenance', 'ar': 'الموقع تحت الصيانة'},
          ),
          const SettingItem(
            key: 'announce.banner',
            type: 'json',
            group: 'announce',
            value: {'enabled': true, 'tone': 'warn', 'en': 'Storm', 'ar': 'عاصفة'},
          ),
        ]);
    when(() => repo.approvals()).thenAnswer((_) async => const []);
    when(() => repo.audit()).thenAnswer((_) async => const Paged<AuditEvent>());
    when(() => repo.integrations()).thenAnswer((_) async => const []);
    when(() => repo.flags()).thenAnswer((_) async => [
          const FlagItem(key: 'killswitch.payments', kind: 'killswitch', description: 'Stops checkout.'),
          FlagItem(
            key: 'killswitch.sms',
            kind: 'killswitch',
            enabled: true,
            description: 'Stops outbound SMS.',
            updatedBy: 'u9',
            updatedAt: DateTime.now().toUtc(),
          ),
          const FlagItem(key: 'ui.bilingual', kind: 'flag', enabled: true, description: 'New screens.'),
        ]);
  });

  tearDown(() => GetIt.I.reset());

  testWidgets('kill switches read localized; engaging names the switch, not the key', (tester) async {
    // A tall viewport builds the whole list at once (ListView is lazy and
    // scrollUntilVisible fights multi-match finders here).
    tester.view.physicalSize = const Size(1080, 8000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final session = SessionCubit(MockAuthRepository(), AuthEvents())
      ..signedIn(loginResponse(adminUser, const ['*']));
    const locale = Locale('ar');
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
        routerConfig: _SingleRouter().config(),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));


    expect(find.text(ar.killPaymentsTitle), findsOneWidget);
    expect(find.text(ar.killSmsTitle), findsOneWidget);
    expect(find.textContaining('.Stops'), findsNothing);
    expect(find.text('Payments'), findsNothing);
    expect(tester.takeException(), isNull);

    // The confirm sheet names the switch, not `killswitch.sms`.
    await tester.tap(find.bySemanticsLabel(ar.killSmsTitle).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('killswitch.sms'), findsNothing);
    expect(find.text(ar.ccKillReleaseTitle(ar.killSmsTitle)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editing announcement copy keeps the enabled flag and the tone', (tester) async {
    tester.view.physicalSize = const Size(1080, 8000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Object? sent;
    when(() => repo.setSetting(any(), any(), any())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0] as String;
      sent = invocation.positionalArguments[1];
      final reason = invocation.positionalArguments[2] as String;
      expect(ConfirmDangerSheet.validReason(reason), isTrue, reason: 'reason must clear the sheet contract');
      return SettingItem(
        key: key,
        type: 'json',
        group: 'announce',
        value: sent,
        version: 2,
        updatedBy: 'u9',
        updatedAt: DateTime.now().toUtc(),
      );
    });

    final session = SessionCubit(MockAuthRepository(), AuthEvents())
      ..signedIn(loginResponse(adminUser, const ['*']));
    const locale = Locale('ar');
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
        routerConfig: _SingleRouter().config(),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    // The announcement editor is the second bilingual editor on the page.
    final enField = find.widgetWithText(DahabTextField, ar.messageEn).last;
    await tester.enterText(enField, 'Storm warning');
    await tester.pump();
    await tester.tap(find.widgetWithText(DahabButton, ar.saveMessage).last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Confirm with a reason, then assert the payload kept its siblings.
    await tester.enterText(find.byKey(const Key('danger.reason')), 'Copy update');
    await tester.pump();
    await tester.tap(find.byKey(const Key('danger.confirm')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(sent, isA<Map>());
    final map = Map<String, dynamic>.from(sent! as Map);
    expect(map['en'], 'Storm warning');
    expect(map['ar'], 'عاصفة');
    // The server requires both on announce.banner: a text-only save would 400.
    expect(map['enabled'], isTrue);
    expect(map['tone'], 'warn');
    expect(tester.takeException(), isNull);
  });
});
}
