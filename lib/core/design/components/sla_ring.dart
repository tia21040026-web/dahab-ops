import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import 'primitives.dart';

/// Time left against an SLA as a thin ring plus minutes in mono.
/// Turns warning under 25% left and critical when overdue.
class SlaRing extends StatelessWidget {
  const SlaRing({
    super.key,
    required this.total,
    required this.remaining,
    this.size = 36,
    this.showLabel = true,
  });

  final Duration total;

  /// Negative when overdue.
  final Duration remaining;
  final double size;
  final bool showLabel;

  double get fraction {
    if (total.inSeconds <= 0) return 0;
    return (remaining.inSeconds / total.inSeconds).clamp(0.0, 1.0);
  }

  Tone get tone {
    if (remaining.isNegative) return Tone.critical;
    if (fraction < 0.25) return Tone.warning;
    return Tone.neutral;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final c = tone == Tone.neutral ? t.ink2 : t.toneInk(tone);
    final mins = remaining.inMinutes.abs();
    final text = remaining.isNegative ? '−${l.slaMinutes(mins)}' : l.slaMinutes(mins);
    return Semantics(
      label: '$text ${remaining.isNegative ? l.overdue : l.slaLeft}',
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(fraction: fraction, color: c, track: t.line, width: 2.5),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          MonoText(text, color: c, size: 13),
        ],
      ]),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.fraction, required this.color, required this.track, required this.width});

  final double fraction;
  final Color color;
  final Color track;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = rect.deflate(width / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = track;
    canvas.drawArc(r, 0, math.pi * 2, false, base);
    if (fraction <= 0) return;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(r, -math.pi / 2, math.pi * 2 * fraction, false, p);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color || old.track != track;
}
