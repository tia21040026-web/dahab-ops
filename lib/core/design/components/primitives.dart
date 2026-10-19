import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../dahab_tokens.dart';
import '../spacing.dart';

/// Status vocabulary. Colour carries meaning only.
enum Tone { neutral, action, positive, warning, critical, highlight }

extension ToneColors on DahabTokens {
  Color toneInk(Tone tone) => switch (tone) {
        Tone.neutral => ink2,
        Tone.action => action,
        Tone.positive => positive,
        Tone.warning => warning,
        Tone.critical => critical,
        Tone.highlight => highlight,
      };

  Color toneWash(Tone tone) => switch (tone) {
        Tone.neutral => ink.withValues(alpha: isDark ? 0.06 : 0.05),
        Tone.action => actionWash,
        Tone.positive => positiveWash,
        Tone.warning => warningWash,
        Tone.critical => criticalWash,
        Tone.highlight => highlightWash,
      };
}

/// A surface panel: surface fill + hairline, no shadow.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Space.lg),
    this.color,
    this.borderColor,
    this.radius = Radii.mdAll,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final BorderRadius radius;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final content = Padding(padding: padding, child: child);
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      container: true,
      child: Material(
        color: color ?? t.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor ?? t.line, width: t.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? content
            : InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
                child: content,
              ),
      ),
    );
  }
}

/// Monospaced reading with tabular figures (IDs, amounts, latencies).
class MonoText extends StatelessWidget {
  const MonoText(this.text, {super.key, this.color, this.size, this.weight, this.maxLines = 1});

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final base = context.type.monoMd;
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      // IDs and numbers never reorder inside RTL text.
      textDirection: TextDirection.ltr,
      style: base.copyWith(
        color: color ?? context.dg.ink2,
        fontSize: size ?? base.fontSize,
        fontWeight: weight ?? base.fontWeight,
      ),
    );
  }
}

/// A status dot. [pulse] breathes slowly for "live"; static under reduced
/// motion.
class StatusDot extends StatefulWidget {
  const StatusDot({super.key, required this.color, this.size = 8, this.pulse = false});

  final Color color;
  final double size;
  final bool pulse;

  @override
  State<StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<StatusDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (widget.pulse && !reduce) {
      if (!_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s * 2.2,
      height: s * 2.2,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final v = _c.value;
          return Stack(alignment: Alignment.center, children: [
            if (widget.pulse && v > 0)
              Container(
                width: s + s * 1.2 * v,
                height: s + s * 1.2 * v,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.35 * (1 - v)),
                ),
              ),
            Container(
              width: s,
              height: s,
              decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
            ),
          ]);
        },
      ),
    );
  }
}

/// Thin divider in the line colour.
class Hairline extends StatelessWidget {
  const Hairline({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsetsDirectional.only(start: indent),
        child: Container(height: context.dg.hairline, color: context.dg.line),
      );
}

/// Round initials avatar with a hairline ring.
class Monogram extends StatelessWidget {
  const Monogram(this.initials, {super.key, this.size = 40, this.tone = Tone.neutral});

  final String initials;
  final double size;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: t.toneWash(tone),
        border: Border.all(color: t.line, width: t.hairline),
      ),
      child: Text(
        initials,
        textDirection: TextDirection.ltr,
        style: context.type.label.copyWith(
          color: tone == Tone.neutral ? t.ink : t.toneInk(tone),
          fontSize: size * 0.34,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

/// Toast in the instrument style.
void showToast(BuildContext context, String message, {Tone tone = Tone.neutral, String? actionLabel, VoidCallback? onAction}) {
  final t = context.dg;
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Row(children: [
        if (tone != Tone.neutral) ...[
          StatusDot(color: t.toneInk(tone)),
          Gap.w8,
        ],
        Expanded(child: Text(message)),
      ]),
      action: actionLabel == null
          ? null
          : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      duration: const Duration(seconds: 4),
    ));
}
