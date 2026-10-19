import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/timeline.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/control_repository.dart';
import 'control_cubit.dart';
import '../../../core/router/shell_leading.dart';

/// Typed settings: number / string / boolean / json editors, each save with
/// a reason, plus per-key history and rollback.
@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ControlCubit>()..start(parts: {ControlPart.settings}),
      child: const _SettingsView(),
    );
  }
}

/// Keys whose change is queued for a second admin (contract § Admin: control).
const _approvalKeys = {'commerce.commissionRate'};

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(leading: shellLeading(context),
        automaticallyImplyLeading: false, title: Text(l.settingsTitle)),
      body: BlocBuilder<ControlCubit, ControlState>(
        builder: (context, s) {
          if (s.status == ControlStatus.loading || s.status == ControlStatus.initial) {
            return const SkeletonList();
          }
          if (s.status == ControlStatus.failure) {
            return ErrorView(error: s.error!, onRetry: context.read<ControlCubit>().refresh);
          }
          if (s.settings.isEmpty) return const EmptyState(icon: Icons.tune);
          final groups = groupBy(s.settings, (SettingItem i) => i.group);
          return RefreshIndicator(
            onRefresh: context.read<ControlCubit>().refresh,
            child: ListView(children: [
              for (final g in groups.entries) ...[
                SectionHeader(title: g.key, count: g.value.length),
                for (final item in g.value) _SettingRow(item: item),
              ],
              Gap.h32,
            ]),
          );
        },
      ),
    );
  }
}

String displaySettingValue(Object? v) {
  if (v == null) return '—';
  if (v is num) return Fmt.number(v);
  if (v is bool) return v ? 'true' : 'false';
  if (v is Map || v is List) return jsonEncode(v);
  return '$v';
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.item});

  final SettingItem item;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final canEdit = context.select<SessionCubit, bool>((s) => s.state.can(P.settingsManage));
    final value = displaySettingValue(item.value);
    return Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
        title: Text(item.label(arabic)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          MonoText(item.key, size: 12, color: t.ink3),
          if (_approvalKeys.contains(item.key))
            Text(l.commissionNeedsApproval, style: context.type.caption.copyWith(color: t.warning)),
        ]),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
            MonoText(value, color: t.ink, maxLines: 1),
            MonoText(l.versionLabel(item.version), size: 11, color: t.ink3),
          ]),
        ),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => BlocProvider.value(
            value: context.read<ControlCubit>(),
            child: _SettingEditor(item: item, canEdit: canEdit),
          ),
        ),
      ),
      const Hairline(indent: Space.gutter),
    ]);
  }
}

class _SettingEditor extends StatefulWidget {
  const _SettingEditor({required this.item, required this.canEdit});

  final SettingItem item;
  final bool canEdit;

  @override
  State<_SettingEditor> createState() => _SettingEditorState();
}

class _SettingEditorState extends State<_SettingEditor> {
  late final TextEditingController _text;
  late bool _bool;
  String? _error;
  List<SettingVersion>? _history;
  bool _historyFailed = false;

  SettingItem get item => widget.item;

