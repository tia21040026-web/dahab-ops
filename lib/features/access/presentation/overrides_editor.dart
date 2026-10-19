import 'package:flutter/material.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';

/// Edits per-user overrides (grant / deny per key). Returns the new list,
/// or null when dismissed. Deny beats grant on the server.
class OverridesEditor extends StatefulWidget {
  const OverridesEditor({super.key, required this.initial, required this.catalog});

  final List<PermissionOverride> initial;
  final List<PermissionDef> catalog;

  @override
  State<OverridesEditor> createState() => _OverridesEditorState();
}

class _OverridesEditorState extends State<OverridesEditor> {
  late final Map<String, String> _values = {for (final o in widget.initial) o.permission: o.effect};

  bool _danger(String key) => widget.catalog.any((p) => p.key == key && p.dangerous);

  Future<void> _add() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _PermissionPicker(
        catalog: widget.catalog.where((p) => !_values.containsKey(p.key)).toList(),
      ),
    );
    if (picked != null) setState(() => _values[picked] = 'grant');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final keys = _values.keys.toList()..sort();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (context, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.sm, Space.sm),
          child: Row(children: [
            Expanded(child: Text(l.overrides, style: context.type.heading)),
            TextButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: Text(l.addOverride)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xl),
          child: Text(l.overridesHint, style: context.type.caption.copyWith(color: t.ink3)),
        ),
        Expanded(
          child: ListView(controller: scroll, children: [
            for (final k in keys)
              ListTile(
                contentPadding: const EdgeInsetsDirectional.only(start: Space.xl, end: Space.sm),
                title: MonoText(k, color: t.ink),
                subtitle: _danger(k)
                    ? Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: StatusBadge(label: l.dangerous, tone: Tone.critical),
                      )
                    : null,
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: 'grant', label: Text(l.grant)),
                      ButtonSegment(value: 'deny', label: Text(l.deny)),
                    ],
                    selected: {_values[k]!},
                    onSelectionChanged: (s) => setState(() => _values[k] = s.first),
                  ),
                  IconButton(
                    tooltip: l.remove,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _values.remove(k)),
                  ),
                ]),
              ),
          ]),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: DahabButton(
              label: l.save,
              expand: true,
              onPressed: () => Navigator.of(context).pop([
                for (final e in _values.entries) PermissionOverride(permission: e.key, effect: e.value),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _PermissionPicker extends StatefulWidget {
  const _PermissionPicker({required this.catalog});

  final List<PermissionDef> catalog;

  @override
  State<_PermissionPicker> createState() => _PermissionPickerState();
}

class _PermissionPickerState extends State<_PermissionPicker> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final arabic = context.type.isArabic;
    final rows = widget.catalog
        .where((p) => _q.isEmpty || p.key.contains(_q) || p.label(arabic).toLowerCase().contains(_q))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: DahabTextField(
            hint: l.pickPermission,
            prefixIcon: Icons.search,
            autofocus: true,
            onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final p = rows[i];
              return ListTile(
                title: Text(p.label(arabic)),
                subtitle: MonoText(p.key, size: 12, color: t.ink3),
                trailing: p.dangerous ? Icon(Icons.warning_amber_rounded, color: t.critical, size: 18) : null,
                onTap: () => Navigator.of(context).pop(p.key),
              );
            },
          ),
        ),
      ]),
    );
  }
}
