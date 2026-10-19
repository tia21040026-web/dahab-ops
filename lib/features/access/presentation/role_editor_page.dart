import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_error.dart';
import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../data/access_repository.dart';
import '../domain/permissions.dart';
import 'role_labels.dart';
import 'session_cubit.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/instrument.dart';

/// Permission matrix for one role (prototype `.grp` / `.perm`): grouped by
/// area with a granted meter, dangerous keys marked, save with a reason.
/// [roleId] null creates a role.
@RoutePage()
class RoleEditorPage extends StatefulWidget {
  const RoleEditorPage({super.key, this.roleId});

  final String? roleId;

  @override
  State<RoleEditorPage> createState() => _RoleEditorPageState();
}

class _RoleEditorPageState extends State<RoleEditorPage> {
  final _repo = GetIt.I<AccessRepository>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  Role? _role;
  List<PermissionDef> _catalog = const [];
  Set<String> _granted = {};
  Set<String> _original = {};
  final Set<String> _collapsed = {};

  /// Owned so toggles (which rebuild the matrix) never move the list: the
  /// next tap must land on the row the user is looking at.
  final _scroll = ScrollController();
  bool _loading = true;
  bool _saving = false;
  ApiError? _error;

  bool get _isNew => widget.roleId == null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([_repo.roles(), _repo.permissions()]);
      final roles = results[0] as List<Role>;
      final role = roles.firstWhereOrNull((r) => r.id == widget.roleId);
      if (!mounted) return;
      setState(() {
        _catalog = results[1] as List<PermissionDef>;
        _role = role;
        _original = {...?role?.permissions};
        _granted = {..._original};
        _name.text = role?.name ?? '';
        _description.text = role?.description ?? '';
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = ApiError.from(e);
        });
      }
    }
  }

  int get _changes =>
      _granted.difference(_original).length + _original.difference(_granted).length;

  bool _isGranted(String key) => _granted.contains(key) || Permissions.can(_granted.where((g) => g.contains('*')), key);

  Future<void> _save() async {
    final l = context.l10n;
    final addsDanger = _catalog.any((p) => p.dangerous && _granted.contains(p.key) && !_original.contains(p.key));
    if (_isNew) {
      if (_name.text.trim().isEmpty) {
        showToast(context, l.nameRequired, tone: Tone.warning);
        return;
      }
    }
    final reason = await showConfirmDangerSheet(
      context,
      title: _isNew ? l.createRole : '${l.saveRole} · ${_role == null ? '' : RoleLabels.of(l, _role!)}',
      body: l.changesCount(_changes),
      biometric: addsDanger,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !mounted) return;
    setState(() => _saving = true);
    try {
      if (_isNew) {
        await _repo.createRole(
          name: _name.text.trim(),
          description: _description.text.trim(),
          permissions: _granted.toList()..sort(),
        );
      } else {
        await _repo.updateRole(_role!.id, permissions: _granted.toList()..sort(), reason: reason);
      }
      if (!mounted) return;
      showToast(context, l.saved, tone: Tone.positive);
      // Our own role may have changed.
      await context.read<SessionCubit>().refresh();
      if (mounted) await context.router.maybePop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        final err = ApiError.from(e);
        err.isApprovalRequired
            ? showToast(context, l.approvalQueued(err.approvalId ?? ''), tone: Tone.warning)
            : showErrorToast(context, err);
      }
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(context, title: l.deleteRoleTitle, body: _role == null ? null : RoleLabels.of(l, _role!));
    if (reason == null || !mounted) return;
    try {
      await _repo.deleteRole(_role!.id, reason);
      if (mounted) await context.router.maybePop();
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final canManage = context.select<SessionCubit, bool>((s) => s.state.can(P.rolesManage));
    final role = _role;
    return Scaffold(
      appBar: DgTopBar(
        title: _isNew ? l.newRole : (role == null ? l.rolesTitle : RoleLabels.of(l, role)),
        subtitle: role == null ? null : l.usersCount(role.userCount),
        actions: [
          if (canManage && role != null && !role.isSystem && role.userCount == 0)
            DgIconButton(icon: DgIcons.trash, tooltip: l.deleteRole, onPressed: _delete),
        ],
      ),
      // Kept mounted (button disabled at 0 changes) rather than toggled in and
      // out: adding/removing it resizes the list viewport, which shifted rows
      // under the user's finger between taps.
      bottomNavigationBar: !canManage || _loading || _error != null
          ? null
          : DgBottomBar(
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(l.unsavedChanges(_changes),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: t.ink)),
                    Text(l.reasonAskedOnSave,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.type.ui.copyWith(fontSize: 13, color: t.ink2)),
                  ]),
                ),
                Gap.w12,
                DahabButton(
                    label: _isNew ? l.createRole : l.saveRole, compact: true,
                    loading: _saving,
                    onPressed: !_isNew && _changes == 0 ? null : _save),
              ]),
            ),
      body: _loading
          ? const SkeletonList(count: 10, lines: 1)
          : _error != null
              ? ErrorView(error: _error!, onRetry: _load)
              : _matrix(context, canManage),
    );
  }

  Widget _matrix(BuildContext context, bool canManage) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final arabic = type.isArabic;
    final role = _role;
    final groups = groupBy(_catalog, (PermissionDef p) => p.group);
    final keys = groups.keys.toList()..sort();
    final wildcard = _granted.contains('*');
    return ListView(
        key: const PageStorageKey('role-matrix'),
        controller: _scroll,
        // Lay out every group so extents are exact, never estimated.
        scrollCacheExtent: const ScrollCacheExtent.pixels(100000),
        children: [
      if (_isNew) ...[
        Padding(
          padding: const EdgeInsets.all(Space.gutter),
          child: Column(children: [
            DahabTextField(label: l.roleName, controller: _name),
            Gap.h12,
            DahabTextField(label: l.roleDescription, controller: _description, maxLines: 2),
          ]),
        ),
      ] else if (role != null) ...[
        Padding(
          padding: const EdgeInsets.all(Space.gutter),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (role.description != null) Text(role.description!, style: type.bodySm.copyWith(color: t.ink2)),
            Gap.h8,
            Wrap(spacing: Space.sm, children: [
              StatusBadge(label: l.usersCount(role.userCount), dot: false, outlined: true),
              if (role.isSystem) StatusBadge(label: l.systemRole, dot: false, outlined: true),
            ]),
            if (role.isSystem) ...[
              Gap.h8,
              Text(l.systemRoleLocked, style: type.caption.copyWith(color: t.ink3)),
            ],
          ]),
        ),
      ],
      if (wildcard)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
          child: Panel(
            color: t.criticalWash,
            borderColor: t.critical.withValues(alpha: 0.35),
            child: Row(children: [
              Icon(Icons.all_inclusive, color: t.critical),
              Gap.w12,
              Expanded(child: MonoText('*', color: t.critical, size: 16)),
            ]),
          ),
        ),
      for (final g in keys) _group(context, g, groups[g]!, canManage && !wildcard, arabic),
      Gap.h32,
    ]);
  }

  Widget _group(BuildContext context, String group, List<PermissionDef> perms, bool editable, bool arabic) {
    final t = context.dg;
    final l = context.l10n;
    final granted = perms.where((p) => _isGranted(p.key)).length;
    final danger = perms.where((p) => p.dangerous && _isGranted(p.key)).length;
    final open = !_collapsed.contains(group);
    return Container(
      key: ValueKey('perm-group-$group'),
      decoration: BoxDecoration(border: Border(top: t.hairlineSide)),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => open ? _collapsed.add(group) : _collapsed.remove(group)),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(children: [
              Text(group,
                  textDirection: TextDirection.ltr,
                  style: context.type.mono.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.ink)),
              Gap.w12,
              Flexible(
                child: DgMeter(value: perms.isEmpty ? 0 : granted / perms.length, width: 90),
              ),
              if (danger > 0) ...[
                Gap.w8,
                DgIcon(DgIcons.alert, size: 14, color: t.critical),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(l.dangerousCount(danger),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.type.ui.copyWith(fontSize: 13, color: t.critical)),
                ),
              ],
              const Spacer(),
              Text(l.grantedOf(granted, perms.length),
                  textDirection: TextDirection.ltr,
                  style: context.type.mono.copyWith(fontSize: 13, color: t.ink3)),
              Gap.w8,
              DgIcon(open ? DgIcons.down : DgIcons.chev, size: 16, color: t.ink3),
            ]),
          ),
        ),
        if (open)
          for (final p in perms)
            Container(
              key: ValueKey('perm-row-${p.key}'),
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsetsDirectional.fromSTEB(32, 6, 20, 6),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Text(p.label(arabic), style: context.type.ui.copyWith(fontSize: 14, color: t.ink)),
                      if (p.dangerous)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            DgIcon(DgIcons.alert, size: 14, color: t.critical),
                            const SizedBox(width: 4),
                            Text(l.dangerous,
                                style: context.type.ui
                                    .copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.critical)),
                          ]),
                        ),
                    ]),
                    Text(p.key,
                        textDirection: TextDirection.ltr,
                        style: context.type.mono.copyWith(fontSize: 13, color: t.ink3)),
                  ]),
                ),
                Gap.w12,
                DgSwitch(
                  key: ValueKey('perm-switch-${p.key}'),
                  value: _isGranted(p.key),
                  semanticLabel: p.key,
                  onChanged: !editable || (!_granted.contains(p.key) && _isGranted(p.key))
                      ? null
                      : (v) => setState(() => v ? _granted.add(p.key) : _granted.remove(p.key)),
                ),
              ]),
            ),
      ]),
    );
  }
}
