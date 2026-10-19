import 'dart:async' show unawaited;

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_client.dart' show Json;
import '../../../core/api/api_error.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/modern.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../core/router/shell_leading.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../content_repository.dart';

/// Trip programmes (`/cms/programmes`): the ready-made trips the web
/// concierge/plan surfaces and the REHLA app render. List, filter, edit,
/// publish/archive — changes go live on both apps without a release.
@RoutePage()
class ProgrammesPage extends StatelessWidget {
  const ProgrammesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(context.l10n.ccTileProgrammes),
        actions: [
          if (context.watch<SessionCubit>().state.can('cms.content.edit'))
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.sm),
              child: DgIconButton(
                icon: DgIcons.plus,
                tooltip: context.l10n.ccProgrammeNew,
                onPressed: () => context.router.push(ProgrammeEditorRoute(id: 'new')),
              ),
            ),
        ],
      ),
      body: const _ProgrammesBody(),
    );
  }
}

class _ProgrammesBody extends StatefulWidget {
  const _ProgrammesBody();

  @override
  State<_ProgrammesBody> createState() => _ProgrammesBodyState();
}

class _ProgrammesBodyState extends State<_ProgrammesBody> {
  List<Programme> _items = const [];
  var _status = ContentLoading.loading;
  ApiError? _error;
  var _statusFilter = '';
  var _destinationFilter = '';

  static const _statuses = ['', 'published', 'draft', 'archived'];
  static const _destinations = ['', 'dahab', 'nuweiba', 'siwa'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = ContentLoading.loading);
    try {
      final items = await GetIt.I<ContentRepository>()
          .programmes(status: _statusFilter, destination: _destinationFilter);
      if (!mounted) return;
      setState(() {
        _items = items;
        _status = ContentLoading.ready;
      });
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _status = ContentLoading.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    switch (_status) {
      case ContentLoading.loading:
        return const SkeletonList(count: 6);
      case ContentLoading.failure:
        return ErrorView(error: _error!, onRetry: _load);
      case ContentLoading.ready:
        break;
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: Column(children: [
        DgChipRow(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
          children: [
            for (final s in _statuses)
              DgChip(
                label: s.isEmpty ? l.ccAll : _statusLabel(l, s),
                selected: _statusFilter == s,
                onTap: () {
                  setState(() => _statusFilter = s);
                  _load();
                },
              ),
          ],
        ),
        DgChipRow(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 8),
          children: [
            for (final d in _destinations)
              DgChip(
                label: d.isEmpty ? l.ccAllDestinations : _destinationLabel(l, d),
                selected: _destinationFilter == d,
                onTap: () {
                  setState(() => _destinationFilter = d);
                  _load();
                },
              ),
          ],
        ),
        Expanded(
          child: _items.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 120),
                  EmptyState(title: l.ccProgrammesEmpty, body: l.ccProgrammesEmptyBody),
                ])
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(Space.gutter, Space.xs, Space.gutter, Space.x4),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final p = _items[index];
                    final tone = switch (p.status) {
                      'published' => Tone.positive,
                      'draft' => Tone.warning,
                      _ => Tone.neutral,
                    };
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.xs),
                      child: Panel(
                        onTap: () {
                          unawaited(context.router.push(ProgrammeEditorRoute(id: p.id)));
                          if (mounted) _load();
                        },
                        child: Row(children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Expanded(
                                  child: Text(
                                    p.titleEn.isNotEmpty ? p.titleEn : p.id,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.type.bodyStrong.copyWith(color: t.ink),
                                  ),
                                ),
                                MonoText('${p.startingPriceEgp.toInt()}', size: 14, color: t.ink2),
                              ]),
                              Gap.h4,
                              Text(
                                p.titleAr.isNotEmpty ? p.titleAr : p.taglineEn,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.type.ui.copyWith(fontSize: 13, color: t.ink3),
                              ),
                              Gap.h4,
                              Row(children: [
                                StatusPill(_statusLabel(l, p.status),
                                    tone: tone, pulse: p.status == 'published'),
                                Gap.w8,
                                Text(_destinationLabel(l, p.destination),
                                    style: context.type.ui.copyWith(fontSize: 13, color: t.ink3)),
                                const Spacer(),
                                MonoText('${p.durationDays}d', size: 12, color: t.ink3),
                              ]),
                            ]),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }

  static String _statusLabel(AppLocalizations l, String s) => switch (s) {
        'published' => l.cmsPublished,
        'draft' => l.ccDraft,
        'archived' => l.ccArchived,
        _ => l.ccAll,
      };

  static String _destinationLabel(AppLocalizations l, String d) => switch (d) {
        'dahab' => l.ccDestDahab,
        'nuweiba' => l.ccDestNuweiba,
        'siwa' => l.ccDestSiwa,
        _ => l.ccAllDestinations,
      };
}