  @override
  void initState() {
    super.initState();
    final v = item.value;
    _bool = v == true;
    _text = TextEditingController(
      text: item.type == 'json'
          ? const JsonEncoder.withIndent('  ').convert(v)
          : (v == null ? '' : '$v'),
    );
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final h = await GetIt.I<ControlRepository>().settingHistory(item.key);
      if (mounted) setState(() => _history = h..sort((a, b) => b.version.compareTo(a.version)));
    } catch (_) {
      if (mounted) setState(() => _historyFailed = true);
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  /// Parsed value or null with [_error] set.
  (bool, Object?) _parse() {
    final l = context.l10n;
    final raw = _text.text.trim();
    switch (item.type) {
      case 'number':
        final n = num.tryParse(raw);
        if (n == null) return _fail(l.invalidNumber);
        return (true, n);
      case 'boolean':
        return (true, _bool);
      case 'json':
        try {
          return (true, jsonDecode(raw));
        } on FormatException {
          return _fail(l.invalidJson);
        }
      default:
        return (true, raw);
    }
  }

  (bool, Object?) _fail(String message) {
    setState(() => _error = message);
    return (false, null);
  }

  Future<void> _save() async {
    final l = context.l10n;
    final (ok, value) = _parse();
    if (!ok) return;
    setState(() => _error = null);
    final reason = await showConfirmDangerSheet(
      context,
      title: l.saveSettingTitle(item.key),
      body: '${displaySettingValue(item.value)}  →  ${displaySettingValue(value)}',
      requiresApproval: _approvalKeys.contains(item.key),
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !mounted) return;
    final cubit = context.read<ControlCubit>();
    final saved = await cubit.saveSetting(item, value, reason);
    if (!mounted) return;
    if (saved) {
      showToast(context, l.saved, tone: Tone.positive);
      Navigator.of(context).pop();
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }

  Future<void> _rollback(SettingVersion v) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.rollbackTo(v.version),
      body: displaySettingValue(v.value),
      requiresApproval: _approvalKeys.contains(item.key),
      biometric: false,
      confirmLabel: l.rollback,
    );
    if (reason == null || !mounted) return;
    final cubit = context.read<ControlCubit>();
    final ok = await cubit.rollbackSetting(item, v.version, reason);
    if (!mounted) return;
    if (ok) {
      showToast(context, l.saved, tone: Tone.positive);
      Navigator.of(context).pop();
    } else if (cubit.state.error != null) {
      showErrorToast(context, cubit.state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final type = context.type;
    final editor = switch (item.type) {
      'boolean' => SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_bool ? l.enabled : l.disabled),
          value: _bool,
          onChanged: widget.canEdit ? (v) => setState(() => _bool = v) : null,
        ),
      'number' => DahabTextField(
          label: l.newValue,
          controller: _text,
          mono: true,
          enabled: widget.canEdit,
          errorText: _error,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]'))],
        ),
      'json' => DahabTextField(
          label: l.newValue,
          controller: _text,
          mono: true,
          enabled: widget.canEdit,
          errorText: _error,
          maxLines: 10,
          minLines: 4,
          textDirection: TextDirection.ltr,
        ),
      _ => DahabTextField(
          label: l.newValue,
          controller: _text,
          enabled: widget.canEdit,
          errorText: _error,
        ),
    };
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (context, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xl),
          children: [
            Text(item.label(type.isArabic), style: type.heading),
            MonoText(item.key, color: t.ink3),
            Gap.h16,
            Text(l.currentValue, style: type.caption.copyWith(color: t.ink3)),
            MonoText(displaySettingValue(item.value), color: t.ink, maxLines: 6),
            if (item.updatedAt != null)
              Text(
                '${l.updatedAgo(Fmt.ago(context, item.updatedAt))} · ${item.updatedBy ?? ''}',
                style: type.caption.copyWith(color: t.ink3),
              ),
            Gap.h16,
            editor,
            if (widget.canEdit) ...[
              Gap.h16,
              DahabButton(label: l.save, expand: true, onPressed: _save),
            ],
            SectionHeader(title: l.history, padding: const EdgeInsetsDirectional.only(top: Space.xl, bottom: Space.sm)),
            if (_history == null && !_historyFailed)
              const LinearProgressIndicator(minHeight: 1)
            else if (_historyFailed || _history!.isEmpty)
              Text(l.historyEmpty, style: type.bodySm.copyWith(color: t.ink3))
            else
              Timeline(
                padding: EdgeInsets.zero,
                entries: [
                  for (final v in _history!)
                    TimelineEntry(
                      title: '${l.versionLabel(v.version)}  ${displaySettingValue(v.value)}',
                      subtitle: [v.updatedBy, v.reason].whereType<String>().join(' · '),
                      when: Fmt.ago(context, v.updatedAt),
                      state: v.version == item.version ? TimelineState.now : TimelineState.done,
                      detail: widget.canEdit && v.version != item.version
                          ? Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: DahabButton.ghost(
                                label: l.rollback,
                                icon: Icons.undo,
                                compact: true,
                                onPressed: () => _rollback(v),
                              ),
                            )
                          : null,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
