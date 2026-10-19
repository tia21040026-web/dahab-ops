import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_error.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/router/shell_leading.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../calendar/range_calendar.dart';
import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../form/catalog_form_engine.dart';
import '../form/gallery_field.dart';
import 'catalog_common.dart';
import 'catalog_editor_pages.dart';

Scaffold _scaffold(BuildContext context,
        {required String title, required String permission, required Widget body, Widget? fab, List<Widget> actions = const []}) =>
    Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(title),
        actions: actions,
      ),
      floatingActionButton: fab,
      body: PermissionGate(permission: permission, explain: true, child: body),
    );

String _viewPerm(BuildContext context, String type) =>
    CatalogAccess(context.read<SessionCubit>().state, type).viewPermission;

bool _canManage(BuildContext context, String type) => CatalogAccess(context.watch<SessionCubit>().state, type).canManage;

// ── Generic child records (hotel rooms) ───────────────────────────────────

/// Fallback form for a child type the schema does not describe.
const _fallbackChild = CatalogTypeSchema(type: 'child', sections: [
  CatalogSection(key: 'basics', fields: [
    CatalogField(key: 'title', kind: FieldKind.i18nText, required: true, max: 120),
    CatalogField(key: 'summary', kind: FieldKind.i18nTextarea, max: 600),
    CatalogField(key: 'priceFromEGP', kind: FieldKind.money),
    CatalogField(key: 'capacity', kind: FieldKind.number),
    CatalogField(key: 'images', kind: FieldKind.gallery, max: 20),
  ]),
]);

/// Child records of a parent (e.g. hotel rooms), edited in a sheet.
@RoutePage()
class CatalogChildrenPage extends StatefulWidget {
  const CatalogChildrenPage({
    super.key,
    @PathParam('type') required this.type,
    @PathParam('id') required this.id,
    @PathParam('child') required this.child,
    this.itemType,
  });

  final String type;
  final String id;
  final String child;
  final String? itemType;

  @override
  State<CatalogChildrenPage> createState() => _CatalogChildrenPageState();
}

class _CatalogChildrenPageState extends State<CatalogChildrenPage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  late Future<List<CatalogItem>> _rows = _load();
  CatalogTypeSchema _schema = _fallbackChild;

  Future<List<CatalogItem>> _load() async {
    if (widget.itemType != null) {
      final s = await _repo.schemaFor(widget.itemType!).catchError((Object _) => null);
      if (s != null && s.fields.isNotEmpty) _schema = s;
    }
    return _repo.children(widget.type, widget.id, widget.child);
  }

  Future<void> _reload() async {
    final f = _load();
    setState(() => _rows = f);
    await f;
  }

  Future<void> _edit(CatalogItem? item) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionCubit>(),
        child: _ChildSheet(repo: _repo, type: widget.type, parentId: widget.id, child: widget.child, schema: _schema, item: item),
      ),
    );
    if (saved == true && mounted) await _reload();
  }

  Future<void> _delete(CatalogItem item) async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(context,
        title: l.catDeleteTitle(item.title.of(context.type.isArabic)), confirmLabel: l.catDelete, biometric: false);
    if (reason == null || !mounted) return;
    try {
      await _repo.deleteChild(widget.type, widget.id, widget.child, item.id, reason: reason);
      if (mounted) await _reload();
    } catch (e) {
      if (mounted) showErrorToast(context, isConflict(e) ? ApiError(kind: ApiErrorKind.conflict, detail: l.catInUseBody) : e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final arabic = context.type.isArabic;
    final manage = _canManage(context, widget.type);
    return _scaffold(
      context,
      title: widget.child == 'rooms' ? l.catRooms : widget.child,
      permission: _viewPerm(context, widget.type),
      fab: manage
          ? FloatingActionButton.extended(
              key: const Key('cat.child.add'),
              onPressed: () => _edit(null),
              icon: const Icon(Icons.add),
              label: Text(l.add),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<CatalogItem>>(
          future: _rows,
          builder: (context, snap) {
            if (snap.hasError) return ListView(children: [ErrorView(error: snap.error!, onRetry: _reload, compact: true)]);
            if (!snap.hasData) return const SkeletonList(count: 4);
            final rows = snap.data!;
            if (rows.isEmpty) return ListView(children: const [EmptyState(icon: Icons.meeting_room_outlined)]);
            return ListView(padding: const EdgeInsets.only(bottom: Space.x4), children: [
              for (final r in rows)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.xs),
                  leading: CatalogThumb(r.coverImage, size: 48),
                  title: Text(r.title.of(arabic).isEmpty ? l.catUntitled : r.title.of(arabic)),
                  subtitle: r.priceFromEGP == null
                      ? null
                      : Text(l.catFromPrice(Fmt.money(r.priceFromEGP!)), style: context.type.caption.copyWith(color: t.ink2)),
                  trailing: manage
                      ? IconButton(
                          tooltip: l.catDelete,
                          icon: Icon(Icons.delete_outline, color: t.ink3),
                          onPressed: () => _delete(r),
                        )
                      : null,
                  onTap: () => _edit(r),
                ),
            ]);
          },
        ),
      ),
    );
  }
}