/// The programme editor: bilingual copy, price/pace/destination, the
/// highlight lists and the day-by-day plan, then publish/archive/delete.
@RoutePage()
class ProgrammeEditorPage extends StatelessWidget {
  const ProgrammeEditorPage({@PathParam('id') this.id = 'new', super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final isNew = id == 'new';
    return FutureBuilder<Programme?>(
      future: isNew ? Future.value(null) : GetIt.I<ContentRepository>().programme(id),
      builder: (context, snap) {
        if (!isNew && snap.connectionState != ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(leading: shellLeading(context), automaticallyImplyLeading: false),
            body: const SkeletonList(count: 8),
          );
        }
        if (!isNew && (snap.hasError || snap.data == null)) {
          return Scaffold(
            appBar: AppBar(leading: shellLeading(context), automaticallyImplyLeading: false),
            body: ErrorView(
              error: snap.hasError
                  ? ApiError.fromResponse(0, '${snap.error}')
                  : ApiError.fromResponse(404, 'Programme not found'),
              onRetry: () => context.router.maybePop(),
            ),
          );
        }
        return _ProgrammeEditor(original: snap.data, isNew: isNew);
      },
    );
  }
}

/// Equal-width chips across the full width.
///
/// Not [DgChipRow]: that scrolls horizontally, so its children get unbounded
/// width and a `MainAxisSize.max` row inside them throws. These three pickers
/// always fit the phone, so a plain [Row] of [Expanded] chips is the correct
/// primitive — the labels stay on one line at the narrowest supported screen.
class _SegmentedChips extends StatelessWidget {
  const _SegmentedChips({required this.labels, required this.selected, required this.onTap});

  final List<String> labels;
  final int selected;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) Gap.w8,
          Expanded(
            child: DgChip(
              label: labels[i],
              selected: selected == i,
              expand: true,
              onTap: onTap == null ? null : () => onTap!(i),
            ),
          ),
        ],
      ],
    );
  }
}

enum ContentLoading { loading, ready, failure }

class _ProgrammeEditor extends StatefulWidget {
  const _ProgrammeEditor({required this.original, required this.isNew});

  final Programme? original;
  final bool isNew;

  @override
  State<_ProgrammeEditor> createState() => _ProgrammeEditorState();
}

class _ProgrammeEditorState extends State<_ProgrammeEditor> {
  late final TextEditingController _id;
  late final TextEditingController _titleEn;
  late final TextEditingController _titleAr;
  late final TextEditingController _taglineEn;
  late final TextEditingController _taglineAr;
  late final TextEditingController _idealEn;
  late final TextEditingController _idealAr;
  late final TextEditingController _price;
  late final TextEditingController _days;
  late final TextEditingController _highlightsEn;
  late final TextEditingController _highlightsAr;
  var _destination = 'dahab';
  var _pace = 'Balanced';
  var _budget = 'Moderate';
  var _estimate = true;
  var _busy = false;
  List<_DayDraft> _days_ = [];

