import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
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
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/supplier_portal_repository.dart';

/// Explicit supplier (Ops/Admin opening a portal) or the session's own.
String? resolveSupplierId(BuildContext context, String? explicit) =>
    explicit ?? context.read<SessionCubit>().state.user?.supplierId;

/// Portal hub for Ops/Admin acting on one supplier, and the supplier's own
/// "More" list for the tabs that are not in the bottom bar.
@RoutePage()
class SupplierPortalPage extends StatelessWidget {
  const SupplierPortalPage({super.key, this.supplierId});

  final String? supplierId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final id = supplierId;
    Widget link(IconData icon, String label, PageRouteInfo route) => Column(children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
            leading: Icon(icon, color: t.ink2),
            title: Text(label),
            trailing: Icon(Icons.chevron_right, color: t.ink3),
            onTap: () => context.router.push(route),
          ),
          const Hairline(indent: Space.gutter + 40),
        ]);
    return SectionScaffold(
      title: l.supplierPortal,
      permission: 'supplier.inbox.view',
      body: ListView(children: [
        if (id != null)
          Padding(
            padding: const EdgeInsets.all(Space.gutter),
            child: MonoText(id, color: t.ink3),
          ),
        link(Icons.inbox_outlined, l.supplierInbox, SupplierInboxRoute(supplierId: id)),
        link(Icons.event_available_outlined, l.supplierInventory, SupplierInventoryRoute(supplierId: id)),
        link(Icons.bed_outlined, l.supplierStays, const SupplierStaysRoute()),
        link(Icons.directions_bike_outlined, l.supplierRentals, const SupplierRentalsRoute()),
        link(Icons.payments_outlined, l.supplierRevenue, SupplierRevenueRoute(supplierId: id)),
        link(Icons.verified_outlined, l.supplierReliability, SupplierReliabilityRoute(supplierId: id)),
        link(Icons.history, l.supplierAudit, const SupplierAuditRoute()),
      ]),
    );
  }
}

// ── Inventory / calendar ───────────────────────────────────────────────────

/// Month calendar of blocked days with "block dates".
@RoutePage()
class SupplierInventoryPage extends StatefulWidget {
  const SupplierInventoryPage({super.key, this.supplierId});

  final String? supplierId;

  @override
  State<SupplierInventoryPage> createState() => _SupplierInventoryPageState();
}

