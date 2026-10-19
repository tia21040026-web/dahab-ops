import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../core/router/shell_leading.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../form/catalog_form_engine.dart';
import 'catalog_common.dart';
import 'catalog_draft.dart';

/// The wizard's three steps over a schema: basics, photos, price &
/// availability (contract § UX rules).
class WizardSteps {
  WizardSteps(this.schema);

  final CatalogTypeSchema schema;

  static const _priceKinds = {
    FieldKind.money,
    FieldKind.number,
    FieldKind.boolean,
    FieldKind.time,
    FieldKind.timeList,
    FieldKind.duration,
  };

  static bool _priceSection(String key) =>
      RegExp('price|pric|avail|rate|schedule|capacity', caseSensitive: false).hasMatch(key);

  List<CatalogField> get basics {
    final out = <CatalogField>[];
    for (var i = 0; i < schema.sections.length; i++) {
      final s = schema.sections[i];
      for (final f in s.fields) {
        if (f.kind == FieldKind.gallery || _priceKinds.contains(f.kind) || _priceSection(s.key)) continue;
        // The first section, plus required essentials from the others.
        if (i == 0 || f.required) out.add(f);
      }
    }
    return out;
  }

  List<CatalogField> get photos {
    final g = schema.fields.where((f) => f.kind == FieldKind.gallery).toList();
    return g.isEmpty ? const [CatalogField(key: 'images', kind: FieldKind.gallery, max: 20)] : g;
  }

  List<CatalogField> get price {
    final taken = {...basics.map((f) => f.key), ...photos.map((f) => f.key)};
    return schema.fields.where((f) => !taken.contains(f.key)).toList();
  }

  List<List<CatalogField>> get all => [basics, photos, price];
}

/// Sticky "Saved · Publish" bar. Publish stays disabled until complete;
/// tapping the hint shows what is missing.
class PublishBar extends StatelessWidget {
  const PublishBar({
    super.key,
    required this.draft,
    required this.supplier,
    required this.canPublish,
    required this.onPublish,
    this.onSave,
    this.publishing = false,
  });

  final CatalogDraft draft;
  final bool supplier;
  final bool canPublish;
  final VoidCallback onPublish;
  final VoidCallback? onSave;
  final bool publishing;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final missing = draft.missing;
    final published = draft.item?.isPublished ?? false;
    final label = supplier ? l.catSubmitReview : (published ? l.catPublishChanges : l.catPublish);
    final (stateText, stateTone) = switch (draft.saveState) {
      DraftSave.saving => (l.catSaving, Tone.neutral),
      DraftSave.saved => (l.saved, Tone.positive),
      DraftSave.dirty => (l.catUnsaved, Tone.warning),
      DraftSave.conflict => (l.catConflictShort, Tone.critical),
      DraftSave.failed => (l.catSaveFailed, Tone.critical),
      DraftSave.idle => (draft.isNew ? l.catNotSaved : l.saved, draft.isNew ? Tone.neutral : Tone.positive),
    };
    return DgBottomBar(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          StatusDot(color: t.toneInk(stateTone)),
          Gap.w8,
          Expanded(
            child: Text(stateText, key: const Key('cat.saveState'), style: context.type.caption.copyWith(color: t.ink2)),
          ),
          if (missing.isNotEmpty)
            InkWell(
              key: const Key('cat.missingHint'),
              onTap: () => showModalBottomSheet<void>(
                context: context,
                useSafeArea: true,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(Space.xl),
                  child: MissingList(schema: draft.schema, missing: missing),
                ),
              ),
              child: Text(l.catMissingCount(missing.length),
                  style: context.type.caption.copyWith(color: t.warning, decoration: TextDecoration.underline)),
            ),
        ]),
        Gap.h8,
        Row(children: [
          if (onSave != null) ...[
            Expanded(
              child: DahabButton.secondary(
                key: const Key('cat.saveDraft'),
                label: l.catSaveDraft,
                loading: draft.saveState == DraftSave.saving,
                onPressed: onSave,
              ),
            ),
            Gap.w8,
          ],
          if (canPublish)
            Expanded(
              child: DahabButton(
                key: const Key('cat.publish'),
                label: label,
                icon: supplier ? Icons.send_outlined : Icons.publish_outlined,
                loading: publishing,
                onPressed: missing.isEmpty && draft.saveState != DraftSave.conflict ? onPublish : null,
              ),
            ),
        ]),
      ]),
    );
  }
}

