import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/design/app_theme.dart';
import '../../core/design/components/confirm_danger_sheet.dart';
import '../../core/design/components/dahab_button.dart';
import '../../core/design/components/dahab_text_field.dart';
import '../../core/design/components/data_card.dart';
import '../../core/design/components/empty_state.dart';
import '../../core/design/components/error_view.dart';
import '../../core/design/components/filter_bar.dart';
import '../../core/design/components/permission_gate.dart';
import '../../core/design/components/primitives.dart';
import '../../core/design/components/skeleton_list.dart';
import '../../core/design/components/status_badge.dart';
import '../../core/design/components/timeline.dart';
import '../../core/design/spacing.dart';
import '../../core/format/formatters.dart';
import '../../core/list/async_list_view.dart';
import '../../core/list/list_cubit.dart';
import '../../core/router/app_router.gr.dart';
import '../../l10n/l10n.dart';
import '../access/presentation/session_cubit.dart';
import 'cms_repository.dart';
import '../../core/router/shell_leading.dart';

/// CMS pages by status.
@RoutePage()
class CmsListPage extends StatelessWidget {
  const CmsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<CmsRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<CmsPage>(repo.pages)..start(),
      child: Builder(builder: (context) {
        final cubit = context.watch<ListCubit<CmsPage>>();
        final arabic = context.type.isArabic;
        return SectionScaffold(
          title: l.sectionCms,
          permission: 'cms.content.view',
          body: AsyncListView<CmsPage>(
            header: FilterBar<String>(
              options: [
                FilterOption(null, l.all),
                FilterOption('draft', l.cmsDraft),
                FilterOption('published', l.cmsPublished),
                FilterOption('archived', l.cmsArchived),
              ],
              selected: cubit.state.filter('status') as String?,
              onSelected: (v) => cubit.setFilter('status', v),
            ),
            emptyIcon: Icons.article_outlined,
            itemBuilder: (context, p) => DataCard(
              title: p.title(arabic),
              subtitle: p.type,
              id: '/${p.slug}',
              status: StatusBadge.humanize(p.status),
              statusTone: StatusBadge.toneFor(p.status),
              fields: [
                DataField(l.versionLabel(p.version), Fmt.ago(context, p.updatedAt)),
              ],
              onTap: () async {
                await context.router.push(CmsEditorRoute(pageId: p.id));
                if (context.mounted) await cubit.refresh();
              },
            ),
          ),
        );
      }),
    );
  }
}

/// Page editor: bilingual content, SEO, hero image upload, publish and the
/// revision history.
@RoutePage()
class CmsEditorPage extends StatefulWidget {
  const CmsEditorPage({super.key, @PathParam('id') required this.pageId});

  final String pageId;

  @override
  State<CmsEditorPage> createState() => _CmsEditorPageState();
}

