import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/modern.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'control_cubit.dart';
import 'flag_labels.dart';

/// The five kill switches, localized, with the danger-confirmed engage flow.
class KillSwitchesCard extends StatelessWidget {
  const KillSwitchesCard({super.key, required this.s});

  final ControlState s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final kills = s.flags.where((f) => f.isKillSwitch).toList();
    if (kills.isEmpty || !session.canAny(const [P.flagsManage, P.opsFlags])) {
      return const SizedBox.shrink();
    }
    final engaged = kills.where((f) => f.enabled).length;
    final rows = <Widget>[];
    for (var i = 0; i < kills.length; i++) {
      if (i > 0) rows.add(const Hairline(indent: Space.lg));
      rows.add(_KillRow(flag: kills[i]));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DgGroupTitle(
        l.killSwitches,
        note: l.killSwitchesNote,
        color: engaged > 0 ? context.dg.critical : null,
      ),
      Panel(
        padding: EdgeInsets.zero,
        child: Column(children: rows),
      ),
    ]);
  }
}

class _KillRow extends StatelessWidget {
  const _KillRow({required this.flag});

  final FlagItem flag;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final session = context.watch<SessionCubit>().state;
    final can = session.can(P.flagsManage);
    return DgSetRow(
      title: FlagLabels.title(l, flag),
      subtitle: FlagLabels.description(l, flag),
      subtitleColor: flag.enabled ? t.critical : null,
      value: flag.enabled ? l.ccFlagEngaged : l.ccFlagNormal,
      trailing: DgSwitch(
        value: flag.enabled,
        kill: true,
        semanticLabel: FlagLabels.title(l, flag),
        onChanged: can ? (next) => _toggle(context, next) : null,
      ),
    );
  }

  Future<void> _toggle(BuildContext context, bool next) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: next ? l.ccKillEngageTitle(FlagLabels.title(l, flag)) : l.ccKillReleaseTitle(FlagLabels.title(l, flag)),
      body: FlagLabels.description(l, flag) ?? l.killSwitchesNote,
      destructive: next,
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

/// Per-platform update gates: `apps.<platform>Min/LatestVersion/StoreUrl`
/// settings plus a simulator — type an app version, see the gate result the
/// `GET /api/config` client will compute.
class AppVersionGatesCard extends StatelessWidget {
  const AppVersionGatesCard({super.key, required this.s});

  final ControlState s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    if (!session.can(P.settingsView)) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DgGroupTitle(l.ccGatesTitle, note: l.ccGatesNote),
      for (final platform in const ['android', 'ios']) ...[
        _PlatformGates(platform: platform, s: s, canEdit: session.can(P.settingsManage)),
        Gap.h12,
      ],
    ]);
  }
}

class _PlatformGates extends StatefulWidget {
  const _PlatformGates({required this.platform, required this.s, required this.canEdit});

  final String platform;
  final ControlState s;
  final bool canEdit;

  @override
  State<_PlatformGates> createState() => _PlatformGatesState();
}

class _PlatformGatesState extends State<_PlatformGates> {
  final _simulate = TextEditingController();

  @override
  void dispose() {
    _simulate.dispose();
    super.dispose();
  }

  SettingItem? _setting(ControlState s, String key) =>
      s.settings.where((i) => i.key == key).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final p = widget.platform;
    final minItem = _setting(widget.s, 'apps.${p}MinVersion');
    final latestItem = _setting(widget.s, 'apps.${p}LatestVersion');
    final storeItem = _setting(widget.s, 'apps.${p}StoreUrl');
    final min = minItem == null ? '' : '${minItem.value ?? ''}';
    final latest = latestItem == null ? '' : '${latestItem.value ?? ''}';

    return Panel(
      padding: const EdgeInsets.all(Space.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(
                p == 'android' ? l.ccPlatformAndroid : l.ccPlatformIos,
                style: context.type.title),
          ),
          MonoText(min, size: 13, color: t.ink2),
        ]),
        Gap.h12,
        if (minItem != null)
          _VersionField(
            label: l.ccMinVersion,
            item: minItem,
            enabled: widget.canEdit,
          ),
        Gap.h12,
        if (latestItem != null)
          _VersionField(
            label: l.ccLatestVersion,
            item: latestItem,
            enabled: widget.canEdit,
          ),
        Gap.h12,
        if (storeItem != null)
          _StoreUrlField(
            label: l.ccStoreUrl,
            item: storeItem,
            enabled: widget.canEdit,
          ),
        Gap.h12,
        // The simulator: exactly what `GET /api/config` computes.
        Container(
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(
            color: t.raised2,
            borderRadius: Radii.mdAll,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.ccSimulatorTitle, style: context.type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: t.ink2)),
            Gap.h8,
            DahabTextField(
              label: l.ccSimulatorHint,
              controller: _simulate,
              mono: true,
              enabled: true,
              onChanged: (_) => setState(() {}),
            ),
            Gap.h8,
            _GateResult(min: min, latest: latest, version: _simulate.text),
          ]),
        ),
      ]),
    );
  }
}

