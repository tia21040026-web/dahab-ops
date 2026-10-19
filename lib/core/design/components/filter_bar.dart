import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import '../spacing.dart';

/// One chip in a [FilterBar]. A null [value] means "all".
class FilterOption<T> {
  const FilterOption(this.value, this.label, {this.count});

  final T? value;
  final String label;
  final int? count;
}

/// Horizontal single-select chips, with an optional sort button at the end.
class FilterBar<T> extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.onSort,
    this.sortLabel,
  });

  final List<FilterOption<T>> options;
  final T? selected;
  final ValueChanged<T?> onSelected;
  final VoidCallback? onSort;
  final String? sortLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
      height: 52,
      child: Row(children: [
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
            itemCount: options.length,
            separatorBuilder: (_, __) => Gap.w8,
            itemBuilder: (context, i) {
              final o = options[i];
              final isSel = o.value == selected;
              return ChoiceChip(
                label: Text(o.count == null ? o.label : '${o.label}  ${o.count}'),
                selected: isSel,
                onSelected: (_) => onSelected(o.value),
              );
            },
          ),
        ),
        if (onSort != null)
          IconButton(
            tooltip: sortLabel ?? context.l10n.sort,
            icon: const Icon(Icons.swap_vert),
            onPressed: onSort,
          ),
      ]),
    );
  }
}

/// A sortable field: `field` ascending, `-field` descending on the wire.
class SortOption {
  const SortOption(this.field, this.label);

  final String field;
  final String label;
}

/// Bottom sheet picking a sort field and direction. Returns the wire value
/// (`field` or `-field`), or null when dismissed.
Future<String?> showSortSheet(
  BuildContext context, {
  required List<SortOption> options,
  String? current,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    builder: (context) => SortSheet(options: options, current: current),
  );
}

class SortSheet extends StatefulWidget {
  const SortSheet({super.key, required this.options, this.current});

  final List<SortOption> options;
  final String? current;

  @override
  State<SortSheet> createState() => _SortSheetState();
}

class _SortSheetState extends State<SortSheet> {
  late String _field;
  late bool _desc;

  @override
  void initState() {
    super.initState();
    final c = widget.current;
    _desc = c?.startsWith('-') ?? true;
    final f = c == null ? null : (c.startsWith('-') ? c.substring(1) : c);
    _field = f ?? widget.options.first.field;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final type = context.type;
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.sm),
          child: Text(l.sortBy, style: type.title),
        ),
        RadioGroup<String>(
          groupValue: _field,
          onChanged: (v) => setState(() => _field = v ?? _field),
          child: Column(children: [
            for (final o in widget.options)
              RadioListTile<String>(value: o.field, title: Text(o.label)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.sm),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(l.descending)),
              ButtonSegment(value: false, label: Text(l.ascending)),
            ],
            selected: {_desc},
            onSelectionChanged: (s) => setState(() => _desc = s.first),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.lg),
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(_desc ? '-$_field' : _field),
            child: Text(l.apply),
          ),
        ),
      ]),
    );
  }
}
