import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/models/paged.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../form/gallery_field.dart';
import '../form/supplier_picker.dart';
import 'catalog_common.dart';

/// Records of one type: search, status chips, supplier filter, a
/// completeness bar per row. Swipe right publishes / hides; swipe left (or
/// long-press) opens quick actions: duplicate, edit price, archive.
@RoutePage()
class CatalogListPage extends StatefulWidget {
  const CatalogListPage({super.key, @PathParam('type') required this.type, this.initialStatus});

  final String type;
  final String? initialStatus;

  @override
  State<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends State<CatalogListPage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  late final ListCubit<CatalogItem> _cubit = ListCubit<CatalogItem>(
    (q) => _repo.list(widget.type, q),
    initial: ListQuery(filters: {'status': widget.initialStatus}),
  )..start();
  CatalogTypeSchema? _schema;
  String? _supplierName;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _repo.schemaFor(widget.type).then((s) {
      if (mounted) setState(() => _schema = s);
    }).catchError((Object _) {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cubit.close();
    super.dispose();
  }

  CatalogActions get _actions => CatalogActions(context, _repo, widget.type, schema: _schema);

  void _replace(CatalogItem? next, CatalogItem old) {
    if (next == null) return;
    if (next.id.isEmpty || next.id == old.id) {
      _cubit.replaceWhere((i) => i.id == old.id, next.id.isEmpty ? old.merge(next.json) : next);
    } else {
      _cubit.refresh();
    }
  }

  Future<void> _togglePublish(CatalogItem item) async {
    final next = item.isPublished ? await _actions.hide(item) : await _actions.publish(item);
    _replace(next, item);
  }

  Future<void> _quickActions(CatalogItem item, CatalogAccess access) async {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final action = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (sheet) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text(item.title.of(arabic), style: context.type.title)),
          if (access.canPublish && !item.isPublished)
            ListTile(
              key: const Key('cat.act.publish'),
              leading: const Icon(Icons.publish_outlined),
              title: Text(access.supplier ? l.catSubmitReview : l.catPublish),
              onTap: () => Navigator.of(sheet).pop('publish'),
            ),
          if (access.canPublish && item.isPublished)
            ListTile(
              key: const Key('cat.act.hide'),
              leading: const Icon(Icons.visibility_off_outlined),
              title: Text(l.catHide),
              onTap: () => Navigator.of(sheet).pop('hide'),
            ),
          ListTile(
            key: const Key('cat.act.price'),
            leading: const Icon(Icons.sell_outlined),
            title: Text(l.catEditPrice),
            onTap: () => Navigator.of(sheet).pop('price'),
          ),
          ListTile(
            key: const Key('cat.act.duplicate'),
            leading: const Icon(Icons.copy_outlined),
            title: Text(l.catDuplicate),
            onTap: () => Navigator.of(sheet).pop('duplicate'),
          ),
          if (!item.isArchived)
            ListTile(
              key: const Key('cat.act.archive'),
              leading: Icon(Icons.archive_outlined, color: context.dg.critical),
              title: Text(l.catArchive, style: TextStyle(color: context.dg.critical)),
              onTap: () => Navigator.of(sheet).pop('archive'),
            ),
        ]),
      ),
    );
    if (!mounted || action == null) return;
    switch (action) {
      case 'publish':
        _replace(await _actions.publish(item), item);
      case 'hide':
        _replace(await _actions.hide(item), item);
      case 'price':
        _replace(await _actions.editPrice(item), item);
      case 'duplicate':
        final copy = await _actions.duplicate(item);
        if (copy != null && mounted) {
          await _cubit.refresh();
          if (mounted && copy.id.isNotEmpty) {
            await context.router.push(CatalogEditRoute(type: widget.type, id: copy.id));
            if (mounted) await _cubit.refresh();
          }
        }
      case 'archive':
        _replace(await _actions.archive(item), item);
    }
  }

  Future<void> _pickSupplier() async {
    final pick = await showSupplierPicker(context);
    if (pick == null) return;
    setState(() => _supplierName = pick.name);
    await _cubit.setFilter('supplierId', pick.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final access = CatalogAccess(session, widget.type);
    final arabic = context.type.isArabic;
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ListCubit<CatalogItem>, ListState<CatalogItem>>(builder: (context, s) {
        return SectionScaffold(
          title: _schema?.labelOf(arabic) ?? widget.type,
          permission: access.viewPermission,
          floating: access.canManage
              ? FloatingActionButton.extended(
                  key: const Key('cat.list.new'),
                  onPressed: () async {
                    await context.router.push(CatalogCreateRoute(type: widget.type));
                    if (mounted) await _cubit.refresh();
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l.catNew),
                )
              : null,
          body: AsyncListView<CatalogItem>(
            emptyIcon: catalogTypeIcon(widget.type, _schema?.icon),
            emptyBody: l.catEmptyBody,
            header: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, 0),
                child: TextField(
                  key: const Key('cat.list.search'),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.search, isDense: true),
                  onChanged: (v) {
                    _debounce?.cancel();
                    _debounce = Timer(const Duration(milliseconds: 350), () => _cubit.setSearch(v));
                  },
                ),
              ),
              Row(children: [
                Expanded(
                  child: FilterBar<String>(
                    options: [
                      FilterOption(null, l.all),
                      for (final st in CatalogStatus.filters) FilterOption(st, catalogStatusLabel(l, st)),
                    ],
                    selected: s.filter('status') as String?,
                    onSelected: (v) => _cubit.setFilter('status', v),
                  ),
                ),
                if (!access.supplier)
                  IconButton(
                    key: const Key('cat.list.supplier'),
                    tooltip: l.catFilterSupplier,
                    icon: const Icon(Icons.storefront_outlined),
                    onPressed: _pickSupplier,
                  ),
              ]),
              if (s.filter('supplierId') != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, 0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: InputChip(
                      key: const Key('cat.list.supplierChip'),
                      avatar: const Icon(Icons.storefront_outlined, size: 16),
                      label: Text(_supplierName ?? '${s.filter('supplierId')}'),
                      onDeleted: () => _cubit.setFilter('supplierId', null),
                    ),
                  ),
                ),
            ]),
            itemBuilder: (context, item) => CatalogRow(
              item: item,
              access: access,
              onTap: () async {
                await context.router.push(CatalogEditRoute(type: widget.type, id: item.id));
                if (mounted) await _cubit.refresh();
              },
              onSwipePublish: () => _togglePublish(item),
              onActions: () => _quickActions(item, access),
            ),
          ),
        );
      }),
    );
  }
}

