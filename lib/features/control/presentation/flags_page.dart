import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'control_cubit.dart';
import 'flag_labels.dart';
import '../../../core/router/shell_leading.dart';

/// Kill switches first (they switch a capability off for everyone), then
/// feature flags with their rollout. Every toggle goes through
/// [ConfirmDangerSheet].
@RoutePage()
class FlagsPage extends StatelessWidget {
  const FlagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ControlCubit>()..start(parts: {ControlPart.flags}),
      child: const _FlagsView(),
    );
  }
}

class _FlagsView extends StatelessWidget {
  const _FlagsView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.flagsTitle)),
      body: BlocBuilder<ControlCubit, ControlState>(
        builder: (context, s) {
          if (s.status == ControlStatus.loading || s.status == ControlStatus.initial) {
            return const SkeletonList(lines: 1);
          }
          if (s.status == ControlStatus.failure) {
            return ErrorView(error: s.error!, onRetry: context.read<ControlCubit>().refresh);
          }
          final kills = s.flags.where((f) => f.isKillSwitch).toList();
          final flags = s.flags.where((f) => !f.isKillSwitch && !f.isMaintenance).toList();
          if (kills.isEmpty && flags.isEmpty) return const EmptyState(icon: Icons.flag_outlined);
          return RefreshIndicator(
            onRefresh: context.read<ControlCubit>().refresh,
            child: ListView(children: [
              SectionHeader(title: l.killSwitches, count: kills.length),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.gutter),
                child: Text(l.killSwitchWarning,
                    style: context.type.caption.copyWith(color: context.dg.ink2)),
              ),
              Gap.h8,
              for (final f in kills) FlagTile(flag: f),
              SectionHeader(title: l.featureFlags, count: flags.length),
              for (final f in flags) FlagTile(flag: f),
              Gap.h32,
            ]),
          );
        },
      ),
    );
  }
}

/// One flag. Kill switches read "on = capability off" so they are tinted
/// critical when engaged.
class FlagTile extends StatelessWidget {
  const FlagTile({super.key, required this.flag});

  final FlagItem flag;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final canManage = context.select<SessionCubit, bool>((s) => s.state.can(P.flagsManage));
    final engagedKill = flag.isKillSwitch && flag.enabled;
    return Column(children: [
      Container(
        color: engagedKill ? t.criticalWash : null,
        child: SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          secondary: flag.isKillSwitch
              ? Icon(Icons.power_settings_new, color: engagedKill ? t.critical : t.ink3)
              : null,
          title: MonoText(flag.key, color: t.ink, size: 14),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (FlagLabels.description(l, flag) case final d?) Text(d),
            Text(
              [
                if (flag.rolloutPercent != null) '${l.rollout} ${flag.rolloutPercent}%',
                if (flag.roles.isNotEmpty) flag.roles.join(l.listSeparator),
                if (flag.updatedAt != null) '${Fmt.ago(context, flag.updatedAt)} · ${flag.updatedBy ?? ''}',
              ].join(' · '),
              style: context.type.caption.copyWith(color: t.ink3),
            ),
          ]),
          value: flag.enabled,
          onChanged: canManage ? (v) => _toggle(context, v) : null,
        ),
      ),
      if (canManage && !flag.isKillSwitch && flag.rolloutPercent != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.sm),
          child: _RolloutSlider(flag: flag),
        ),
      const Hairline(indent: Space.gutter),
    ]);
  }

  Future<void> _toggle(BuildContext context, bool v) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.toggleTitle(FlagLabels.title(l, flag), v ? l.on : l.off),
      body: flag.isKillSwitch ? l.killSwitchWarning : FlagLabels.description(l, flag),
      biometric: flag.isKillSwitch || flag.isMaintenance,
      destructive: flag.isKillSwitch ? v : false,
    );
    if (reason == null || !context.mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.setFlag(flag, v, reason);
    if (!context.mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}

class _RolloutSlider extends StatefulWidget {
  const _RolloutSlider({required this.flag});

  final FlagItem flag;

  @override
  State<_RolloutSlider> createState() => _RolloutSliderState();
}

class _RolloutSliderState extends State<_RolloutSlider> {
  late double _v = (widget.flag.rolloutPercent ?? 0).toDouble();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(children: [
      Expanded(
        child: Slider(
          value: _v,
          max: 100,
          divisions: 20,
          label: '${_v.round()}%',
          onChanged: (v) => setState(() => _v = v),
          onChangeEnd: (v) async {
            final reason = await showConfirmDangerSheet(
              context,
              title: '${widget.flag.key} · ${l.rollout} ${v.round()}%',
              biometric: false,
              destructive: false,
            );
            if (!context.mounted) return;
            if (reason == null) {
              setState(() => _v = (widget.flag.rolloutPercent ?? 0).toDouble());
              return;
            }
            final cubit = context.read<ControlCubit>();
            final ok = await cubit.setFlag(widget.flag, widget.flag.enabled, reason,
                rolloutPercent: v.round());
            if (!ok && context.mounted && cubit.state.error != null) {
              showErrorToast(context, cubit.state.error!);
            }
          },
        ),
      ),
      SizedBox(width: 48, child: MonoText('${_v.round()}%')),
    ]);
  }
}
