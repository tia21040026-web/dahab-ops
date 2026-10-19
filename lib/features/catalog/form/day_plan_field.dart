import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../data/catalog_models.dart';
import 'i18n_field.dart';

/// One package day (`{ day, title: {en, ar}, body: {en, ar}, ...rest }`).
class PlanDay {
  const PlanDay({this.title = const I18n(), this.body = const I18n(), this.extra = const {}, required this.uid});

  factory PlanDay.from(Map j, int uid) => PlanDay(
        uid: uid,
        title: I18n.from(j['title']),
        body: I18n.from(j['body'] ?? j['description']),
        extra: {
          for (final e in j.entries)
            if (!const {'day', 'title', 'body', 'description'}.contains(e.key)) '${e.key}': e.value,
        },
      );

  /// Stable widget identity across reorders (not sent).
  final int uid;
  final I18n title;
  final I18n body;
  final Map<String, Object?> extra;

  PlanDay copyWith({I18n? title, I18n? body}) =>
      PlanDay(uid: uid, title: title ?? this.title, body: body ?? this.body, extra: extra);

  Map<String, Object?> toJsonAt(int index) => {...extra, 'day': index + 1, 'title': title.toJson(), 'body': body.toJson()};

  Map<String, Object?> toJson() => {...extra, 'title': title.toJson(), 'body': body.toJson()};
}

/// Package itinerary: one card per day, long-press the handle to reorder.
class DayPlanEditor extends StatefulWidget {
  const DayPlanEditor({super.key, required this.fieldKey, required this.days, required this.onChanged, this.enabled = true});

  final String fieldKey;
  final List<PlanDay> days;
  final bool enabled;

  /// Days in order; `day` numbers are reassigned on save.
  final ValueChanged<List<PlanDay>> onChanged;

  static List<PlanDay> parse(Object? v) {
    final list = v is List ? v.whereType<Map>().toList() : <Map>[];
    list.sort((a, b) => ((a['day'] as num?) ?? 0).compareTo((b['day'] as num?) ?? 0));
    return [for (var i = 0; i < list.length; i++) PlanDay.from(list[i], i)];
  }

  @override
  State<DayPlanEditor> createState() => _DayPlanEditorState();
}

class _DayPlanEditorState extends State<DayPlanEditor> {
  late List<PlanDay> _days = widget.days;
  late int _next = widget.days.length;

  @override
  void didUpdateWidget(DayPlanEditor old) {
    super.didUpdateWidget(old);
    if (widget.days.length != _days.length) _days = widget.days;
  }

  void _emit(List<PlanDay> days) {
    setState(() => _days = days);
    // Day numbers follow the order.
    widget.onChanged(days);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: _days.length,
        onReorderItem: (from, to) {
          if (!widget.enabled) return;
          final next = [..._days];
          next.insert(to, next.removeAt(from));
          HapticFeedback.selectionClick();
          _emit(next);
        },
        itemBuilder: (context, i) {
          final d = _days[i];
          return Container(
            key: ValueKey('day.${d.uid}'),
            margin: const EdgeInsets.only(bottom: Space.sm),
            padding: const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: Radii.mdAll,
              border: Border.all(color: t.line, width: t.hairline),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                ReorderableDelayedDragStartListener(
                  index: i,
                  enabled: widget.enabled,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.drag_indicator, color: t.ink3),
                  ),
                ),
                Gap.w4,
                Expanded(child: Text(l.catDay(i + 1), style: context.type.bodyStrong)),
                if (widget.enabled)
                  IconButton(
                    key: Key('cat.${widget.fieldKey}.remove.$i'),
                    tooltip: l.remove,
                    icon: Icon(Icons.delete_outline, color: t.ink3),
                    onPressed: () => _emit([..._days]..removeAt(i)),
                  ),
              ]),
              Gap.h8,
              I18nField(
                fieldKey: '${widget.fieldKey}.$i.title',
                label: l.catDayTitle,
                value: d.title,
                enabled: widget.enabled,
                onChanged: (v) => _emit([..._days]..[i] = d.copyWith(title: v)),
              ),
              Gap.h12,
              I18nField(
                fieldKey: '${widget.fieldKey}.$i.body',
                label: l.catDayBody,
                value: d.body,
                multiline: true,
                enabled: widget.enabled,
                onChanged: (v) => _emit([..._days]..[i] = d.copyWith(body: v)),
              ),
            ]),
          );
        },
      ),
      if (widget.enabled)
        OutlinedButton.icon(
          key: Key('cat.${widget.fieldKey}.addDay'),
          icon: const Icon(Icons.add),
          label: Text(l.catAddDay),
          onPressed: () => _emit([..._days, PlanDay(uid: _next++)]),
        ),
    ]);
  }
}
