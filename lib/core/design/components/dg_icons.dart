import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The prototype's stroke icon set (24-grid, 1.75 stroke, round caps).
///
/// Drawn from the same path data as the design prototype so the shell,
/// top bars and rows read exactly like it. Directional glyphs ([back],
/// [chev]) mirror in RTL.
enum DgIcons {
  activity('<path d="M22 12h-4l-3 9L9 3l-3 9H2"/>'),
  queue('<path d="M9 6h12M9 12h12M9 18h12"/><path d="M3.5 6h1.5M3.5 12h1.5M3.5 18h1.5"/>'),
  live('<circle cx="12" cy="12" r="2"/><path d="M16.24 7.76a6 6 0 0 1 0 8.49M7.76 16.24a6 6 0 0 1 0-8.49M19.07 4.93a10 10 0 0 1 0 14.14M4.93 19.07a10 10 0 0 1 0-14.14"/>'),
  inbox('<path d="M22 12h-6l-2 3h-4l-2-3H2"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/>'),
  grid('<rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/>'),
  search('<circle cx="11" cy="11" r="7.5"/><path d="m21 21-4.3-4.3"/>'),
  bell('<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>'),
  chev('<path d="m9 18 6-6-6-6"/>', mirror: true),
  back('<path d="m15 18-6-6 6-6"/>', mirror: true),
  down('<path d="m6 9 6 6 6-6"/>'),
  check('<path d="M20 6 9 17l-5-5"/>'),
  x('<path d="M18 6 6 18M6 6l12 12"/>'),
  alert('<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4M12 17h.01"/>'),
  card('<rect width="20" height="14" x="2" y="5" rx="2"/><path d="M2 10h20"/>'),
  user('<circle cx="12" cy="8" r="4"/><path d="M20 21a8 8 0 0 0-16 0"/>'),
  users('<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>'),
  car('<path d="M5 17H3v-5l2.2-5h13.6L21 12v5h-2"/><circle cx="7.5" cy="17" r="2"/><circle cx="16.5" cy="17" r="2"/><path d="M9.5 17h5M3 12h18"/>'),
  face('<path d="M3 7V5a2 2 0 0 1 2-2h2M17 3h2a2 2 0 0 1 2 2v2M21 17v2a2 2 0 0 1-2 2h-2M7 21H5a2 2 0 0 1-2-2v-2"/><path d="M9 9v1M15 9v1M12 9v4h-1M9 16c1.7 1.3 4.3 1.3 6 0"/>'),
  lock('<rect width="18" height="11" x="3" y="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>'),
  mail('<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-10 6L2 7"/>'),
  eye('<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>'),
  shield('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/>'),
  power('<path d="M12 2v10"/><path d="M18.4 6.6a9 9 0 1 1-12.77.04"/>'),
  refresh('<path d="M21 12a9 9 0 1 1-2.64-6.36L21 8"/><path d="M21 3v5h-5"/>'),
  phone('<path d="M22 16.9v3a2 2 0 0 1-2.2 2 19.8 19.8 0 0 1-8.6-3.1 19.5 19.5 0 0 1-6-6A19.8 19.8 0 0 1 2.1 4.2 2 2 0 0 1 4.1 2h3a2 2 0 0 1 2 1.7c.1 1 .4 1.9.7 2.8a2 2 0 0 1-.5 2.1L8 9.9a16 16 0 0 0 6 6l1.3-1.3a2 2 0 0 1 2.1-.4c.9.3 1.8.6 2.8.7a2 2 0 0 1 1.7 2z"/>'),
  msg('<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>'),
  cal('<rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>'),
  pin('<path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0z"/><circle cx="12" cy="10" r="3"/>'),
  box('<path d="M21 8 12 3 3 8v8l9 5 9-5z"/><path d="m3 8 9 5 9-5M12 13v8"/>'),
  wallet('<path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1"/><path d="M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4"/>'),
  snooze('<circle cx="12" cy="13" r="8"/><path d="M12 9v4l2 2M5 3 2 6M22 6l-3-3"/>'),
  more('<circle cx="5" cy="12" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/>'),
  up('<path d="M7 17 17 7M8 7h9v9"/>'),
  dn('<path d="M7 7l10 10M17 8v9H8"/>'),
  sort('<path d="M3 6h18M6 12h12M10 18h4"/>'),
  plus('<path d="M12 5v14M5 12h14"/>'),
  wrench('<path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94z"/>'),
  server('<rect width="20" height="8" x="2" y="2" rx="2"/><rect width="20" height="8" x="2" y="14" rx="2"/><path d="M6 6h.01M6 18h.01"/>'),
  building('<rect width="16" height="20" x="4" y="2" rx="2"/><path d="M9 22v-4h6v4M8 6h.01M12 6h.01M16 6h.01M8 10h.01M12 10h.01M16 10h.01M8 14h.01M12 14h.01M16 14h.01"/>'),
  trash('<path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>'),
  copy('<rect width="14" height="14" x="8" y="8" rx="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/>'),
  anchor('<circle cx="12" cy="5" r="3"/><path d="M12 22V8M5 12H2a10 10 0 0 0 20 0h-3"/>');

  const DgIcons(this.body, {this.mirror = false});

  final String body;

  /// Points along the reading direction; flipped in RTL.
  final bool mirror;

  String get svg =>
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#000" '
      'stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">$body</svg>';
}

/// One [DgIcons] glyph in [color] (defaults to the ambient icon colour).
class DgIcon extends StatelessWidget {
  const DgIcon(this.icon, {super.key, this.size = 20, this.color, this.semanticLabel});

  final DgIcons icon;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? const Color(0xFF888888);
    Widget pic = SvgPicture.string(
      icon.svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
      excludeFromSemantics: semanticLabel == null,
      semanticsLabel: semanticLabel,
    );
    if (icon.mirror && Directionality.of(context) == TextDirection.rtl) {
      pic = Transform.flip(flipX: true, child: pic);
    }
    return SizedBox(width: size, height: size, child: pic);
  }
}

/// The Dahab Ops mark (sounding rings around a point), in the action colour.
class DgMark extends StatelessWidget {
  const DgMark({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  static const _svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" fill="none" '
      'stroke="#000" stroke-width="1.75"><circle cx="16" cy="16" r="14.5"/>'
      '<ellipse cx="16.6" cy="15.4" rx="9.5" ry="8.6"/><ellipse cx="17.2" cy="14.8" rx="5" ry="4.4"/>'
      '<circle cx="17.6" cy="14.4" r="1.4" fill="#000" stroke="none"/></svg>';

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return SvgPicture.string(_svg,
        width: size, height: size, colorFilter: ColorFilter.mode(c, BlendMode.srcIn));
  }
}