class _ChildSheet extends StatefulWidget {
  const _ChildSheet({
    required this.repo,
    required this.type,
    required this.parentId,
    required this.child,
    required this.schema,
    this.item,
  });

  final CatalogRepository repo;
  final String type;
  final String parentId;
  final String child;
  final CatalogTypeSchema schema;
  final CatalogItem? item;

  @override
  State<_ChildSheet> createState() => _ChildSheetState();
}

class _ChildSheetState extends State<_ChildSheet> {
  late Map<String, Object?> _values = widget.item == null
      ? {}
      : {
          for (final f in widget.schema.fields)
            f.key: switch (f.kind) {
              FieldKind.i18nText || FieldKind.i18nTextarea => I18n.from(widget.item!.valueOf(f.key)),
              _ => widget.item!.valueOf(f.key),
            },
        };
  final Set<String> _dirty = {};
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final body = CatalogValues.body(widget.item == null ? _values : {for (final k in _dirty) k: _values[k]});
      if (widget.item == null) {
        await widget.repo.addChild(widget.type, widget.parentId, widget.child, body);
      } else {
        await widget.repo.patchChild(widget.type, widget.parentId, widget.child, widget.item!.id, body);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final missing = widget.schema.missing(_values);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, scroll) => Column(children: [
          Expanded(
            child: PrimaryScrollController(
              controller: scroll,
              child: CatalogFormEngine(
                sections: widget.schema.sections,
                values: _values,
                sectionHeaders: false,
                uploader: catalogUploader(widget.repo),
                showSupplier: false,
                onChanged: (k, v) => setState(() {
                  _values = {..._values, k: v};
                  _dirty.add(k);
                }),
              ),
            ),
          ),
          DgBottomBar(
            child: DahabButton(
              key: const Key('cat.child.save'),
              label: l.save,
              expand: true,
              loading: _saving,
              onPressed: missing.isEmpty && (widget.item == null || _dirty.isNotEmpty) ? _save : null,
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Hotel rates calendar ──────────────────────────────────────────────────

class RateEdit {
  const RateEdit({this.nightlyEGP, this.closed, required this.weekdays, this.reason});

  final num? nightlyEGP;
  final bool? closed;
  final Set<int> weekdays;
  final String? reason;
}

/// Month grid per room. Long-press and drag a range, then set a price or
/// close the dates; weekday toggles narrow the range.
@RoutePage()
class CatalogRatesPage extends StatefulWidget {
  const CatalogRatesPage({super.key, @PathParam('id') required this.hotelId});

  final String hotelId;

  @override
  State<CatalogRatesPage> createState() => _CatalogRatesPageState();
}

class _CatalogRatesPageState extends State<CatalogRatesPage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  List<CatalogItem>? _rooms;
  String? _roomId;
  Map<DateTime, RateNight> _nights = {};
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rooms = await _repo.children('hotel', widget.hotelId, 'rooms');
      if (!mounted) return;
      setState(() {
        _rooms = rooms;
        _roomId ??= rooms.isEmpty ? null : rooms.first.id;
      });
      await _loadMonth();
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMonth() async {
    if (_roomId == null) return;
    final from = DateTime(_month.year, _month.month, 1);
    final to = DateTime(_month.year, _month.month + 1, 0);
    try {
      final nights = await _repo.rates(widget.hotelId, roomId: _roomId, from: from, to: to);
      if (!mounted) return;
      setState(() => _nights = {
            for (final n in nights)
              if (n.roomId == null || n.roomId == _roomId) dayOnly(n.date): n,
          });
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  Future<void> _onRange(DateTime from, DateTime to) async {
    if (_roomId == null || !_canManage(context, 'hotel')) return;
    final inRange = [
      for (final e in _nights.entries)
        if (!e.key.isBefore(from) && !e.key.isAfter(to) && e.value.nightlyEGP != null) e.value.nightlyEGP!,
    ];
    final current = inRange.isEmpty ? null : inRange.reduce((a, b) => a + b) / inRange.length;
    final edit = await showModalBottomSheet<RateEdit>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => RateRangeSheet(from: from, to: to, current: current),
    );
    if (edit == null || !mounted) return;
    try {
      await _repo.setRates(widget.hotelId,
          roomId: _roomId!,
          from: from,
          to: to,
          nightlyEGP: edit.nightlyEGP,
          closed: edit.closed,
          weekdays: edit.weekdays.toList()..sort(),
          reason: edit.reason);
      if (!mounted) return;
      showToast(context, context.l10n.saved, tone: Tone.positive);
      await _loadMonth();
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final arabic = context.type.isArabic;
    return _scaffold(
      context,
      title: l.catRates,
      permission: _viewPerm(context, 'hotel'),
      body: _loading
          ? const SkeletonList(count: 5)
          : _error != null
              ? ErrorView(error: _error!, onRetry: _loadRooms)
              : (_rooms ?? const []).isEmpty
                  ? EmptyState(icon: Icons.meeting_room_outlined, title: l.catNoRooms)
                  : ListView(padding: const EdgeInsets.only(bottom: Space.x2), children: [
                      DgChipRow(
                        padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, Space.sm),
                        children: [
                          for (final r in _rooms!)
                            DgChip(
                              key: Key('cat.room.${r.id}'),
                              label: r.title.of(arabic).isEmpty ? r.id : r.title.of(arabic),
                              selected: r.id == _roomId,
                              onTap: () {
                                setState(() {
                                  _roomId = r.id;
                                  _nights = {};
                                });
                                _loadMonth();
                              },
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Space.sm),
                        child: MonthSwitcher(
                          month: _month,
                          onChanged: (m) {
                            setState(() {
                              _month = m;
                              _nights = {};
                            });
                            _loadMonth();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Space.md),
                        child: RangeCalendar(
                          month: _month,
                          onRange: _onRange,
                          cellBuilder: (context, day) {
                            final n = _nights[day];
                            if (n == null) return null;
                            if (n.closed) {
                              return Text(l.catClosedShort,
                                  style: context.type.caption.copyWith(color: t.critical, fontSize: 11));
                            }
                            if (n.nightlyEGP == null) return null;
                            return Text(Fmt.compact(n.nightlyEGP!),
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                                style: context.type.monoSm.copyWith(color: t.ink2, fontSize: 11));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Space.gutter),
                        child: Text(l.catRangeHint, style: context.type.caption.copyWith(color: t.ink3)),
                      ),
                    ]),
    );
  }
}

String _rangeLabel(BuildContext context, DateTime from, DateTime to) {
  final ml = MaterialLocalizations.of(context);
  return from == to ? ml.formatMediumDate(from) : '${ml.formatShortDate(from)} – ${ml.formatShortDate(to)}';
}

/// Price / close for a range, with weekday toggles.
class RateRangeSheet extends StatefulWidget {
  const RateRangeSheet({super.key, required this.from, required this.to, this.current});

  final DateTime from;
  final DateTime to;
  final num? current;

  @override
  State<RateRangeSheet> createState() => _RateRangeSheetState();
}

class _RateRangeSheetState extends State<RateRangeSheet> {
  late final _price = TextEditingController(text: widget.current == null ? '' : '${widget.current!.round()}');
  final _reason = TextEditingController();
  bool _closed = false;
  Set<int> _weekdays = {0, 1, 2, 3, 4, 5, 6};

  @override
  void dispose() {
    _price.dispose();
    _reason.dispose();
    super.dispose();
  }

  num? get _value => num.tryParse(_price.text.trim());
  bool get _needsReason => _value != null && needsPriceReason(widget.current, _value!);

  bool get _valid =>
      (_closed || _value != null) && (!_needsReason || ConfirmDangerSheet.validReason(_reason.text));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final days = widget.to.difference(widget.from).inDays + 1;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xl),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(_rangeLabel(context, widget.from, widget.to), style: context.type.heading),
          Text(l.catNights(days), style: context.type.bodySm.copyWith(color: t.ink2)),
          Gap.h16,
          Row(children: [
            Expanded(child: Text(l.catCloseDates, style: context.type.body)),
            DgSwitch(key: const Key('cat.rate.closed'), value: _closed, kill: true, onChanged: (v) => setState(() => _closed = v)),
          ]),
          if (!_closed) ...[
            Gap.h12,
            DahabTextField(
              fieldKey: const Key('cat.rate.price'),
              label: l.catNightlyPrice,
              controller: _price,
              autofocus: true,
              mono: true,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              suffix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                child: Center(widthFactor: 1, child: Text('EGP', style: context.type.monoMd.copyWith(color: t.ink3))),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          if (days > 1) ...[
            Gap.h16,
            WeekdayToggles(selected: _weekdays, onChanged: (v) => setState(() => _weekdays = v)),
          ],
          if (_needsReason && !_closed) ...[
            Gap.h16,
            DahabTextField(
              fieldKey: const Key('cat.rate.reason'),
              label: '${l.dangerReasonLabel} *',
              helper: l.catPriceReasonBody(Fmt.money(widget.current ?? 0), Fmt.money(_value ?? 0)),
              controller: _reason,
              maxLines: 2,
              maxLength: ConfirmDangerSheet.maxReason,
              onChanged: (_) => setState(() {}),
            ),
          ],
          Gap.h16,
          DahabButton(
            key: const Key('cat.rate.apply'),
            label: _closed ? l.catCloseDates : l.apply,
            expand: true,
            onPressed: _valid
                ? () => Navigator.of(context).pop(RateEdit(
                      nightlyEGP: _closed ? null : _value,
                      closed: _closed,
                      weekdays: _weekdays,
                      reason: _needsReason && !_closed ? _reason.text.trim() : null,
                    ))
                : null,
          ),
        ]),
      ),
    );
  }
}

// ── Activity slots ────────────────────────────────────────────────────────

class SlotEdit {
  const SlotEdit({required this.times, this.capacity, required this.weekdays, this.closed = false});

  final List<String> times;
  final int? capacity;
  final Set<int> weekdays;
  final bool closed;
}

/// Activity departures by month; long-press a range to set times and
/// capacity, or close dates.
@RoutePage()
class CatalogSlotsPage extends StatefulWidget {
  const CatalogSlotsPage({super.key, @PathParam('id') required this.activityId});

  final String activityId;

  @override
  State<CatalogSlotsPage> createState() => _CatalogSlotsPageState();
}

class _CatalogSlotsPageState extends State<CatalogSlotsPage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  Map<DateTime, List<SlotRow>> _byDay = {};
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _byDay.isEmpty;
      _error = null;
    });
    try {
      final rows = await _repo.slots(widget.activityId,
          from: DateTime(_month.year, _month.month, 1), to: DateTime(_month.year, _month.month + 1, 0));
      final by = <DateTime, List<SlotRow>>{};
      for (final r in rows) {
        (by[r.date] ??= []).add(r);
      }
      if (mounted) setState(() => _byDay = by);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRange(DateTime from, DateTime to) async {
    if (!_canManage(context, 'activity')) return;
    final sample = _byDay[from] ?? const <SlotRow>[];
    final edit = await showModalBottomSheet<SlotEdit>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SlotRangeSheet(
        from: from,
        to: to,
        times: [for (final s in sample) s.time]..sort(),
        capacity: sample.isEmpty ? null : sample.first.capacity,
      ),
    );
    if (edit == null || !mounted) return;
    try {
      await _repo.setSlots(widget.activityId,
          from: from,
          to: to,
          times: edit.times,
          capacity: edit.capacity,
          weekdays: edit.weekdays.toList()..sort(),
          closed: edit.closed);
      if (!mounted) return;
      showToast(context, context.l10n.saved, tone: Tone.positive);
      await _load();
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return _scaffold(
      context,
      title: l.catSlots,
      permission: _viewPerm(context, 'activity'),
      body: _loading
          ? const SkeletonList(count: 5)
          : _error != null
              ? ErrorView(error: _error!, onRetry: _load)
              : ListView(padding: const EdgeInsets.only(bottom: Space.x2), children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(Space.sm, Space.sm, Space.sm, 0),
                    child: MonthSwitcher(
                      month: _month,
                      onChanged: (m) {
                        setState(() {
                          _month = m;
                          _byDay = {};
                        });
                        _load();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.md),
                    child: RangeCalendar(
                      month: _month,
                      onRange: _onRange,
                      cellBuilder: (context, day) {
                        final rows = _byDay[day];
                        if (rows == null || rows.isEmpty) return null;
                        final open = rows.where((r) => !r.closed).toList();
                        if (open.isEmpty) {
                          return Text(l.catClosedShort, style: context.type.caption.copyWith(color: t.critical, fontSize: 11));
                        }
                        final left = open.fold<int>(0, (a, r) => a + (r.capacity - r.booked));
                        return Text('${open.length}×·$left',
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                            style: context.type.monoSm.copyWith(color: t.ink2, fontSize: 11));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Space.gutter),
                    child: Text(l.catSlotsHint, style: context.type.caption.copyWith(color: t.ink3)),
                  ),
                ]),
    );
  }
}

/// Times, capacity and weekdays for a range of slots.
class SlotRangeSheet extends StatefulWidget {
  const SlotRangeSheet({super.key, required this.from, required this.to, this.times = const [], this.capacity});

  final DateTime from;
  final DateTime to;
  final List<String> times;
  final int? capacity;

  @override
  State<SlotRangeSheet> createState() => _SlotRangeSheetState();
}

class _SlotRangeSheetState extends State<SlotRangeSheet> {
  late List<String> _times = widget.times;
  late final _capacity = TextEditingController(text: widget.capacity?.toString() ?? '');
  bool _closed = false;
  Set<int> _weekdays = {0, 1, 2, 3, 4, 5, 6};

  @override
  void dispose() {
    _capacity.dispose();
    super.dispose();
  }

  int? get _cap => int.tryParse(_capacity.text.trim());
  bool get _valid => _closed || (_times.isNotEmpty && (_cap ?? 0) > 0);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final days = widget.to.difference(widget.from).inDays + 1;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xl),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(_rangeLabel(context, widget.from, widget.to), style: context.type.heading),
          Gap.h16,
          Row(children: [
            Expanded(child: Text(l.catCloseDates, style: context.type.body)),
            DgSwitch(key: const Key('cat.slot.closed'), value: _closed, kill: true, onChanged: (v) => setState(() => _closed = v)),
          ]),
          if (!_closed) ...[
            Gap.h12,
            Text(l.catTimes, style: context.type.label.copyWith(color: context.dg.ink2)),
            Gap.h8,
            TimeListEditor(fieldKey: 'slot', times: _times, onChanged: (v) => setState(() => _times = v)),
            Gap.h16,
            DahabTextField(
              fieldKey: const Key('cat.slot.capacity'),
              label: l.catCapacity,
              controller: _capacity,
              mono: true,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
            ),
          ],
          if (days > 1) ...[
            Gap.h16,
            WeekdayToggles(selected: _weekdays, onChanged: (v) => setState(() => _weekdays = v)),
          ],
          Gap.h16,
          DahabButton(
            key: const Key('cat.slot.apply'),
            label: _closed ? l.catCloseDates : l.apply,
            expand: true,
            onPressed: _valid
                ? () => Navigator.of(context).pop(SlotEdit(times: _times, capacity: _cap, weekdays: _weekdays, closed: _closed))
                : null,
          ),
        ]),
      ),
    );
  }
}