class _SupplierInventoryPageState extends State<SupplierInventoryPage> {
  final _repo = GetIt.I<SupplierPortalRepository>();
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  Future<(Map<String, Map<String, dynamic>>, List<SupplierBlock>)>? _future;
  String? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _id ??= resolveSupplierId(context, widget.supplierId);
    _future ??= _load();
  }

  String get _monthKey => '${_month.year}-${_month.month.toString().padLeft(2, '0')}';

  Future<(Map<String, Map<String, dynamic>>, List<SupplierBlock>)> _load() async {
    final id = _id;
    if (id == null) return (const <String, Map<String, dynamic>>{}, const <SupplierBlock>[]);
    final r = await Future.wait<Object>([
      _repo.availability(id, _monthKey),
      _repo.blocks(id).catchError((Object _) => <SupplierBlock>[]),
    ]);
    return (r[0] as Map<String, Map<String, dynamic>>, r[1] as List<SupplierBlock>);
  }

  void _shift(int months) => setState(() {
        _month = DateTime(_month.year, _month.month + months);
        _future = _load();
      });

  Future<void> _block() async {
    final l = context.l10n;
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (range == null || !mounted) return;
    final reason = await showConfirmDangerSheet(context,
        title: '${l.blockDates}: ${Fmt.date(context, range.start)} – ${Fmt.date(context, range.end)}',
        biometric: false,
        destructive: false);
    if (reason == null || !mounted) return;
    try {
      await _repo.addBlock(_id!, range.start, range.end, reason);
      if (!mounted) return;
      showToast(context, l.blockAdded, tone: Tone.positive);
      setState(() => _future = _load());
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final canEdit = context.select<SessionCubit, bool>((s) => s.state.can('supplier.inventory.edit'));
    return SectionScaffold(
      title: l.supplierInventory,
      permission: 'supplier.inventory.view',
      floating: canEdit && _id != null
          ? FloatingActionButton.extended(
              onPressed: _block, icon: const Icon(Icons.block), label: Text(l.blockDates))
          : null,
      body: _id == null
          ? EmptyState(icon: Icons.storefront_outlined, title: l.noSupplier)
          : FutureBuilder(
              future: _future,
              builder: (context, snap) {
                if (snap.hasError) {
                  return ErrorView(error: snap.error!, onRetry: () => setState(() => _future = _load()));
                }
                final data = snap.data;
                return ListView(padding: const EdgeInsets.only(bottom: Space.x4), children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.sm),
                    child: Row(children: [
                      IconButton(
                        icon: Icon(context.isRtl ? Icons.chevron_right : Icons.chevron_left),
                        onPressed: () => _shift(-1),
                      ),
                      Expanded(
                        child: Text(
                          MaterialLocalizations.of(context).formatMonthYear(_month),
                          textAlign: TextAlign.center,
                          style: context.type.title,
                        ),
                      ),
                      IconButton(
                        icon: Icon(context.isRtl ? Icons.chevron_left : Icons.chevron_right),
                        onPressed: () => _shift(1),
                      ),
                    ]),
                  ),
                  if (data == null)
                    const SizedBox(height: 280, child: SkeletonList(count: 4, lines: 1))
                  else
                    _MonthGrid(month: _month, availability: data.$1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
                    child: Row(children: [
                      _Legend(color: t.criticalWash, border: t.critical, label: l.blocked),
                      Gap.w16,
                      _Legend(color: t.surface, border: t.line, label: l.openDay),
                    ]),
                  ),
                  if (data != null && data.$2.isNotEmpty) ...[
                    SectionHeader(title: l.blocked, count: data.$2.length),
                    for (final b in data.$2)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                        leading: Icon(Icons.block, color: t.critical, size: 20),
                        title: Text('${Fmt.date(context, b.start)} – ${Fmt.date(context, b.end)}'),
                        subtitle: b.reason.isEmpty ? null : Text(b.reason),
                      ),
                  ],
                ]);
              },
            ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.border, required this.label});

  final Color color;
  final Color border;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, border: Border.all(color: border), borderRadius: Radii.smAll),
        ),
        Gap.w4,
        Text(label, style: context.type.caption),
      ]);
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.month, required this.availability});

  final DateTime month;
  final Map<String, Map<String, dynamic>> availability;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final loc = MaterialLocalizations.of(context);
    final first = DateTime(month.year, month.month);
    final days = DateTime(month.year, month.month + 1, 0).day;
    final offset = (first.weekday - loc.firstDayOfWeekIndex) % 7;
    final today = DateUtils.dateOnly(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      child: Column(children: [
        Row(children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: Text(loc.narrowWeekdays[(i + loc.firstDayOfWeekIndex) % 7],
                    style: context.type.caption.copyWith(color: t.ink3)),
              ),
            ),
        ]),
        Gap.h4,
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            for (var i = 0; i < offset; i++) const SizedBox.shrink(),
            for (var d = 1; d <= days; d++)
              Builder(builder: (context) {
                final date = DateTime(month.year, month.month, d);
                final key = date.toIso8601String().substring(0, 10);
                final blocked = availability[key]?['blocked'] == true;
                final reason = availability[key]?['reason'];
                return Tooltip(
                  message: reason == null ? '' : '$reason',
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: blocked ? t.criticalWash : t.surface,
                      borderRadius: Radii.smAll,
                      border: Border.all(
                        color: date == today ? t.ink : (blocked ? t.critical.withValues(alpha: 0.4) : t.line),
                        width: t.hairline,
                      ),
                    ),
                    child: MonoText('$d', color: blocked ? t.critical : t.ink),
                  ),
                );
              }),
          ],
        ),
      ]),
    );
  }
}

// ── Stays ──────────────────────────────────────────────────────────────────