class _VersionField extends StatelessWidget {
  const _VersionField({required this.label, required this.item, required this.enabled});

  final String label;
  final SettingItem item;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _SettingStringField(
      key: ValueKey('${item.key}:${item.version}'),
      label: label,
      initial: '${item.value ?? ''}',
      enabled: enabled,
      mono: true,
      onSave: (value, reason) async {
        final cubit = context.read<ControlCubit>();
        return cubit.saveSetting(item, value, reason);
      },
      invalidMessage: l.ccVersionInvalid,
      validate: (v) => RegExp(r'^\d+\.\d+\.\d+$').hasMatch(v),
    );
  }
}

class _StoreUrlField extends StatelessWidget {
  const _StoreUrlField({required this.label, required this.item, required this.enabled});

  final String label;
  final SettingItem item;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _SettingStringField(
      key: ValueKey('${item.key}:${item.version}'),
      label: label,
      initial: '${item.value ?? ''}',
      enabled: enabled,
      mono: true,
      onSave: (value, reason) async {
        final cubit = context.read<ControlCubit>();
        return cubit.saveSetting(item, value, reason);
      },
    );
  }
}

/// One string setting with a reason-confirmed save and optional validation.
class _SettingStringField extends StatefulWidget {
  const _SettingStringField({
    super.key,
    required this.label,
    required this.initial,
    required this.onSave,
    this.enabled = true,
    this.mono = false,
    this.validate,
    this.invalidMessage,
  });

  final String label;
  final String initial;
  final Future<bool> Function(String value, String reason) onSave;
  final bool enabled;
  final bool mono;
  final bool Function(String value)? validate;
  final String? invalidMessage;

  @override
  State<_SettingStringField> createState() => _SettingStringFieldState();
}

class _SettingStringFieldState extends State<_SettingStringField> {
  late final TextEditingController _c = TextEditingController(text: widget.initial);
  String? _error;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DahabTextField(
        label: widget.label,
        controller: _c,
        enabled: widget.enabled,
        mono: widget.mono,
        errorText: _error,
        onChanged: (_) => _error == null ? null : setState(() => _error = null),
      ),
      if (widget.enabled) ...[
        Gap.h8,
        DahabButton.ghost(
          label: l.save,
          onPressed: () => _save(),
        ),
      ],
    ]);
  }

  Future<void> _save() async {
    final l = context.l10n;
    final value = _c.text.trim();
    if (widget.validate != null && !widget.validate!(value)) {
      setState(() => _error = widget.invalidMessage ?? l.ccVersionInvalid);
      return;
    }
    final reason = await showConfirmDangerSheet(
      context,
      title: l.ccSaveSettingTitle(widget.label),
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !mounted) return;
    final ok = await widget.onSave(value, reason);
    if (!mounted) return;
    if (ok) {
      setState(() => _error = null);
      showToast(context, l.saved, tone: Tone.positive);
    } else {
      setState(() => _error = l.noticeFailed);
    }
  }
}

/// The gate verdict for a simulated version, matching the server's
/// compareVersions math (numeric per segment; malformed input sorts low).
class _GateResult extends StatelessWidget {
  const _GateResult({required this.min, required this.latest, required this.version});

  final String min;
  final String latest;
  final String version;

  static int _compare(String a, String b) {
    List<int> parts(String v) {
      final m = RegExp(r'^(\d+)\.(\d+)\.(\d+)$').firstMatch(v.trim());
      if (m == null) return const [];
      return [int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!)];
    }

    final pa = parts(a);
    final pb = parts(b);
    if (pa.isEmpty && pb.isEmpty) return 0;
    if (pa.isEmpty) return -1;
    if (pb.isEmpty) return 1;
    for (var i = 0; i < 3; i++) {
      if (pa[i] != pb[i]) return pa[i] < pb[i] ? -1 : 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final valid = RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version.trim());
    if (!valid) {
      if (version.trim().isEmpty) {
        return Text(l.ccSimulatorEmpty, style: context.type.caption.copyWith(color: t.ink3));
      }
      return Text(l.ccVersionInvalid, style: context.type.caption.copyWith(color: t.critical));
    }
    final required = _compare(version, min) < 0;
    final available = !required && _compare(version, latest) < 0;
    final (tone, label) = switch ((required, available)) {
      (true, _) => (Tone.critical, l.ccGateBlocked),
      (false, true) => (Tone.warning, l.ccGateUpdate),
      _ => (Tone.positive, l.ccGateOk),
    };
    return StatusPill(label, tone: tone, pulse: required);
  }
}
