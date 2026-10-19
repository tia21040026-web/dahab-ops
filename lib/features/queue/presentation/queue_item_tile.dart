import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../data/queue_repository.dart';

/// A one-second clock that only ticks while someone listens (SLA timers).
class _Clock extends ValueNotifier<DateTime> {
  _Clock() : super(DateTime.now());

  Timer? _timer;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => value = DateTime.now());
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _timer?.cancel();
      _timer = null;
    }
  }
}

final _clock = _Clock();

/// Opens the screen that resolves [item].
void openQueueItem(BuildContext context, QueueItem item) {
  final router = context.router;
  if (item.entityRef != null && item.entityRef!.isNotEmpty) {
    router.push(BookingDetailRoute(ref: item.entityRef!));
  } else if (item.kind == QueueKind.refundApproval) {
    router.push(const ApprovalsRoute());
  } else if (item.kind == QueueKind.support) {
    router.push(const SupportRoute());
  } else {
    router.navigate(const QueueRoute());
  }
}

/// Queue row (prototype `.q-item`): 3px severity stripe, 15/500 title, mono
/// id + meta line, and the SLA countdown with its ring on the end side.
class QueueItemTile extends StatelessWidget {
  const QueueItemTile({super.key, required this.item, this.onTap, this.showLeft = true});

  final QueueItem item;
  final VoidCallback? onTap;

  /// Shows the quiet "left" under the countdown (Queue), hidden on Pulse.
  final bool showLeft;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final stripe = item.isCritical ? t.critical : (item.severity == 1 ? t.warning : t.lineStrong);
    final ref = item.entityRef ?? '';
    return Material(
      color: t.bg,
      child: InkWell(
        onTap: onTap ?? () => openQueueItem(context, item),
        child: Stack(children: [
          PositionedDirectional(
            start: 10,
            top: 12,
            bottom: 12,
            child: Container(
              width: 3,
              decoration: BoxDecoration(color: stripe, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(23, 13, 20, 13),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w500, height: 1.3, color: t.ink)),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(children: [
                      if (ref.isNotEmpty) ...[
                        TextSpan(
                          text: ref,
                          style: type.mono.copyWith(fontSize: 13, color: t.ink3),
                        ),
                        const TextSpan(text: '  '),
                      ],
                      TextSpan(text: item.subtitle),
                    ]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: type.ui.copyWith(fontSize: 13, height: 1.4, color: t.ink2),
                  ),
                ]),
              ),
              Gap.w12,
              QueueSla(item: item, showLeft: showLeft),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Mono countdown with a 16px ring for warn/crit rows, "left" under it.
class QueueSla extends StatelessWidget {
  const QueueSla({super.key, required this.item, this.showLeft = true});

  final QueueItem item;
  final bool showLeft;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final due = item.slaDueAt;
    if (due == null) {
      if (item.at == null) return const SizedBox.shrink();
      return ValueListenableBuilder<DateTime>(
        valueListenable: _clock,
        builder: (context, now, _) => Text(_ago(now.difference(item.at!)),
            textDirection: TextDirection.ltr, style: type.mono.copyWith(fontSize: 13, color: t.ink3)),
      );
    }
    return ValueListenableBuilder<DateTime>(
      valueListenable: _clock,
      builder: (context, now, _) {
        final left = due.difference(now);
        final overdue = left.isNegative;
        final tone = overdue || item.isCritical ? Tone.critical : (item.severity == 1 ? Tone.warning : Tone.neutral);
        final color = tone == Tone.neutral ? t.ink2 : t.toneInk(tone);
        final span = item.at == null ? const Duration(hours: 1) : due.difference(item.at!);
        final frac = span.inSeconds <= 0 ? 0.0 : (left.inSeconds / span.inSeconds).clamp(0.0, 1.0);
        return Semantics(
          label: overdue ? l.overdue : '${_countdown(left)} ${l.slaLeft}',
          excludeSemantics: true,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              if (tone != Tone.neutral) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CustomPaint(painter: _Ring(frac, color, t.lineStrong)),
                ),
                const SizedBox(width: 6),
              ],
              Text(overdue ? l.overdue : _countdown(left),
                  textDirection: TextDirection.ltr,
                  style: (overdue ? type.ui : type.mono)
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w500, height: 1, color: color)),
            ]),
            if (showLeft && !overdue) ...[
              const SizedBox(height: 2),
              Text(l.slaLeft, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
            ],
          ]),
        );
      },
    );
  }

  static String _countdown(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  static String _ago(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }
}

class _Ring extends CustomPainter {
  _Ring(this.fraction, this.color, this.track);

  final double fraction;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final r = (Offset.zero & size).deflate(1.5);
    canvas.drawArc(r, 0, math.pi * 2, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = track);
    if (fraction <= 0) return;
    canvas.drawArc(r, -math.pi / 2, math.pi * 2 * fraction, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color);
  }

  @override
  bool shouldRepaint(_Ring old) => old.fraction != fraction || old.color != color || old.track != track;
}

/// Swipe toward the start edge to reveal Snooze (warn wash) and Resolve
/// (action fill), 168px wide, as in the prototype. Only one row stays open.
class SwipeActionsRow extends StatefulWidget {
  const SwipeActionsRow({super.key, required this.child, required this.onSnooze, required this.onResolve});

  final Widget child;
  final VoidCallback onSnooze;
  final VoidCallback onResolve;

  @override
  State<SwipeActionsRow> createState() => _SwipeActionsRowState();
}

class _SwipeActionsRowState extends State<SwipeActionsRow> with SingleTickerProviderStateMixin {
  static const _w = 168.0;
  static _SwipeActionsRowState? _open;

  late final AnimationController _c = AnimationController(vsync: this, duration: Motion.base);

  @override
  void dispose() {
    if (_open == this) _open = null;
    _c.dispose();
    super.dispose();
  }

  void _close() => _c.animateTo(0, curve: Motion.easeOut);

  void _settle(double velocity) {
    final dir = context.isRtl ? -1 : 1;
    final v = -velocity * dir;
    final open = v > 300 || (v > -300 && _c.value > 0.5);
    if (open) {
      if (_open != null && _open != this) _open!._close();
      _open = this;
      HapticFeedback.selectionClick();
    }
    _c.animateTo(open ? 1 : 0, curve: Motion.easeOut);
  }

  void _act(VoidCallback f) {
    _close();
    f();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final dir = context.isRtl ? -1.0 : 1.0;
    Widget action(DgIcons icon, String label, Color bg, Color fg, VoidCallback onTap) => Expanded(
          child: Material(
            color: bg,
            child: InkWell(
              onTap: () => _act(onTap),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                DgIcon(icon, color: fg),
                const SizedBox(height: 4),
                Text(label, style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: fg)),
              ]),
            ),
          ),
        );
    return ClipRect(
      child: Stack(children: [
        Positioned.fill(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: SizedBox(
              width: _w,
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                action(DgIcons.snooze, l.snooze, t.warningWash, t.warning, widget.onSnooze),
                action(DgIcons.check, l.resolve, t.action, t.actionInk, widget.onResolve),
              ]),
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (d) {
            _c.value = (_c.value - d.primaryDelta! * dir / _w).clamp(0.0, 1.0);
          },
          onHorizontalDragEnd: (d) => _settle(d.primaryVelocity ?? 0),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, child) => Transform.translate(
              offset: Offset(-_w * _c.value * dir, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: _c.value > 0
                      ? BorderDirectional(end: BorderSide(color: t.line, width: t.hairline))
                      : null,
                ),
                child: child,
              ),
            ),
            child: widget.child,
          ),
        ),
      ]),
    );
  }
}
