import 'dart:async';

import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../format/formatters.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'instrument.dart';
import 'primitives.dart';

enum SystemHealth { healthy, degraded, actionRequired }

enum FeedState { live, polling, reconnecting, offline }

/// One subsystem dot on the status card (API, Database, Payments, AI).
class Subsystem {
  const Subsystem(this.label, this.tone);

  final String label;

  /// [Tone.neutral] means unknown / not configured.
  final Tone tone;
}

/// The top reading of the instrument (prototype `.status`): a 3-segment
/// gauge, the status word in its colour, the live feed with its age, a
/// detail line and a row of subsystem dots.
class StatusStrip extends StatefulWidget {
  const StatusStrip({
    super.key,
    required this.health,
    required this.feed,
    this.updatedAt,
    this.detail,
    this.onTap,
    this.now,
    this.subsystems = const [],
  });

  final SystemHealth health;
  final FeedState feed;
  final DateTime? updatedAt;

  /// e.g. "Paymob is slow (p95 1.8 s). 2 payment issues open."
  final String? detail;
  final VoidCallback? onTap;

  /// Fixed clock for tests/goldens. When null the age ticks live.
  final DateTime? now;
  final List<Subsystem> subsystems;

  @override
  State<StatusStrip> createState() => _StatusStripState();
}

class _StatusStripState extends State<StatusStrip> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    if (widget.now == null) {
      _tick = Timer.periodic(const Duration(seconds: 5), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Tone get tone => switch (widget.health) {
        SystemHealth.healthy => Tone.positive,
        SystemHealth.degraded => Tone.warning,
        SystemHealth.actionRequired => Tone.critical,
      };

  String _age(BuildContext context) {
    final at = widget.updatedAt;
    if (at == null) return '';
    final diff = (widget.now ?? DateTime.now()).difference(at);
    if (diff.inSeconds < 60) return context.l10n.secondsAgo(diff.inSeconds < 0 ? 0 : diff.inSeconds);
    return Fmt.ago(context, at, now: widget.now);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final label = switch (widget.health) {
      SystemHealth.healthy => l.statusHealthy,
      SystemHealth.degraded => l.statusDegraded,
      SystemHealth.actionRequired => l.statusActionRequired,
    };
    final (feedLabel, feedTone) = switch (widget.feed) {
      FeedState.live => (l.live, Tone.positive),
      FeedState.polling => (l.polling, Tone.warning),
      FeedState.reconnecting => (l.reconnecting, Tone.warning),
      FeedState.offline => (l.offlineBanner.split('.').first, Tone.critical),
    };
    final gauge = switch (widget.health) {
      SystemHealth.healthy => const [Tone.positive, Tone.positive, Tone.positive],
      SystemHealth.degraded => const [Tone.positive, Tone.warning],
      SystemHealth.actionRequired => const [Tone.critical],
    };
    final age = _age(context);
    final feedText = age.isEmpty ? feedLabel : l.feedUpdated(feedLabel, age);
    final feedInk = t.toneInk(feedTone);

    return Semantics(
      liveRegion: true,
      label: [label, if (widget.detail != null) widget.detail!, feedText].join(', '),
      child: Panel(
        onTap: widget.onTap,
        padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
        child: ExcludeSemantics(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            LayoutBuilder(
              builder: (context, box) => Row(children: [
                DgGauge(segments: gauge),
                const SizedBox(width: 10),
                // The status word wins space over the feed line.
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: box.maxWidth * 0.62 - 52),
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: t.toneInk(tone))),
                ),
                Gap.w12,
                Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: feedInk,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: t.toneWash(feedTone), spreadRadius: 3)],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(feedText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
                    ),
                  ]),
                ),
              ]),
            ),
            if (widget.detail != null && widget.detail!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(widget.detail!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: type.ui.copyWith(fontSize: 13, color: t.ink2)),
            ],
            if (widget.subsystems.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(border: Border(top: t.hairlineSide)),
                child: Wrap(spacing: 14, runSpacing: 6, children: [
                  for (final s in widget.subsystems)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: s.tone == Tone.neutral ? t.ink3 : t.toneInk(s.tone),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(s.label, style: type.ui.copyWith(fontSize: 13, color: t.ink2)),
                    ]),
                ]),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}