class _CmsEditorPageState extends State<CmsEditorPage> {
  final _repo = GetIt.I<CmsRepository>();
  final Map<String, TextEditingController> _page = {for (final f in cmsPageFields) f: TextEditingController()};
  final Map<String, TextEditingController> _seo = {for (final f in cmsSeoFields) f: TextEditingController()};
  Map<String, dynamic> _original = const {};
  Map<String, dynamic> _originalSeo = const {};
  bool _noindex = false;
  bool _loading = true;
  bool _saving = false;
  bool _uploading = false;
  Object? _error;
  Future<List<CmsRevision>>? _revisions;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [..._page.values, ..._seo.values]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final (page, seo) = await _repo.page(widget.pageId);
      if (!mounted) return;
      for (final f in cmsPageFields) {
        _page[f]!.text = '${page[f] ?? ''}';
      }
      for (final f in cmsSeoFields) {
        _seo[f]!.text = '${seo[f] ?? ''}';
      }
      setState(() {
        _original = page;
        _originalSeo = seo;
        _noindex = seo['noindex'] == 1 || seo['noindex'] == true;
        _loading = false;
        _revisions = _repo.revisions(widget.pageId);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e;
        });
      }
    }
  }

  Map<String, dynamic> get _pageChanges => {
        for (final f in cmsPageFields)
          if (_page[f]!.text != '${_original[f] ?? ''}') f: _page[f]!.text,
      };

  Map<String, dynamic> get _seoChanges => {
        for (final f in cmsSeoFields)
          if (_seo[f]!.text != '${_originalSeo[f] ?? ''}') f: _seo[f]!.text,
        if (_noindex != (_originalSeo['noindex'] == 1 || _originalSeo['noindex'] == true)) 'noindex': _noindex ? 1 : 0,
      };

  Future<void> _save() async {
    final l = context.l10n;
    final p = _pageChanges;
    final s = _seoChanges;
    if (p.isEmpty && s.isEmpty) return;
    setState(() => _saving = true);
    try {
      if (p.isNotEmpty) _original = {..._original, ...await _repo.updatePage(widget.pageId, p)};
      if (s.isNotEmpty) {
        await _repo.updateSeo(widget.pageId, s);
        _originalSeo = {..._originalSeo, ...s};
      }
      if (mounted) {
        showToast(context, l.saved, tone: Tone.positive);
        setState(() => _revisions = _repo.revisions(widget.pageId));
      }
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _publish() async {
    final l = context.l10n;
    if (_pageChanges.isNotEmpty || _seoChanges.isNotEmpty) await _save();
    if (!mounted) return;
    final reason = await showConfirmDangerSheet(context,
        title: '${l.cmsPublish} · ${_page['title_en']!.text}', biometric: false, destructive: false,
        confirmLabel: l.cmsPublish);
    if (reason == null || !mounted) return;
    try {
      final page = await _repo.publish(widget.pageId);
      if (!mounted) return;
      setState(() => _original = {..._original, ...page});
      showToast(context, l.cmsPublishedToast, tone: Tone.positive);
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    }
  }

  Future<void> _upload() async {
    final l = context.l10n;
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2400, imageQuality: 85);
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    const maxMb = 8;
    if (bytes.lengthInBytes > maxMb * 1024 * 1024) {
      if (mounted) showToast(context, l.cmsTooLarge(maxMb), tone: Tone.warning);
      return;
    }
    setState(() => _uploading = true);
    try {
      final asset = await _repo.uploadImage(
        bytes: bytes,
        filename: file.name,
        mimeType: file.mimeType ?? (file.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg'),
        altEn: _page['title_en']!.text,
        altAr: _page['title_ar']!.text,
      );
      if (!mounted) return;
      setState(() => _page['hero_image_url']!.text = asset.url);
      showToast(context, l.cmsUploaded, tone: Tone.positive);
    } catch (e) {
      if (mounted) showErrorToast(context, e);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final session = context.watch<SessionCubit>().state;
    final canEdit = session.can('cms.content.edit');
    final canSeo = session.can('cms.seo.manage') || canEdit;
    final status = '${_original['status'] ?? 'draft'}';
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: shellLeading(context),
        automaticallyImplyLeading: false,
          title: Text(_page['title_en']!.text.isEmpty ? l.sectionCms : _page['title_en']!.text),
          actions: [
            if (!_loading) Center(child: StatusBadge(label: StatusBadge.humanize(status), tone: StatusBadge.toneFor(status))),
            Gap.w8,
          ],
          bottom: TabBar(tabs: [Tab(text: l.details), Tab(text: l.cmsSeo), Tab(text: l.cmsRevisions)]),
        ),
        bottomNavigationBar: _loading || _error != null
            ? null
            : SafeArea(
                child: Container(
                  decoration: BoxDecoration(border: Border(top: t.hairlineSide), color: t.chrome),
                  padding: const EdgeInsets.all(Space.md),
                  child: Row(children: [
                    if (canEdit)
                      Expanded(child: DahabButton.secondary(label: l.save, loading: _saving, onPressed: _save)),
                    PermissionGate(
                      permission: 'cms.content.publish',
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: Space.sm),
                        child: DahabButton(label: l.cmsPublish, icon: Icons.publish, onPressed: _publish),
                      ),
                    ),
                  ]),
                ),
              ),
        body: PermissionGate(
          permission: 'cms.content.view',
          explain: true,
          child: _loading
              ? const SkeletonList(count: 6)
              : _error != null
                  ? ErrorView(error: _error!, onRetry: _load)
                  : TabBarView(children: [
                      _content(context, canEdit),
                      _seoTab(context, canSeo),
                      _history(context),
                    ]),
        ),
      ),
    );
  }

  Widget _field(String key, String label, Map<String, TextEditingController> from,
          {bool enabled = true, int lines = 1, bool rtl = false, bool mono = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: Space.md),
        child: DahabTextField(
          label: label,
          controller: from[key],
          enabled: enabled,
          maxLines: lines,
          minLines: lines > 1 ? 3 : null,
          mono: mono,
          textDirection: rtl ? TextDirection.rtl : (mono ? TextDirection.ltr : null),
        ),
      );

  Widget _content(BuildContext context, bool canEdit) {
    final l = context.l10n;
    final t = context.dg;
    final hero = _page['hero_image_url']!.text;
    return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
      _field('title_en', l.cmsTitleEn, _page, enabled: canEdit),
      _field('title_ar', l.cmsTitleAr, _page, enabled: canEdit, rtl: true),
      _field('description_en', l.cmsDescriptionEn, _page, enabled: canEdit, lines: 3),
      _field('description_ar', l.cmsDescriptionAr, _page, enabled: canEdit, lines: 3, rtl: true),
      _field('body_en', l.cmsBodyEn, _page, enabled: canEdit, lines: 10),
      _field('body_ar', l.cmsBodyAr, _page, enabled: canEdit, lines: 10, rtl: true),
      _field('hero_image_url', l.cmsHeroImage, _page, enabled: canEdit, mono: true),
      if (hero.startsWith('http'))
        ClipRRect(
          borderRadius: Radii.mdAll,
          child: Image.network(hero, height: 160, fit: BoxFit.cover,
              errorBuilder: (_, __, ____) => Container(height: 60, color: t.sunken)),
        ),
      Gap.h8,
      PermissionGate(
        permission: 'cms.media.upload',
        child: DahabButton.secondary(
          label: l.cmsUpload,
          icon: Icons.add_photo_alternate_outlined,
          loading: _uploading,
          onPressed: _upload,
        ),
      ),
    ]);
  }

  Widget _seoTab(BuildContext context, bool canSeo) {
    final l = context.l10n;
    return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
      _field('title_en', l.cmsSeoTitleEn, _seo, enabled: canSeo),
      _field('title_ar', l.cmsSeoTitleAr, _seo, enabled: canSeo, rtl: true),
      _field('description_en', l.cmsSeoDescEn, _seo, enabled: canSeo, lines: 3),
      _field('description_ar', l.cmsSeoDescAr, _seo, enabled: canSeo, lines: 3, rtl: true),
      _field('canonical_url', l.cmsCanonical, _seo, enabled: canSeo, mono: true),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l.cmsNoindex),
        value: _noindex,
        onChanged: canSeo ? (v) => setState(() => _noindex = v) : null,
      ),
    ]);
  }

  Widget _history(BuildContext context) {
    return FutureBuilder<List<CmsRevision>>(
      future: _revisions,
      builder: (context, snap) {
        if (snap.hasError) return ErrorView(error: snap.error!);
        if (!snap.hasData) return const SkeletonList(count: 4, lines: 1);
        final revs = snap.data!;
        if (revs.isEmpty) return EmptyState(icon: Icons.history, title: context.l10n.historyEmpty);
        return ListView(children: [
          Timeline(entries: [
            for (var i = 0; i < revs.length; i++)
              TimelineEntry(
                title: '${context.l10n.versionLabel(revs[i].version)} · ${revs[i].action}',
                subtitle: revs[i].actor,
                when: Fmt.ago(context, revs[i].at),
                state: i == 0 ? TimelineState.now : TimelineState.done,
              ),
          ]),
        ]);
      },
    );
  }
}
