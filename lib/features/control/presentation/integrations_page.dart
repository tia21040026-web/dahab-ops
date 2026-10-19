import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'control_cubit.dart';
import '../../../core/router/shell_leading.dart';

/// Integration health (real probes, cached 60 s): check now, enable,
/// sandbox / live mode. Going live asks for Face ID.
@RoutePage()
class IntegrationsPage extends StatelessWidget {
  const IntegrationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ControlCubit>()..start(parts: {ControlPart.integrations}),
      child: const _IntegrationsView(),
    );
  }
}

class _IntegrationsView extends StatelessWidget {
  const _IntegrationsView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.integrationsTitle)),
      body: BlocBuilder<ControlCubit, ControlState>(
        builder: (context, s) {
          if (s.status == ControlStatus.loading || s.status == ControlStatus.initial) {
            return const SkeletonList(count: 5);
          }
          if (s.status == ControlStatus.failure) {
            return ErrorView(error: s.error!, onRetry: context.read<ControlCubit>().refresh);
          }
          if (s.integrations.isEmpty) return const EmptyState(icon: Icons.hub_outlined);
          return RefreshIndicator(
            onRefresh: context.read<ControlCubit>().refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(Space.gutter),
              itemCount: s.integrations.length,
              separatorBuilder: (_, __) => Gap.h12,
              itemBuilder: (context, i) => _IntegrationCard(integration: s.integrations[i]),
            ),
          );
        },
      ),
    );
  }
}

class _IntegrationCard extends StatefulWidget {
  const _IntegrationCard({required this.integration});

  final Integration integration;

  @override
  State<_IntegrationCard> createState() => _IntegrationCardState();
}

class _IntegrationCardState extends State<_IntegrationCard> {
  bool _checking = false;

  Integration get i => widget.integration;

  String _statusLabel(BuildContext context) {
    final l = context.l10n;
    return switch (i.status) {
      'healthy' => l.statusHealthy,
      'degraded' => l.statusDegraded,
      'down' => l.statusDown,
      'disabled' => l.statusOff,
      _ => l.statusUnconfigured,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final l = context.l10n;
    final canManage = context.select<SessionCubit, bool>((s) => s.state.can(P.integrationsManage));
    final tone = StatusBadge.toneFor(i.status == 'disabled' ? 'neutral' : i.status);
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(i.name, style: type.title)),
          StatusBadge(label: _statusLabel(context), tone: tone),
        ]),
        Gap.h8,
        Wrap(spacing: Space.lg, runSpacing: Space.xs, children: [
          if (i.latencyMs != null) MonoText(l.latencyMs(i.latencyMs!)),
          if (i.keyHint != null) MonoText(i.keyHint!),
          if (i.checkedAt != null)
            Text(l.checkedAgo(Fmt.ago(context, i.checkedAt)),
                style: type.caption.copyWith(color: t.ink3)),
        ]),
        if (i.detail != null && i.detail!.isNotEmpty) ...[
          Gap.h4,
          Text(i.detail!, style: type.caption.copyWith(color: t.ink2)),
        ],
        Gap.h12,
        Row(children: [
          if (canManage) ...[
            SegmentedButton<String>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: 'sandbox', label: Text(l.sandbox)),
                ButtonSegment(value: 'live', label: Text(l.liveMode)),
              ],
              selected: {i.mode},
              onSelectionChanged: (s) => _mode(s.first),
            ),
            const Spacer(),
            Switch(value: i.enabled, onChanged: _enable),
          ] else ...[
            StatusBadge(label: i.mode == 'live' ? l.liveMode : l.sandbox, dot: false, outlined: true),
            const Spacer(),
          ],
        ]),
        Gap.h8,
        DahabButton.ghost(
          label: l.checkNow,
          icon: Icons.network_check,
          compact: true,
          loading: _checking,
          onPressed: () async {
            setState(() => _checking = true);
            await context.read<ControlCubit>().checkIntegration(i);
            if (mounted) setState(() => _checking = false);
          },
        ),
      ]),
    );
  }

  Future<void> _mode(String mode) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.switchModeTitle(i.name, mode == 'live' ? l.liveMode : l.sandbox),
      biometric: mode == 'live',
      destructive: mode == 'live',
    );
    if (reason == null || !mounted) return;
    await _patch(reason, mode: mode);
  }

  Future<void> _enable(bool enabled) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.toggleTitle(i.name, enabled ? l.on : l.off),
      biometric: !enabled,
      destructive: !enabled,
    );
    if (reason == null || !mounted) return;
    await _patch(reason, enabled: enabled);
  }

  Future<void> _patch(String reason, {bool? enabled, String? mode}) async {
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.patchIntegration(i, enabled: enabled, mode: mode, reason: reason);
    if (!mounted) return;
    if (ok) {
      showToast(context, context.l10n.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}