// ── Restaurant menu ───────────────────────────────────────────────────────

extension MenuItemX on CatalogItem {
  String get menuSection => '${fields['section'] ?? fields['category'] ?? ''}';
  num? get menuPrice {
    final v = fields['priceEGP'] ?? fields['price'] ?? json['priceEGP'] ?? priceFromEGP;
    return v is num ? v : num.tryParse('${v ?? ''}');
  }

  bool get menuAvailable {
    final v = fields['available'] ?? json['available'];
    return v is bool ? v : true;
  }
}

/// Menu grouped by section, with an inline price edit and an "available"
/// switch on each item.
@RoutePage()
class CatalogMenuPage extends StatefulWidget {
  const CatalogMenuPage({super.key, @PathParam('id') required this.restaurantId});

  final String restaurantId;

  @override
  State<CatalogMenuPage> createState() => _CatalogMenuPageState();
}

class _CatalogMenuPageState extends State<CatalogMenuPage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  List<CatalogItem>? _items;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _repo.children('restaurant', widget.restaurantId, 'menu');
      if (mounted) {
        setState(() {
          _items = items;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _patch(CatalogItem item, Map<String, Object?> fields) async {
    final before = _items;
    setState(() => _items = [
          for (final i in _items!) i.id == item.id ? i.merge({'fields': {...i.fields, ...fields}}) : i,
        ]);
    try {
      await _repo.patchChild('restaurant', widget.restaurantId, 'menu', item.id, {'fields': fields});
    } catch (e) {
      if (!mounted) return;
      setState(() => _items = before);
      showErrorToast(context, e);
    }
  }

  Future<void> _add({String? section}) async {
    final sections = {for (final i in _items ?? const <CatalogItem>[]) i.menuSection}..remove('');
    final created = await showModalBottomSheet<Map<String, Object?>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _MenuItemSheet(section: section, sections: sections.toList()..sort()),
    );
    if (created == null || !mounted) return;
    try {
      await _repo.addChild('restaurant', widget.restaurantId, 'menu', CatalogValues.body(created));
      await _load();
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final manage = _canManage(context, 'restaurant');
    final items = _items;
    final groups = <String, List<CatalogItem>>{};
    for (final i in items ?? const <CatalogItem>[]) {
      (groups[i.menuSection] ??= []).add(i);
    }
    return _scaffold(
      context,
      title: l.catMenu,
      permission: _viewPerm(context, 'restaurant'),
      fab: manage
          ? FloatingActionButton.extended(
              key: const Key('cat.menu.add'),
              onPressed: _add,
              icon: const Icon(Icons.add),
              label: Text(l.catAddItem),
            )
          : null,
      body: _error != null && items == null
          ? ErrorView(error: _error!, onRetry: _load)
          : items == null
              ? const SkeletonList(count: 6, lines: 1)
              : items.isEmpty
                  ? EmptyState(icon: Icons.menu_book_outlined, actionLabel: manage ? l.catAddItem : null, onAction: manage ? _add : null)
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(padding: const EdgeInsets.only(bottom: Space.x4), children: [
                        for (final g in groups.entries) ...[
                          DgSectionHead(
                            title: g.key.isEmpty ? l.catMenuOther : g.key,
                            count: g.value.length,
                            linkLabel: manage ? l.add : null,
                            onLink: manage ? () => _add(section: g.key.isEmpty ? null : g.key) : null,
                          ),
                          for (final i in g.value)
                            MenuItemRow(
                              key: ValueKey('menu.${i.id}'),
                              item: i,
                              enabled: manage,
                              onPrice: (v) => _patch(i, {'priceEGP': v}),
                              onAvailable: (v) => _patch(i, {'available': v}),
                            ),
                        ],
                      ]),
                    ),
    );
  }
}

/// Menu row: title, inline price (submit to save) and the available switch.
class MenuItemRow extends StatefulWidget {
  const MenuItemRow({super.key, required this.item, required this.onPrice, required this.onAvailable, this.enabled = true});

  final CatalogItem item;
  final bool enabled;
  final ValueChanged<num> onPrice;
  final ValueChanged<bool> onAvailable;

  @override
  State<MenuItemRow> createState() => _MenuItemRowState();
}

class _MenuItemRowState extends State<MenuItemRow> {
  late final _ctrl = TextEditingController(text: _fmt(widget.item.menuPrice));
  final _focus = FocusNode();

  static String _fmt(num? v) => v == null ? '' : (v == v.roundToDouble() ? '${v.toInt()}' : '$v');

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _commit();
    });
  }

  @override
  void didUpdateWidget(MenuItemRow old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus) _ctrl.text = _fmt(widget.item.menuPrice);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _commit() {
    final v = num.tryParse(_ctrl.text.trim());
    if (v != null && v != widget.item.menuPrice) widget.onPrice(v);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final arabic = context.type.isArabic;
    final available = widget.item.menuAvailable;
    return Container(
      decoration: BoxDecoration(border: Border(top: t.hairlineSide)),
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.xs),
      child: Row(children: [
        Expanded(
          child: Text(widget.item.title.of(arabic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.type.body.copyWith(color: available ? t.ink : t.ink3)),
        ),
        SizedBox(
          width: 104,
          child: TextField(
            key: Key('cat.menu.price.${widget.item.id}'),
            controller: _ctrl,
            focusNode: _focus,
            enabled: widget.enabled,
            textAlign: TextAlign.end,
            textDirection: TextDirection.ltr,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            textInputAction: TextInputAction.done,
            style: context.type.monoMd.copyWith(color: t.ink, fontSize: 15),
            decoration: InputDecoration(
              isDense: true,
              suffixText: 'EGP',
              suffixStyle: context.type.monoSm.copyWith(color: t.ink3),
            ),
            onSubmitted: (_) => _commit(),
          ),
        ),
        Gap.w8,
        DgSwitch(
          key: Key('cat.menu.available.${widget.item.id}'),
          value: available,
          semanticLabel: context.l10n.catAvailable,
          onChanged: widget.enabled ? widget.onAvailable : null,
        ),
      ]),
    );
  }
}