@RoutePage()
class SupplierStaysPage extends StatelessWidget {
  const SupplierStaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<SupplierPortalRepository>();
    final l = context.l10n;
    final arabic = context.type.isArabic;
    return BlocProvider(
      create: (_) => ListCubit<PropertyStay>(repo.stays)..start(),
      child: SectionScaffold(
        title: l.supplierStays,
        permission: 'supplier.inbox.view',
        body: AsyncListView<PropertyStay>(
          emptyIcon: Icons.bed_outlined,
          itemBuilder: (context, s) => DataCard(
            title: s.name(arabic).isEmpty ? s.traveler : s.name(arabic),
            subtitle: s.traveler,
            id: s.ref,
            status: StatusBadge.humanize(s.status),
            statusTone: StatusBadge.toneFor(s.status),
            trailing: Fmt.money(s.amountEGP),
            fields: [
              DataField(l.fCheckIn, Fmt.date(context, s.checkIn)),
              DataField(l.fNights, '${s.nights}', mono: true),
            ],
            onTap: () => showDetailSheet<void>(
              context,
              title: s.traveler,
              id: s.ref,
              status: s.status,
              fields: [
                DataField(l.fCheckIn, Fmt.date(context, s.checkIn)),
                DataField(l.fCheckOut, Fmt.date(context, s.checkOut)),
                DataField(l.fNights, '${s.nights}', mono: true),
                DataField(l.fAmount, Fmt.money(s.amountEGP), mono: true),
              ],
              actions: (sheet) => [
                if (s.pending && sheet.read<SessionCubit>().can('supplier.stays.manage')) ...[
                  DahabButton.secondary(
                    label: l.stayDecline,
                    onPressed: () => _respond(sheet, context, s, false),
                  ),
                  DahabButton(label: l.stayApprove, onPressed: () => _respond(sheet, context, s, true)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _respond(BuildContext sheet, BuildContext page, PropertyStay s, bool approve) async {
    String? reason;
    if (!approve) {
      reason = await showConfirmDangerSheet(sheet, title: page.l10n.stayDecline, biometric: false);
      if (reason == null) return;
    }
    try {
      await GetIt.I<SupplierPortalRepository>().respondStay(s.ref, approve: approve, reason: reason);
      if (sheet.mounted) Navigator.of(sheet).pop();
      if (page.mounted) await page.read<ListCubit<PropertyStay>>().refresh();
    } catch (e) {
      if (sheet.mounted) showErrorToast(sheet, e);
    }
  }
}

// ── Rentals ────────────────────────────────────────────────────────────────

@RoutePage()
class SupplierRentalsPage extends StatelessWidget {
  const SupplierRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<SupplierPortalRepository>();
    final l = context.l10n;
    final arabic = context.type.isArabic;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ListCubit<RentalBooking>(repo.rentalBookings)..start()),
        BlocProvider(create: (_) => ListCubit<RentalListing>(repo.rentals)..start()),
      ],
      child: DefaultTabController(
        length: 2,
        child: SectionScaffold(
          title: l.supplierRentals,
          permission: 'supplier.inbox.view',
          bottom: TabBar(tabs: [Tab(text: l.tabBookings), Tab(text: l.tabListings)]),
          body: TabBarView(children: [
            AsyncListView<RentalBooking>(
              emptyIcon: Icons.event_note_outlined,
              itemBuilder: (context, b) => DataCard(
                title: b.traveler,
                id: b.ref,
                status: StatusBadge.humanize(b.status),
                statusTone: StatusBadge.toneFor(b.status),
                trailing: Fmt.money(b.totalEGP),
                fields: [
                  DataField(l.fDate, '${Fmt.date(context, b.start)} – ${Fmt.date(context, b.end)}'),
                  DataField(l.fQuantity, '${b.quantity}', mono: true),
                ],
                footer: !context.read<SessionCubit>().can('supplier.rentals.manage') || !(b.pending || b.active)
                    ? null
                    : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        if (b.pending) ...[
                          TextButton(onPressed: () => _act(context, b, 'reject'), child: Text(l.decline)),
                          Gap.w8,
                          DahabButton(label: l.accept, compact: true, onPressed: () => _act(context, b, 'accept')),
                        ],
                        if (b.active)
                          DahabButton.secondary(
                              label: l.markReturned, compact: true, onPressed: () => _act(context, b, 'mark-returned')),
                      ]),
              ),
            ),
            AsyncListView<RentalListing>(
              emptyIcon: Icons.directions_bike_outlined,
              itemBuilder: (context, r) => DataCard(
                title: r.name(arabic),
                subtitle: r.category,
                trailing: Fmt.money(r.dailyRateEGP),
                fields: [
                  DataField(l.fQuantity, '${r.quantity}', mono: true),
                  DataField(l.fDeposit, Fmt.money(r.depositEGP), mono: true),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _act(BuildContext context, RentalBooking b, String action) async {
    String? reason;
    if (action == 'reject') {
      reason = await showConfirmDangerSheet(context, title: context.l10n.decline, biometric: false);
      if (reason == null) return;
    }
    try {
      await GetIt.I<SupplierPortalRepository>().rentalAction(b.id, action, reason: reason);
      if (context.mounted) await context.read<ListCubit<RentalBooking>>().refresh();
    } catch (e) {
      if (context.mounted) showErrorToast(context, e);
    }
  }
}

// ── Revenue ────────────────────────────────────────────────────────────────

@RoutePage()
class SupplierRevenuePage extends StatefulWidget {
  const SupplierRevenuePage({super.key, this.supplierId});

  final String? supplierId;

  @override
  State<SupplierRevenuePage> createState() => _SupplierRevenuePageState();
}

class _SupplierRevenuePageState extends State<SupplierRevenuePage> {
  int _days = 30;
  Future<RevenueReport>? _future;
  String? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _id ??= resolveSupplierId(context, widget.supplierId);
    if (_id != null) _future ??= GetIt.I<SupplierPortalRepository>().revenue(_id!, days: _days);
  }

  void _window(int days) => setState(() {
        _days = days;
        _future = GetIt.I<SupplierPortalRepository>().revenue(_id!, days: days);
      });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SectionScaffold(
      title: l.supplierRevenue,
      permission: 'supplier.revenue.view',
      body: _id == null
          ? EmptyState(icon: Icons.storefront_outlined, title: l.noSupplier)
          : FutureBuilder<RevenueReport>(
              future: _future,
              builder: (context, snap) {
                if (snap.hasError) return ErrorView(error: snap.error!, onRetry: () => _window(_days));
                if (!snap.hasData) return const SkeletonList(count: 5);
                final r = snap.data!;
                final completion = r.totals['completionRate'] as num?;
                return RefreshIndicator(
                  onRefresh: () async => _window(_days),
                  child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
                    SegmentedButton<int>(
                      segments: [
                        ButtonSegment(value: 7, label: Text(l.days7)),
                        ButtonSegment(value: 30, label: Text(l.days30)),
                        ButtonSegment(value: 90, label: Text(l.days90)),
                      ],
                      selected: {_days},
                      onSelectionChanged: (s) => _window(s.first),
                    ),
                    Gap.h16,
                    Row(children: [
                      Expanded(child: KpiCard(label: l.revenueGross, value: r.t('grossBookingsEGP'), caption: 'EGP')),
                      Gap.w8,
                      Expanded(child: KpiCard(label: l.revenuePayout, value: r.t('payoutEGP'), caption: 'EGP')),
                    ]),
                    Gap.h8,
                    Row(children: [
                      Expanded(child: KpiCard(label: l.revenueEscrow, value: r.t('escrowPendingEGP'), caption: 'EGP')),
                      Gap.w8,
                      Expanded(
                        child: KpiCard(
                          label: l.revenueCompletion,
                          value: completion == null ? null : (completion > 1 ? completion : completion * 100).round(),
                          caption: '%',
                        ),
                      ),
                    ]),
                    SectionHeader(title: l.revenueDaily, padding: const EdgeInsetsDirectional.only(top: Space.xl, bottom: Space.sm)),
                    if (r.daily.length >= 2)
                      SizedBox(height: 200, child: RevenueChart(days: r.daily))
                    else
                      const EmptyState(icon: Icons.show_chart),
                    SectionHeader(title: l.revenueByService, padding: const EdgeInsetsDirectional.only(top: Space.xl, bottom: Space.sm)),
                    for (final s in r.byService)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Space.xs),
                        child: Row(children: [
                          Expanded(child: Text(StatusBadge.humanize('${s['serviceType']}'))),
                          MonoText('${s['bookingsCount'] ?? 0}×', color: context.dg.ink3),
                          Gap.w12,
                          MonoText(Fmt.money((s['payoutEGP'] as num?) ?? 0), color: context.dg.ink),
                        ]),
                      ),
                  ]),
                );
              },
            ),
    );
  }
}

/// Gross vs payout per day. Payout is ink, gross the faint reference line.
class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key, required this.days});

  final List<RevenueDay> days;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    LineChartBarData line(List<double> v, Color c, {bool area = false}) => LineChartBarData(
          spots: [for (var i = 0; i < v.length; i++) FlSpot(i.toDouble(), v[i])],
          isCurved: true,
          preventCurveOverShooting: true,
          color: c,
          barWidth: 1.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: area, color: c.withValues(alpha: 0.08)),
        );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LineChart(LineChartData(
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: t.line, strokeWidth: t.hairline),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => t.raised,
            getTooltipItems: (spots) => [
              for (final s in spots)
                LineTooltipItem(Fmt.money(s.y), context.type.monoSm.copyWith(color: t.ink)),
            ],
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (v, _) => Text(Fmt.compact(v), style: context.type.monoSm.copyWith(color: t.ink3)),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (days.length / 4).ceilToDouble().clamp(1, 1000),
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox.shrink();
                final d = days[i].date;
                return Text('${d.day}/${d.month}', style: context.type.monoSm.copyWith(color: t.ink3));
              },
            ),
          ),
        ),
        lineBarsData: [
          line([for (final d in days) d.gross], t.ink3),
          line([for (final d in days) d.payout], t.ink, area: true),
        ],
      )),
    );
  }
}

