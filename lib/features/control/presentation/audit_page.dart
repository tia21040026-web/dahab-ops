import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/admin_models.dart';
import '../../../core/api/models/paged.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/timeline.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../data/control_repository.dart';

/// Audit timeline with filters (actor, action, entity, date range) and a
/// before/after diff per event. [ops] reads `/api/operations/audit-events`
/// instead of `/api/admin/audit`.
@RoutePage()
class AuditPage extends StatelessWidget {
  const AuditPage({super.key, this.ops = false, this.entityType, this.entityId});

  final bool ops;
  final String? entityType;
  final String? entityId;

  static AuditFilter filterOf(ListQuery q) {
    String? s(String k) => q.filters[k] as String?;
    DateTime? d(String k) => q.filters[k] is String ? DateTime.tryParse(q.filters[k] as String) : null;
    return AuditFilter(
      actor: s('actor'),
      action: s('action'),
      entityType: s('entityType'),
      entityId: s('entityId'),
      from: d('from'),
      to: d('to'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<ControlRepository>();
    return BlocProvider(
      create: (_) => ListCubit<AuditEvent>(
        (q) => ops
            ? repo.opsAudit(cursor: q.cursor, filter: filterOf(q))
            : repo.audit(cursor: q.cursor, filter: filterOf(q)),
        initial: ListQuery(filters: {'entityType': entityType, 'entityId': entityId}),
      )..start(),
      child: _AuditView(ops: ops),
    );
  }
}

class _AuditView extends StatelessWidget {
  const _AuditView({required this.ops});

  final bool ops;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.watch<ListCubit<AuditEvent>>();
    final active = !AuditPage.filterOf(cubit.state.query).isEmpty;
    return SectionScaffold(
      title: ops ? l.auditOps : l.auditTitle,
      permission: ops ? P.opsAudit : P.usersView,
      actions: [
        IconButton(
          tooltip: l.filters,
          icon: Badge(isLabelVisible: active, smallSize: 8, child: const Icon(Icons.filter_list)),
          onPressed: () => _filters(context),
        ),
      ],
      body: AsyncListView<AuditEvent>(
        emptyIcon: Icons.history,
        emptyTitle: l.auditEmpty,
        itemBuilder: (context, e) => _AuditEntry(event: e),
      ),
    );
  }

  Future<void> _filters(BuildContext context) async {
    final cubit = context.read<ListCubit<AuditEvent>>();
    final next = await showModalBottomSheet<Map<String, Object?>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _FilterSheet(initial: cubit.state.query.filters),
    );
    if (next == null) return;
    await cubit.setFilters(next);
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});

  final Map<String, Object?> initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final _actor = TextEditingController(text: '${widget.initial['actor'] ?? ''}');
  late final _action = TextEditingController(text: '${widget.initial['action'] ?? ''}');
  late final _entity = TextEditingController(text: '${widget.initial['entityType'] ?? ''}');
  late DateTimeRange? _range = _initialRange();

  DateTimeRange? _initialRange() {
    final f = DateTime.tryParse('${widget.initial['from']}');
    final t = DateTime.tryParse('${widget.initial['to']}');
    return f != null && t != null ? DateTimeRange(start: f, end: t) : null;
  }

  @override
  void dispose() {
    _actor.dispose();
    _action.dispose();
    _entity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(l.filters, style: context.type.heading),
          Gap.h16,
          DahabTextField(label: l.actor, controller: _actor, hint: 'ops@dahab.travel'),
          Gap.h12,
          DahabTextField(label: l.action, controller: _action, mono: true, hint: 'settings.update'),
          Gap.h12,
          DahabTextField(label: l.entity, controller: _entity, mono: true, hint: 'user'),
          Gap.h12,
          OutlinedButton.icon(
            icon: const Icon(Icons.date_range),
            label: Text(_range == null
                ? l.dateRange
                : '${Fmt.date(context, _range!.start)} – ${Fmt.date(context, _range!.end)}'),
            onPressed: () async {
              final now = DateTime.now();
              final r = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 2),
                lastDate: now,
                initialDateRange: _range,
              );
              if (r != null) setState(() => _range = r);
            },
          ),
          Gap.h24,
          Row(children: [
            Expanded(
              child: DahabButton.secondary(
                label: l.reset,
                onPressed: () => Navigator.of(context).pop(<String, Object?>{
                  'actor': null,
                  'action': null,
                  'entityType': null,
                  'entityId': null,
                  'from': null,
                  'to': null,
                }),
              ),
            ),
            Gap.w12,
            Expanded(
              child: DahabButton(
                label: l.filterApply,
                onPressed: () => Navigator.of(context).pop(<String, Object?>{
                  'actor': _actor.text.trim(),
                  'action': _action.text.trim(),
                  'entityType': _entity.text.trim(),
                  'from': _range?.start.toIso8601String(),
                  'to': _range?.end.add(const Duration(days: 1)).toIso8601String(),
                }),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _AuditEntry extends StatefulWidget {
  const _AuditEntry({required this.event});

  final AuditEvent event;

  @override
  State<_AuditEntry> createState() => _AuditEntryState();
}

class _AuditEntryState extends State<_AuditEntry> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final hasDiff = e.before != null || e.after != null;
    final bad = e.action.contains('deny') || e.action.contains('fail') || e.action.contains('reject');
    return Timeline(
      padding: const EdgeInsetsDirectional.fromSTEB(Space.gutter, 0, Space.gutter, 0),
      entries: [
        TimelineEntry(
          title: e.action,
          subtitle: [
            if (e.actor != null) '${e.actor}${e.actorRole == null ? '' : ' (${e.actorRole})'}',
            if (e.entityType != null) '${e.entityType}${e.entityId == null ? '' : ' ${Fmt.shortId(e.entityId!)}'}',
            if (e.reason != null) '“${e.reason}”',
          ].join(' · '),
          when: Fmt.ago(context, e.timestamp),
          state: bad ? TimelineState.bad : TimelineState.done,
          onTap: hasDiff ? () => setState(() => _open = !_open) : null,
          detail: !hasDiff
              ? null
              : _open
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      AuditDiff(before: e.before, after: e.after),
                      if (e.correlationId != null) ...[Gap.h8, CorrelationChip(id: e.correlationId!)],
                    ])
                  : Text(context.l10n.showChanges,
                      style: context.type.caption.copyWith(color: context.dg.action)),
        ),
      ],
    );
  }
}

