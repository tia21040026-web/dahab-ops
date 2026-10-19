import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/access/presentation/session_cubit.dart';
import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'primitives.dart';

/// Shows [child] only when the session grants [permission] (or any of
/// [anyOf]). Otherwise shows [fallback], or [NoAccessView] when
/// [explain] is set, or nothing.
///
/// The server still enforces every key; this only hides what would 403.
class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    this.permission,
    this.anyOf = const [],
    required this.child,
    this.fallback,
    this.explain = false,
  });

  final String? permission;
  final List<String> anyOf;
  final Widget child;
  final Widget? fallback;
  final bool explain;

  static bool allowed(SessionState s, String? permission, List<String> anyOf) =>
      (permission != null && s.can(permission)) || (anyOf.isNotEmpty && s.canAny(anyOf));

  @override
  Widget build(BuildContext context) {
    final ok = context.select<SessionCubit, bool>((c) => allowed(c.state, permission, anyOf));
    if (ok) return child;
    if (fallback != null) return fallback!;
    if (explain) return NoAccessView(permission: permission ?? (anyOf.isEmpty ? '' : anyOf.first));
    return const SizedBox.shrink();
  }
}

/// "No access" with the missing key in mono, so it can be asked for.
class NoAccessView extends StatelessWidget {
  const NoAccessView({super.key, required this.permission});

  final String permission;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.x2),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline, color: t.ink3, size: 32),
          Gap.h12,
          Text(l.noAccessTitle, style: context.type.title),
          Gap.h4,
          Text(l.noAccessBody,
              textAlign: TextAlign.center, style: context.type.bodySm.copyWith(color: t.ink2)),
          Gap.h12,
          MonoText(permission, color: t.ink),
        ]),
      ),
    );
  }
}