/// List row: cover, title, supplier / price, status, completeness bar.
class CatalogRow extends StatelessWidget {
  const CatalogRow({
    super.key,
    required this.item,
    required this.access,
    required this.onTap,
    required this.onSwipePublish,
    required this.onActions,
  });

  final CatalogItem item;
  final CatalogAccess access;
  final VoidCallback onTap;
  final VoidCallback onSwipePublish;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final arabic = type.isArabic;
    final title = item.title.of(arabic);
    final sub = [
      if (item.supplierName != null) item.supplierName!,
      if (item.priceFromEGP != null) l.catFromPrice(Fmt.money(item.priceFromEGP!)),
    ].join(' · ');
    Widget bg(Alignment a, IconData icon, String text, Color c, Color wash) => Container(
          color: wash,
          alignment: a,
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: c),
            Gap.w8,
            Text(text, style: type.bodyStrong.copyWith(color: c)),
          ]),
        );
    final row = InkWell(
      onTap: onTap,
      onLongPress: access.canManage
          ? () {
              HapticFeedback.mediumImpact();
              onActions();
            }
          : null,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
        padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.md),
        child: Row(children: [
          CatalogThumb(item.coverImage, size: 56),
          Gap.w12,
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title.isEmpty ? l.catUntitled : title,
                  maxLines: 1, overflow: TextOverflow.ellipsis, style: type.bodyStrong),
              if (sub.isNotEmpty)
                Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: type.caption.copyWith(color: t.ink2)),
              Gap.h4,
              CompletenessBar(value: item.completeness),
            ]),
          ),
          Gap.w8,
          StatusBadge(label: catalogStatusLabel(l, item.status), tone: catalogStatusTone(item.status)),
        ]),
      ),
    );
    if (!access.canManage) return row;
    final rtl = context.isRtl;
    return Dismissible(
      key: ValueKey('cat.row.${item.id}'),
      direction: access.canPublish ? DismissDirection.horizontal : DismissDirection.endToStart,
      background: bg(rtl ? Alignment.centerRight : Alignment.centerLeft,
          item.isPublished ? Icons.visibility_off_outlined : Icons.publish_outlined,
          item.isPublished ? l.catHide : (access.supplier ? l.catSubmitReview : l.catPublish),
          item.isPublished ? t.ink2 : t.positive, item.isPublished ? t.sunken : t.positiveWash),
      secondaryBackground: bg(rtl ? Alignment.centerLeft : Alignment.centerRight, Icons.more_horiz, l.catActions, t.action, t.actionWash),
      confirmDismiss: (dir) async {
        unawaited(HapticFeedback.selectionClick());
        if (dir == DismissDirection.startToEnd) {
          onSwipePublish();
        } else {
          onActions();
        }
        return false;
      },
      child: row,
    );
  }
}
