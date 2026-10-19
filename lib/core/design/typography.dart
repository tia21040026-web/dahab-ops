import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.g.dart';

/// Font loading switch. Tests turn runtime fetching off so goldens never
/// touch the network; the families then fall back to the test font.
abstract final class DahabFonts {
  static bool useGoogleFonts = true;

  static TextStyle _gf(TextStyle Function({TextStyle? textStyle}) loader, String family,
      TextStyle base) {
    if (!useGoogleFonts) return base.copyWith(fontFamily: family);
    return loader(textStyle: base);
  }

  static TextStyle plexSans(TextStyle base) =>
      _gf(({textStyle}) => GoogleFonts.ibmPlexSans(textStyle: textStyle), 'IBM Plex Sans', base);
  static TextStyle plexSansArabic(TextStyle base) => _gf(
      ({textStyle}) => GoogleFonts.ibmPlexSansArabic(textStyle: textStyle),
      'IBM Plex Sans Arabic',
      base);
  static TextStyle fraunces(TextStyle base) =>
      _gf(({textStyle}) => GoogleFonts.fraunces(textStyle: textStyle), 'Fraunces', base);
  static TextStyle alexandria(TextStyle base) =>
      _gf(({textStyle}) => GoogleFonts.alexandria(textStyle: textStyle), 'Alexandria', base);
  static TextStyle plexMono(TextStyle base) =>
      _gf(({textStyle}) => GoogleFonts.ibmPlexMono(textStyle: textStyle), 'IBM Plex Mono', base);
}

/// The app's three voices: UI (IBM Plex Sans / Plex Sans Arabic), display
/// numbers (Fraunces, Alexandria for Arabic), and mono readings with tabular
/// figures (IBM Plex Mono) for IDs and amounts.
///
/// Arabic is never tracked and gets taller leading.
@immutable
class DahabType {
  const DahabType._({
    required this.isArabic,
    required this.ui,
    required this.display,
    required this.mono,
  });

  static final Map<String, DahabType> _cache = {};

  factory DahabType.forLocale(Locale locale, {required Color ink}) {
    final key = '${locale.languageCode}|${ink.toARGB32()}|${DahabFonts.useGoogleFonts}';
    return _cache.putIfAbsent(key, () => DahabType._build(locale, ink));
  }

  factory DahabType._build(Locale locale, Color ink) {
    final ar = locale.languageCode == 'ar';
    final baseUi = TextStyle(color: ink, height: ar ? 1.6 : 1.4, letterSpacing: 0);
    final ui = ar ? DahabFonts.plexSansArabic(baseUi) : DahabFonts.plexSans(baseUi);
    final baseDisplay = TextStyle(
      color: ink,
      height: ar ? 1.3 : 1.05,
      letterSpacing: ar ? 0 : -0.5,
      fontFeatures: const [FontFeature.liningFigures(), FontFeature.tabularFigures()],
    );
    final display = ar ? DahabFonts.alexandria(baseDisplay) : DahabFonts.fraunces(baseDisplay);
    final mono = DahabFonts.plexMono(TextStyle(
      color: ink,
      height: 1.35,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures(), FontFeature.slashedZero()],
    ));
    return DahabType._(isArabic: ar, ui: ui, display: display, mono: mono);
  }

  final bool isArabic;
  final TextStyle ui;
  final TextStyle display;
  final TextStyle mono;

  // UI scale — nothing renders below 13.
  TextStyle get caption => ui.copyWith(fontSize: DgScale.textXs, fontWeight: FontWeight.w500);
  TextStyle get label => ui.copyWith(
      fontSize: DgScale.textXs,
      fontWeight: FontWeight.w600,
      letterSpacing: isArabic ? 0 : 0.4);
  TextStyle get bodySm => ui.copyWith(fontSize: DgScale.textSm, fontWeight: FontWeight.w400);
  TextStyle get body => ui.copyWith(fontSize: DgScale.textMd, fontWeight: FontWeight.w400);
  TextStyle get bodyStrong => ui.copyWith(fontSize: DgScale.textMd, fontWeight: FontWeight.w600);
  TextStyle get title => ui.copyWith(fontSize: DgScale.textLg, fontWeight: FontWeight.w600);
  TextStyle get heading => ui.copyWith(fontSize: DgScale.textXl, fontWeight: FontWeight.w600);
  TextStyle get pageTitle => ui.copyWith(fontSize: DgScale.text2xl, fontWeight: FontWeight.w600);

  // Display numbers.
  TextStyle get numberLg => display.copyWith(fontSize: DgScale.text3xl, fontWeight: FontWeight.w500);
  TextStyle get numberMd => display.copyWith(fontSize: DgScale.text2xl, fontWeight: FontWeight.w500);

  /// Screen titles in the top bar (30, Fraunces / Alexandria).
  TextStyle get displayTitle => display.copyWith(
      fontSize: 30, fontWeight: FontWeight.w400, height: isArabic ? 1.35 : 1.1, letterSpacing: isArabic ? 0 : -0.3);

  /// Display reading at [size], regular weight (KPI numbers, amounts).
  TextStyle displayAt(double size, {double? height}) => display.copyWith(
      fontSize: size, fontWeight: FontWeight.w400, height: height ?? (isArabic ? 1.3 : 1.1));

  /// Display numbers stay Latin (Fraunces) in both languages.
  TextStyle get displayNumber => DahabFonts.fraunces(display.copyWith(
      fontWeight: FontWeight.w400, letterSpacing: 0, height: 1));

  // Mono readings.
  TextStyle get monoSm => mono.copyWith(fontSize: DgScale.textXs, fontWeight: FontWeight.w500);
  TextStyle get monoMd => mono.copyWith(fontSize: DgScale.textSm, fontWeight: FontWeight.w500);

  TextTheme toTextTheme() => TextTheme(
        displayLarge: numberLg,
        displayMedium: numberMd,
        displaySmall: numberMd.copyWith(fontSize: DgScale.textXl),
        headlineLarge: pageTitle,
        headlineMedium: heading,
        headlineSmall: title,
        titleLarge: heading,
        titleMedium: title,
        titleSmall: bodyStrong.copyWith(fontSize: DgScale.textSm),
        bodyLarge: body,
        bodyMedium: bodySm,
        bodySmall: caption,
        labelLarge: bodyStrong.copyWith(fontSize: DgScale.textSm),
        labelMedium: label,
        labelSmall: caption,
      );
}
