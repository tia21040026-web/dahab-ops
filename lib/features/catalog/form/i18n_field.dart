import 'package:flutter/material.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../data/catalog_models.dart';

/// Bilingual field as EN / AR tabs (mobile rule). A dot marks the language
/// that is still empty; the app language opens first.
class I18nField extends StatefulWidget {
  const I18nField({
    super.key,
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    this.multiline = false,
    this.maxLength,
    this.enabled = true,
    this.required = false,
    this.missing = false,
  });

  final String fieldKey;
  final String label;
  final I18n value;
  final bool multiline;
  final int? maxLength;
  final bool enabled;
  final bool required;
  final bool missing;
  final ValueChanged<I18n> onChanged;

  @override
  State<I18nField> createState() => _I18nFieldState();
}

class _I18nFieldState extends State<I18nField> {
  late final _en = TextEditingController(text: widget.value.en);
  late final _ar = TextEditingController(text: widget.value.ar);
  final _enFocus = FocusNode();
  final _arFocus = FocusNode();
  String? _lang;

  @override
  void didUpdateWidget(I18nField old) {
    super.didUpdateWidget(old);
    if (!_enFocus.hasFocus && _en.text != widget.value.en) _en.text = widget.value.en;
    if (!_arFocus.hasFocus && _ar.text != widget.value.ar) _ar.text = widget.value.ar;
  }

  @override
  void dispose() {
    _en.dispose();
    _ar.dispose();
    _enFocus.dispose();
    _arFocus.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(I18n(en: _en.text, ar: _ar.text));

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final lang = _lang ?? (context.type.isArabic ? 'ar' : 'en');
    final enMissing = _en.text.trim().isEmpty;
    final arMissing = _ar.text.trim().isEmpty;
    final flag = widget.missing || widget.required;

    Widget tab(String code, String text, bool missing) {
      final sel = lang == code;
      return InkWell(
        key: Key('cat.${widget.fieldKey}.tab.$code'),
        borderRadius: Radii.smAll,
        onTap: () => setState(() => _lang = code),
        child: Container(
          constraints: const BoxConstraints(minHeight: 32, minWidth: 48),
          padding: const EdgeInsets.symmetric(horizontal: Space.md),
          decoration: BoxDecoration(
            color: sel ? t.actionWash : null,
            borderRadius: Radii.smAll,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(text, style: context.type.label.copyWith(color: sel ? t.action : t.ink2)),
            if (missing) ...[
              const SizedBox(width: 6),
              Container(
                key: Key('cat.${widget.fieldKey}.missing.$code'),
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: flag ? t.warning : t.ink3, shape: BoxShape.circle),
              ),
            ],
          ]),
        ),
      );
    }

    final ar = lang == 'ar';
    final missingText = (enMissing && arMissing)
        ? null
        : (enMissing ? l.catMissingLang(l.english) : (arMissing ? l.catMissingLang(l.arabic) : null));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(
          child: Text(widget.label,
              style: context.type.label.copyWith(color: widget.missing ? t.warning : t.ink2)),
        ),
        tab('en', 'EN', enMissing),
        Gap.w4,
        tab('ar', 'عربي', arMissing),
      ]),
      Gap.h8,
      // Both stay mounted so focus/selection survive tab switches.
      Offstage(
        offstage: ar,
        child: DahabTextField(
          fieldKey: Key('cat.${widget.fieldKey}.en'),
          controller: _en,
          focusNode: _enFocus,
          enabled: widget.enabled,
          maxLines: widget.multiline ? 6 : 1,
          minLines: widget.multiline ? 3 : null,
          maxLength: widget.maxLength,
          textDirection: TextDirection.ltr,
          onChanged: (_) {
            setState(() {});
            _emit();
          },
        ),
      ),
      Offstage(
        offstage: !ar,
        child: DahabTextField(
          fieldKey: Key('cat.${widget.fieldKey}.ar'),
          controller: _ar,
          focusNode: _arFocus,
          enabled: widget.enabled,
          maxLines: widget.multiline ? 6 : 1,
          minLines: widget.multiline ? 3 : null,
          maxLength: widget.maxLength,
          textDirection: TextDirection.rtl,
          onChanged: (_) {
            setState(() {});
            _emit();
          },
        ),
      ),
      if (missingText != null) ...[
        Gap.h4,
        Text(missingText, style: context.type.caption.copyWith(color: flag ? t.warning : t.ink3)),
      ],
    ]);
  }
}
