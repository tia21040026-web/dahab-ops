import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/kpi_card.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_strip.dart';
import '../../../core/realtime/realtime_service.dart';
import '../../../core/realtime/sse_client.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../queue/data/queue_repository.dart';
import '../../queue/presentation/queue_item_tile.dart';
import '../data/overview_repository.dart';
import 'pulse_cubit.dart';

/// Pulse (home): system state, eight KPIs, then the action queue preview.
/// All numbers come from `/api/operations/*`; deltas appear once the device
/// holds two snapshots — never invented.
@RoutePage()
class PulsePage extends StatelessWidget {
  const PulsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PulseCubit>()..start(),
      child: const _PulseView(),
    );
  }
}

class _PulseView extends StatelessWidget {
  const _PulseView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    final now = DateFormat('EEE d MMM, HH:mm', lang).format(DateTime.now());
    final unread = context.select<PulseCubit, int>((c) => c.state.data?.unreadNotifications ?? 0);
    return Scaffold(
      appBar: DgTopBar(
        title: l.pulseTitle,
        subtitle: l.pulseSubtitle(now),
        actions: [
          DgIconButton(
            icon: DgIcons.search,
            tooltip: l.search,
            onPressed: () => context.router.push(const SearchRoute()),
          ),
          DgIconButton(
            icon: DgIcons.bell,
            tooltip: l.sectionNotifications,
            dot: unread > 0,
            onPressed: () => context.router.push(const NotificationsRoute()),
          ),
        ],
      ),
      body: BlocBuilder<PulseCubit, PulseState>(
        builder: (context, s) {
          if (s.status == PulseStatus.initial || (s.status == PulseStatus.loading && s.data == null)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.status == PulseStatus.failure && s.data == null) {
            return _Error(message: l.errorGeneric, onRetry: () => context.read<PulseCubit>().refresh());
          }
          final data = s.data!;
          final t = context.dg;
          final queue = GetIt.I<QueueRepository>().openCount;
          return RefreshIndicator(
            onRefresh: () => context.read<PulseCubit>().refresh(),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 16),
                  child: ValueListenableBuilder<RealtimeStatus>(
                    valueListenable: GetIt.I<RealtimeService>().status,
                    builder: (context, feed, _) => StatusStrip(
                      health: _health(data.systemStatus),
                      feed: _feed(feed),
                      updatedAt: data.fetchedAt,
                      detail: data.systemDetail.isEmpty ? null : data.systemDetail,
                      subsystems: [
                        for (final (key, label) in [
                          ('api', l.subsystemApi),
                          ('database', l.subsystemDatabase),
                          ('payments', l.subsystemPayments),
                          ('ai', l.subsystemAi),
                        ])
                          Subsystem(label, switch (data.subsystems[key]) {
                            'ok' => Tone.positive,
                            'warn' => Tone.warning,
                            'down' => Tone.critical,
                            _ => Tone.neutral,
                          }),
                      ],
                    ),
                  ),
                ),
                _KpiGrid(data: data),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                  child: Text(l.kpiArrowsNote, style: context.type.ui.copyWith(fontSize: 13, color: t.ink3)),
                ),
                const SizedBox(height: 18),
                ValueListenableBuilder<int>(
                  valueListenable: queue,
                  builder: (context, n, _) => DgSectionHead(
                    title: l.needsAction,
                    count: n,
                    linkLabel: l.seeAll,
                    onLink: () => context.router.navigate(const QueueRoute()),
                  ),
                ),
                if (s.preview.isNotEmpty) Container(height: t.hairline, color: t.line),
                for (final item in s.preview)
                  DecoratedBox(
                    decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
                    child: QueueItemTile(item: item, showLeft: false),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  SystemHealth _health(String status) => switch (status) {
        'healthy' => SystemHealth.healthy,
        'degraded' => SystemHealth.degraded,
        _ => SystemHealth.actionRequired,
      };

  FeedState _feed(RealtimeStatus s) => switch (s) {
        RealtimeStatus.live => FeedState.live,
        RealtimeStatus.polling => FeedState.polling,
        RealtimeStatus.reconnecting => FeedState.reconnecting,
        _ => FeedState.offline,
      };
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.data});

  final PulseData data;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = {
      'activeTrips': l.kpiActiveTrips,
      'pendingBookings': l.kpiPendingBookings,
      'supplierConfirmations': l.kpiSupplierConfirmations,
      'supportQueue': l.kpiUnreadSupport,
      'exceptions': l.kpiExceptions,
      'paymentIssues': l.kpiPaymentIssues,
      'activeTransfers': l.kpiActiveTransfers,
      'unread': l.kpiUnreadNotifications,
    };
    Widget card(KpiReading k) => KpiCard(
          label: labels[k.key] ?? k.key,
          value: k.value,
          delta: k.delta,
          deltaCount: k.deltaCount,
          spark: k.spark.isEmpty ? null : k.spark,
          upIsGood: k.upIsGood,
          // Status tone only while the reading is non-zero.
          tone: k.value > 0 && k.critical
              ? Tone.critical
              : (k.value > 0 && k.warning ? Tone.warning : Tone.neutral),
          onTap: () => context.router.navigate(const QueueRoute()),
        );
    final kpis = data.kpis;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        for (var i = 0; i < kpis.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: card(kpis[i])),
              const SizedBox(width: 8),
              Expanded(child: i + 1 < kpis.length ? card(kpis[i + 1]) : const SizedBox.shrink()),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(message),
        const SizedBox(height: 12),
        DahabButton(label: l.retry, onPressed: onRetry),
      ]),
    );
  }
}
