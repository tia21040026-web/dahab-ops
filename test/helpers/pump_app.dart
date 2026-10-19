import 'dart:io';

import 'package:dahab_ops/core/api/auth_events.dart';
import 'package:dahab_ops/core/design/app_theme.dart';
import 'package:dahab_ops/core/design/dahab_tokens.dart';
import 'package:dahab_ops/core/design/typography.dart';
import 'package:dahab_ops/features/access/presentation/session_cubit.dart';
import 'package:dahab_ops/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mocks.dart';

bool _fontsLoaded = false;

/// Turns off google_fonts network fetching and maps the app's families to
/// fonts bundled with the Flutter SDK (Roboto + Material Icons), so goldens
/// render real glyphs offline. Missing SDK fonts fall back to the test font.
Future<void> setUpTestFonts() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  DahabFonts.useGoogleFonts = false;
  if (_fontsLoaded) return;
  _fontsLoaded = true;
  final root = Platform.environment['FLUTTER_ROOT'] ?? '';
  final dir = '$root/bin/cache/artifacts/material_fonts';
  Future<void> load(String family, List<String> files, {String? from}) async {
    final loader = FontLoader(family);
    var any = false;
    for (final f in files) {
      final file = File('${from ?? dir}/$f');
      if (file.existsSync()) {
        any = true;
        loader.addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
      }
    }
    if (any) await loader.load();
  }

  const text = ['roboto-regular.ttf', 'roboto-medium.ttf', 'roboto-bold.ttf'];
  for (final family in const ['IBM Plex Sans', 'Fraunces', 'IBM Plex Mono', 'Roboto']) {
    await load(family, text);
  }
  // Roboto has no Arabic glyphs. Use Tahoma where the host has it (Windows),
  // otherwise Arabic renders in the test font.
  final tahoma = File('C:/Windows/Fonts/tahoma.ttf').existsSync();
  for (final family in const ['IBM Plex Sans Arabic', 'Alexandria']) {
    if (tahoma) {
      await load(family, const ['tahoma.ttf', 'tahomabd.ttf'], from: 'C:/Windows/Fonts');
    } else {
      await load(family, text);
    }
  }
  await load('MaterialIcons', const ['materialicons-regular.otf']);
}

SessionCubit testSession({List<String> permissions = const ['*'], bool supplier = false}) {
  final c = SessionCubit(MockAuthRepository(), AuthEvents());
  c.signedIn(loginResponse(supplier ? supplierUser : adminUser, permissions));
  return c;
}

/// Wraps [child] in the real theme, localizations and a session.
Widget testApp(
  Widget child, {
  DahabThemeId theme = DahabThemeId.abyss,
  Locale locale = const Locale('en'),
  SessionCubit? session,
  bool scaffold = true,
}) {
  final s = session ?? testSession();
  return BlocProvider<SessionCubit>.value(
    value: s,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(theme, locale),
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: scaffold ? Scaffold(body: child) : child,
    ),
  );
}
