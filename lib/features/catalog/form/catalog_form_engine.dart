import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../data/catalog_models.dart';
import 'day_plan_field.dart';
import 'gallery_field.dart';
import 'i18n_field.dart';
import 'supplier_picker.dart';

typedef CatalogUploader = Future<String> Function(Uint8List bytes, String filename, String mimeType);
typedef SupplierPick = Future<SupplierChoice?> Function(BuildContext context);

/// Form values keep the supplier's display name under this key; it is never
/// sent ([CatalogValues.body] skips `_`-prefixed keys).
const supplierNameKey = '_supplierName';

/// Schema-driven form: renders [sections] (or a flat [fields] list) from the
/// contract's field kinds. Stateless over [values]; every edit is reported
/// through [onChanged] so the screen can autosave.
class CatalogFormEngine extends StatelessWidget {
  const CatalogFormEngine({
    super.key,
    this.sections = const [],
    this.fields,
    required this.values,
    required this.onChanged,
    this.enabled = true,
    this.missing = const {},
    this.uploader,
    this.pickSupplier,
    this.showSupplier = true,
    this.sectionHeaders = true,
    this.padding = const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.x2),
    this.shrinkWrap = false,
  });

  final List<CatalogSection> sections;

  /// Overrides [sections] with a flat list (wizard steps).
  final List<CatalogField>? fields;
  final Map<String, Object?> values;
  final void Function(String key, Object? value) onChanged;
  final bool enabled;

  /// Keys the server (422) or the gate reports as missing.
  final Set<String> missing;
  final CatalogUploader? uploader;
  final SupplierPick? pickSupplier;

  /// Suppliers never pick a supplier (the server ignores it).
  final bool showSupplier;
  final bool sectionHeaders;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;

  bool _visible(CatalogField f) => showSupplier || f.kind != FieldKind.supplier;

  @override
  Widget build(BuildContext context) {
    final arabic = context.type.isArabic;
    final children = <Widget>[];
    void addField(CatalogField f) {
      if (!_visible(f)) return;
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: Space.lg),
        child: CatalogFieldInput(
          key: ValueKey('cat.field.${f.key}'),
          field: f,
          value: values[f.key],
          values: values,
          onChanged: onChanged,
          enabled: enabled,
          missing: missing.contains(f.key),
          uploader: uploader,
          pickSupplier: pickSupplier,
        ),
      ));
    }

    if (fields != null) {
      fields!.forEach(addField);
    } else {
      for (final s in sections) {
        final visible = s.fields.where(_visible).toList();
        if (visible.isEmpty) continue;
        if (sectionHeaders) {
          final miss = visible.where((f) => missing.contains(f.key)).length;
          children.add(CatalogSectionTitle(s.labelOf(arabic),
              note: miss > 0 ? context.l10n.catMissingCount(miss) : null, warn: miss > 0));
        }
        visible.forEach(addField);
      }
    }
    return ListView(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      children: children,
    );
  }
}

/// Section heading inside a form (no extra gutter).
class CatalogSectionTitle extends StatelessWidget {
  const CatalogSectionTitle(this.title, {super.key, this.note, this.warn = false});

  final String title;
  final String? note;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Padding(
      padding: const EdgeInsets.only(top: Space.md, bottom: Space.md),
      child: Semantics(
        header: true,
        child: Row(children: [
          Expanded(child: Text(title, style: context.type.title)),
          if (note != null) Text(note!, style: context.type.caption.copyWith(color: warn ? t.warning : t.ink3)),
        ]),
      ),
    );
  }
}

/// One field, dispatched on [CatalogField.kind].
class CatalogFieldInput extends StatelessWidget {
  const CatalogFieldInput({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
    this.values = const {},
    this.enabled = true,
    this.missing = false,
    this.uploader,
    this.pickSupplier,
  });

  final CatalogField field;
  final Object? value;
  final Map<String, Object?> values;
  final void Function(String key, Object? value) onChanged;
  final bool enabled;
  final bool missing;
  final CatalogUploader? uploader;
  final SupplierPick? pickSupplier;

  void _set(Object? v) => onChanged(field.key, v);

