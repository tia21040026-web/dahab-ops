import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/api/models/paged.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/control_repository.dart';

/// Second-admin inbox. The requester's own items are hidden (the server
/// refuses self-approval anyway); approving executes the queued action.
@RoutePage()
class ApprovalsPage extends StatelessWidget {
  const ApprovalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<ControlRepository>();
    return BlocProvider(
      create: (_) => ListCubit<Approval>(
        (q) async => Paged(items: await repo.approvals(status: '${q.filters['status'] ?? 'pending'}')),
        initial: const ListQuery(filters: {'status': 'pending'}),
      )..start(),
      child: const _ApprovalsView(),
    );
  }
}

/// Whether [a] was requested by the signed-in user.
bool isOwnApproval(Approval a, SessionState s) {
  final by = a.requestedBy?.toLowerCase();
  final u = s.user;
  if (by == null || u == null) return false;
  return by == u.id.toLowerCase() || by == u.email.toLowerCase();
}

class _ApprovalsView extends StatelessWidget {
  const _ApprovalsView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final cubit = context.watch<ListCubit<Approval>>();
    final status = '${cubit.state.filter('status') ?? 'pending'}';
    final hidden = status == 'pending'
        ? cubit.state.items.where((a) => isOwnApproval(a, session)).length
        : 0;
    return SectionScaffold(
      title: l.approvalsTitle,
      permission: P.approvalsDecide,
      body: AsyncListView<Approval>(
        header: Column(children: [
          FilterBar<String>(
            options: [
              FilterOption('pending', l.pending),
              FilterOption('approved', l.approved),
              FilterOption('rejected', l.rejected),
            ],
            selected: status,
            onSelected: (v) => cubit.setFilter('status', v ?? 'pending'),
          ),
          if (hidden > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, 0),
              child: Row(children: [
                Icon(Icons.visibility_off_outlined, size: 16, color: context.dg.ink3),
                Gap.w8,
                Expanded(
                  child: Text(l.ownHidden,
                      style: context.type.caption.copyWith(color: context.dg.ink3)),
                ),
              ]),
            ),
        ]),
        where: (a) => status != 'pending' || !isOwnApproval(a, session),
        emptyIcon: Icons.how_to_reg_outlined,
        emptyTitle: l.approvalsEmpty,
        itemBuilder: (context, a) => _ApprovalCard(approval: a, pending: status == 'pending'),
      ),
    );
  }
}

class _ApprovalCard extends StatefulWidget {
  const _ApprovalCard({required this.approval, required this.pending});

  final Approval approval;
  final bool pending;

  @override
  State<_ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<_ApprovalCard> {
  bool _open = false;
  bool _busy = false;

  Approval get a => widget.approval;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.xs),
      child: Panel(
        onTap: () => setState(() => _open = !_open),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text(a.summary ?? a.action, style: type.bodyStrong)),
            StatusBadge(label: a.status, tone: StatusBadge.toneFor(a.status)),
          ]),
          Gap.h4,
          MonoText(a.action, size: 12, color: t.ink3),
          Gap.h4,
          Text(
            [l.requestedBy(a.requestedBy ?? '—'), Fmt.ago(context, a.requestedAt)].join(' · '),
            style: type.caption.copyWith(color: t.ink2),
          ),
          if (a.decisionNote != null)
            Text('${a.decidedBy ?? ''}: ${a.decisionNote}',
                style: type.caption.copyWith(color: t.ink3)),
          if (_open && a.payload != null) ...[
            Gap.h8,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Space.sm),
              decoration: BoxDecoration(color: t.sunken, borderRadius: Radii.smAll),
              child: MonoText(
                const JsonEncoder.withIndent('  ').convert(a.payload),
                maxLines: 30,
                size: 12,
              ),
            ),
          ],
          if (widget.pending) ...[
            Gap.h12,
            Row(children: [
              Expanded(
                child: DahabButton.secondary(
                  label: l.reject,
                  compact: true,
                  onPressed: _busy ? null : () => _decide(false),
                ),
              ),
              Gap.w8,
              Expanded(
                child: DahabButton(
                  label: l.approve,
                  compact: true,
                  loading: _busy,
                  onPressed: () => _decide(true),
                ),
              ),
            ]),
          ],
        ]),
      ),
    );
  }

  Future<void> _decide(bool approve) async {
    final l = context.l10n;
    final note = await showConfirmDangerSheet(
      context,
      title: '${approve ? l.approve : l.reject} · ${a.summary ?? a.action}',
      body: approve ? null : l.decisionNote,
      biometric: approve,
      destructive: !approve,
      confirmLabel: approve ? l.approve : l.reject,
    );
    if (note == null || !mounted) return;
    setState(() => _busy = true);
    final cubit = context.read<ListCubit<Approval>>();
    try {
      await GetIt.I<ControlRepository>().decideApproval(a.id, approve: approve, note: note);
      if (!mounted) return;
      cubit.removeWhere((x) => x.id == a.id);
      showToast(context, l.decidedToast, tone: Tone.positive);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showErrorToast(context, e);
      }
    }
  }
}
