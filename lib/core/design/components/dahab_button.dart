import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../spacing.dart';

enum ButtonVariant { primary, secondary, ghost, danger }

/// The app's button. One [ButtonVariant.primary] per screen.
class DahabButton extends StatelessWidget {
  const DahabButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.leading,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  });

  const DahabButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  }) : variant = ButtonVariant.secondary;

  const DahabButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  }) : variant = ButtonVariant.ghost;

  const DahabButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leading,
    this.loading = false,
    this.expand = false,
    this.compact = false,
  }) : variant = ButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;

  /// Custom leading glyph (e.g. a [DgIcon]); wins over [icon].
  final Widget? leading;
  final bool loading;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final enabled = onPressed != null && !loading;
    final fg = switch (variant) {
      ButtonVariant.primary => t.actionInk,
      ButtonVariant.secondary => t.ink,
      ButtonVariant.ghost => t.action,
      ButtonVariant.danger => t.bg,
    };
    final spinner = SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2, color: fg),
    );
    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          spinner
        else if (leading != null)
          IconTheme.merge(data: IconThemeData(color: fg, size: 20), child: leading!)
        else if (icon != null)
          Icon(icon, size: 18),
        if (loading || icon != null || leading != null) Gap.w8,
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );
    final press = enabled
        ? () {
            HapticFeedback.lightImpact();
            onPressed!();
          }
        : null;
    final size = compact ? const Size(44, 40) : const Size(64, 48);
    final pad = compact
        ? const EdgeInsetsDirectional.symmetric(horizontal: Space.lg, vertical: Space.sm)
        : null;

    final Widget button = switch (variant) {
      ButtonVariant.primary => FilledButton(
          onPressed: press,
          style: FilledButton.styleFrom(minimumSize: size, padding: pad),
          child: child,
        ),
      ButtonVariant.secondary => OutlinedButton(
          onPressed: press,
          style: OutlinedButton.styleFrom(minimumSize: size, padding: pad),
          child: child,
        ),
      ButtonVariant.ghost => TextButton(
          onPressed: press,
          style: TextButton.styleFrom(minimumSize: size, padding: pad),
          child: child,
        ),
      ButtonVariant.danger => FilledButton(
          onPressed: press,
          style: FilledButton.styleFrom(
            minimumSize: size,
            padding: pad,
            backgroundColor: t.critical,
            foregroundColor: t.bg,
            disabledBackgroundColor: t.ink.withValues(alpha: 0.08),
            disabledForegroundColor: t.ink3,
          ),
          child: child,
        ),
    };
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
