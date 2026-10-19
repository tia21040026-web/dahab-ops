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
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/modern.dart';
import '../../../core/design/components/offline_banner.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'app_experience_gates.dart';
import 'control_cubit.dart';
import 'flag_labels.dart';

/// App Experience (`/control/app-experience`): everything that changes what
/// travelers see on the web and both apps without a release — maintenance,
/// the announcement banner, kill switches, app version gates and feature
/// flags — with a live preview of the traveler's screen.
@RoutePage()
class AppExperiencePage extends StatelessWidget {
  const AppExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ControlCubit>()
        ..start(parts: {ControlPart.settings, ControlPart.flags}),
      child: const _AppExperienceView(),
    );
  }
}

class _AppExperienceView extends StatelessWidget {
  const _AppExperienceView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: DgTopBar(title: l.ccTileExperience, subtitle: l.ccTileExperienceSub),
      body: BlocBuilder<ControlCubit, ControlState>(
        builder: (context, s) {
          if (s.status == ControlStatus.initial || s.status == ControlStatus.loading) {
            return const SkeletonList(count: 6);
          }
          if (s.status == ControlStatus.failure) {
            return ErrorView(error: s.error!, onRetry: context.read<ControlCubit>().refresh);
          }
          return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
            const OfflineBannerSafe(),
            _MaintenanceCard(s: s),
            Gap.h16,
            _AnnouncementCard(s: s),
            Gap.h16,
            KillSwitchesCard(s: s),
            Gap.h16,
            AppVersionGatesCard(s: s),
            Gap.h16,
            const _FeatureFlagsCard(),
            Gap.h32,
          ]);
        },
      ),
    );
  }
}

/// The hub's OfflineBanner needs a ScaffoldMessenger ancestor; these screens
/// always have one, so the plain banner is safe. Wrapped for reuse.
class OfflineBannerSafe extends StatelessWidget {
  const OfflineBannerSafe({super.key});

  @override
  Widget build(BuildContext context) => const OfflineBanner();
}

/// Reused by the maintenance and announcement editors: bilingual text fields
/// plus the reason-confirmed save through [ControlCubit.saveSetting].
class BilingualSettingEditor extends StatefulWidget {
  const BilingualSettingEditor({
    super.key,
    required this.item,
    required this.labelEn,
    required this.labelAr,
    required this.saveLabel,
    this.enabled = true,
  });

  final SettingItem item;
  final String labelEn;
  final String labelAr;
  final String saveLabel;
  final bool enabled;

  @override
  State<BilingualSettingEditor> createState() => _BilingualSettingEditorState();
}

class _BilingualSettingEditorState extends State<BilingualSettingEditor> {
  late final TextEditingController _en;
  late final TextEditingController _ar;

  @override
  void initState() {
    super.initState();
    _en = TextEditingController(text: _of(widget.item, 'en'));
    _ar = TextEditingController(text: _of(widget.item, 'ar'));
  }

  @override
  void didUpdateWidget(BilingualSettingEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.key != widget.item.key || oldWidget.item.version != widget.item.version) {
      _en.text = _of(widget.item, 'en');
      _ar.text = _of(widget.item, 'ar');
    }
  }

  @override
  void dispose() {
    _en.dispose();
    _ar.dispose();
    super.dispose();
  }

  static String _of(SettingItem item, String lang) {
    final v = item.value;
    return v is Map ? '${v[lang] ?? ''}' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DahabTextField(label: widget.labelEn, controller: _en, maxLines: 2, enabled: widget.enabled),
      Gap.h12,
      DahabTextField(
        label: widget.labelAr,
        controller: _ar,
        maxLines: 2,
        enabled: widget.enabled,
        textDirection: TextDirection.rtl,
      ),
      if (widget.enabled) ...[
        Gap.h12,
        DahabButton.secondary(label: widget.saveLabel, expand: true, onPressed: _save),
      ],
    ]);
  }

  Future<void> _save() async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.ccSaveSettingTitle(widget.item.key),
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !mounted) return;
    final cubit = context.read<ControlCubit>();
    // Keep every sibling key (announce.banner carries `enabled` and `tone`,
    // maintenance message carries nothing) so a text edit never drops fields
    // the server requires.
    final base = widget.item.value is Map
        ? Map<String, dynamic>.from(widget.item.value as Map)
        : <String, dynamic>{};
    final ok = await cubit.saveSetting(
      widget.item,
      {...base, 'en': _en.text.trim(), 'ar': _ar.text.trim()},
      reason,
    );
    if (!mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}

