import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'control_cubit.dart';
import '../../../core/router/shell_leading.dart';

/// `system.maintenance` plus the bilingual message travellers see
/// (`system.maintenanceMessage` = `{ en, ar }`).
@RoutePage()
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  static const flagKey = 'system.maintenance';
  static const messageKey = 'system.maintenanceMessage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ControlCubit>()
        ..start(parts: {ControlPart.flags, ControlPart.settings}),
      child: const _MaintenanceView(),
    );
  }
}

class _MaintenanceView extends StatefulWidget {
  const _MaintenanceView();

  @override
  State<_MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<_MaintenanceView> {
  final _en = TextEditingController();
  final _ar = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _en.dispose();
    _ar.dispose();
    super.dispose();
  }

  void _seed(SettingItem? message) {
    if (_seeded || message == null) return;
    _seeded = true;
    final v = message.value;
    if (v is Map) {
      _en.text = '${v['en'] ?? ''}';
      _ar.text = '${v['ar'] ?? ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final session = context.watch<SessionCubit>().state;
    return Scaffold(
      appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.maintenanceTitle)),
      body: BlocBuilder<ControlCubit, ControlState>(
        builder: (context, s) {
          if (s.status == ControlStatus.loading || s.status == ControlStatus.initial) {
            return const SkeletonList(count: 3);
          }
          if (s.status == ControlStatus.failure) {
            return ErrorView(error: s.error!, onRetry: context.read<ControlCubit>().refresh);
          }
          final flag = s.flags.firstWhereOrNull(
              (f) => f.key == MaintenancePage.flagKey || f.isMaintenance);
          final message = s.settings.firstWhereOrNull((i) => i.key == MaintenancePage.messageKey);
          _seed(message);
          final on = flag?.enabled ?? false;
          final canFlag = session.can(P.flagsManage) && flag != null;
          final canMessage = session.can(P.settingsManage) && message != null;
          return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
            Panel(
              color: on ? t.warningWash : t.surface,
              borderColor: on ? t.warning.withValues(alpha: 0.4) : null,
              child: Row(children: [
                StatusDot(color: on ? t.warning : t.positive, size: 10, pulse: on),
                Gap.w12,
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(on ? l.maintenanceActive : l.maintenanceInactive, style: type.title),
                    Gap.h4,
                    Text(l.maintenanceBody, style: type.caption.copyWith(color: t.ink2)),
                  ]),
                ),
              ]),
            ),
            Gap.h16,
            if (canFlag)
              on
                  ? DahabButton(
                      label: l.maintenanceOff,
                      icon: Icons.play_arrow_rounded,
                      expand: true,
                      onPressed: () => _toggle(flag, false),
                    )
                  : DahabButton.danger(
                      label: l.maintenanceOn,
                      icon: Icons.construction,
                      expand: true,
                      onPressed: () => _toggle(flag, true),
                    ),
            if (message != null) ...[
              SectionHeader(title: l.saveMessage, padding: const EdgeInsetsDirectional.only(top: Space.x2, bottom: Space.sm)),
              DahabTextField(label: l.messageEn, controller: _en, maxLines: 3, enabled: canMessage),
              Gap.h12,
              DahabTextField(
                label: l.messageAr,
                controller: _ar,
                maxLines: 3,
                enabled: canMessage,
                textDirection: TextDirection.rtl,
              ),
              if (canMessage) ...[
                Gap.h12,
                DahabButton.secondary(
                  label: l.saveMessage,
                  expand: true,
                  onPressed: () => _saveMessage(message),
                ),
              ],
            ],
          ]);
        },
      ),
    );
  }

  Future<void> _toggle(FlagItem flag, bool on) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: on ? l.maintenanceOn : l.maintenanceOff,
      body: l.maintenanceBody,
      destructive: on,
    );
    if (reason == null || !mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.setFlag(flag, on, reason);
    if (!mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }

  Future<void> _saveMessage(SettingItem message) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.saveSettingTitle(message.key),
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.saveSetting(
        message, {'en': _en.text.trim(), 'ar': _ar.text.trim()}, reason);
    if (!mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}
