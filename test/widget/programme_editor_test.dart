import 'package:auto_route/auto_route.dart';
import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/core/design/app_theme.dart';
import 'package:dahab_ops/core/design/components/dahab_button.dart';
import 'package:dahab_ops/core/design/dahab_tokens.dart';
import 'package:dahab_ops/core/platform/biometric_service.dart';
import 'package:dahab_ops/core/router/app_router.gr.dart';
import 'package:dahab_ops/features/access/presentation/session_cubit.dart';
import 'package:dahab_ops/features/cms/content_repository.dart';
import 'package:dahab_ops/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';
import '../helpers/pump_app.dart';

class _MockContent extends Mock implements ContentRepository {}

class _Router extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ProgrammeEditorRoute.page, path: '/cms/programmes/:id'),
      ];
}

/// A day carries more than the editor models: `tag`, `accentColor` and the
/// Arabic copy are read-only here, so saving must merge them back instead of
/// shipping a four-field array that silently drops the rest of the plan.
void main() {
  late _MockContent content;

  setUpAll(setUpTestFonts);

  final programme = const Programme({
    'id': 'dahab-first-timer',
    'destination': 'dahab',
    'title_en': 'Dahab First Timer',
    'title_ar': 'أول مرة في دهب',
    'duration_days': 2,
    'pace': 'Relaxed',
    'default_budget': 'Budget',
    'starting_price_egp': 9800,
    'status': 'draft',
    'day_by_day': [
      {
        'day': 1,
        'title': 'Arrive and breathe',
        'subtitle': 'Check in, slow down',
        'timeEstimate': '3 hours',
        'highlights': ['Snorkel', 'Sunset'],
        'tag': 'Easy start',
        'accentColor': '#0EA5A4',
        'titleAr': 'الوصول والتأقلم',
        'subtitleAr': 'تسجيل الدخول والهدوء',
        'highlightsAr': [' snorkeling', 'غروب'],
      },
    ],
  });

  setUp(() {
    content = _MockContent();
    GetIt.I
      ..registerSingleton<ContentRepository>(content)
      ..registerSingleton<BiometricService>(const NoopBiometricService());
    when(() => content.programme(any())).thenAnswer((_) async => programme);
    when(() => content.updateProgramme(any(), any())).thenAnswer((invocation) async {
      final body = invocation.positionalArguments[1] as Map<String, dynamic>;
      return Programme({...programme.json, ...body});
    });
  });

  tearDown(() => GetIt.I.reset());

  Future<void> pumpEditor(WidgetTester tester) async {
    // A real phone width, tall enough that the whole form builds at once.
    tester.view.physicalSize = const Size(1080, 6400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final auth = MockAuthRepository();
    when(() => auth.me()).thenAnswer((_) async => meResponse(adminUser, const ['*']));
    final session = SessionCubit(auth, AuthEvents())..signedIn(loginResponse(adminUser, const ['*']));
    const locale = Locale('en');
    final l = lookupAppLocalizations(locale);
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
        routerConfig: _Router().config(
          deepLinkBuilder: (_) => DeepLink([ProgrammeEditorRoute(id: 'dahab-first-timer')]),
        ),
      ),
    ));
await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // FutureBuilder -> editor swap needs one more frame.
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(l.ccTitleEn), findsWidgets);
    expect(find.widgetWithText(DahabButton, l.save), findsOneWidget);
  }

  testWidgets('saving keeps the day fields the editor does not model', (tester) async {
    await pumpEditor(tester);
    final l = lookupAppLocalizations(const Locale('en'));

    await tester.tap(find.widgetWithText(DahabButton, l.save).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(find.byKey(const Key('danger.reason')), 'Editorial pass');
    await tester.pump();
    await tester.tap(find.byKey(const Key('danger.confirm')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final captured = verify(() => content.updateProgramme(captureAny(), captureAny())).captured;
    final body = Map<String, dynamic>.from(captured[1] as Map);
    final days = body['day_by_day'] as List;
    expect(days, hasLength(1));
    final day = Map<String, dynamic>.from(days.first as Map);

    // Edited by the desk.
    expect(day['day'], 1);
    expect(day['title'], 'Arrive and breathe');
    expect(day['highlights'], ['Snorkel', 'Sunset']);
    // Never on screen, still shipped back untouched.
    expect(day['tag'], 'Easy start');
    expect(day['accentColor'], '#0EA5A4');
    expect(day['titleAr'], 'الوصول والتأقلم');
    expect(day['subtitleAr'], 'تسجيل الدخول والهدوء');
    expect(day['highlightsAr'], [' snorkeling', 'غروب']);
    expect(tester.takeException(), isNull);
  });
}