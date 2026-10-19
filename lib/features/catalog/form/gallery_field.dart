import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../env/env.dart';
import '../../../l10n/l10n.dart';
import 'catalog_form_engine.dart';

/// Absolute URL for a `/api/media/...` path.
String mediaUrl(String url) {
  if (url.startsWith('http') || url.startsWith('data:')) return url;
  final base = GetIt.I.isRegistered<EnvConfig>() ? GetIt.I<EnvConfig>().apiBase : '';
  return '$base$url';
}

/// Thumbnail of a catalogue image with a quiet placeholder.
class CatalogThumb extends StatelessWidget {
  const CatalogThumb(this.url, {super.key, this.size = 56, this.radius = Radii.md});

  final String? url;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final placeholder = Container(
      width: size,
      height: size,
      color: t.sunken,
      child: Icon(Icons.image_outlined, color: t.ink3, size: size * 0.4),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url == null || url!.isEmpty
          ? placeholder
          : Image.network(mediaUrl(url!), width: size, height: size, fit: BoxFit.cover,
              errorBuilder: (_, __, ____) => placeholder),
    );
  }
}

/// Photos: camera or gallery, upload, long-press drag to reorder; the first
/// is the cover.
class GalleryField extends StatefulWidget {
  const GalleryField({
    super.key,
    required this.fieldKey,
    required this.images,
    required this.onChanged,
    this.max = 20,
    this.enabled = true,
    this.uploader,
    this.picker,
  });

  final String fieldKey;
  final List<String> images;
  final int max;
  final bool enabled;
  final CatalogUploader? uploader;

  /// Test seam; defaults to [ImagePicker].
  final ImagePicker? picker;
  final ValueChanged<List<String>> onChanged;

  @override
  State<GalleryField> createState() => _GalleryFieldState();
}

class _GalleryFieldState extends State<GalleryField> {
  int _pending = 0;

  static const _tile = 104.0;

  Future<void> _add() async {
    final l = context.l10n;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      useSafeArea: true,
      builder: (sheet) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            key: const Key('cat.gallery.camera'),
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l.catCamera),
            onTap: () => Navigator.of(sheet).pop(ImageSource.camera),
          ),
          ListTile(
            key: const Key('cat.gallery.library'),
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l.catLibrary),
            onTap: () => Navigator.of(sheet).pop(ImageSource.gallery),
          ),
        ]),
      ),
    );
    if (source == null || !mounted) return;
    final picker = widget.picker ?? ImagePicker();
    final room = widget.max - widget.images.length;
    List<XFile> files;
    try {
      if (source == ImageSource.camera) {
        final f = await picker.pickImage(source: source, maxWidth: 2400, imageQuality: 85);
        files = f == null ? const [] : [f];
      } else {
        files = await picker.pickMultiImage(maxWidth: 2400, imageQuality: 85, limit: room > 1 ? room : null);
      }
    } on PlatformException catch (e) {
      if (mounted) showErrorToast(context, e);
      return;
    }
    if (files.isEmpty || !mounted) return;
    await _upload(files.take(room).toList());
  }

  Future<void> _upload(List<XFile> files) async {
    final l = context.l10n;
    final upload = widget.uploader;
    if (upload == null) return;
    setState(() => _pending += files.length);
    var images = [...widget.images];
    for (final f in files) {
      try {
        final bytes = await f.readAsBytes();
        const maxMb = 8;
        if (bytes.lengthInBytes > maxMb * 1024 * 1024) {
          if (mounted) showToast(context, l.cmsTooLarge(maxMb), tone: Tone.warning);
          continue;
        }
        final mime = f.mimeType ?? (f.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg');
        final url = await upload(bytes, f.name, mime);
        images = [...images, url];
        widget.onChanged(images);
      } catch (e) {
        if (mounted) showErrorToast(context, e);
      } finally {
        if (mounted) setState(() => _pending--);
      }
    }
  }

  void _reorder(int from, int to) {
    final next = [...widget.images];
    final v = next.removeAt(from);
    next.insert(to, v);
    HapticFeedback.selectionClick();
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final canAdd = widget.enabled && widget.uploader != null && widget.images.length < widget.max;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: _tile + 8,
        child: ReorderableListView.builder(
          key: Key('cat.${widget.fieldKey}.list'),
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          itemCount: widget.images.length,
          onReorderItem: widget.enabled ? _reorder : (_, __) {},
          proxyDecorator: (child, __, ____) => Material(color: Colors.transparent, elevation: 6, child: child),
          footer: Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < _pending; i++)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Space.sm),
                child: Container(
                  width: _tile,
                  height: _tile,
                  decoration: BoxDecoration(color: t.sunken, borderRadius: Radii.mdAll),
                  alignment: Alignment.center,
                  child: const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
            if (canAdd)
              InkWell(
                key: Key('cat.${widget.fieldKey}.add'),
                borderRadius: Radii.mdAll,
                onTap: _add,
                child: Container(
                  width: _tile,
                  height: _tile,
                  decoration: BoxDecoration(
                    borderRadius: Radii.mdAll,
                    border: Border.all(color: t.lineStrong, width: t.hairline),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add_a_photo_outlined, color: t.action),
                    Gap.h4,
                    Text(l.catAddPhoto, style: context.type.caption.copyWith(color: t.action)),
                  ]),
                ),
              ),
          ]),
          itemBuilder: (context, i) {
            final url = widget.images[i];
            return ReorderableDelayedDragStartListener(
              key: ValueKey('img.$url.$i'),
              index: i,
              enabled: widget.enabled,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: Space.sm),
                child: Stack(children: [
                  CatalogThumb(url, size: _tile),
                  if (i == 0)
                    PositionedDirectional(
                      start: 6,
                      bottom: 6,
                      child: Container(
                        key: Key('cat.${widget.fieldKey}.cover'),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: t.action, borderRadius: Radii.pill),
                        child: Text(l.catCover, style: context.type.caption.copyWith(color: t.actionInk)),
                      ),
                    ),
                  if (widget.enabled)
                    PositionedDirectional(
                      top: 2,
                      end: 2,
                      child: Material(
                        color: t.scrim,
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: Key('cat.${widget.fieldKey}.remove.$i'),
                          customBorder: const CircleBorder(),
                          onTap: () => widget.onChanged([...widget.images]..removeAt(i)),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
            );
          },
        ),
      ),
      Gap.h4,
      Text(l.catPhotoHint(widget.images.length, widget.max), style: context.type.caption.copyWith(color: t.ink3)),
    ]);
  }
}