  @override
  Widget build(BuildContext context) {
    final arabic = context.type.isArabic;
    final label = '${field.labelOf(arabic)}${field.required ? ' *' : ''}';
    final helper = field.help?.of(arabic);
    final k = field.key;
    switch (field.kind) {
      case FieldKind.text:
        return _TextInput(
            fieldKey: Key('cat.$k'), label: label, helper: helper, value: '${value ?? ''}', enabled: enabled,
            maxLength: field.max?.toInt(), missing: missing, onChanged: _set);
      case FieldKind.i18nText:
      case FieldKind.i18nTextarea:
        return I18nField(
          fieldKey: k,
          label: label,
          value: value is I18n ? value as I18n : I18n.from(value),
          multiline: field.kind == FieldKind.i18nTextarea,
          maxLength: field.max?.toInt(),
          enabled: enabled,
          required: field.required,
          missing: missing,
          onChanged: _set,
        );
      case FieldKind.number:
      case FieldKind.money:
        return _NumberInput(
          fieldKey: Key('cat.$k'),
          label: label,
          helper: helper,
          value: value is num ? value as num : num.tryParse('${value ?? ''}'),
          money: field.kind == FieldKind.money,
          enabled: enabled,
          missing: missing,
          onChanged: _set,
        );
      case FieldKind.duration:
        return _DurationInput(
          fieldKey: k,
          label: label,
          minutes: value is num ? (value as num).toInt() : int.tryParse('${value ?? ''}'),
          enabled: enabled,
          missing: missing,
          onChanged: _set,
        );
      case FieldKind.boolean:
        return _Labelled(
          label: label,
          inline: DgSwitch(
            key: Key('cat.$k'),
            value: value == true,
            semanticLabel: label,
            onChanged: enabled ? (v) => _set(v) : null,
          ),
        );
      case FieldKind.select:
        return _SelectInput(fieldKey: k, label: label, field: field, value: value?.toString(), enabled: enabled, missing: missing, onChanged: _set);
      case FieldKind.multiselect:
        final sel = {for (final v in (value is List ? value as List : const [])) '$v'};
        return _Labelled(
          label: label,
          missing: missing,
          child: Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final o in field.options)
              DgChip(
                key: Key('cat.$k.${o.value}'),
                label: o.label.of(arabic).isEmpty ? o.value : o.label.of(arabic),
                selected: sel.contains(o.value),
                onTap: enabled
                    ? () => _set(sel.contains(o.value)
                        ? [...sel.where((e) => e != o.value)]
                        : [...sel, o.value])
                    : null,
              ),
          ]),
        );
      case FieldKind.tags:
        return _TagsInput(
          fieldKey: k,
          label: label,
          tags: [for (final v in (value is List ? value as List : const [])) '$v'],
          suggestions: field.suggestions,
          enabled: enabled,
          missing: missing,
          onChanged: _set,
        );
      case FieldKind.time:
        return _Labelled(
          label: label,
          missing: missing,
          child: _TimeTile(
            key: Key('cat.$k'),
            value: value?.toString(),
            enabled: enabled,
            onPicked: (v) => _set(v),
          ),
        );
      case FieldKind.timeList:
        final times = [for (final v in (value is List ? value as List : const [])) '$v']..sort();
        return _Labelled(
          label: label,
          missing: missing,
          child: TimeListEditor(
            fieldKey: k,
            times: times,
            enabled: enabled,
            onChanged: _set,
          ),
        );
      case FieldKind.geo:
        return _GeoInput(fieldKey: k, label: label, value: value is Map ? value as Map : const {}, enabled: enabled, missing: missing, onChanged: _set);
      case FieldKind.gallery:
        return _Labelled(
          label: label,
          missing: missing,
          child: GalleryField(
            fieldKey: k,
            images: [for (final v in (value is List ? value as List : const [])) '$v'],
            max: field.max?.toInt() ?? 20,
            enabled: enabled,
            uploader: uploader,
            onChanged: _set,
          ),
        );
      case FieldKind.supplier:
        return _Labelled(
          label: label,
          missing: missing,
          child: SupplierTile(
            key: Key('cat.$k'),
            supplierId: value?.toString(),
            supplierName: values[supplierNameKey]?.toString(),
            enabled: enabled,
            onPick: () async {
              final pick = await (pickSupplier ?? showSupplierPicker)(context);
              if (pick == null) return;
              onChanged(supplierNameKey, pick.name);
              _set(pick.id);
            },
          ),
        );
      case FieldKind.dayPlan:
        return _Labelled(
          label: label,
          missing: missing,
          child: DayPlanEditor(
            fieldKey: k,
            days: DayPlanEditor.parse(value),
            enabled: enabled,
            onChanged: (days) => _set([for (var i = 0; i < days.length; i++) days[i].toJsonAt(i)]),
          ),
        );
      case FieldKind.json:
        return _JsonInput(fieldKey: Key('cat.$k'), label: label, value: value, enabled: enabled, onChanged: _set);
    }
  }
}

