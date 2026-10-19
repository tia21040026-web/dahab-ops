import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/kpi_card.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/api/models/paged.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import 'insight_repository.dart';

/// Knowledge base health: gaps, conflicts, review queue, stale facts (read).
@RoutePage()
class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<InsightRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) =>
          ListCubit<KnowledgeItem>(repo.knowledge, initial: const ListQuery(filters: {'kind': 'gaps'}))..start(),
      child: Builder(builder: (context) {
        final cubit = context.watch<ListCubit<KnowledgeItem>>();
        return SectionScaffold(
          title: l.sectionKnowledge,
          permission: 'ops.knowledge.view',
          body: AsyncListView<KnowledgeItem>(
            header: FilterBar<String>(
              options: [
                FilterOption('gaps', l.knowledgeGaps),
                FilterOption('conflicts', l.knowledgeConflicts),
                FilterOption('review', l.knowledgeReview),
                FilterOption('stale', l.knowledgeStale),
              ],
              selected: (cubit.state.filter('kind') as String?) ?? 'gaps',
              onSelected: (v) => cubit.setFilter('kind', v ?? 'gaps'),
            ),
            emptyIcon: Icons.menu_book_outlined,
            itemBuilder: (context, k) => DataCard(
              title: k.title,
              subtitle: k.body,
              status: k.severity.isNotEmpty ? StatusBadge.humanize(k.severity) : StatusBadge.humanize(k.status),
              statusTone: StatusBadge.toneFor(k.severity.isNotEmpty ? k.severity : k.status),
              fields: [if (k.at != null) DataField(l.fDate, Fmt.ago(context, k.at))],
              onTap: () => showDetailSheet<void>(
                context,
                title: k.title,
                id: k.id,
                status: k.status.isEmpty ? k.severity : k.status,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Space.gutter),
                    child: SelectableText(k.body, style: context.type.body),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Opportunities found by the intelligence layer, with evidence (read).
@RoutePage()
class OpportunitiesPage extends StatelessWidget {
  const OpportunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<InsightRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<Opportunity>(repo.opportunities)..start(),
      child: SectionScaffold(
        title: l.sectionOpportunities,
        permission: 'ops.opportunities.view',
        body: AsyncListView<Opportunity>(
          emptyIcon: Icons.lightbulb_outline,
          itemBuilder: (context, o) => DataCard(
            title: o.title,
            subtitle: o.description,
            status: StatusBadge.humanize(o.status),
            trailing: o.confidence == null ? null : Fmt.percent(o.confidence! > 1 ? o.confidence! / 100 : o.confidence!),
            fields: [if (o.category.isNotEmpty) DataField(l.fCategory, o.category)],
            onTap: () => showDetailSheet<void>(
              context,
              title: o.title,
              subtitle: o.category,
              id: o.id,
              status: o.status,
              fields: [
                if (o.confidence != null)
                  DataField(l.fConfidence, Fmt.percent(o.confidence! > 1 ? o.confidence! / 100 : o.confidence!), mono: true),
              ],
              children: [
                Padding(
                  padding: const EdgeInsets.all(Space.gutter),
                  child: Text(o.description, style: context.type.body),
                ),
                if (o.evidence.isNotEmpty) ...[
                  SectionHeader(title: l.evidence),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                    child: SelectableText(o.evidence, style: context.type.bodySm),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Market intelligence overview: readings, the price-observation series and
/// source health. Refresh triggers a manual ingestion (`market.manage`).
@RoutePage()
class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final _repo = GetIt.I<InsightRepository>();
  late Future<(MarketOverview, List<PriceObservation>, List<SourceHealth>)> _future = _load();

  Future<(MarketOverview, List<PriceObservation>, List<SourceHealth>)> _load() async {
    final r = await Future.wait<Object>([
      _repo.marketOverview(),
      _repo.priceHistory().catchError((Object _) => <PriceObservation>[]),
      _repo.sourcesHealth().catchError((Object _) => <SourceHealth>[]),
    ]);
    return (r[0] as MarketOverview, r[1] as List<PriceObservation>, r[2] as List<SourceHealth>);
  }

  Future<void> _reload() async {
    final f = _load();
    setState(() => _future = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final canManage = context.select<SessionCubit, bool>((s) => s.state.can('market.manage'));
    return SectionScaffold(
      title: l.sectionMarket,
      permission: 'market.view',
      actions: [
        if (canManage)
          IconButton(
            tooltip: l.refreshMarket,
            icon: const Icon(Icons.sync),
            onPressed: () async {
              try {
                await _repo.refreshMarket();
                if (context.mounted) showToast(context, l.jobQueued, tone: Tone.positive);
                await _reload();
              } catch (e) {
                if (context.mounted) showErrorToast(context, e);
              }
            },
          ),
      ],
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return ErrorView(error: snap.error!, onRetry: _reload);
          if (!snap.hasData) return const SkeletonList(count: 6);
          final (o, prices, sources) = snap.data!;
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(padding: const EdgeInsets.only(bottom: Space.x3), children: [
              Padding(
                padding: const EdgeInsets.all(Space.gutter),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: Space.sm,
                  crossAxisSpacing: Space.sm,
                  childAspectRatio: 1.7,
                  children: [
                    KpiCard(label: l.marketSuppliers, value: o.suppliers),
                    KpiCard(label: l.marketOffers, value: o.offers),
                    KpiCard(label: l.marketObservations, value: o.observations),
                    KpiCard(
                      label: l.marketChanges,
                      value: o.changes,
                      tone: o.pendingReviews > 0 ? Tone.warning : Tone.neutral,
                      caption: o.pendingReviews > 0 ? '${o.pendingReviews} ${l.pending}' : null,
                    ),
                  ],
                ),
              ),
              if (o.freshness != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                  child: Row(children: [
                    Text(l.marketFreshness, style: context.type.caption.copyWith(color: context.dg.ink2)),
                    Gap.w8,
                    Expanded(
                      child: ClipRRect(
                        borderRadius: Radii.smAll,
                        child: LinearProgressIndicator(
                          value: (o.freshness! > 1 ? o.freshness! / 100 : o.freshness!).toDouble(),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    Gap.w8,
                    MonoText(Fmt.percent(o.freshness! > 1 ? o.freshness! / 100 : o.freshness!)),
                  ]),
                ),
              SectionHeader(title: l.priceIndex, count: prices.length),
              if (prices.length >= 2)
                Padding(
                  padding: const EdgeInsets.fromLTRB(Space.sm, 0, Space.gutter, 0),
                  child: SizedBox(height: 200, child: PriceChart(observations: prices)),
                ),
              SectionHeader(title: l.marketSources, count: sources.length),
              for (final s in sources)
                DataCard(
                  title: s.source,
                  status: StatusBadge.humanize(s.status),
                  statusTone: StatusBadge.toneFor(s.status),
                  fields: [
                    if (s.latencyMs != null) DataField(l.latency, l.latencyMs(s.latencyMs!), mono: true),
                    DataField(l.fLastRun, Fmt.ago(context, s.lastSuccess)),
                    if (s.failures > 0) DataField(l.fFailures, '${s.failures}', mono: true),
                  ],
                ),
            ]),
          );
        },
      ),
    );
  }
}

/// Price observations over time. Time runs left to right in both languages.
class PriceChart extends StatelessWidget {
  const PriceChart({super.key, required this.observations});

  final List<PriceObservation> observations;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final pts = observations.where((o) => o.at != null && o.price > 0).toList()
      ..sort((a, b) => a.at!.compareTo(b.at!));
    if (pts.length < 2) return const SizedBox.shrink();
    final t0 = pts.first.at!.millisecondsSinceEpoch.toDouble();
    final spots = [
      for (final p in pts) FlSpot((p.at!.millisecondsSinceEpoch - t0) / 3.6e6, p.price.toDouble()),
    ];
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: t.line, strokeWidth: t.hairline),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, meta) =>
                    Text(Fmt.compact(v), style: context.type.monoSm.copyWith(color: t.ink3)),
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: t.ink2,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: t.ink.withValues(alpha: 0.04)),
            ),
          ],
        ),
      ),
    );
  }
}
