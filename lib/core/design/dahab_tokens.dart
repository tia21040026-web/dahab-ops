import 'package:flutter/material.dart';

import 'tokens.g.dart';

/// The three themes the web product ships (src/styles/tokens.css).
enum DahabThemeId {
  abyss('abyss', Brightness.dark),
  salt('salt', Brightness.light),
  highContrastPro('high-contrast-pro', Brightness.dark);

  const DahabThemeId(this.wire, this.brightness);

  final String wire;
  final Brightness brightness;

  static DahabThemeId fromWire(String? value) =>
      values.firstWhere((t) => t.wire == value, orElse: () => abyss);
}

/// Semantic colour tokens for the "Lagoon Instrument" direction.
///
/// Rules of the instrument: colour only for status and action, hairlines
/// instead of shadows, one action colour per screen.
@immutable
class DahabTokens extends ThemeExtension<DahabTokens> {
  const DahabTokens({
    required this.id,
    required this.bg,
    required this.bgSunken,
    required this.surface,
    required this.raised,
    required this.sunken,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.line,
    required this.lineStrong,
    required this.action,
    required this.actionHover,
    required this.actionInk,
    required this.actionWash,
    required this.highlight,
    required this.highlightInk,
    required this.highlightWash,
    required this.positive,
    required this.positiveWash,
    required this.warning,
    required this.warningWash,
    required this.critical,
    required this.criticalWash,
    required this.scrim,
    required this.chrome,
    required this.focus,
    required this.hairline,
    required this.raised2,
    required this.data,
    required this.dataWash,
  });

  final DahabThemeId id;
  final Color bg;
  final Color bgSunken;
  final Color surface;
  final Color raised;
  final Color sunken;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color line;
  final Color lineStrong;
  final Color action;
  final Color actionHover;
  final Color actionInk;
  final Color actionWash;
  final Color highlight;
  final Color highlightInk;
  final Color highlightWash;
  final Color positive;
  final Color positiveWash;
  final Color warning;
  final Color warningWash;
  final Color critical;
  final Color criticalWash;
  final Color scrim;
  final Color chrome;
  final Color focus;

  /// Border width for hairlines. High contrast draws them heavier.
  final double hairline;

  /// Second raised step (meters, switch tracks, avatar fills).
  final Color raised2;

  /// Plotted-series ink, distinct from the action colour.
  final Color data;
  final Color dataWash;

  Brightness get brightness => id.brightness;
  bool get isDark => brightness == Brightness.dark;

  static const abyss = DahabTokens(
    id: DahabThemeId.abyss,
    bg: DgAbyss.bg,
    bgSunken: DgAbyss.bgSunken,
    surface: DgAbyss.surface,
    raised: DgAbyss.surfaceRaised,
    sunken: DgAbyss.surfaceSunken,
    ink: DgAbyss.ink,
    ink2: DgAbyss.ink2,
    ink3: DgAbyss.ink3,
    line: DgAbyss.line,
    lineStrong: DgAbyss.lineStrong,
    action: DgAbyss.action,
    actionHover: DgAbyss.actionHover,
    actionInk: DgAbyss.actionInk,
    actionWash: DgAbyss.actionWash,
    highlight: DgAbyss.highlight,
    highlightInk: DgAbyss.highlightInk,
    highlightWash: DgAbyss.highlightWash,
    positive: DgAbyss.positive,
    positiveWash: DgAbyss.positiveWash,
    warning: DgAbyss.warning,
    warningWash: DgAbyss.warningWash,
    critical: DgAbyss.critical,
    criticalWash: DgAbyss.criticalWash,
    scrim: DgAbyss.scrim,
    chrome: DgAbyss.chromeBg,
    focus: DgAbyss.focus,
    hairline: 1,
    raised2: Color(0xFF1B2E3A),
    data: Color(0xFF86B9C6),
    dataWash: Color(0x1F86B9C6),
  );