/// Field label above [child], or beside [inline]; warns when [missing].
class _Labelled extends StatelessWidget {
  const _Labelled({required this.label, this.child, this.inline, this.missing = false});

  final String label;
  final Widget? child;
  final Widget? inline;
  final bool missing;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final style = context.type.label.copyWith(color: missing ? t.warning : t.ink2);
    if (inline != null) {
      return Row(children: [Expanded(child: Text(label, style: context.type.body)), inline!]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(child: Text(label, style: style)),
        if (missing) Text(context.l10n.catRequired, style: context.type.caption.copyWith(color: t.warning)),
      ]),
      Gap.h8,
      child!,
    ]);
  }
}

/// A text controller that follows [value] when it changes from outside
/// (reload, 409 merge) but never fights the user's typing.
mixin _SyncedText<W extends StatefulWidget> on State<W> {
  late final TextEditingController ctrl = TextEditingController(text: initialText);
  final focus = FocusNode();

  String get initialText;

  void syncTo(String text) {
    if (!focus.hasFocus && ctrl.text != text) ctrl.text = text;
  }

  @override
  void dispose() {
    ctrl.dispose();
    focus.dispose();
    super.dispose();
  }
}

class _TextInput extends StatefulWidget {
  const _TextInput({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helper,
    this.enabled = true,
    this.maxLength,
    this.missing = false,
  });

  final Key fieldKey;
  final String label;
  final String? helper;
  final String value;
  final bool enabled;
  final int? maxLength;
  final bool missing;
  final ValueChanged<String> onChanged;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> with _SyncedText {
  @override
  String get initialText => widget.value;

  @override
  void didUpdateWidget(_TextInput old) {
    super.didUpdateWidget(old);
    syncTo(widget.value);
  }

  @override
  Widget build(BuildContext context) => DahabTextField(
        fieldKey: widget.fieldKey,
        label: widget.label,
        helper: widget.helper,
        controller: ctrl,
        focusNode: focus,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        errorText: widget.missing && ctrl.text.trim().isEmpty ? context.l10n.catRequired : null,
        onChanged: widget.onChanged,
      );
}

class _NumberInput extends StatefulWidget {
  const _NumberInput({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helper,
    this.money = false,
    this.enabled = true,
    this.missing = false,
  });

  final Key fieldKey;
  final String label;
  final String? helper;
  final num? value;
  final bool money;
  final bool enabled;
  final bool missing;
  final ValueChanged<num?> onChanged;

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

String _fmtNum(num? v) => v == null ? '' : (v == v.roundToDouble() ? '${v.toInt()}' : '$v');

class _NumberInputState extends State<_NumberInput> with _SyncedText {
  @override
  String get initialText => _fmtNum(widget.value);

