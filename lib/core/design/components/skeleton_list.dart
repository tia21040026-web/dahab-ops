import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import '../spacing.dart';

/// Loading placeholder shaped like the rows that will arrive. Shimmers
/// unless the platform asks for reduced motion.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 6, this.lines = 2, this.leading = false});

  final int count;
  final int lines;
  final bool leading;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final list = ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      itemCount: count,
      separatorBuilder: (_, __) => Container(height: t.hairline, color: t.line),
      itemBuilder: (_, i) => _SkeletonRow(lines: lines, leading: leading, seed: i),
    );
    return Semantics(
      label: context.l10n.loading,
      child: reduce
          ? list
          : Shimmer.fromColors(
              baseColor: t.raised,
              highlightColor: t.sunken,
              period: const Duration(milliseconds: 1400),
              child: list,
            ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.lines, required this.leading, required this.seed});

  final int lines;
  final bool leading;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    Widget bar(double widthFactor, double h) => FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: widthFactor,
          child: Container(
            height: h,
            decoration: BoxDecoration(color: t.raised, borderRadius: Radii.smAll),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.md),
      child: Row(children: [
        if (leading) ...[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: t.raised, shape: BoxShape.circle),
          ),
          Gap.w12,
        ],
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            bar(0.55 + (seed % 3) * 0.12, 14),
            for (var i = 1; i < lines; i++) ...[Gap.h8, bar(0.35 + (seed % 2) * 0.1, 11)],
          ]),
        ),
      ]),
    );
  }
}
