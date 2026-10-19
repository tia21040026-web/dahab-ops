import 'dart:convert' show JsonDecoder, JsonEncoder;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_error.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/shell_leading.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../content_repository.dart';

/// The homepage editor (`/cms/homepage`): reorder sections by drag, flip
/// visibility, and edit the bilingual titles plus the section config JSON —
/// the same powers the web's HomepageEditor has, from the phone.
@RoutePage()
class HomepageEditorPage extends StatelessWidget {
  const HomepageEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomepageSection>>(
      future: GetIt.I<ContentRepository>().homepage(),
      builder: (context, snap) {
        final l = context.l10n;
        return Scaffold(
          appBar: AppBar(
            leading: shellLeading(context),
            automaticallyImplyLeading: false,
            title: Text(l.ccTileHomepage),
          ),
          body: _HomepageBody(snap: snap),
        );
      },
    );
  }
}

class _HomepageBody extends StatefulWidget {
  const _HomepageBody({required this.snap});

  final AsyncSnapshot<List<HomepageSection>> snap;

  @override
  State<_HomepageBody> createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<_HomepageBody> {
  List<HomepageSection> _sections = const [];
  /// The last sort order persisted per section key: a drag re-persists only
  /// the rows whose order actually changed.
  Map<String, int> _savedOrders = const {};
  var _loaded = false;

  @override
  void didUpdateWidget(_HomepageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_loaded && widget.snap.hasData) _ingest(widget.snap.data!);
  }

  void _ingest(List<HomepageSection> data) {
    _sections = [...data];
    _savedOrders = {for (final s in data) s.sectionKey: s.sortOrder};
    _loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final canEdit = context.watch<SessionCubit>().state.can('cms.content.edit');
    if (widget.snap.connectionState != ConnectionState.done && !_loaded) {
      return const SkeletonList(count: 6);
    }
    if (widget.snap.hasError && !_loaded) {
      return ErrorView(error: ApiError.fromResponse(0, '${widget.snap.error}'), onRetry: () => setState(_reset));
    }
    if (!_loaded && widget.snap.data != null) _ingest(widget.snap.data!);
    if (_sections.isEmpty) {
      return Center(child: EmptyState(title: l.ccHomepageEmpty));
    }

    return RefreshIndicator(
      onRefresh: () async {
        final fresh = await GetIt.I<ContentRepository>().homepage();
        if (mounted) setState(() => _ingest(fresh));
      },
      child: Column(children: [
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) => AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final lift = animation.value.clamp(0.0, 1.0);
                return Container(
                  decoration: BoxDecoration(
                    color: t.toneWash(Tone.action).withValues(alpha: 0.5 * lift),
                    borderRadius: Radii.lgAll,
                  ),
                  child: child,
                );
              },
            ),
            itemCount: _sections.length,
            onReorderItem: _reorder,
            footer: Padding(
              padding: const EdgeInsets.all(Space.gutter),
              child: Text(l.ccHomepageHint, style: context.type.caption.copyWith(color: t.ink3)),
            ),
            itemBuilder: (context, index) {
              final section = _sections[index];
              final dirty = section.sortOrder != (_savedOrders[section.sectionKey] ?? section.sortOrder);
              return Container(
                key: ValueKey(section.sectionKey),
                padding: const EdgeInsets.fromLTRB(Space.gutter, Space.xs, Space.gutter, Space.xs),
                child: Panel(
                  padding: const EdgeInsets.all(Space.md),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      ReorderableDragStartListener(
                        index: index,
                        enabled: canEdit,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: Space.sm),
                          child: DgIcon(DgIcons.sort, size: 16, color: canEdit ? t.ink2 : t.ink3),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          section.titleEn.isNotEmpty ? section.titleEn : section.sectionKey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.type.bodyStrong.copyWith(color: t.ink),
                        ),
                      ),
                      if (dirty) StatusDot(color: t.action, size: 6),
                      Gap.w8,
                      MonoText(section.sectionKey, size: 11, color: t.ink3),
                    ]),
                    Gap.h8,
                    Row(children: [
                      Text(l.ccVisible, style: context.type.ui.copyWith(fontSize: 13, color: t.ink2)),
                      const Spacer(),
                      DgSwitch(
                        value: section.visible,
                        semanticLabel: l.ccVisible,
                        onChanged: canEdit
                            ? (next) {
                                setState(() => _sections[index] = HomepageSection({
                                      ...section.json,
                                      'visible': next ? 1 : 0,
                                    }));
                                _persist(index);
                              }
                            : null,
                      ),
                      Gap.w8,
                      DahabButton.ghost(
                        label: l.edit,
                        onPressed: canEdit ? () => _edit(index) : null,
                      ),
                    ]),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _reset() {
    _loaded = false;
  }

