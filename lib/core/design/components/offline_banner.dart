import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../../connectivity/connectivity_cubit.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'primitives.dart';

/// Thin strip under the app bar while the device has no route. Reads
/// [ConnectivityCubit] when one is provided; otherwise use [online].
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.online});

  /// Explicit state (tests, previews). Null reads [ConnectivityCubit].
  final bool? online;

  @override
  Widget build(BuildContext context) {
    final explicit = online;
    if (explicit != null) return _strip(context, explicit);
    final cubit = _maybeCubit(context);
    if (cubit == null) return const SizedBox.shrink();
    return BlocBuilder<ConnectivityCubit, bool>(
      bloc: cubit,
      builder: (context, isOnline) => _strip(context, isOnline),
    );
  }

  static ConnectivityCubit? _maybeCubit(BuildContext context) {
    try {
      return BlocProvider.of<ConnectivityCubit>(context, listen: false);
    } catch (_) {
      return null;
    }
  }

  Widget _strip(BuildContext context, bool isOnline) {
    final t = context.dg;
    return AnimatedSize(
      duration: Motion.quick,
      child: isOnline
          ? const SizedBox(width: double.infinity)
          : Semantics(
              liveRegion: true,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
                decoration: BoxDecoration(
                  color: t.warningWash,
                  border: Border(bottom: BorderSide(color: t.line, width: t.hairline)),
                ),
                child: Row(children: [
                  StatusDot(color: t.warning, size: 7),
                  Gap.w8,
                  Expanded(
                    child: Text(context.l10n.offlineBanner,
                        style: context.type.caption.copyWith(color: t.ink)),
                  ),
                ]),
              ),
            ),
    );
  }
}
