import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/components/status_strip.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import 'system_repository.dart';

/// Ingestion jobs with "run now" (`ops.jobs.run`).
@RoutePage()
class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<SystemRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<JobPolicy>(repo.jobs)..start(),
      child: Builder(builder: (context) {
        final canRun = context.select<SessionCubit, bool>((s) => s.state.can('ops.jobs.run'));
        return SectionScaffold(
          title: l.sectionJobs,
          permission: 'ops.jobs.view',
          body: AsyncListView<JobPolicy>(
            header: FutureBuilder<int>(
              future: repo.activeJobs(),
              builder: (context, snap) => snap.hasData
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
                      child: Row(children: [
                        StatusDot(color: context.dg.positive, pulse: snap.data! > 0),
                        Text(l.activeJobs(snap.data!), style: context.type.bodySm),
                      ]),
                    )
                  : const SizedBox.shrink(),
            ),
            emptyIcon: Icons.schedule_outlined,
            itemBuilder: (context, j) => DataCard(
              title: j.source,
              subtitle: [j.type, j.interval, j.mode].where((x) => x.isNotEmpty).join(' · '),
              status: j.failures > 0 ? '${l.fFailures} ${j.failures}' : (j.enabled ? l.enabled : l.disabled),
              statusTone: j.failures > 2 ? Tone.critical : (j.failures > 0 ? Tone.warning : (j.enabled ? Tone.positive : Tone.neutral)),
              fields: [
                DataField(l.fLastRun, Fmt.ago(context, j.lastRun)),
                if (j.nextRun != null) DataField(l.fNextRun, Fmt.dateTime(context, j.nextRun)),
              ],
              footer: !canRun
                  ? null
                  : Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(l.runNow),
                        onPressed: () async {
                          final reason = await showConfirmDangerSheet(context,
                              title: '${l.runNow} · ${j.source}', biometric: false, destructive: false);
                          if (reason == null || !context.mounted) return;
                          try {
                            await repo.runJob(j.sourceId);
                            if (context.mounted) showToast(context, l.jobQueued, tone: Tone.positive);
                          } catch (e) {
                            if (context.mounted) showErrorToast(context, e);
                          }
                        },
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

/// System health: overall reading, the subsystems behind it and data
/// freshness per integration.
@RoutePage()
class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final _repo = GetIt.I<SystemRepository>();
  late Future<(HealthReading, List<IntegrationFreshness>)> _future = _load();
  DateTime _at = DateTime.now();

  Future<(HealthReading, List<IntegrationFreshness>)> _load() async {
    final r = await Future.wait([
      _repo.health(),
      _repo.integrations().catchError((Object _) => <IntegrationFreshness>[]),
    ]);
    _at = DateTime.now();
    return (r[0] as HealthReading, r[1] as List<IntegrationFreshness>);
  }

  Future<void> _refresh() async {
    final f = _load();
    setState(() => _future = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SectionScaffold(
      title: l.sectionHealth,
      permission: 'ops.health.view',
      body: FutureBuilder<(HealthReading, List<IntegrationFreshness>)>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return ErrorView(error: snap.error!, onRetry: _refresh);
          if (!snap.hasData) return const SkeletonList(count: 6);
          final (h, integrations) = snap.data!;
          return RefreshIndicator(onRefresh: _refresh, child: _HealthBody(health: h, integrations: integrations, at: _at));
        },
      ),
    );
  }
}

class _HealthBody extends StatelessWidget {
  const _HealthBody({required this.health, required this.integrations, required this.at});

  final HealthReading health;
  final List<IntegrationFreshness> integrations;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final h = health;
    final ledgerValid = h.ledger['valid'];
    final degraded = h.status != 'ok' && h.status != 'healthy';
    final down = integrations.where((i) => StatusBadge.toneFor(i.status) == Tone.critical).length;
    Widget row(String label, String value, Tone tone) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          title: Text(label),
          trailing: StatusBadge(label: value, tone: tone),
        );
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(Space.gutter),
        child: StatusStrip(
          health: down > 0
              ? SystemHealth.actionRequired
              : (degraded ? SystemHealth.degraded : SystemHealth.healthy),
          feed: FeedState.polling,
          updatedAt: at,
          detail: h.readiness.isEmpty ? null : '${l.healthReadiness}: ${StatusBadge.humanize(h.readiness)}',
        ),
      ),
      row(l.healthDatabase, '${h.database['adapter'] ?? '—'} · ${h.database['persistenceMode'] ?? ''}', Tone.neutral),
      row(l.healthLedger, ledgerValid == true ? l.ledgerIntact : l.ledgerBroken,
          ledgerValid == true ? Tone.positive : Tone.critical),
      row(l.healthPayments, h.paymentsSimulated ? l.simulated : l.liveMode,
          h.paymentsSimulated ? Tone.warning : Tone.positive),
      row(l.healthAi, h.aiConfigured ? (h.aiQuotaExhausted ? l.statusDegraded : h.aiModel) : l.notConfigured,
          h.aiConfigured ? (h.aiQuotaExhausted ? Tone.warning : Tone.positive) : Tone.warning),
      row(l.healthPush, h.pushConfigured ? l.configured : l.notConfigured,
          h.pushConfigured ? Tone.positive : Tone.warning),
      SectionHeader(title: l.controlIntegrations, count: integrations.length),
      for (final i in integrations)
        DataCard(
          title: i.name,
          subtitle: i.purpose,
          status: StatusBadge.humanize(i.status),
          statusTone: StatusBadge.toneFor(i.status),
          fields: [
            if (i.freshness.isNotEmpty) DataField(l.marketFreshness, i.freshness),
            DataField(l.fLastRun, Fmt.ago(context, i.lastSuccess)),
          ],
        ),
      Gap.h32,
    ]);
  }
}