  @override
  void initState() {
    super.initState();
    final p = widget.original;
    _id = TextEditingController(text: p?.id ?? '');
    _titleEn = TextEditingController(text: p?.titleEn ?? '');
    _titleAr = TextEditingController(text: p?.titleAr ?? '');
    _taglineEn = TextEditingController(text: p?.taglineEn ?? '');
    _taglineAr = TextEditingController(text: p?.taglineAr ?? '');
    _idealEn = TextEditingController(text: p?.idealForEn ?? '');
    _idealAr = TextEditingController(text: p?.idealForAr ?? '');
    _price = TextEditingController(text: p == null ? '' : '${p.startingPriceEgp.toInt()}');
    _days = TextEditingController(text: p == null ? '' : '${p.durationDays}');
    _highlightsEn = TextEditingController(text: p?.highlightsEn.join(', ') ?? '');
    _highlightsAr = TextEditingController(text: p?.highlightsAr.join(', ') ?? '');
    _destination = p?.destination ?? 'dahab';
    _pace = p?.pace ?? 'Balanced';
    _budget = p?.defaultBudget ?? 'Moderate';
    _estimate = p?.priceIsEstimate ?? true;
    _days_ = [
      for (final d in p?.dayByDay ?? const <Map<String, dynamic>>[])
        _DayDraft(
          day: (d['day'] as num?)?.toInt() ?? 0,
          source: Map<String, dynamic>.from(d),
          title: '${d['title'] ?? ''}',
          subtitle: '${d['subtitle'] ?? ''}',
          timeEstimate: '${d['timeEstimate'] ?? ''}',
          highlights: ((d['highlights'] as List?) ?? const []).map((e) => '$e').join(', '),
        ),
    ];
  }