Future<void> _publish(BuildContext context, CatalogDraft draft, void Function(bool) busy) async {
  final l = context.l10n;
  busy(true);
  try {
    final r = await draft.publish();
    if (!context.mounted) return;
    if (r != null) {
      showToast(context, draft.repo.supplier ? l.catSubmittedToast : l.catPublishedToast, tone: Tone.positive);
    } else if (draft.error != null && !isIncomplete(draft.error!)) {
      showErrorToast(context, draft.error!);
    }
  } catch (e) {
    if (context.mounted) showErrorToast(context, e);
  } finally {
    busy(false);
  }
}

/// Uploader bound to the repository.
CatalogUploader catalogUploader(CatalogRepository repo) => repo.uploadImage;

// ── Create wizard ─────────────────────────────────────────────────────────

/// 3-step create: Basics → Photos → Price & availability. The record is
/// saved as a draft after each step; Publish waits for completeness.
@RoutePage()
class CatalogCreatePage extends StatefulWidget {
  const CatalogCreatePage({super.key, @PathParam('type') required this.type});

  final String type;

  @override
  State<CatalogCreatePage> createState() => _CatalogCreatePageState();
}

class _CatalogCreatePageState extends State<CatalogCreatePage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  late Future<CatalogTypeSchema?> _schema = _repo.schemaFor(widget.type);
  CatalogDraft? _draft;
  WizardSteps? _steps;
  int _step = 0;
  bool _publishing = false;

  @override
  void dispose() {
    _draft?.dispose();
    super.dispose();
  }

  CatalogDraft _draftFor(CatalogTypeSchema s) => _draft ??= CatalogDraft(repo: _repo, type: widget.type, schema: s);

  bool _canLeaveBasics(CatalogDraft d) {
    final t = d.values['title'];
    final title = t is I18n ? t : I18n.from(t);
    return !title.isEmpty;
  }

  Future<void> _next(CatalogDraft d) async {
    final ok = await d.save();
    if (!mounted) return;
    if (!ok) {
      if (d.error != null) showErrorToast(context, d.error!);
      return;
    }
    if (_step < 2) setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = context.watch<SessionCubit>().state;
    final access = CatalogAccess(session, widget.type);
    final arabic = context.type.isArabic;
    return FutureBuilder<CatalogTypeSchema?>(
      future: _schema,
      builder: (context, snap) {
        final schema = snap.data;
        final titles = [l.catStepBasics, l.catStepPhotos, l.catStepPrice];
        return Scaffold(
          appBar: AppBar(
            leading: shellLeading(context),
            automaticallyImplyLeading: false,
            title: Text(schema == null ? l.catNew : l.catNewType(schema.labelOf(arabic))),
          ),
          bottomNavigationBar: schema == null ? null : _bar(context, _draftFor(schema), access),
          body: PermissionGate(
            permission: access.supplier ? supplierCatalogPermission : catalogPerm(widget.type, 'manage'),
            explain: true,
            child: snap.hasError
                ? ErrorView(error: snap.error!, onRetry: () => setState(() => _schema = _repo.schemaFor(widget.type)))
                : schema == null
                    ? (snap.connectionState == ConnectionState.done
                        ? ErrorView(error: Exception(l.errorNotFound))
                        : const SkeletonList(count: 5))
                    : ListenableBuilder(
                        listenable: _draftFor(schema),
                        builder: (context, _) {
                          final d = _draftFor(schema);
                          _steps ??= WizardSteps(schema);
                          return Column(children: [
                            _StepHeader(step: _step, titles: titles, onTap: (i) {
                              if (i < _step || !d.isNew) setState(() => _step = i);
                            }),
                            Expanded(
                              child: CatalogFormEngine(
                                key: ValueKey('step.$_step'),
                                fields: _steps!.all[_step],
                                values: d.values,
                                onChanged: d.set,
                                missing: _step == 2 ? d.missing.toSet() : const {},
                                uploader: catalogUploader(_repo),
                                showSupplier: !access.supplier,
                                padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, Space.x2),
                              ),
                            ),
                            if (_step == 2 && d.missing.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(Space.gutter, 0, Space.gutter, Space.sm),
                                child: MissingList(schema: schema, missing: d.missing),
                              ),
                          ]);
                        },
                      ),
          ),
        );
      },
    );
  }

  Widget _bar(BuildContext context, CatalogDraft d, CatalogAccess access) {
    final l = context.l10n;
    return ListenableBuilder(
      listenable: d,
      builder: (context, _) {
        if (_step == 2) {
          return PublishBar(
            draft: d,
            supplier: access.supplier,
            canPublish: access.canPublish,
            publishing: _publishing,
            onSave: () async {
              if (await d.save() && context.mounted) {
                showToast(context, l.catDraftSaved, tone: Tone.positive);
                unawaited(context.router.maybePop(d.item));
              } else if (context.mounted && d.error != null) {
                showErrorToast(context, d.error!);
              }
            },
            onPublish: () async {
              await _publish(context, d, (b) => mounted ? setState(() => _publishing = b) : null);
              if (context.mounted && (d.item?.status ?? '') != CatalogStatus.draft) {
                unawaited(context.router.maybePop(d.item));
              }
            },
          );
        }
        final canNext = _step != 0 || _canLeaveBasics(d);
        return DgBottomBar(
          child: Row(children: [
            if (_step > 0) ...[
              Expanded(child: DahabButton.secondary(label: l.back, onPressed: () => setState(() => _step--))),
              Gap.w8,
            ],
            Expanded(
              child: DahabButton(
                key: const Key('cat.wizard.next'),
                label: l.catNextStep,
                icon: Icons.arrow_forward,
                loading: d.saveState == DraftSave.saving,
                onPressed: canNext ? () => _next(d) : null,
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step, required this.titles, required this.onTap});

  final int step;
  final List<String> titles;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, Space.md),
      child: Row(children: [
        for (var i = 0; i < titles.length; i++) ...[
          if (i > 0) Expanded(child: Container(height: 1, color: i <= step ? t.action : t.line)),
          InkWell(
            key: Key('cat.step.$i'),
            onTap: () => onTap(i),
            borderRadius: Radii.pill,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < step ? t.action : (i == step ? t.actionWash : t.raised2),
                    border: Border.all(color: i <= step ? t.action : t.line, width: t.hairline),
                  ),
                  child: i < step
                      ? Icon(Icons.check, size: 14, color: t.actionInk)
                      : Text('${i + 1}', style: context.type.monoSm.copyWith(color: i == step ? t.action : t.ink3)),
                ),
                Gap.w4,
                Text(titles[i], style: context.type.caption.copyWith(color: i == step ? t.ink : t.ink3)),
              ]),
            ),
          ),
        ],
      ]),
    );
  }
}

