import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../../control/data/control_repository.dart';
import 'session_cubit.dart';

/// App-wide strip while an admin is viewing as someone (read-only session).
/// Sits above every route so it cannot be missed; "End" calls
/// `DELETE /api/admin/view-as` and re-reads `/api/auth/me`.
class ViewAsBanner extends StatefulWidget {
  const ViewAsBanner({super.key});

  @override
  State<ViewAsBanner> createState() => _ViewAsBannerState();
}

class _ViewAsBannerState extends State<ViewAsBanner> {
  bool _busy = false;

  Future<void> _end() async {
    final session = context.read<SessionCubit>();
    setState(() => _busy = true);
    try {
      await GetIt.I<ControlRepository>().endViewAs();
      await session.refresh();
      if (mounted) showToast(context, context.l10n.viewAsEnded);
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewAs = context.select<SessionCubit, String?>((s) => s.state.viewAs?.email);
    if (viewAs == null) return const SizedBox.shrink();
    final t = context.dg;
    final l = context.l10n;
    return Material(
      color: t.highlightWash,
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: t.highlight, width: t.hairline))),
          padding: const EdgeInsetsDirectional.fromSTEB(Space.gutter, Space.xs, Space.xs, Space.xs),
          child: Semantics(
            liveRegion: true,
            child: Row(children: [
              Icon(Icons.visibility_outlined, size: 16, color: t.highlight),
              Gap.w8,
              Expanded(
                child: Text(l.viewAsBanner(viewAs),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.type.caption.copyWith(color: t.ink, fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: _busy ? null : _end,
                style: TextButton.styleFrom(foregroundColor: t.highlight, minimumSize: const Size(44, 36)),
                child: Text(l.endViewAs),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
