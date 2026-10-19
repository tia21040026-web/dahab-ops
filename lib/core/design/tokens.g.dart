// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: src/styles/tokens.css via tool/gen_tokens.dart.
// Regenerate: fvm dart run tool/gen_tokens.dart
// ignore_for_file: constant_identifier_names

import 'package:flutter/painting.dart';

/// Theme-independent scales (spacing, radii, type, motion, geometry).
abstract final class DgScale {
  static const Color abyss950 = Color(0xFF071017);
  static const Color abyss900 = Color(0xFF0B151C);
  static const Color abyss850 = Color(0xFF0F1C25);
  static const Color abyss800 = Color(0xFF13222C);
  static const Color abyss700 = Color(0xFF1B2E3A);
  static const Color salt50 = Color(0xFFFBFAF7);
  static const Color salt100 = Color(0xFFF5F4F0);
  static const Color salt200 = Color(0xFFECEAE4);
  static const Color salt300 = Color(0xFFDEDAD1);
  static const Color granite700 = Color(0xFF4E403A);
  static const Color granite500 = Color(0xFF6B5A52);
  static const Color granite300 = Color(0xFFBBA99E);
  static const Color lagoon800 = Color(0xFF0A5E5C);
  static const Color lagoon700 = Color(0xFF0E7C7A);
  static const Color lagoon400 = Color(0xFF3CC2BC);
  static const Color lagoon200 = Color(0xFFA6E3DF);
  static const Color coral700 = Color(0xFFB4523A);
  static const Color coral500 = Color(0xFFD2694C);
  static const Color coral300 = Color(0xFFF08A6C);
  static const Color sand300 = Color(0xFFD9C3A5);
  static const double textXs = 13;
  static const double textSm = 14;
  static const double textMd = 16;
  static const double textLg = 18;
  static const double textXl = 22;
  static const double text2xl = 28;
  static const double text3xl = 36;
  static const double text4xl = 48;
  static const double text5xl = 64;
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;
  static const double space7 = 48;
  static const double space8 = 72;
  static const double contentMax = 1240;
  static const double radiusSm = 6;
  static const double radiusMd = 12;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusFull = 999;
  static const Duration durInstant = Duration(milliseconds: 120);
  static const Duration durQuick = Duration(milliseconds: 200);
  static const Duration durBase = Duration(milliseconds: 320);
  static const Duration durSlow = Duration(milliseconds: 520);
  static const List<double> easeOut = [0.22, 1, 0.36, 1];
  static const List<double> easeInOut = [0.65, 0, 0.35, 1];
  static const List<double> easeSpring = [0.34, 1.3, 0.64, 1];
  static const double touch = 44;
  static const double topbarH = 60;
  static const double tabbarH = 64;
  static const int zBase = 1;
  static const int zSticky = 30;
  static const int zChrome = 40;
  static const int zSheet = 60;
  static const int zToast = 80;
}

/// `abyss` theme colours.
abstract final class DgAbyss {
  static const Color bg = Color(0xFF0B151C);
  static const Color bgSunken = Color(0xFF071017);
  static const Color surface = Color(0xFF0F1C25);
  static const Color surfaceRaised = Color(0xFF13222C);
  static const Color surfaceSunken = Color(0xFF0A131A);
  static const Color ink = Color(0xFFECE9E2);
  static const Color ink2 = Color(0xFFBAC3C7);
  static const Color ink3 = Color(0xFF8C9AA2);
  static const Color line = Color(0x1AECE9E2);
  static const Color lineStrong = Color(0x33ECE9E2);
  static const Color action = Color(0xFF3CC2BC);
  static const Color actionHover = Color(0xFF5BD0CA);
  static const Color actionInk = Color(0xFF032220);
  static const Color actionWash = Color(0x243CC2BC);
  static const Color highlight = Color(0xFFF08A6C);
  static const Color highlightInk = Color(0xFF2A0F07);
  static const Color highlightWash = Color(0x24F08A6C);
  static const Color positive = Color(0xFF7FD1A8);
  static const Color positiveWash = Color(0x1F7FD1A8);
  static const Color warning = Color(0xFFF2C46B);
  static const Color warningWash = Color(0x1FF2C46B);
  static const Color critical = Color(0xFFF4917E);
  static const Color criticalWash = Color(0x21F4917E);
  static const Color scrim = Color(0x9E040A0E);
  static const Color chromeBg = Color(0xD60B151C);
  static const Color focus = Color(0xFF3CC2BC);
}

/// `salt` theme colours.
abstract final class DgSalt {
  static const Color bg = Color(0xFFF5F4F0);
  static const Color bgSunken = Color(0xFFECEAE4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceRaised = Color(0xFFFFFFFF);
  static const Color surfaceSunken = Color(0xFFECEAE4);
  static const Color ink = Color(0xFF0B151C);
  static const Color ink2 = Color(0xFF4B4744);
  static const Color ink3 = Color(0xFF6F6863);
  static const Color line = Color(0x1A0D1A22);
  static const Color lineStrong = Color(0x330D1A22);
  static const Color action = Color(0xFF0E7C7A);
  static const Color actionHover = Color(0xFF0A5E5C);
  static const Color actionInk = Color(0xFFFFFFFF);
  static const Color actionWash = Color(0x170E7C7A);
  static const Color highlight = Color(0xFFB4523A);
  static const Color highlightInk = Color(0xFFFFFFFF);
  static const Color highlightWash = Color(0x1AD2694C);
  static const Color positive = Color(0xFF1F6B47);
  static const Color positiveWash = Color(0xFFE6F2EC);
  static const Color warning = Color(0xFF8A5A0B);
  static const Color warningWash = Color(0xFFFBF1DC);
  static const Color critical = Color(0xFFA23A22);
  static const Color criticalWash = Color(0xFFFBEBE5);
  static const Color scrim = Color(0x73071017);
  static const Color chromeBg = Color(0xDBF5F4F0);
  static const Color focus = Color(0xFF0E7C7A);
}

/// `high-contrast-pro` theme colours.
abstract final class DgHighContrastPro {
  static const Color bg = Color(0xFF000000);
  static const Color bgSunken = Color(0xFF000000);
  static const Color surface = Color(0xFF0A0A0A);
  static const Color surfaceRaised = Color(0xFF171717);
  static const Color surfaceSunken = Color(0xFF000000);
  static const Color ink = Color(0xFFFFFFFF);
  static const Color ink2 = Color(0xFFF5F5F5);
  static const Color ink3 = Color(0xFFE5E5E5);
  static const Color line = Color(0xFFFFFFFF);
  static const Color lineStrong = Color(0xFFFFFFFF);
  static const Color action = Color(0xFFFFE600);
  static const Color actionHover = Color(0xFFFFD000);
  static const Color actionInk = Color(0xFF000000);
  static const Color actionWash = Color(0xFF1F1C00);
  static const Color highlight = Color(0xFF00F0FF);
  static const Color highlightInk = Color(0xFF000000);
  static const Color highlightWash = Color(0xFF002326);
  static const Color positive = Color(0xFF7CFFB2);
  static const Color positiveWash = Color(0xFF00210F);
  static const Color warning = Color(0xFFFFE600);
  static const Color warningWash = Color(0xFF1F1C00);
  static const Color critical = Color(0xFFFF8A7A);
  static const Color criticalWash = Color(0xFF2A0500);
  static const Color scrim = Color(0xD9000000);
  static const Color chromeBg = Color(0xFF000000);
  static const Color focus = Color(0xFFFFE600);
}