/// Maintenance: the kill switch, the bilingual message and the live
/// traveler preview in both directions.
class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.s});

  final ControlState s;

  static const flagKey = 'system.maintenance';
  static const messageKey = 'system.maintenanceMessage';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final session = context.watch<SessionCubit>().state;
    final flag = s.flags.where((f) => f.key == flagKey || f.isMaintenance).firstOrNull;
    final message = s.settings.where((i) => i.key == messageKey).firstOrNull;
    final on = flag?.enabled ?? false;
    final canFlag = session.can(P.flagsManage) && flag != null;
    final canMessage = session.can(P.settingsManage) && message != null;
    final en = message == null ? '' : _lang(message, 'en');
    final ar = message == null ? '' : _lang(message, 'ar');

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DgSectionHead(title: l.maintenanceTitle),
      Panel(
        color: on ? t.warningWash : t.surface,
        borderColor: on ? t.warning.withValues(alpha: 0.4) : null,
        child: Row(children: [
          StatusDot(color: on ? t.warning : t.positive, size: 10, pulse: on),
          Gap.w12,
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(on ? l.maintenanceActive : l.maintenanceInactive, style: context.type.title),
              Gap.h4,
              Text(l.ccMaintenanceHint, style: context.type.caption.copyWith(color: t.ink2)),
            ]),
          ),
          DgSwitch(
            value: on,
            kill: true,
            semanticLabel: l.maintenanceTitle,
            onChanged: canFlag ? (next) => _toggle(context, flag, next) : null,
          ),
        ]),
      ),
      Gap.h12,
      if (message != null)
        BilingualSettingEditor(
          key: ValueKey('${message.key}:${message.version}'),
          item: message,
          labelEn: l.messageEn,
          labelAr: l.messageAr,
          saveLabel: l.saveMessage,
          enabled: canMessage,
        ),
      Gap.h12,
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: PreviewFrame(
            label: l.ccPreviewEn,
            maintenance: on ? (en.isNotEmpty ? en : l.maintenanceBody) : null,
          ),
        ),
        Gap.w12,
        Expanded(
          child: PreviewFrame(
            label: l.ccPreviewAr,
            maintenance: on ? (ar.isNotEmpty ? ar : l.maintenanceBody) : null,
            arabic: true,
          ),
        ),
      ]),
    ]);
  }

  static String _lang(SettingItem item, String lang) {
    final v = item.value;
    if (v is Map) {
      final s = '${v[lang] ?? ''}';
      if (s.trim().isNotEmpty) return s;
    }
    return '';
  }

  Future<void> _toggle(BuildContext context, FlagItem? flag, bool on) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: on ? l.maintenanceOn : l.maintenanceOff,
      body: l.maintenanceBody,
      destructive: on,
    );
    if (reason == null || flag == null || !context.mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.setFlag(flag, on, reason);
    if (!context.mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}

/// The announcement banner (`announce.banner`): enable, tone, bilingual
/// copy, and the live preview strip.
class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.s});

  final ControlState s;

  static const key_ = 'announce.banner';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final item = s.settings.where((i) => i.key == key_).firstOrNull;
    if (item == null) return const SizedBox.shrink();
    final data = item.value is Map ? item.value as Map : const {};
    final enabled = data['enabled'] == true;
    final warn = data['tone'] == 'warn';
    final canEdit = session.can(P.settingsManage);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DgGroupTitle(l.ccAnnouncementTitle, note: l.ccAnnouncementNote),
      Panel(
        color: enabled ? bannerWash(context, warn) : context.dg.surface,
        borderColor: enabled
            ? toneOf(context, warn).withValues(alpha: 0.4)
            : null,
        child: Row(children: [
          StatusDot(color: toneOf(context, warn), size: 10, pulse: enabled),
          Gap.w12,
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(enabled ? l.ccBannerOn : l.ccBannerOff, style: context.type.title),
              Gap.h4,
              Text(warn ? l.ccBannerWarn : l.ccBannerInfo,
                  style: context.type.caption.copyWith(color: context.dg.ink2)),
            ]),
          ),
          DgSwitch(
            value: enabled,
            semanticLabel: l.ccAnnouncementTitle,
            onChanged: canEdit ? (next) => _setEnabled(context, item, data, next) : null,
          ),
        ]),
      ),
      Gap.h12,
      if (canEdit) ...[
        _ToneChips(item: item, data: data, warn: warn, enabled: enabled),
        Gap.h12,
      ],
      BilingualSettingEditor(
        key: ValueKey('$key_:${item.version}:$warn'),
        item: item,
        labelEn: l.messageEn,
        labelAr: l.messageAr,
        saveLabel: l.saveMessage,
        enabled: canEdit,
      ),
      Gap.h12,
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: PreviewFrame(
            label: l.ccPreviewEn,
            banner: enabled ? _lang(data, 'en') : null,
            bannerWarn: warn,
          ),
        ),
        Gap.w12,
        Expanded(
          child: PreviewFrame(
            label: l.ccPreviewAr,
            banner: enabled ? _lang(data, 'ar') : null,
            bannerWarn: warn,
            arabic: true,
          ),
        ),
      ]),
    ]);
  }

  static Color bannerWash(BuildContext context, bool warn) =>
      warn ? context.dg.warningWash : context.dg.actionWash;

  static Color toneOf(BuildContext context, bool warn) =>
      warn ? context.dg.warning : context.dg.action;

  static String _lang(Map data, String lang) => '${data[lang] ?? ''}';

  Future<void> _setEnabled(BuildContext context, SettingItem item, Map data, bool next) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: next ? l.ccBannerEnable : l.ccBannerDisable,
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !context.mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.saveSetting(item, {
      ...data,
      'enabled': next,
    }, reason);
    if (!context.mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}