  @override
  void dispose() {
    for (final c in [_id, _titleEn, _titleAr, _taglineEn, _taglineAr, _idealEn, _idealAr, _price, _days, _highlightsEn, _highlightsAr]) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> _list(String raw) => raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Json get _body => {
        if (!widget.isNew) 'id': _id.text.trim(),
        'destination': _destination,
        'title_en': _titleEn.text.trim(),
        'title_ar': _titleAr.text.trim(),
        'tagline_en': _taglineEn.text.trim(),
        'tagline_ar': _taglineAr.text.trim(),
        'ideal_for_en': _idealEn.text.trim(),
        'ideal_for_ar': _idealAr.text.trim(),
        'duration_days': int.tryParse(_days.text.trim()) ?? 1,
        'pace': _pace,
        'starting_price_egp': num.tryParse(_price.text.trim()) ?? 0,
        'price_is_estimate': _estimate,
        'highlights_en': _list(_highlightsEn.text),
        'highlights_ar': _list(_highlightsAr.text),
        'default_budget': _budget,
        'day_by_day': [
          for (var i = 0; i < _days_.length; i++)
            {
              ..._days_[i].source,
              'day': i + 1,
              'title': _days_[i].title.text.trim(),
              'subtitle': _days_[i].subtitle.text.trim(),
              'timeEstimate': _days_[i].timeEstimate.text.trim(),
              'highlights': _list(_days_[i].highlights.text),
            },
        ],
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final canEdit = context.watch<SessionCubit>().state.can('cms.content.edit');
    final canPublish = context.watch<SessionCubit>().state.can('cms.content.publish');
    final status = widget.original?.status ?? 'draft';

    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(widget.isNew ? l.ccProgrammeNew : (_titleEn.text.isEmpty ? widget.original!.id : _titleEn.text)),
        actions: [
          if (status == 'published')
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.md),
              child: Center(child: StatusPill(l.cmsPublished, tone: Tone.positive)),
            ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        if (widget.isNew) ...[
          DahabTextField(label: l.ccProgrammeId, controller: _id, mono: true, enabled: canEdit),
          Gap.h12,
        ],
        DahabTextField(label: l.ccTitleEn, controller: _titleEn, enabled: canEdit),
        Gap.h12,
        DahabTextField(label: l.ccTitleAr, controller: _titleAr, enabled: canEdit, textDirection: TextDirection.rtl),
        Gap.h12,
        DahabTextField(label: l.ccTaglineEn, controller: _taglineEn, maxLines: 2, enabled: canEdit),
        Gap.h12,
        DahabTextField(label: l.ccTaglineAr, controller: _taglineAr, maxLines: 2, enabled: canEdit, textDirection: TextDirection.rtl),
        Gap.h16,
        DgGroupTitle(l.ccDestination),
        _SegmentedChips(
          labels: const ['dahab', 'nuweiba', 'siwa'].map((d) => _ProgrammesBodyState._destinationLabel(l, d)).toList(),
          selected: const ['dahab', 'nuweiba', 'siwa'].indexOf(_destination),
          onTap: canEdit ? (i) => setState(() => _destination = const ['dahab', 'nuweiba', 'siwa'][i]) : null,
        ),
        DgGroupTitle(l.ccPace),
        _SegmentedChips(
          labels: const ['Relaxed', 'Balanced', 'Active'],
          selected: const ['Relaxed', 'Balanced', 'Active'].indexOf(_pace),
          onTap: canEdit ? (i) => setState(() => _pace = const ['Relaxed', 'Balanced', 'Active'][i]) : null,
        ),
        DgGroupTitle(l.ccBudget),
        _SegmentedChips(
          labels: const ['Budget', 'Moderate', 'Premium'],
          selected: const ['Budget', 'Moderate', 'Premium'].indexOf(_budget),
          onTap: canEdit ? (i) => setState(() => _budget = const ['Budget', 'Moderate', 'Premium'][i]) : null,
        ),
        Gap.h12,
        Row(children: [
          Expanded(
            child: DahabTextField(label: l.ccDurationDays, controller: _days, mono: true, enabled: canEdit, keyboardType: TextInputType.number),
          ),
          Gap.w12,
          Expanded(
            child: DahabTextField(label: l.ccPriceEgp, controller: _price, mono: true, enabled: canEdit, keyboardType: TextInputType.number),
          ),
        ]),
        Gap.h12,
        DgSetRow(
          title: l.ccPriceEstimate,
          subtitle: l.ccPriceEstimateHint,
          trailing: DgSwitch(
            value: _estimate,
            semanticLabel: l.ccPriceEstimate,
            onChanged: canEdit ? (v) => setState(() => _estimate = v) : null,
          ),
        ),
        Gap.h12,
        DahabTextField(label: l.ccIdealForEn, controller: _idealEn, maxLines: 2, enabled: canEdit),
        Gap.h12,
        DahabTextField(label: l.ccIdealForAr, controller: _idealAr, maxLines: 2, enabled: canEdit, textDirection: TextDirection.rtl),
        Gap.h12,
        DahabTextField(label: l.ccHighlightsEn, controller: _highlightsEn, maxLines: 3, helper: l.ccCommaSeparated, enabled: canEdit),
        Gap.h12,
        DahabTextField(label: l.ccHighlightsAr, controller: _highlightsAr, maxLines: 3, helper: l.ccCommaSeparated, enabled: canEdit, textDirection: TextDirection.rtl),
        Gap.h16,
        DgSectionHead(
          title: l.ccDayByDay,
          linkLabel: canEdit ? l.ccAddDay : null,
          onLink: canEdit
              ? () => setState(() => _days_ = [
                    ..._days_,
                    _DayDraft(day: _days_.length + 1, source: const {}),
                  ])
              : null,
        ),
        if (_days_.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.md),
            child: Text(l.ccNoDaysYet, style: context.type.caption.copyWith(color: t.ink3)),
          ),
        for (var i = 0; i < _days_.length; i++) _DayCard(index: i, draft: _days_[i], canEdit: canEdit, onRemove: canEdit ? () => setState(() => _days_.removeAt(i)) : null),
        Gap.h24,
        if (canEdit)
          DahabButton(
            label: widget.isNew ? l.ccCreate : l.save,
            expand: true,
            onPressed: _busy ? null : _save,
          ),
        if (!widget.isNew && canPublish) ...[
          Gap.h12,
          Row(children: [
            Expanded(
              child: status == 'published'
                  ? DahabButton.secondary(
                      label: l.ccArchived,
                      expand: true,
                      onPressed: _busy ? null : () => _setStatus('archive'),
                    )
                  : DahabButton(
                      label: l.cmsPublish,
                      expand: true,
                      onPressed: _busy ? null : () => _setStatus('publish'),
                    ),
            ),
            if (widget.original != null && widget.original!.status != 'published') ...[
              Gap.w12,
              Expanded(
                child: DahabButton.danger(
                  label: l.deleteLabel,
                  expand: true,
                  onPressed: _busy ? null : _delete,
                ),
              ),
            ],
          ]),
        ],
        Gap.h32,
      ]),
    );
  }

  Future<void> _save() async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: widget.isNew ? l.ccProgrammeCreateConfirm : l.ccSaveSettingTitle(_id.text),
      biometric: false,
      destructive: false,
      confirmLabel: l.save,
    );
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    final repo = GetIt.I<ContentRepository>();
    try {
      final saved = widget.isNew ? await repo.createProgramme(_body) : await repo.updateProgramme(_id.text.trim(), _body);
      if (!mounted) return;
      showToast(context, l.saved, tone: Tone.positive);
      if (widget.isNew) {
        unawaited(context.router.replace(ProgrammeEditorRoute(id: saved.id)));
      }
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setStatus(String action) async {
    final l = context.l10n;
    final publish = action == 'publish';
    final reason = await showConfirmDangerSheet(
      context,
      title: publish ? l.ccProgrammePublishConfirm : l.ccProgrammeArchiveConfirm,
      body: publish ? l.ccProgrammePublishBody : l.ccProgrammeArchiveBody,
      destructive: !publish,
    );
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await GetIt.I<ContentRepository>().setProgrammeStatus(_id.text.trim(), action);
      if (!mounted) return;
      showToast(context, publish ? l.cmsPublishedToast : l.ccArchivedToast, tone: Tone.positive);
      if (publish) {
        unawaited(context.router.maybePop());
      } else {
        setState(() {});
      }
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final reason = await showConfirmDangerSheet(
      context,
      title: l.ccProgrammeDeleteConfirm,
      body: l.ccProgrammeDeleteBody,
      destructive: true,
    );
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await GetIt.I<ContentRepository>().deleteProgramme(_id.text.trim());
      if (!mounted) return;
      showToast(context, l.ccProgrammeDeleted, tone: Tone.positive);
      unawaited(context.router.maybePop());
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _DayDraft {
  _DayDraft({
    required this.day,
    required this.source,
    String title = '',
    String subtitle = '',
    String timeEstimate = '',
    String highlights = '',
  })  : title = TextEditingController(text: title),
        subtitle = TextEditingController(text: subtitle),
        timeEstimate = TextEditingController(text: timeEstimate),
        highlights = TextEditingController(text: highlights);

  final int day;

  /// The day as it came from the API. The editor only models four fields, so
  /// the untouched keys (`tag`, `accentColor`, `titleAr`, `subtitleAr`,
  /// `highlightsAr`) are merged back in on save instead of being dropped.
  final Map<String, dynamic> source;
  final TextEditingController title;
  final TextEditingController subtitle;
  final TextEditingController timeEstimate;
  final TextEditingController highlights;
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.index, required this.draft, required this.canEdit, required this.onRemove});

  final int index;
  final _DayDraft draft;
  final bool canEdit;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return Panel(
      color: t.raised2,
      padding: const EdgeInsets.all(Space.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          MonoText('DAY ${index + 1}', size: 12, color: t.ink2, weight: FontWeight.w600),
          const Spacer(),
          if (onRemove != null)
            DgIconButton(icon: DgIcons.trash, size: 32, tooltip: l.deleteLabel, onPressed: onRemove),
        ]),
        Gap.h8,
        DahabTextField(label: l.ccTitleEn, controller: draft.title, enabled: canEdit),
        Gap.h8,
        DahabTextField(label: l.ccSubtitleEn, controller: draft.subtitle, enabled: canEdit),
        Gap.h8,
        DahabTextField(label: l.ccTimeEstimate, controller: draft.timeEstimate, mono: true, enabled: canEdit),
        Gap.h8,
        DahabTextField(label: l.ccHighlightsEn, controller: draft.highlights, helper: l.ccCommaSeparated, enabled: canEdit),
      ]),
    );
  }
}
