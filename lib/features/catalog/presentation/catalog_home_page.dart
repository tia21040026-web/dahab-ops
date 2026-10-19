import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/offline_banner.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../core/router/shell_leading.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/catalog_models.dart';
import 'catalog_common.dart';

class _TypeCounts {
  const _TypeCounts(this.total, this.drafts, this.review);

  final int? total;
  final int? drafts;
  final int? review;
}

/// Catalogue home: one card per type with its count, drafts and items in
/// review, and "+ New". Suppliers see their own listings ("My listings").
@RoutePage()
class CatalogHomePage extends StatefulWidget {
  const CatalogHomePage({super.key});

  @override
  State<CatalogHomePage> createState() => _CatalogHomePageState();
}

class _CatalogHomePageState extends State<CatalogHomePage> {
  Future<List<CatalogTypeSchema>>? _schema;
  final Map<String, _TypeCounts> _counts = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _schema ??= _load();
  }

  Future<List<CatalogTypeSchema>> _load({bool refresh = false}) async {
    final repo = CatalogScope.of(context);
    final session = context.read<SessionCubit>().state;
    final types = (await repo.schema(refresh: refresh)).where((t) => CatalogAccess(session, t.type).canView).toList();
    unawaited(_loadCounts());
    return types;
  }

  /// One `GET {base}/summary` for every card (not three counts per type).
  /// A failure leaves the counts as dashes.
  Future<void> _loadCounts() async {
    final repo = CatalogScope.of(context);
    try {
      final summary = await repo.summary();
      if (!mounted) return;
      setState(() {
        _counts
          ..clear()
          ..addAll({
            for (final e in summary.entries) e.key: _TypeCounts(e.value.total, e.value.draft, e.value.review),
          });
      });
    } catch (_) {
      // Counts are decoration; the cards still open.
    }
  }

  Future<void> _refresh() async {
    final f = _load(refresh: true);
    setState(() => _schema = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final supplier = session.isSupplier;
    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(supplier ? l.catMyListings : l.sectionCatalog),
      ),
      body: PermissionGate(
        anyOf: supplier ? const [supplierCatalogPermission] : catalogViewPermissions,
        explain: true,
        child: Column(children: [
          const OfflineBanner(),
          if (supplier)
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
              child: Text(l.catSupplierHint, style: context.type.bodySm.copyWith(color: context.dg.ink2)),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<CatalogTypeSchema>>(
                future: _schema,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return ListView(children: [ErrorView(error: snap.error!, onRetry: _refresh, compact: true)]);
                  }
                  if (!snap.hasData) return const SkeletonList(count: 5);
                  final types = snap.data!;
                  if (types.isEmpty) return ListView(children: const [EmptyState(icon: Icons.inventory_2_outlined)]);
                  return ListView.separated(
                    padding: const EdgeInsets.all(Space.gutter),
                    itemCount: types.length,
                    separatorBuilder: (_, __) => Gap.h12,
                    itemBuilder: (context, i) => _TypeCard(
                      schema: types[i],
                      counts: _counts[types[i].type],
                      access: CatalogAccess(session, types[i].type),
                      onOpen: (status) async {
                        await context.router.push(CatalogListRoute(type: types[i].type, initialStatus: status));
                        if (mounted) unawaited(_loadCounts());
                      },
                      onNew: () async {
                        await context.router.push(CatalogCreateRoute(type: types[i].type));
                        if (mounted) unawaited(_loadCounts());
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({required this.schema, required this.counts, required this.access, required this.onOpen, required this.onNew});

  final CatalogTypeSchema schema;
  final _TypeCounts? counts;
  final CatalogAccess access;
  final ValueChanged<String?> onOpen;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    String n(int? v) => v == null ? '–' : Fmt.number(v);
    return Material(
      key: Key('cat.home.${schema.type}'),
      color: t.surface,
      shape: RoundedRectangleBorder(borderRadius: Radii.lgAll, side: BorderSide(color: t.line, width: t.hairline)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onOpen(null),
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: t.actionWash, borderRadius: Radii.mdAll),
              child: Icon(catalogTypeIcon(schema.type, schema.icon), color: t.action),
            ),
            Gap.w16,
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(schema.labelOf(type.isArabic), style: type.title),
                Gap.h4,
                Wrap(spacing: Space.md, runSpacing: Space.xs, children: [
                  _Count(label: l.catCountDrafts, value: n(counts?.drafts), onTap: () => onOpen(CatalogStatus.draft)),
                  _Count(
                    label: l.catCountReview,
                    value: n(counts?.review),
                    warn: (counts?.review ?? 0) > 0,
                    onTap: () => onOpen(CatalogStatus.review),
                  ),
                ]),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(n(counts?.total), textDirection: TextDirection.ltr, style: type.numberMd),
              if (access.canManage)
                TextButton.icon(
                  key: Key('cat.home.${schema.type}.new'),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                  onPressed: onNew,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.catNew),
                ),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value, required this.onTap, this.warn = false});

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return InkWell(
      onTap: onTap,
      borderRadius: Radii.smAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text.rich(TextSpan(children: [
          TextSpan(text: value, style: context.type.monoMd.copyWith(color: warn ? t.warning : t.ink)),
          TextSpan(text: ' $label', style: context.type.caption.copyWith(color: t.ink3)),
        ])),
      ),
    );
  }
}
