import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'dg_icons.dart';
import 'primitives.dart';

/// The modern layer of the Control Center: expressive status hero, rich
/// action tiles and the live traveler preview. Built on the same tokens and
/// hairline language as the rest of the app — no shadows, colour only for
/// status and action, and every animation respects reduced-motion.

/// The big state card at the top of the Control Center: a pulsing status
/// dot, a display-size verdict and a row of mono readings.
class HeroStatusCard extends StatelessWidget {
  const HeroStatusCard({
    super.key,
    required this.tone,
    required this.title,
    this.subtitle,
    this.readings = const [],
  });

  final Tone tone;
  final String title;
  final String? subtitle;

  /// `(label, value)` pairs rendered as small mono meters.
  final List<(String, String)> readings;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: t.toneWash(tone),
        borderRadius: Radii.lgAll,
        border: Border.all(color: t.toneInk(tone).withValues(alpha: 0.35), width: t.hairline),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          StatusDot(color: t.toneInk(tone), size: 10, pulse: tone != Tone.positive),
          Gap.w12,
          Expanded(
            child: Text(title, style: type.title.copyWith(color: t.toneInk(tone))),
          ),
        ]),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          Gap.h4,
          Text(subtitle!, style: type.caption.copyWith(color: t.ink2, height: 1.4)),
        ],
        if (readings.isNotEmpty) ...[
          Gap.h12,
          Row(
            children: [
              for (var i = 0; i < readings.length; i++) ...[
                if (i > 0) ...[Gap.w8, Container(width: 1, height: 22, color: t.line), Gap.w8],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(readings[i].$1,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: t.ink3)),
                      Gap.h4,
                      MonoText(readings[i].$2, size: 14, weight: FontWeight.w600, color: t.ink),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ]),
    );
  }
}

/// A rich navigation tile: icon on a tone wash, title + live subtitle and a
/// trailing status pill, hairline card, press haptic. The Control Center's
/// primary navigation unit.
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.tone = Tone.neutral,
    this.trailing,
    this.onTap,
  });

  final DgIcons icon;
  final String title;
  final String subtitle;
  final Tone tone;

  /// A small trailing widget (status pill, mono reading, switch).
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.all(Space.md),
      radius: Radii.lgAll,
      child: Row(children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: t.toneWash(tone),
            shape: BoxShape.circle,
            border: Border.all(color: t.toneInk(tone).withValues(alpha: 0.3), width: t.hairline),
          ),
          child: DgIcon(icon, size: 18, color: t.toneInk(tone)),
        ),
        Gap.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: t.ink)),
              Gap.h4,
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
            ],
          ),
        ),
        if (trailing != null) ...[Gap.w8, trailing!],
        Gap.w4,
        DgIcon(DgIcons.chev, size: 16, color: t.ink3),
      ]),
    );
  }
}

/// A small coloured pill with a mono reading (`ENGAGED 2`, `24 live`).
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.tone = Tone.neutral, this.pulse = false});

  final String label;
  final Tone tone;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: t.toneWash(tone),
        borderRadius: Radii.pill,
        border: Border.all(color: t.toneInk(tone).withValues(alpha: 0.4), width: t.hairline),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (pulse) ...[StatusDot(color: t.toneInk(tone), size: 6, pulse: true), Gap.w4],
        Text(label,
            textDirection: TextDirection.ltr,
            style: type.mono.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: t.toneInk(tone))),
      ]),
    );
  }
}

/// A mini device frame previewing what the traveler sees right now:
/// the announcement banner strip and/or the maintenance screen, localized.
class PreviewFrame extends StatelessWidget {
  const PreviewFrame({
    super.key,
    required this.label,
    this.banner,
    this.bannerWarn = false,
    this.maintenance,
    this.arabic = false,
  });

  final String label;

  /// Announcement text shown as a strip under a fake status bar.
  final String? banner;
  final bool bannerWarn;

  /// Maintenance message shown as a centered full-screen notice.
  final String? maintenance;
  final bool arabic;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final dir = arabic ? TextDirection.rtl : TextDirection.ltr;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: t.ink2)),
      Gap.h8,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Space.sm),
        decoration: BoxDecoration(
          color: t.bg,
          borderRadius: Radii.lgAll,
          border: Border.all(color: t.lineStrong, width: t.hairline),
        ),
        child: Directionality(
          textDirection: dir,
          child: Column(children: [
            // Fake status bar: a dot and a time-ish mono reading, like a device.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(children: [
                StatusDot(color: t.ink3, size: 5),
                const Spacer(),
                MonoText('10:27', size: 10, color: t.ink3),
              ]),
            ),
            if (banner != null && banner!.trim().isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: t.toneWash(bannerWarn ? Tone.warning : Tone.action),
                  borderRadius: Radii.smAll,
                ),
                child: Text(banner!,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: type.ui.copyWith(fontSize: 11, fontWeight: FontWeight.w600,
                        color: t.toneInk(bannerWarn ? Tone.warning : Tone.action))),
              ),
            if (maintenance != null && maintenance!.trim().isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(6, 6, 6, 8),
                padding: const EdgeInsets.all(Space.lg),
                constraints: const BoxConstraints(minHeight: 110),
                decoration: BoxDecoration(
                  color: t.toneWash(Tone.warning),
                  borderRadius: Radii.mdAll,
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  DgIcon(DgIcons.wrench, size: 20, color: t.toneInk(Tone.warning)),
                  Gap.h8,
                  Text(maintenance!,
                      textAlign: TextAlign.center,
                      maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: type.ui.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: t.ink)),
                ]),
              ),
            if ((banner == null || banner!.trim().isEmpty) &&
                (maintenance == null || maintenance!.trim().isEmpty))
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Text(context.l10n.previewQuiet,
                    textAlign: TextAlign.center,
                    style: type.ui.copyWith(fontSize: 12, color: t.ink3)),
              ),
          ]),
        ),
      ),
    ]);
  }
}