  @override
  void didUpdateWidget(_NumberInput old) {
    super.didUpdateWidget(old);
    if (num.tryParse(ctrl.text) != widget.value) syncTo(_fmtNum(widget.value));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return DahabTextField(
      fieldKey: widget.fieldKey,
      label: widget.label,
      helper: widget.helper,
      controller: ctrl,
      focusNode: focus,
      enabled: widget.enabled,
      mono: true,
      textDirection: TextDirection.ltr,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      errorText: widget.missing && ctrl.text.isEmpty ? context.l10n.catRequired : null,
      suffix: widget.money
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.md),
              child: Center(
                  widthFactor: 1,
                  child: Text('EGP', style: context.type.monoMd.copyWith(color: t.ink3))),
            )
          : null,
      onChanged: (s) => widget.onChanged(s.trim().isEmpty ? null : num.tryParse(s)),
    );
  }
}

class _DurationInput extends StatelessWidget {
  const _DurationInput({
    required this.fieldKey,
    required this.label,
    required this.minutes,
    required this.onChanged,
    this.enabled = true,
    this.missing = false,
  });

  final String fieldKey;
  final String label;
  final int? minutes;
  final bool enabled;
  final bool missing;
  final ValueChanged<int?> onChanged;

  static const presets = [30, 60, 90, 120, 180, 240, 480];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String fmt(int m) => m < 60 ? l.catMinutesShort(m) : (m % 60 == 0 ? l.catHoursShort(m ~/ 60) : '${l.catHoursShort(m ~/ 60)} ${l.catMinutesShort(m % 60)}');
    return _Labelled(
      label: label,
      missing: missing,
      child: Wrap(spacing: Space.sm, runSpacing: Space.sm, crossAxisAlignment: WrapCrossAlignment.center, children: [
        for (final p in presets)
          DgChip(
            key: Key('cat.$fieldKey.$p'),
            label: fmt(p),
            selected: minutes == p,
            onTap: enabled ? () => onChanged(minutes == p ? null : p) : null,
          ),
        if (minutes != null && !presets.contains(minutes)) DgChip(label: fmt(minutes!), selected: true, onTap: null),
        IconButton(
          key: Key('cat.$fieldKey.custom'),
          tooltip: l.catCustom,
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: !enabled
              ? null
              : () async {
                  final v = await showNumberSheet(context, title: label, initial: minutes, suffix: l.catMinutesUnit);
                  if (v != null) onChanged(v.toInt());
                },
        ),
      ]),
    );
  }
}

class _SelectInput extends StatelessWidget {
  const _SelectInput({
    required this.fieldKey,
    required this.label,
    required this.field,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.missing = false,
  });

  final String fieldKey;
  final String label;
  final CatalogField field;
  final String? value;
  final bool enabled;
  final bool missing;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final arabic = context.type.isArabic;
    String text(CatalogOption o) => o.label.of(arabic).isEmpty ? o.value : o.label.of(arabic);
    if (field.options.length <= 6) {
      return _Labelled(
        label: label,
        missing: missing,
        child: Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
          for (final o in field.options)
            DgChip(
              key: Key('cat.$fieldKey.${o.value}'),
              label: text(o),
              selected: value == o.value,
              onTap: enabled ? () => onChanged(o.value) : null,
            ),
        ]),
      );
    }
    return _Labelled(
      label: label,
      missing: missing,
      child: DropdownButtonFormField<String>(
        key: Key('cat.$fieldKey'),
        initialValue: field.options.any((o) => o.value == value) ? value : null,
        isExpanded: true,
        items: [for (final o in field.options) DropdownMenuItem(value: o.value, child: Text(text(o)))],
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

class _TagsInput extends StatefulWidget {
  const _TagsInput({
    required this.fieldKey,
    required this.label,
    required this.tags,
    required this.suggestions,
    required this.onChanged,
    this.enabled = true,
    this.missing = false,
  });

  final String fieldKey;
  final String label;
  final List<String> tags;
  final List<String> suggestions;
  final bool enabled;
  final bool missing;
  final ValueChanged<List<String>> onChanged;

  @override
  State<_TagsInput> createState() => _TagsInputState();
}

class _TagsInputState extends State<_TagsInput> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final tags = [...widget.tags];
    for (final part in raw.split(',')) {
      final v = part.trim();
      if (v.isNotEmpty && !tags.contains(v)) tags.add(v);
    }
    _ctrl.clear();
    if (tags.length != widget.tags.length) widget.onChanged(tags);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final rest = widget.suggestions.where((s) => !widget.tags.contains(s)).toList();
    return _Labelled(
      label: widget.label,
      missing: widget.missing,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (widget.tags.isNotEmpty)
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final tag in widget.tags)
              InputChip(
                key: Key('cat.${widget.fieldKey}.tag.$tag'),
                label: Text(tag),
                onDeleted: widget.enabled ? () => widget.onChanged([...widget.tags.where((e) => e != tag)]) : null,
              ),
          ]),
        if (widget.enabled) ...[
          Gap.h8,
          TextField(
            key: Key('cat.${widget.fieldKey}.input'),
            controller: _ctrl,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: l.catAddTag,
              suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: () => _add(_ctrl.text)),
            ),
            onSubmitted: _add,
          ),
          if (rest.isNotEmpty) ...[
            Gap.h8,
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              for (final s in rest)
                ActionChip(
                  key: Key('cat.${widget.fieldKey}.suggest.$s'),
                  avatar: Icon(Icons.add, size: 16, color: t.ink3),
                  label: Text(s),
                  onPressed: () => widget.onChanged([...widget.tags, s]),
                ),
            ]),
          ],
        ],
      ]),
    );
  }
}

