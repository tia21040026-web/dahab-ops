import 'package:flutter/widgets.dart';

import 'tokens.g.dart';

/// 4pt spacing grid (tokens.css `--dg-space-*`).
abstract final class Space {
  static const double xs = DgScale.space1; // 4
  static const double sm = DgScale.space2; // 8
  static const double md = DgScale.space3; // 12
  static const double lg = DgScale.space4; // 16
  static const double xl = DgScale.space5; // 24
  static const double x2 = DgScale.space6; // 32
  static const double x3 = DgScale.space7; // 48
  static const double x4 = DgScale.space8; // 72

  /// Screen gutter on phones.
  static const double gutter = lg;
}

/// Radii. `full` is for chips, dots and avatars only.
abstract final class Radii {
  static const double sm = DgScale.radiusSm;
  static const double md = DgScale.radiusMd;
  static const double lg = DgScale.radiusLg;
  static const double xl = DgScale.radiusXl;
  static const double full = DgScale.radiusFull;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlTop = BorderRadius.vertical(top: Radius.circular(xl));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}

/// Motion durations and curves (tokens.css `--dg-dur-*`, `--dg-ease-*`).
abstract final class Motion {
  static const Duration instant = DgScale.durInstant;
  static const Duration quick = DgScale.durQuick;
  static const Duration base = DgScale.durBase;
  static const Duration slow = DgScale.durSlow;

  static final Curve easeOut = _cubic(DgScale.easeOut);
  static final Curve easeInOut = _cubic(DgScale.easeInOut);
  static final Curve spring = _cubic(DgScale.easeSpring);

  static Cubic _cubic(List<double> p) => Cubic(p[0], p[1], p[2], p[3]);
}

/// Geometry.
abstract final class Geometry {
  static const double touch = DgScale.touch; // 44 minimum hit target
  static const double topBar = DgScale.topbarH;
  static const double tabBar = DgScale.tabbarH;

  /// Width at which the shell switches to rail + master-detail.
  static const double tabletBreakpoint = 840;
}

/// Shorthand gaps.
abstract final class Gap {
  static const SizedBox h4 = SizedBox(height: Space.xs);
  static const SizedBox h8 = SizedBox(height: Space.sm);
  static const SizedBox h12 = SizedBox(height: Space.md);
  static const SizedBox h16 = SizedBox(height: Space.lg);
  static const SizedBox h24 = SizedBox(height: Space.xl);
  static const SizedBox h32 = SizedBox(height: Space.x2);
  static const SizedBox w4 = SizedBox(width: Space.xs);
  static const SizedBox w8 = SizedBox(width: Space.sm);
  static const SizedBox w12 = SizedBox(width: Space.md);
  static const SizedBox w16 = SizedBox(width: Space.lg);
}
