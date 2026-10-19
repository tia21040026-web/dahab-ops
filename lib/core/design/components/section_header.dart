import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../spacing.dart';

/// Group heading inside a screen: small label, optional count and action.
/// Latin labels are tracked; Arabic never is (and is never uppercased).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.count,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsetsDirectional.fromSTEB(Space.lg, Space.xl, Space.sm, Space.sm),
    this.trailing,
  });

  final String title;
  final int? count;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Padding(
      padding: padding,
      child: Semantics(
        header: true,
        child: Row(children: [
          Flexible(
            child: Text(
              type.isArabic ? title : title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: type.label.copyWith(color: t.ink3, letterSpacing: type.isArabic ? 0 : 1.1),
            ),
          ),
          if (count != null) ...[
            Gap.w8,
            Text('$count',
                textDirection: TextDirection.ltr,
                style: type.monoSm.copyWith(color: t.ink3)),
          ],
          const Spacer(),
          if (trailing != null) trailing!,
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 36),
                padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.sm),
              ),
              child: Text(actionLabel!),
            ),
        ]),
      ),
    );
  }
}