String? _hhmm(TimeOfDay? t) =>
    t == null ? null : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

TimeOfDay? parseHhmm(String? v) {
  final m = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(v ?? '');
  if (m == null) return null;
  return TimeOfDay(hour: int.parse(m[1]!) % 24, minute: int.parse(m[2]!) % 60);
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({super.key, required this.value, required this.onPicked, this.enabled = true});

  final String? value;
  final bool enabled;
  final ValueChanged<String?> onPicked;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(alignment: AlignmentDirectional.centerStart, minimumSize: const Size.fromHeight(48)),
      icon: const Icon(Icons.schedule, size: 18),
      label: Text(value == null || value!.isEmpty ? '--:--' : value!,
          textDirection: TextDirection.ltr, style: context.type.monoMd.copyWith(color: t.ink, fontSize: 15)),
      onPressed: !enabled
          ? null
          : () async {
              final picked = await showTimePicker(
                  context: context, initialTime: parseHhmm(value) ?? const TimeOfDay(hour: 9, minute: 0));
              if (picked != null) onPicked(_hhmm(picked));
            },
    );
  }
}

/// Times as chips (sorted, deduped) with an add chip. Shared with the
/// slots range sheet.
class TimeListEditor extends StatelessWidget {
  const TimeListEditor({super.key, required this.fieldKey, required this.times, required this.onChanged, this.enabled = true});

  final String fieldKey;
  final List<String> times;
  final bool enabled;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
      for (final time in times)
        InputChip(
          key: Key('cat.$fieldKey.time.$time'),
          label: Text(time, textDirection: TextDirection.ltr, style: context.type.monoMd),
          onDeleted: enabled ? () => onChanged([...times.where((e) => e != time)]) : null,
        ),
      if (enabled)
        ActionChip(
          key: Key('cat.$fieldKey.addTime'),
          avatar: const Icon(Icons.add, size: 16),
          label: Text(l.catAddTime),
          onPressed: () async {
            final last = times.isEmpty ? null : parseHhmm(times.last);
            final picked = await showTimePicker(
              context: context,
              initialTime: last == null ? const TimeOfDay(hour: 9, minute: 0) : TimeOfDay(hour: (last.hour + 1) % 24, minute: last.minute),
            );
            final v = _hhmm(picked);
            if (v != null && !times.contains(v)) onChanged([...times, v]..sort());
          },
        ),
    ]);
  }
}

class _GeoInput extends StatefulWidget {
  const _GeoInput({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.missing = false,
  });

  final String fieldKey;
  final String label;
  final Map value;
  final bool enabled;
  final bool missing;
  final ValueChanged<Map<String, num>?> onChanged;

  @override
  State<_GeoInput> createState() => _GeoInputState();
}

class _GeoInputState extends State<_GeoInput> {
  late final _lat = TextEditingController(text: _fmtNum(widget.value['lat'] as num?));
  late final _lng = TextEditingController(text: _fmtNum(widget.value['lng'] as num?));