// ── Edit ──────────────────────────────────────────────────────────────────

/// One sectioned form from the schema, autosaving (PATCH + If-Match), with
/// a sticky "Saved · Publish changes" bar and the record's children.
@RoutePage()
class CatalogEditPage extends StatefulWidget {
  const CatalogEditPage({super.key, @PathParam('type') required this.type, @PathParam('id') required this.id});

  final String type;
  final String id;

  @override
  State<CatalogEditPage> createState() => _CatalogEditPageState();
}

class _CatalogEditPageState extends State<CatalogEditPage> {
  late final CatalogRepository _repo = CatalogScope.of(context);
  CatalogDraft? _draft;
  CatalogTypeSchema? _schema;
  Map<String, List<CatalogItem>> _children = const {};
  Object? _error;
  bool _loading = true;
  bool _publishing = false;
  bool _conflictOpen = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    final d = _draft;
    if (d != null) {
      d.removeListener(_onDraft);
      // Flush the last edit; the draft is released when it settles.
      if (d.hasChanges && d.saveState != DraftSave.conflict) {
        d.save().whenComplete(d.dispose);
      } else {
        d.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([_repo.schemaFor(widget.type), _repo.get(widget.type, widget.id)]);
      final schema = results[0] as CatalogTypeSchema?;
      final detail = results[1] as CatalogDetail;
      if (!mounted) return;
      final s = schema ?? CatalogTypeSchema(type: widget.type);
      _draft?.removeListener(_onDraft);
      _draft?.dispose();
      setState(() {
        _schema = s;
        _children = detail.children;
        _draft = CatalogDraft(repo: _repo, type: widget.type, schema: s, item: detail.item, autosave: true)
          ..addListener(_onDraft);
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    }
  }

  void _onDraft() {
    final d = _draft;
    if (d == null || !mounted) return;
    if (d.saveState == DraftSave.conflict && !_conflictOpen) {
      _conflictOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _conflict(d));
    }
  }

  Future<void> _conflict(CatalogDraft d) async {
    final l = context.l10n;
    final keep = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: Text(l.catConflictTitle),
        content: Text(l.catConflictBody),
        actions: [
          TextButton(key: const Key('cat.conflict.reload'), onPressed: () => Navigator.of(c).pop(false), child: Text(l.catConflictReload)),
          FilledButton(key: const Key('cat.conflict.keep'), onPressed: () => Navigator.of(c).pop(true), child: Text(l.catConflictKeep)),
        ],
      ),
    );
    try {
      await d.resolveConflict(keepMine: keep ?? false);
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      _conflictOpen = false;
    }
  }

  CatalogActions get _actions => CatalogActions(context, _repo, widget.type, schema: _schema);

  Future<void> _menu(String action) async {
    final d = _draft;
    final item = d?.item;
    if (d == null || item == null) return;
    switch (action) {
      case 'duplicate':
        final copy = await _actions.duplicate(item);
        if (copy != null && copy.id.isNotEmpty && mounted) {
          await context.router.replace(CatalogEditRoute(type: widget.type, id: copy.id));
        }
      case 'hide':
        final n = await _actions.hide(item);
        if (n != null) d.replaceItem(n.id.isEmpty ? item.merge(n.json) : n);
      case 'restore':
        final n = await _actions.restore(item);
        if (n != null) d.replaceItem(n.id.isEmpty ? item.merge(n.json) : n);
      case 'archive':
        final n = await _actions.archive(item);
        if (n != null) d.replaceItem(n.id.isEmpty ? item.merge({'status': CatalogStatus.archived}) : n);
      case 'delete':
        if (await _actions.delete(item) && mounted) await context.router.maybePop();
    }
  }

  List<CatalogChildSpec> _childSpecs(CatalogTypeSchema s) {
    final specs = [...s.children];
    bool has(bool Function(CatalogChildSpec) t) => specs.any(t);
    switch (widget.type) {
      case 'hotel':
        if (!has((c) => c.key == 'rooms')) specs.add(const CatalogChildSpec(key: 'rooms', itemType: 'hotel-room'));
        if (!has((c) => c.isRateCalendar)) specs.add(const CatalogChildSpec(key: 'rates', kind: 'rateCalendar'));
      case 'activity':
        if (!has((c) => c.isSlots)) specs.add(const CatalogChildSpec(key: 'slots', kind: 'slots'));
      case 'restaurant':
        if (!has((c) => c.isMenu)) specs.add(const CatalogChildSpec(key: 'menu', kind: 'menu'));
        if (!has((c) => c.isOrders)) specs.add(const CatalogChildSpec(key: 'orders', kind: 'orders'));
    }
    return specs;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final session = context.watch<SessionCubit>().state;
    final access = CatalogAccess(session, widget.type);
    final arabic = context.type.isArabic;
    final d = _draft;
    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: d == null
            ? Text(l.edit)
            : ListenableBuilder(
                listenable: d,
                builder: (context, _) {
                  final ti = d.values['title'];
                  final title = (ti is I18n ? ti : I18n.from(ti)).of(arabic);
                  return Text(title.isEmpty ? l.catUntitled : title, overflow: TextOverflow.ellipsis);
                },
              ),
        actions: [
          if (d?.item != null)
            ListenableBuilder(
              listenable: d!,
              builder: (context, _) => Center(
                child: StatusBadge(label: catalogStatusLabel(l, d.item!.status), tone: catalogStatusTone(d.item!.status)),
              ),
            ),
          if (d?.item != null && access.canManage)
            PopupMenuButton<String>(
              key: const Key('cat.edit.menu'),
              onSelected: _menu,
              itemBuilder: (_) => [
                PopupMenuItem(value: 'duplicate', child: Text(l.catDuplicate)),
                if (access.canPublish && d!.item!.isPublished) PopupMenuItem(value: 'hide', child: Text(l.catHide)),
                if (d!.item!.isArchived || d.item!.status == CatalogStatus.hidden)
                  PopupMenuItem(value: 'restore', child: Text(l.catRestore)),
                if (!d.item!.isArchived) PopupMenuItem(value: 'archive', child: Text(l.catArchive)),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l.catDelete, style: TextStyle(color: t.critical)),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: d == null
          ? null
          : ListenableBuilder(
              listenable: d,
              builder: (context, _) => PublishBar(
                draft: d,
                supplier: access.supplier,
                canPublish: access.canPublish,
                publishing: _publishing,
                onPublish: () => _publish(context, d, (b) => mounted ? setState(() => _publishing = b) : null),
              ),
            ),
      body: PermissionGate(
        permission: access.viewPermission,
        explain: true,
        child: _loading
            ? const SkeletonList(count: 6)
            : _error != null
                ? ErrorView(error: _error!, onRetry: _load)
                : ListenableBuilder(
                    listenable: d!,
                    builder: (context, _) {
                      final schema = _schema!;
                      return ListView(padding: const EdgeInsets.only(bottom: Space.x2), children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
                          child: Row(children: [
                            Expanded(child: CompletenessBar(value: d.completeness, width: 140)),
                            if (d.item?.updatedAt != null)
                              Text(Fmt.ago(context, d.item!.updatedAt), style: context.type.caption.copyWith(color: t.ink3)),
                          ]),
                        ),
                        if (d.missing.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
                            child: MissingList(schema: schema, missing: d.missing),
                          ),
                        CatalogFormEngine(
                          sections: schema.sections,
                          values: d.values,
                          onChanged: d.set,
                          enabled: access.canManage,
                          missing: d.missing.toSet(),
                          uploader: catalogUploader(_repo),
                          showSupplier: !access.supplier,
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.md),
                        ),
                        for (final c in _childSpecs(schema)) _childTile(context, c),
                      ]);
                    },
                  ),
      ),
    );
  }

  Widget _childTile(BuildContext context, CatalogChildSpec c) {
    final l = context.l10n;
    final t = context.dg;
    final arabic = context.type.isArabic;
    final count = _children[c.key]?.length;
    final (IconData icon, String fallback) = c.isRateCalendar
        ? (Icons.calendar_month_outlined, l.catRates)
        : c.isSlots
            ? (Icons.event_available_outlined, l.catSlots)
            : c.isMenu
                ? (Icons.menu_book_outlined, l.catMenu)
                : c.isOrders
                    ? (Icons.receipt_long_outlined, l.catOrders)
                    : (Icons.meeting_room_outlined, c.key == 'rooms' ? l.catRooms : c.key);
    final label = c.label.of(arabic).isEmpty ? fallback : c.label.of(arabic);
    return DgSetRow(
      key: Key('cat.child.${c.key}'),
      title: label,
      leading: Icon(icon, color: t.ink2),
      value: count == null || c.isRateCalendar || c.isOrders ? null : '$count',
      chevron: true,
      topBorder: true,
      onTap: () async {
        final router = context.router;
        if (c.isRateCalendar) {
          await router.push(CatalogRatesRoute(hotelId: widget.id));
        } else if (c.isSlots) {
          await router.push(CatalogSlotsRoute(activityId: widget.id));
        } else if (c.isMenu) {
          await router.push(CatalogMenuRoute(restaurantId: widget.id));
        } else if (c.isOrders) {
          await router.push(const DiningRoute());
        } else {
          await router.push(CatalogChildrenRoute(type: widget.type, id: widget.id, child: c.key, itemType: c.itemType));
        }
        if (mounted) unawaited(_refreshChildren());
      },
    );
  }

  Future<void> _refreshChildren() async {
    try {
      final detail = await _repo.get(widget.type, widget.id);
      if (mounted) setState(() => _children = detail.children);
    } catch (_) {}
  }
}
