import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/offline_banner.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../domain/permissions.dart';
import 'role_labels.dart';
import 'users_cubit.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/instrument.dart';

/// Access control (prototype § Access control): the user directory and the
/// role list. A user opens [UserDetailPage]; a role opens the matrix editor.
@RoutePage()
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<UsersCubit>()..start(),
      child: const _UsersView(),
    );
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: DgTopBar(
          title: l.accessTitle,
          large: true,
          subtitle: context.select<UsersCubit, String?>((c) => c.state.status == UsersStatus.ready
              ? l.accessSubtitle(c.state.total, c.state.roles.length)
              : null),
          actions: [
            PermissionGate(
              permission: P.usersManage,
              child: DgIconButton(
                icon: DgIcons.plus,
                tooltip: l.inviteStaff,
                onPressed: () async {
                  await context.router.push(const InviteStaffRoute());
                  if (context.mounted) await context.read<UsersCubit>().refresh();
                },
              ),
            ),
          ],
          bottom: DgUnderlineTabs(tabs: [l.controlUsers, l.controlRoles]),
        ),
        body: const PermissionGate(
          permission: P.usersView,
          explain: true,
          child: Column(children: [
            OfflineBanner(),
            Expanded(child: TabBarView(children: [_Directory(), _Roles()])),
          ]),
        ),
      ),
    );
  }
}

class _Directory extends StatelessWidget {
  const _Directory();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<UsersCubit>();
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, s) {
        final header = Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
            child: DahabTextField(
              hint: l.usersSearch,
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              onChanged: cubit.setQuery,
              onSubmitted: (_) => cubit.refresh(),
            ),
          ),
          FilterBar<String>(
            options: [
              FilterOption(null, l.all),
              FilterOption('active', l.statusActive),
              FilterOption('suspended', l.statusSuspended),
              for (final r in s.roles) FilterOption('role:${r.id}', RoleLabels.of(l, r)),
            ],
            selected: s.role.isNotEmpty
                ? 'role:${s.role}'
                : (s.statusFilter.isEmpty ? null : s.statusFilter),
            onSelected: (v) {
              if (v == null) {
                cubit
                  ..setRole('')
                  ..setStatusFilter('');
              } else if (v.startsWith('role:')) {
                cubit.setRole(v.substring(5));
              } else {
                cubit.setStatusFilter(v);
              }
            },
          ),
        ]);
        Widget body;
        if (s.status == UsersStatus.initial || (s.status == UsersStatus.loading && s.rows.isEmpty)) {
          body = const SkeletonList(leading: true);
        } else if (s.status == UsersStatus.failure && s.rows.isEmpty) {
          body = ListView(children: [ErrorView(error: s.error!, onRetry: cubit.refresh, compact: true)]);
        } else if (s.rows.isEmpty) {
          body = ListView(children: const [EmptyState(icon: Icons.people_outline)]);
        } else {
          body = ListView.builder(
            itemCount: s.rows.length + 1,
            itemBuilder: (context, i) {
              if (i == s.rows.length) {
                return Padding(
                  padding: const EdgeInsets.all(Space.lg),
                  child: Center(
                    child: s.hasMore
                        ? TextButton(onPressed: cubit.loadMore, child: Text(l.loadMore))
                        : Text(l.usersCount(s.total),
                            style: context.type.caption.copyWith(color: context.dg.ink3)),
                  ),
                );
              }
              return _UserRow(row: s.rows[i]);
            },
          );
        }
        return Column(children: [
          header,
          Expanded(child: RefreshIndicator(onRefresh: cubit.refresh, child: body)),
        ]);
      },
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.row});

  final AdminUserRow row;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final suspended = row.status == 'suspended';
    final invited = row.status == 'invited' || row.status == 'pending';
    final role = row.role.toLowerCase();
    final roleColor = role.contains('admin') ? t.highlight : (role.contains('supplier') ? t.data : t.ink2);
    final sub = suspended
        ? l.statusSuspended
        : (row.lastSeenAt != null ? l.lastSeen(Fmt.ago(context, row.lastSeenAt)) : row.email);
    return InkWell(
      onTap: () async {
        await context.router.push(UserDetailRoute(userId: row.id));
        if (context.mounted) await context.read<UsersCubit>().refresh();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
        child: Row(children: [
          DgAvatar(initials: row.asUser.initials),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(row.name?.isNotEmpty == true ? row.name! : row.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: t.ink)),
              Text(sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: sub == row.email ? TextDirection.ltr : null,
                  style: (sub == row.email ? type.mono : type.ui)
                      .copyWith(fontSize: 13, color: suspended ? t.critical : t.ink3)),
            ]),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: Radii.smAll,
              border: Border.all(
                  color: roleColor == t.ink2 ? t.lineStrong : roleColor.withValues(alpha: 0.5), width: t.hairline),
            ),
            child: Text(RoleLabels.name(l, row.role),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: roleColor)),
          ),
          const SizedBox(width: 12),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: suspended ? t.critical : (invited ? Colors.transparent : t.positive),
              border: invited ? Border.all(color: t.warning, width: 1.5) : null,
            ),
          ),
        ]),
      ),
    );
  }
}

class _Roles extends StatelessWidget {
  const _Roles();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, s) {
        if (s.roles.isEmpty) {
          return s.status == UsersStatus.ready
              ? const EmptyState(icon: Icons.badge_outlined)
              : const SkeletonList(lines: 1);
        }
        final dangerous = {for (final p in s.catalog) if (p.dangerous) p.key};
        return ListView(children: [
          for (final r in s.roles) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
              title: Row(children: [
                Flexible(child: Text(RoleLabels.of(l, r))),
                if (r.isSystem) ...[Gap.w8, StatusBadge(label: l.systemRole, dot: false, outlined: true)],
              ]),
              subtitle: Text(
                [
                  RoleLabels.permissions(l, r.permissions),
                  l.usersCount(r.userCount),
                  if (r.permissions.any(dangerous.contains) || r.permissions.contains('*'))
                    l.dangerous,
                ].join(' · '),
                style: context.type.caption.copyWith(color: t.ink3),
              ),
              trailing: Icon(Icons.chevron_right, color: t.ink3),
              onTap: () async {
                await context.router.push(RoleEditorRoute(roleId: r.id));
                if (context.mounted) await context.read<UsersCubit>().start();
              },
            ),
            const Hairline(indent: Space.gutter),
          ],
          PermissionGate(
            permission: P.rolesManage,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
              leading: Icon(Icons.add, color: t.action),
              title: Text(l.newRole, style: TextStyle(color: t.action)),
              onTap: () async {
                await context.router.push(RoleEditorRoute());
                if (context.mounted) await context.read<UsersCubit>().start();
              },
            ),
          ),
        ]);
      },
    );
  }
}