  /// Persists one section (visibility/title/config edits).
  Future<void> _persist(int index) async {
    final l = context.l10n;
    final section = _sections[index];
    try {
      final saved = await GetIt.I<ContentRepository>().saveSection(section);
      if (!mounted) return;
      setState(() {
        _sections[index] = saved;
        _savedOrders[saved.sectionKey] = saved.sortOrder;
      });
      showToast(context, l.saved, tone: Tone.positive);
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    }
  }

  Future<void> _reorder(int oldIndex, int newIndex) async {
    final l = context.l10n;
    setState(() {
      // onReorderItem already adjusts newIndex for the removed item.
      final moved = _sections.removeAt(oldIndex);
      _sections.insert(newIndex, moved);
      for (var i = 0; i < _sections.length; i++) {
        _sections[i] = HomepageSection({..._sections[i].json, 'sort_order': i});
      }
    });
    final repo = GetIt.I<ContentRepository>();
    var changed = 0;
    for (final section in _sections) {
      if (section.sortOrder == (_savedOrders[section.sectionKey] ?? section.sortOrder)) continue;
      try {
        final saved = await repo.saveSection(section);
        _savedOrders[saved.sectionKey] = saved.sortOrder;
        changed++;
      } on ApiError {
        if (mounted) showErrorToast(context, l.noticeFailed);
        break;
      }
    }
    if (mounted && changed > 0) showToast(context, l.ccHomepageReordered, tone: Tone.positive);
    if (mounted) setState(() {});
  }

  Future<void> _edit(int index) async {
    final l = context.l10n;
    final section = _sections[index];
    final saved = await showSectionEditorSheet(context, section);
    if (saved == null || !mounted) return;
    setState(() => _sections[index] = saved);
    try {
      final persisted = await GetIt.I<ContentRepository>().saveSection(saved);
      if (!mounted) return;
      setState(() {
        _sections[index] = persisted;
        _savedOrders[persisted.sectionKey] = persisted.sortOrder;
      });
      showToast(context, l.saved, tone: Tone.positive);
    } on ApiError catch (e) {
      if (!mounted) return;
      showErrorToast(context, e);
    }
  }
}

/// Bilingual titles + the section `config` JSON, in one bottom sheet.
Future<HomepageSection?> showSectionEditorSheet(
    BuildContext context, HomepageSection section) async {
  final l = context.l10n;
  final tEn = TextEditingController(text: section.titleEn);
  final tAr = TextEditingController(text: section.titleAr);
  final cfg =
      TextEditingController(text: const JsonEncoder.withIndent('  ').convert(section.config));
  String? cfgError;

  final result = await showModalBottomSheet<HomepageSection>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheet) {
      var editing = section;
      return StatefulBuilder(
        builder: (sheet, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheet).bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(section.sectionKey,
                  style: sheet.type.title.copyWith(color: sheet.dg.ink)),
              Gap.h12,
              DahabTextField(label: l.ccTitleEn, controller: tEn),
              Gap.h12,
              DahabTextField(label: l.ccTitleAr, controller: tAr, textDirection: TextDirection.rtl),
              Gap.h12,
              DahabTextField(
                label: l.ccConfigJson,
                controller: cfg,
                mono: true,
                maxLines: 8,
                errorText: cfgError,
              ),
              Gap.h16,
              DahabButton(
                label: l.save,
                expand: true,
                onPressed: () {
                  Object? parsed;
                  try {
                    parsed = const JsonDecoder().convert(cfg.text);
                  } catch (_) {
                    setSheet(() => cfgError = l.ccInvalidJson);
                    return;
                  }
                  if (parsed is! Map<String, dynamic>) {
                    setSheet(() => cfgError = l.ccConfigMustBeObject);
                    return;
                  }
                  editing = HomepageSection({
                    ...section.json,
                    'title_en': tEn.text.trim(),
                    'title_ar': tAr.text.trim(),
                    'config': parsed,
                  });
                  Navigator.of(sheet).pop(editing);
                },
              ),
            ]),
          ),
        ),
      );
    },
  );
  return result;
}