  @override
  void dispose() {
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  void _emit() {
    final lat = num.tryParse(_lat.text), lng = num.tryParse(_lng.text);
    widget.onChanged(lat == null || lng == null ? null : {'lat': lat, 'lng': lng});
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final fmt = [FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]'))];
    const kb = TextInputType.numberWithOptions(decimal: true, signed: true);
    return _Labelled(
      label: widget.label,
      missing: widget.missing,
      child: Row(children: [
        Expanded(
          child: DahabTextField(
              fieldKey: Key('cat.${widget.fieldKey}.lat'), hint: l.catLat, controller: _lat, mono: true,
              textDirection: TextDirection.ltr, keyboardType: kb, inputFormatters: fmt, enabled: widget.enabled,
              onChanged: (_) => _emit()),
        ),
        Gap.w8,
        Expanded(
          child: DahabTextField(
              fieldKey: Key('cat.${widget.fieldKey}.lng'), hint: l.catLng, controller: _lng, mono: true,
              textDirection: TextDirection.ltr, keyboardType: kb, inputFormatters: fmt, enabled: widget.enabled,
              onChanged: (_) => _emit()),
        ),
      ]),
    );
  }
}

class _JsonInput extends StatefulWidget {
  const _JsonInput({required this.fieldKey, required this.label, required this.value, required this.onChanged, this.enabled = true});

  final Key fieldKey;
  final String label;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;

  @override
  State<_JsonInput> createState() => _JsonInputState();
}

class _JsonInputState extends State<_JsonInput> {
  late final _ctrl = TextEditingController(
      text: widget.value == null ? '' : const JsonEncoder.withIndent('  ').convert(widget.value));
  bool _invalid = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DahabTextField(
        fieldKey: widget.fieldKey,
        label: widget.label,
        controller: _ctrl,
        mono: true,
        maxLines: 8,
        minLines: 3,
        enabled: widget.enabled,
        textDirection: TextDirection.ltr,
        errorText: _invalid ? context.l10n.catInvalidJson : null,
        onChanged: (s) {
          if (s.trim().isEmpty) {
            setState(() => _invalid = false);
            widget.onChanged(null);
            return;
          }
          try {
            final v = jsonDecode(s);
            setState(() => _invalid = false);
            widget.onChanged(v);
          } on FormatException {
            setState(() => _invalid = true);
          }
        },
      );
}

/// Single number in a bottom sheet (custom duration, quick price edit).
Future<num?> showNumberSheet(BuildContext context, {required String title, num? initial, String? suffix, String? body}) {
  return showModalBottomSheet<num>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheet) => _NumberSheet(title: title, initial: initial, suffix: suffix, body: body),
  );
}

class _NumberSheet extends StatefulWidget {
  const _NumberSheet({required this.title, this.initial, this.suffix, this.body});

  final String title;
  final num? initial;
  final String? suffix;
  final String? body;

  @override
  State<_NumberSheet> createState() => _NumberSheetState();
}

class _NumberSheetState extends State<_NumberSheet> {
  late final _ctrl = TextEditingController(text: _fmtNum(widget.initial));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _done() {
    final v = num.tryParse(_ctrl.text.trim());
    if (v != null) Navigator.of(context).pop(v);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xl),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.title, style: context.type.heading),
          if (widget.body != null) ...[Gap.h4, Text(widget.body!, style: context.type.bodySm.copyWith(color: t.ink2))],
          Gap.h16,
          DahabTextField(
            fieldKey: const Key('cat.numberSheet'),
            controller: _ctrl,
            autofocus: true,
            mono: true,
            textDirection: TextDirection.ltr,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            suffix: widget.suffix == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.md),
                    child: Center(widthFactor: 1, child: Text(widget.suffix!, style: context.type.monoMd.copyWith(color: t.ink3))),
                  ),
            onSubmitted: (_) => _done(),
          ),
          Gap.h16,
          FilledButton(key: const Key('cat.numberSheet.done'), onPressed: _done, child: Text(l.apply)),
        ]),
      ),
    );
  }
}