class _MenuItemSheet extends StatefulWidget {
  const _MenuItemSheet({this.section, this.sections = const []});

  final String? section;
  final List<String> sections;

  @override
  State<_MenuItemSheet> createState() => _MenuItemSheetState();
}

class _MenuItemSheetState extends State<_MenuItemSheet> {
  late Map<String, Object?> _values = {'section': widget.section, 'available': true};

  static const _fields = [
    CatalogField(key: 'title', kind: FieldKind.i18nText, required: true, max: 120),
    CatalogField(key: 'priceEGP', kind: FieldKind.money, required: true),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final title = _values['title'];
    final ok = (title is I18n && !title.isEmpty) && _values['priceEGP'] is num;
    final section = '${_values['section'] ?? ''}';
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.xl),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.catAddItem, style: context.type.heading),
          Gap.h16,
          for (final f in _fields)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.lg),
              child: CatalogFieldInput(
                field: CatalogField(
                    key: f.key,
                    kind: f.kind,
                    required: f.required,
                    label: I18n(en: f.key == 'title' ? l.catItemName : l.catPrice, ar: f.key == 'title' ? l.catItemName : l.catPrice)),
                value: _values[f.key],
                onChanged: (k, v) => setState(() => _values = {..._values, k: v}),
              ),
            ),
          Text(l.catSection, style: context.type.label.copyWith(color: context.dg.ink2)),
          Gap.h8,
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final s in widget.sections)
              DgChip(label: s, selected: section == s, onTap: () => setState(() => _values = {..._values, 'section': s})),
          ]),
          Gap.h8,
          TextField(
            decoration: InputDecoration(hintText: l.catNewSection, isDense: true),
            onChanged: (v) => setState(() => _values = {..._values, 'section': v.trim()}),
          ),
          Gap.h16,
          DahabButton(
            key: const Key('cat.menu.save'),
            label: l.save,
            expand: true,
            onPressed: ok ? () => Navigator.of(context).pop(_values) : null,
          ),
        ]),
      ),
    );
  }
}