// ── Reliability ────────────────────────────────────────────────────────────

@RoutePage()
class SupplierReliabilityPage extends StatelessWidget {
  const SupplierReliabilityPage({super.key, this.supplierId});

  final String? supplierId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final id = resolveSupplierId(context, supplierId);
    String pct(num? v) => v == null ? '—' : Fmt.percent(v > 1 ? v / 100 : v);
    return SectionScaffold(
      title: l.supplierReliability,
      permission: 'supplier.reliability.view',
      body: id == null
          ? EmptyState(icon: Icons.storefront_outlined, title: l.noSupplier)
          : FutureBuilder<ReliabilityScore>(
              future: GetIt.I<SupplierPortalRepository>().reliability(id),
              builder: (context, snap) {
                if (snap.hasError) return ErrorView(error: snap.error!);
                if (!snap.hasData) return const SkeletonList(count: 4);
                final s = snap.data!;
                final overall = s.v('overall');
                return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
                  Panel(
                    child: Column(children: [
                      Text(l.reliabilityOverall, style: context.type.caption.copyWith(color: t.ink2)),
                      Gap.h8,
                      Text(
                        overall == null ? '—' : (overall > 1 ? overall.round() : (overall * 100).round()).toString(),
                        textDirection: TextDirection.ltr,
                        style: context.type.numberLg,
                      ),
                      Text(l.sampleSize(s.sampleSize), style: context.type.caption.copyWith(color: t.ink3)),
                    ]),
                  ),
                  Gap.h16,
                  FieldList(fields: [
                    DataField(l.reliabilityAcceptance, pct(s.v('acceptanceRate')), mono: true),
                    DataField(l.reliabilitySpeed, pct(s.v('responseSpeed')), mono: true),
                    DataField(l.reliabilityCancellation, pct(s.v('cancellationRate')), mono: true),
                  ]),
                ]);
              },
            ),
    );
  }
}

// ── Audit (placeholder) ────────────────────────────────────────────────────

/// No supplier-scoped audit endpoint exists yet (contract has none; the
/// web tab renders static catalogue fields).
@RoutePage()
class SupplierAuditPage extends StatelessWidget {
  const SupplierAuditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SectionScaffold(
      title: l.supplierAudit,
      permission: 'supplier.audit.view',
      body: ComingNextView(body: l.auditTabPlaceholder),
    );
  }
}