/// Field-level before/after. Unchanged keys are skipped; removed values are
/// struck through in critical, new values sit on a positive wash.
class AuditDiff extends StatelessWidget {
  const AuditDiff({super.key, this.before, this.after});

  final Object? before;
  final Object? after;

  static Map<String, Object?> _flat(Object? v) {
    if (v is Map) return v.map((k, v) => MapEntry('$k', v));
    if (v == null) return const {};
    return {'value': v};
  }

  static String _s(Object? v) => v == null ? '∅' : (v is String ? v : jsonEncode(v));

  /// Keys whose value differs, in a stable order.
  static List<String> changedKeys(Object? before, Object? after) {
    final b = _flat(before);
    final a = _flat(after);
    final keys = {...b.keys, ...a.keys}.toList()..sort();
    return keys.where((k) => _s(b[k]) != _s(a[k])).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final b = _flat(before);
    final a = _flat(after);
    final keys = changedKeys(before, after);
    if (keys.isEmpty) {
      return Text(l.noChanges, style: context.type.caption.copyWith(color: t.ink3));
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: t.line, width: t.hairline),
        borderRadius: Radii.smAll,
      ),
      child: Column(children: [
        for (final k in keys)
          Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              MonoText(k, size: 12, color: t.ink3),
              Gap.h4,
              if (b.containsKey(k))
                Container(
                  width: double.infinity,
                  color: t.criticalWash,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    '− ${_s(b[k])}',
                    textDirection: TextDirection.ltr,
                    style: context.type.monoSm.copyWith(
                      color: t.critical,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              if (a.containsKey(k))
                Container(
                  width: double.infinity,
                  color: t.positiveWash,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    '+ ${_s(a[k])}',
                    textDirection: TextDirection.ltr,
                    style: context.type.monoSm.copyWith(color: t.positive),
                  ),
                ),
            ]),
          ),
      ]),
    );
  }
}
