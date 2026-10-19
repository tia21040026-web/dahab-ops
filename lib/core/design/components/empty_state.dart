import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'dahab_button.dart';

/// Quiet empty list: a line icon, what is (not) here, and at most one action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String? title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.x3),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: t.line, width: t.hairline),
            ),
            child: Icon(icon, color: t.ink3, size: 26),
          ),
          Gap.h16,
          Text(title ?? context.l10n.emptyList, style: type.title, textAlign: TextAlign.center),
          if (body != null) ...[
            Gap.h4,
            Text(body!, style: type.bodySm.copyWith(color: t.ink2), textAlign: TextAlign.center),
          ],
          if (actionLabel != null && onAction != null) ...[
            Gap.h16,
            DahabButton.secondary(label: actionLabel!, onPressed: onAction),
          ],
        ]),
      ),
    );
  }
}
