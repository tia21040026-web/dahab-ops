import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';

DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Contract weekday (0 = Sunday … 6 = Saturday, as JS `getDay`).
int contractWeekday(DateTime d) => d.weekday % 7;

/// Month grid. Tap picks one day; long-press then drag extends a range.
/// [onRange] fires once when the finger lifts, with `from <= to`.
class RangeCalendar extends StatefulWidget {
  const RangeCalendar({
    super.key,
    required this.month,
    required this.onRange,
    this.cellBuilder,
    this.rowHeight = 58,
    this.firstWeekday,
  });

  /// Any day in the month shown.
  final DateTime month;
  final void Function(DateTime from, DateTime to) onRange;

  /// Content under the day number (price, slot count…).
  final Widget? Function(BuildContext context, DateTime day)? cellBuilder;
  final double rowHeight;

  /// 0 = Sunday. Defaults to the locale's first day.
  final int? firstWeekday;

  @override
  State<RangeCalendar> createState() => RangeCalendarState();
}

class RangeCalendarState extends State<RangeCalendar> {
  DateTime? _anchor;
  DateTime? _end;

  DateTime get _first => DateTime(widget.month.year, widget.month.month, 1);
  int get _days => DateUtils.getDaysInMonth(widget.month.year, widget.month.month);

  int _startOffset(int firstWeekday) => (contractWeekday(_first) - firstWeekday + 7) % 7;

  /// Day under [local] in a grid of [width], or null for the blank cells.
  DateTime? dayAt(Offset local, double width, int firstWeekday, bool rtl) {
    final cell = width / 7;
    var col = (local.dx / cell).floor().clamp(0, 6);
    if (rtl) col = 6 - col;
    final row = (local.dy / widget.rowHeight).floor();
    if (row < 0) return null;
    final index = row * 7 + col - _startOffset(firstWeekday);
    if (index < 0 || index >= _days) return null;
    return DateTime(_first.year, _first.month, index + 1);
  }

  bool _selected(DateTime d) {
    if (_anchor == null) return false;
    final e = _end ?? _anchor!;
    final a = _anchor!.isBefore(e) ? _anchor! : e;
    final b = _anchor!.isBefore(e) ? e : _anchor!;
    return !d.isBefore(a) && !d.isAfter(b);
  }

  void _finish() {
    if (_anchor == null) return;
    final e = _end ?? _anchor!;
    final from = _anchor!.isBefore(e) ? _anchor! : e;
    final to = _anchor!.isBefore(e) ? e : _anchor!;
    widget.onRange(from, to);
    setState(() {
      _anchor = null;
      _end = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final rtl = context.isRtl;
    final ml = MaterialLocalizations.of(context);
    final firstWeekday = widget.firstWeekday ?? ml.firstDayOfWeekIndex;
    final offset = _startOffset(firstWeekday);
    final rows = ((offset + _days) / 7).ceil();
    final today = dayOnly(DateTime.now());
    final narrow = ml.narrowWeekdays; // index 0 = Sunday

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        for (var c = 0; c < 7; c++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Text(narrow[(firstWeekday + c) % 7],
                  textAlign: TextAlign.center, style: type.caption.copyWith(color: t.ink3)),
            ),
          ),
      ]),
      LayoutBuilder(builder: (context, box) {
        final width = box.maxWidth;
        return GestureDetector(
          key: const Key('cat.calendar.grid'),
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) {
            final day = dayAt(d.localPosition, width, firstWeekday, rtl);
            if (day == null) return;
            setState(() => _anchor = _end = day);
            _finish();
          },
          onLongPressStart: (d) {
            final day = dayAt(d.localPosition, width, firstWeekday, rtl);
            if (day == null) return;
            HapticFeedback.mediumImpact();
            setState(() => _anchor = _end = day);
          },
          onLongPressMoveUpdate: (d) {
            if (_anchor == null) return;
            final day = dayAt(d.localPosition, width, firstWeekday, rtl);
            if (day != null && day != _end) {
              HapticFeedback.selectionClick();
              setState(() => _end = day);
            }
          },
          onLongPressEnd: (_) => _finish(),
          onLongPressCancel: () => setState(() => _anchor = _end = null),
          child: Column(children: [
            for (var r = 0; r < rows; r++)
              SizedBox(
                height: widget.rowHeight,
                child: Row(children: [
                  for (var c = 0; c < 7; c++)
                    Expanded(child: Builder(builder: (context) {
                      final index = r * 7 + c - offset;
                      if (index < 0 || index >= _days) return const SizedBox.shrink();
                      final day = DateTime(_first.year, _first.month, index + 1);
                      final sel = _selected(day);
                      final extra = widget.cellBuilder?.call(context, day);
                      return Container(
                        key: Key('cat.day.${day.day}'),
                        margin: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          color: sel ? t.actionWash : t.surface,
                          borderRadius: Radii.smAll,
                          border: Border.all(
                            color: sel ? t.action : (day == today ? t.lineStrong : t.line),
                            width: sel ? 1.5 : t.hairline,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('${day.day}',
                              style: type.monoMd.copyWith(
                                  color: sel ? t.action : t.ink,
                                  fontWeight: day == today ? FontWeight.w700 : FontWeight.w500)),
                          if (extra != null) extra!,
                        ]),
                      );
                    })),
                ]),
              ),
          ]),
        );
      }),
    ]);
  }
}

/// Month title with previous / next.
class MonthSwitcher extends StatelessWidget {
  const MonthSwitcher({super.key, required this.month, required this.onChanged});

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final ml = MaterialLocalizations.of(context);
    return Row(children: [
      IconButton(
        key: const Key('cat.month.prev'),
        tooltip: ml.previousMonthTooltip,
        icon: const Icon(Icons.chevron_left),
        onPressed: () => onChanged(DateTime(month.year, month.month - 1)),
      ),
      Expanded(child: Text(ml.formatMonthYear(month), textAlign: TextAlign.center, style: context.type.title)),
      IconButton(
        key: const Key('cat.month.next'),
        tooltip: ml.nextMonthTooltip,
        icon: const Icon(Icons.chevron_right),
        onPressed: () => onChanged(DateTime(month.year, month.month + 1)),
      ),
    ]);
  }
}

/// Seven weekday toggles (contract numbering), in the locale's order.
class WeekdayToggles extends StatelessWidget {
  const WeekdayToggles({super.key, required this.selected, required this.onChanged});

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final ml = MaterialLocalizations.of(context);
    final first = ml.firstDayOfWeekIndex;
    final names = ml.narrowWeekdays;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Text(context.l10n.catWeekdays, style: context.type.label.copyWith(color: context.dg.ink2)),
      Gap.h8,
      Row(children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          Expanded(
            child: DgChip(
              key: Key('cat.weekday.${(first + i) % 7}'),
              label: names[(first + i) % 7],
              expand: true,
              selected: selected.contains((first + i) % 7),
              onTap: () {
                final d = (first + i) % 7;
                final next = {...selected};
                next.contains(d) ? next.remove(d) : next.add(d);
                if (next.isNotEmpty) onChanged(next);
              },
            ),
          ),
        ],
      ]),
    ]);
  }
}