/// Info/warn tone selector chips for the banner.
class _ToneChips extends StatelessWidget {
  const _ToneChips({required this.item, required this.data, required this.warn, required this.enabled});

  final SettingItem item;
  final Map data;
  final bool warn;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(children: [
      DgChip(label: l.ccBannerInfo, selected: !warn, onTap: enabled ? () => _set(context, 'info') : null),
      Gap.w8,
      DgChip(label: l.ccBannerWarn, selected: warn, onTap: enabled ? () => _set(context, 'warn') : null),
    ]);
  }

  Future<void> _set(BuildContext context, String tone) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.ccSaveSettingTitle(item.key),
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !context.mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.saveSetting(item, {...data, 'tone': tone}, reason);
    if (!context.mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}

/// Feature flags: enable/disable with a reason; full targeting (rollout,
/// roles) lives on the Flags page.
class _FeatureFlagsCard extends StatelessWidget {
  const _FeatureFlagsCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final s = context.watch<ControlCubit>().state;
    final flags = s.flags.where((f) => !f.isKillSwitch && !f.isMaintenance).toList();
    if (flags.isEmpty || !session.canAny(const [P.flagsManage, P.opsFlags])) {
      return const SizedBox.shrink();
    }
    final rows = <Widget>[];
    for (var i = 0; i < flags.length; i++) {
      if (i > 0) rows.add(const Hairline(indent: Space.lg));
      rows.add(DgSetRow(
        title: flagTitle(context, flags[i]),
        subtitle: flags[i].rolloutPercent == null
            ? null
            : l.ccRolloutReading('${flags[i].rolloutPercent}'),
        value: flags[i].enabled ? l.ccFlagOn : l.ccFlagOff,
        trailing: DgSwitch(
          value: flags[i].enabled,
          semanticLabel: flagTitle(context, flags[i]),
          onChanged: (next) => _toggle(context, flags[i], next),
        ),
      ));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DgSectionHead(
        title: l.ccFeatureFlags,
        linkLabel: l.ccFlagsManageAll,
        onLink: () => context.router.push(const FlagsRoute()),
      ),
      Panel(
        padding: EdgeInsets.zero,
        child: Column(children: rows),
      ),
    ]);
  }

  static String flagTitle(BuildContext context, FlagItem f) =>
      FlagLabels.title(context.l10n, f);

  Future<void> _toggle(BuildContext context, FlagItem flag, bool next) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: next ? l.ccFlagEnableTitle(flag.key) : l.ccFlagDisableTitle(flag.key),
      biometric: false,
      destructive: false,
      confirmLabel: next ? l.ccFlagEnable : l.ccFlagDisable,
    );
    if (reason == null || !context.mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.setFlag(flag, next, reason);
    if (!context.mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }
}
