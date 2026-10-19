import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_error.dart';
import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../control/presentation/my_devices_page.dart';
import '../domain/permissions.dart';
import 'overrides_editor.dart';
import 'session_cubit.dart';
import 'role_labels.dart';
import 'user_detail_cubit.dart';
import '../../../core/router/shell_leading.dart';

/// Admin view of one staff member (prototype § Access control › user).
@RoutePage()
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, @PathParam('id') required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<UserDetailCubit>()..start(userId),
      child: _UserDetailView(userId: userId),
    );
  }
}

class _UserDetailView extends StatelessWidget {
  const _UserDetailView({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.details)),
      body: BlocBuilder<UserDetailCubit, UserDetailState>(
        builder: (context, s) {
          final cubit = context.read<UserDetailCubit>();
          if (s.status == UserDetailStatus.loading) return const SkeletonList(count: 5);
          if (s.status == UserDetailStatus.failure || s.detail == null) {
            return ErrorView(
              error: s.error ?? const ApiError(kind: ApiErrorKind.notFound),
              onRetry: () => cubit.start(userId),
            );
          }
          return RefreshIndicator(onRefresh: cubit.reload, child: _Body(state: s));
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final UserDetailState state;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final d = state.detail!;
    final u = d.user;
    final suspended = u.isSuspended;
    final session = context.watch<SessionCubit>().state;
    final isSelf = session.user?.id == u.id;
    final dangerous = {for (final p in state.catalog) if (p.dangerous) p.key};
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(Space.gutter),
        child: Row(children: [
          Monogram(u.initials, size: 56, tone: suspended ? Tone.critical : Tone.neutral),
          Gap.w16,
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u.displayName, style: type.heading),
              Text(u.email, style: type.bodySm.copyWith(color: t.ink2)),
              Gap.h8,
              Wrap(spacing: Space.sm, runSpacing: Space.xs, children: [
                StatusBadge(label: RoleLabels.name(l, u.role), dot: false, outlined: true),
                StatusBadge(
                  label: suspended ? l.statusSuspended : l.statusActive,
                  tone: suspended ? Tone.critical : Tone.positive,
                ),
              ]),
            ]),
          ),
        ]),
      ),
      FieldList(fields: [
        DataField(l.phone, u.phone ?? '—', mono: true),
        if (u.supplierId != null) DataField(l.supplierId, u.supplierId!, mono: true),
        DataField('ID', u.id, mono: true),
        DataField(l.deviceCount(d.devices.length), Fmt.date(context, u.createdAt)),
      ]),
      if (!isSelf)
        PermissionGate(
          permission: P.usersManage,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, 0),
            child: Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              DahabButton.secondary(
                label: l.changeRole,
                icon: Icons.badge_outlined,
                compact: true,
                onPressed: state.busy ? null : () => _changeRole(context),
              ),
              DahabButton.secondary(
                label: l.revokeSessions,
                icon: Icons.logout,
                compact: true,
                onPressed: state.busy ? null : () => _revoke(context),
              ),
              PermissionGate(
                permission: P.viewAs,
                child: DahabButton.secondary(
                  label: l.viewAsStart,
                  icon: Icons.visibility_outlined,
                  compact: true,
                  onPressed: state.busy || session.isViewingAs ? null : () => _viewAs(context),
                ),
              ),
              suspended
                  ? DahabButton(
                      label: l.reactivate,
                      compact: true,
                      onPressed: state.busy ? null : () => _status(context, 'active'),
                    )
                  : DahabButton.danger(
                      label: l.suspend,
                      icon: Icons.block,
                      compact: true,
                      onPressed: state.busy ? null : () => _status(context, 'suspended'),
                    ),
            ]),
          ),
        ),
      SectionHeader(
        title: l.overrides,
        count: d.overrides.length,
        actionLabel: session.can(P.usersManage) && !isSelf ? l.editOverrides : null,
        onAction: () => _editOverrides(context),
      ),
      if (d.overrides.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          child: Text(l.overridesHint, style: type.caption.copyWith(color: t.ink3)),
        )
      else
        for (final o in d.overrides)
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
            leading: Icon(o.effect == 'deny' ? Icons.remove_circle_outline : Icons.add_circle_outline,
                color: o.effect == 'deny' ? t.critical : t.positive, size: 20),
            title: MonoText(o.permission, color: t.ink),
            subtitle: Text([o.effect, o.createdBy, Fmt.ago(context, o.createdAt)].whereType<String>().join(' · ')),
            trailing: dangerous.contains(o.permission)
                ? StatusBadge(label: l.dangerous, tone: Tone.critical)
                : null,
          ),
      SectionHeader(title: l.effectivePermissions, count: d.effectivePermissions.length),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        child: Wrap(spacing: Space.xs, runSpacing: Space.xs, children: [
          for (final p in d.effectivePermissions)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                    color: dangerous.contains(p) || p == '*' ? t.critical.withValues(alpha: 0.5) : t.line,
                    width: t.hairline),
                borderRadius: Radii.smAll,
              ),
              child: MonoText(p, size: 12),
            ),
        ]),
      ),
      SectionHeader(title: l.devices, count: d.devices.length),
      for (final dev in d.devices) DeviceTile(device: dev),
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        leading: Icon(Icons.history, color: t.ink2),
        title: Text(l.controlAudit),
        trailing: Icon(Icons.chevron_right, color: t.ink3),
        onTap: () => context.router.push(AuditRoute(entityType: 'user', entityId: u.id)),
      ),
      Gap.h32,
    ]);
  }

  Future<void> _report(BuildContext context, ApiError? err, {String? success}) async {
    if (!context.mounted) return;
    if (err == null) {
      showToast(context, success ?? context.l10n.saved, tone: Tone.positive);
    } else if (err.isApprovalRequired) {
      showToast(context, context.l10n.approvalQueued(err.approvalId ?? ''), tone: Tone.warning);
    } else {
      showErrorToast(context, err);
    }
  }

  Future<void> _changeRole(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<UserDetailCubit>();
    final current = state.role;
    final picked = await showModalBottomSheet<Role>(
      context: context,
      useSafeArea: true,
      builder: (c) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current?.id,
          onChanged: (id) => Navigator.of(c).pop(state.roles.firstWhere((r) => r.id == id)),
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: const EdgeInsets.all(Space.xl),
              child: Text(l.changeRole, style: context.type.heading),
            ),
            for (final r in state.roles)
              RadioListTile<String>(
                value: r.id,
                title: Text(RoleLabels.of(l, r)),
                subtitle: Text(RoleLabels.permissions(l, r.permissions)),
              ),
          ]),
        ),
      ),
    );
    if (picked == null || picked.id == current?.id || !context.mounted) return;
    final admin = picked.name == 'Admin' || picked.permissions.contains('*');
    final reason = await showConfirmDangerSheet(
      context,
      title: l.changeRoleTo(picked.name),
      requiresApproval: admin,
      biometric: admin,
    );
    if (reason == null || !context.mounted) return;
    final err = await cubit.changeRole(picked, reason);
    if (context.mounted) await _report(context, err);
  }

  Future<void> _status(BuildContext context, String status) async {
    final l = context.l10n;
    final cubit = context.read<UserDetailCubit>();
    final suspend = status == 'suspended';
    final reason = await showConfirmDangerSheet(
      context,
      title: suspend ? l.suspendTitle : l.statusChangeTitle(l.statusActive),
      body: suspend ? l.suspendBody : null,
      destructive: suspend,
      biometric: suspend,
    );
    if (reason == null || !context.mounted) return;
    final err = await cubit.setStatus(status, reason);
    if (context.mounted) await _report(context, err);
  }

  Future<void> _revoke(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<UserDetailCubit>();
    final reason = await showConfirmDangerSheet(context, title: l.revokeSessionsTitle);
    if (reason == null || !context.mounted) return;
    final err = await cubit.revokeSessions(reason);
    if (context.mounted) await _report(context, err, success: l.revokedCount(cubit.lastRevoked));
  }

  Future<void> _viewAs(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<UserDetailCubit>();
    final session = context.read<SessionCubit>();
    final reason = await showConfirmDangerSheet(
      context,
      title: l.viewAsStart,
      body: l.viewAsStartBody,
      destructive: false,
    );
    if (reason == null || !context.mounted) return;
    final err = await cubit.startViewAs(reason);
    if (err == null) {
      await session.refresh();
      if (context.mounted) context.router.popUntilRoot();
    } else if (context.mounted) {
      await _report(context, err);
    }
  }

  Future<void> _editOverrides(BuildContext context) async {
    final l = context.l10n;
    final cubit = context.read<UserDetailCubit>();
    final next = await showModalBottomSheet<List<PermissionOverride>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => OverridesEditor(
        initial: state.detail!.overrides,
        catalog: state.catalog,
      ),
    );
    if (next == null || !context.mounted) return;
    final touchesDanger = next.any((o) => state.catalog.any((p) => p.key == o.permission && p.dangerous));
    final reason = await showConfirmDangerSheet(
      context,
      title: l.editOverrides,
      body: l.overridesHint,
      biometric: touchesDanger,
      destructive: false,
    );
    if (reason == null || !context.mounted) return;
    final err = await cubit.setOverrides(next, reason);
    if (context.mounted) await _report(context, err);
  }
}