  static const salt = DahabTokens(
    id: DahabThemeId.salt,
    bg: DgSalt.bg,
    bgSunken: DgSalt.bgSunken,
    surface: DgSalt.surface,
    raised: DgSalt.surfaceRaised,
    sunken: DgSalt.surfaceSunken,
    ink: DgSalt.ink,
    ink2: DgSalt.ink2,
    ink3: DgSalt.ink3,
    line: DgSalt.line,
    lineStrong: DgSalt.lineStrong,
    action: DgSalt.action,
    actionHover: DgSalt.actionHover,
    actionInk: DgSalt.actionInk,
    actionWash: DgSalt.actionWash,
    highlight: DgSalt.highlight,
    highlightInk: DgSalt.highlightInk,
    highlightWash: DgSalt.highlightWash,
    positive: DgSalt.positive,
    positiveWash: DgSalt.positiveWash,
    warning: DgSalt.warning,
    warningWash: DgSalt.warningWash,
    critical: DgSalt.critical,
    criticalWash: DgSalt.criticalWash,
    scrim: DgSalt.scrim,
    chrome: DgSalt.chromeBg,
    focus: DgSalt.focus,
    hairline: 1,
    raised2: Color(0xFFECEAE4),
    data: Color(0xFF2F6A7C),
    dataWash: Color(0x1A2F6A7C),
  );

  static const highContrastPro = DahabTokens(
    id: DahabThemeId.highContrastPro,
    bg: DgHighContrastPro.bg,
    bgSunken: DgHighContrastPro.bgSunken,
    surface: DgHighContrastPro.surface,
    raised: DgHighContrastPro.surfaceRaised,
    sunken: DgHighContrastPro.surfaceSunken,
    ink: DgHighContrastPro.ink,
    ink2: DgHighContrastPro.ink2,
    ink3: DgHighContrastPro.ink3,
    line: DgHighContrastPro.line,
    lineStrong: DgHighContrastPro.lineStrong,
    action: DgHighContrastPro.action,
    actionHover: DgHighContrastPro.actionHover,
    actionInk: DgHighContrastPro.actionInk,
    actionWash: DgHighContrastPro.actionWash,
    highlight: DgHighContrastPro.highlight,
    highlightInk: DgHighContrastPro.highlightInk,
    highlightWash: DgHighContrastPro.highlightWash,
    positive: DgHighContrastPro.positive,
    positiveWash: DgHighContrastPro.positiveWash,
    warning: DgHighContrastPro.warning,
    warningWash: DgHighContrastPro.warningWash,
    critical: DgHighContrastPro.critical,
    criticalWash: DgHighContrastPro.criticalWash,
    scrim: DgHighContrastPro.scrim,
    chrome: DgHighContrastPro.chromeBg,
    focus: DgHighContrastPro.focus,
    hairline: 1.5,
    raised2: Color(0xFF262626),
    data: Color(0xFFFFFFFF),
    dataWash: Color(0x33FFFFFF),
  );

  static DahabTokens of(DahabThemeId id) => switch (id) {
        DahabThemeId.abyss => abyss,
        DahabThemeId.salt => salt,
        DahabThemeId.highContrastPro => highContrastPro,
      };

  /// Hairline border in the line colour.
  BorderSide get hairlineSide => BorderSide(color: line, width: hairline);
  BorderSide get strongSide => BorderSide(color: lineStrong, width: hairline);

  @override
  DahabTokens copyWith({DahabThemeId? id}) => id == null ? this : of(id);

  @override
  DahabTokens lerp(covariant ThemeExtension<DahabTokens>? other, double t) {
    if (other is! DahabTokens) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return DahabTokens(
      id: t < 0.5 ? id : other.id,
      bg: l(bg, other.bg),
      bgSunken: l(bgSunken, other.bgSunken),
      surface: l(surface, other.surface),
      raised: l(raised, other.raised),
      sunken: l(sunken, other.sunken),
      ink: l(ink, other.ink),
      ink2: l(ink2, other.ink2),
      ink3: l(ink3, other.ink3),
      line: l(line, other.line),
      lineStrong: l(lineStrong, other.lineStrong),
      action: l(action, other.action),
      actionHover: l(actionHover, other.actionHover),
      actionInk: l(actionInk, other.actionInk),
      actionWash: l(actionWash, other.actionWash),
      highlight: l(highlight, other.highlight),
      highlightInk: l(highlightInk, other.highlightInk),
      highlightWash: l(highlightWash, other.highlightWash),
      positive: l(positive, other.positive),
      positiveWash: l(positiveWash, other.positiveWash),
      warning: l(warning, other.warning),
      warningWash: l(warningWash, other.warningWash),
      critical: l(critical, other.critical),
      criticalWash: l(criticalWash, other.criticalWash),
      scrim: l(scrim, other.scrim),
      chrome: l(chrome, other.chrome),
      focus: l(focus, other.focus),
      hairline: hairline + (other.hairline - hairline) * t,
      raised2: l(raised2, other.raised2),
      data: l(data, other.data),
      dataWash: l(dataWash, other.dataWash),
    );
  }
}
