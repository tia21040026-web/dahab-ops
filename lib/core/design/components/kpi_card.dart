import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../format/formatters.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'primitives.dart';

/// One reading on the instrument (prototype `.kpi`): label top-start, a mono
/// delta with an arrow top-end, a large display number bottom-start and a
/// sparkline with an area wash bottom-end.
///
/// The delta is green when the change is an improvement ([upIsGood] decides
/// direction). A worsening reading takes the card's [tone] (crit or warn)
/// and stays quiet ink-3 on neutral cards. Crit and warn tones tint the
/// number; crit also tints the border.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.deltaCount,
    this.upIsGood = true,
    this.spark,
    this.tone = Tone.neutral,
    this.onTap,
    this.caption,
  });

  final String label;
  final num? value;

  /// Relative change (0.12 = +12%) versus the previous window. Shown when
  /// [deltaCount] is null.
  final double? delta;

  /// Absolute change versus the previous window (the prototype's `↑4`).
  final num? deltaCount;
  final bool upIsGood;
  final List<double>? spark;
  final Tone tone;
  final VoidCallback? onTap;

  /// Small unit after the number (e.g. `EGP`).
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final hasSpark = spark != null && spark!.length >= 2;
    final valueText = value == null ? '—' : Fmt.compact(value!);
    final numColor = switch (tone) {
      Tone.critical => t.critical,
      Tone.warning => t.warning,
      _ => t.ink,
    };
    final sparkTone = tone == Tone.critical || tone == Tone.warning ? tone : null;

    return Panel(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 11, 12, 10),
      borderColor: tone == Tone.critical ? t.critical.withValues(alpha: 0.3) : null,
      semanticLabel: '$label: $valueText',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: type.ui.copyWith(fontSize: 13, height: 1.25, color: t.ink2),
              ),
            ),
            if (deltaCount != null || delta != null) ...[
              const SizedBox(width: 6),
              DeltaPill(delta: delta ?? 0, count: deltaCount, upIsGood: upIsGood, tone: tone),
            ],
          ]),
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      valueText,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textDirection: TextDirection.ltr,
                      // The digits stay LTR but the reading sits on the
                      // start edge of the card (the right in Arabic).
                      textAlign: context.isRtl ? TextAlign.right : TextAlign.left,
                      style: type.displayNumber.copyWith(fontSize: 34, height: 0.95, color: numColor),
                    ),
                  ),
                  if (caption != null) ...[
                    const SizedBox(width: 4),
                    Text(caption!,
                        style: type.ui.copyWith(fontSize: 13, color: t.ink3, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ),
            if (hasSpark) ...[
              Gap.w8,
              SizedBox(width: 68, height: 28, child: Sparkline(values: spark!, tone: sparkTone)),
            ],
          ]),
        ],
      ),
    );
  }
}

/// Mono delta with an arrow (`↗4`, `↘2`, `+12%`), coloured by whether the
/// change is good (pos) or bad (the card's tone, else quiet ink-3).
class DeltaPill extends StatelessWidget {
  const DeltaPill({super.key, required this.delta, this.count, this.upIsGood = true, this.tone = Tone.neutral});

  final double delta;
  final num? count;
  final bool upIsGood;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final num change = count ?? delta;
    final flat = count != null ? count == 0 : delta.abs() < 0.005;
    final bool? good = flat ? null : (change > 0) == upIsGood;
    final color = switch (good) {
      null => t.ink3,
      true => t.positive,
      false => tone == Tone.critical || tone == Tone.warning ? t.toneInk(tone) : t.ink3,
    };
    final icon = flat
        ? Icons.remove_rounded
        : (change > 0 ? Icons.north_east_rounded : Icons.south_east_rounded);
    final text = count != null ? Fmt.number(count!.abs()) : Fmt.signedPercent(delta);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 2),
      MonoText(text, color: color, size: 13, weight: FontWeight.w500),
    ]);
  }
}

/// Minimal line (prototype sparkline): baseline hairline, area wash, the
/// series line and an emphasised endpoint dot. Time runs toward the end
/// edge, so the plot mirrors in RTL like the prototype.
class Sparkline extends StatelessWidget {
  const Sparkline({super.key, required this.values, this.color, this.tone});

  final List<double> values;
  final Color? color;

  /// Crit / warn readings draw in their status colour; otherwise the data
  /// series colour.
  final Tone? tone;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final line = color ?? (tone == null ? t.data : t.toneInk(tone!));
    final wash = tone == null ? t.dataWash : t.toneWash(tone!);
    Widget paint = CustomPaint(
      painter: _SparkPainter(values: values, line: line, wash: wash, base: t.line),
      size: Size.infinite,
    );
    if (context.isRtl) paint = Transform.flip(flipX: true, child: paint);
    return ExcludeSemantics(child: paint);
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({required this.values, required this.line, required this.wash, required this.base});

  final List<double> values;
  final Color line;
  final Color wash;
  final Color base;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    const p = 3.0;
    final w = size.width;
    final h = size.height;
    final mn = values.reduce(math.min);
    var mx = values.reduce(math.max);
    if (mx == mn) mx = mn + 1;
    final pts = [
      for (var i = 0; i < values.length; i++)
        Offset(p + i * (w - 2 * p) / (values.length - 1), h - p - (values[i] - mn) / (mx - mn) * (h - 2 * p)),
    ];
    canvas.drawLine(Offset(p, h - p), Offset(w - p, h - p), Paint()
      ..color = base
      ..strokeWidth = 1);
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final q in pts.skip(1)) {
      path.lineTo(q.dx, q.dy);
    }
    final area = Path.from(path)
      ..lineTo(w - p, h - p)
      ..lineTo(p, h - p)
      ..close();
    canvas.drawPath(area, Paint()..color = wash);
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(pts.last, 2.6, Paint()..color = line);
  }

  @override
  bool shouldRepaint(_SparkPainter old) =>
      old.values != values || old.line != line || old.wash != wash || old.base != base;
}
