import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:async' show unawaited;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_error.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/modern.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/shell_leading.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../content_repository.dart';

/// Navigation editor (`/cms/navigation`): the CMS-managed menus the web
/// renders. CRUD per menu key with the reason-confirmed danger sheet.
@RoutePage()
class NavigationEditorPage extends StatelessWidget {
  const NavigationEditorPage({super.key});

  @override
  Widget build(BuildContext context) => const _NavigationBody();
}

class _NavigationBody extends StatefulWidget {
  const _NavigationBody();

  @override
  State<_NavigationBody> createState() => _NavigationBodyState();
}

class _NavigationBodyState extends State<_NavigationBody> {
  List<NavItem> _items = const [];
  var _status = ContentLoading.loading;
  ApiError? _error;
  var _menuKey = 'main';

  static const _menus = ['main', 'footer'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = ContentLoading.loading);
    try {
      final items = await GetIt.I<ContentRepository>().navigation(_menuKey);
      if (!mounted) return;
      setState(() {
        _items = items;
        _status = ContentLoading.ready;
      });
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _status = ContentLoading.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final canEdit = context.watch<SessionCubit>().state.can('cms.content.edit');
    switch (_status) {
      case ContentLoading.loading:
        return Scaffold(
          appBar: AppBar(leading: shellLeading(context), automaticallyImplyLeading: false),
          body: const SkeletonList(count: 5),
        );
      case ContentLoading.failure:
        return Scaffold(
          appBar: AppBar(leading: shellLeading(context), automaticallyImplyLeading: false),
          body: ErrorView(error: _error!, onRetry: _load),
        );
      case ContentLoading.ready:
        break;
    }
    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(l.ccTileNavigation),
        actions: [
          if (canEdit)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.sm),
              child: DgIconButton(
                icon: DgIcons.plus,
                tooltip: l.ccNavItemNew,
                onPressed: () => _edit(null),
              ),
            ),
        ],
      ),
      body: Column(children: [
        DgChipRow(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
          children: [
            for (final m in _menus)
              DgChip(
                label: m,
                selected: _menuKey == m,
                onTap: () {
                  setState(() => _menuKey = m);
                  unawaited(_load());
                },
              ),
          ],
        ),
        Expanded(
          child: _items.isEmpty
              ? EmptyState(title: l.ccNavEmpty, body: l.ccNavEmptyBody)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(Space.gutter, Space.xs, Space.gutter, Space.x4),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.xs),
                      child: Panel(
                        onTap: canEdit ? () => _edit(item) : null,
                        child: Row(children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item.labelEn.isNotEmpty ? item.labelEn : item.id,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.type.bodyStrong.copyWith(color: t.ink)),
                              Gap.h4,
                              MonoText(item.route.isNotEmpty ? item.route : item.externalUrl,
                                  size: 12, color: t.ink3),
                            ]),
                          ),
                          Gap.w8,
                          if (!item.visible) StatusPill(l.ccHidden, tone: Tone.warning),
                          Gap.w8,
                          DgIconButton(
                            icon: DgIcons.trash,
                            size: 36,
                            tooltip: l.deleteLabel,
                            onPressed: canEdit ? () => _remove(item) : null,
                          ),
                        ]),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }

  Future<void> _edit(NavItem? item) async {
    final saved = await showNavItemSheet(context, item == null ? null : (item, _menuKey));
    if (saved == null || !mounted) return;
    final repo = GetIt.I<ContentRepository>();
    try {
      if (item == null) {
        await repo.createNavItem(saved);
      } else {
        await repo.updateNavItem(saved);
      }
      if (!mounted) return;
      showToast(context, context.l10n.saved, tone: Tone.positive);
      unawaited(_load());
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    }
  }

  Future<void> _remove(NavItem item) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.ccNavDeleteTitle(item.labelEn),
      destructive: true,
    );
    if (reason == null || !mounted) return;
    try {
      await GetIt.I<ContentRepository>().deleteNavItem(item.id);
      if (!mounted) return;
      showToast(context, l.saved, tone: Tone.positive);
      unawaited(_load());
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    }
  }
}

/// Label (EN/AR), route or external URL, visibility and order, in one sheet.
Future<NavItem?> showNavItemSheet(BuildContext context, (NavItem, String)? existing) async {
  final l = context.l10n;
  final item = existing?.$1;
  final menuKey = existing?.$2 ?? 'main';
  final labelEn = TextEditingController(text: item?.labelEn ?? '');
  final labelAr = TextEditingController(text: item?.labelAr ?? '');
  final route = TextEditingController(text: item?.route ?? '');
  final external = TextEditingController(text: item?.externalUrl ?? '');
  final order = TextEditingController(text: '${item?.itemOrder ?? 0}');
  var visible = item?.visible ?? true;
  String? error;

  final result = await showModalBottomSheet<NavItem>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, setSheet) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheet).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item == null ? l.ccNavItemNew : l.ccNavItemEdit,
                style: sheet.type.title.copyWith(color: sheet.dg.ink)),
            Gap.h12,
            DahabTextField(label: l.ccTitleEn, controller: labelEn),
            Gap.h12,
            DahabTextField(label: l.ccTitleAr, controller: labelAr, textDirection: TextDirection.rtl),
            Gap.h12,
            DahabTextField(label: l.ccNavRoute, controller: route, mono: true, helper: l.ccNavRouteHint),
            Gap.h12,
            DahabTextField(label: l.ccNavExternal, controller: external, mono: true),
            Gap.h12,
            DahabTextField(label: l.ccNavOrder, controller: order, mono: true, keyboardType: TextInputType.number),
            Gap.h12,
            DgSetRow(
              title: l.ccVisible,
              trailing: DgSwitch(
                value: visible,
                semanticLabel: l.ccVisible,
                onChanged: (v) => setSheet(() => visible = v),
              ),
            ),
            if (error != null) ...[
              Gap.h8,
              Text(error!, style: sheet.type.caption.copyWith(color: sheet.dg.critical)),
            ],
            Gap.h16,
            DahabButton(
              label: l.save,
              expand: true,
              onPressed: () {
                if (labelEn.text.trim().isEmpty && labelAr.text.trim().isEmpty) {
                  setSheet(() => error = l.ccNavLabelRequired);
                  return;
                }
                Navigator.of(sheet).pop(NavItem({
                  if (item != null) 'id': item.id,
                  'menu_key': menuKey,
                  'item_order': int.tryParse(order.text.trim()) ?? 0,
                  'label_en': labelEn.text.trim(),
                  'label_ar': labelAr.text.trim(),
                  'route': route.text.trim(),
                  'external_url': external.text.trim(),
                  'visible': visible ? 1 : 0,
                  'icon': item?.icon ?? '',
                }));
              },
            ),
          ]),
        ),
      ),
    ),
  );
  return result;
}
