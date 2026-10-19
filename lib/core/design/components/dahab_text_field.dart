import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../spacing.dart';

/// Labelled input: the label sits above the field (instrument style), never
/// floats inside it.
class DahabTextField extends StatelessWidget {
  const DahabTextField({
    super.key,
    this.label,
    this.controller,
    this.hint,
    this.helper,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.mono = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffix,
    this.autofillHints,
    this.inputFormatters,
    this.focusNode,
    this.textDirection,
    this.fieldKey,
  });

  final String? label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final bool mono;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final bool enabled;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final style = mono ? context.type.monoMd.copyWith(color: t.ink, fontSize: 15) : context.type.body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: context.type.label.copyWith(color: t.ink2)),
          Gap.h8,
        ],
        TextFormField(
          key: fieldKey,
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscure,
          maxLines: obscure ? 1 : maxLines,
          minLines: minLines,
          maxLength: maxLength,
          autofocus: autofocus,
          enabled: enabled,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          textDirection: textDirection,
          style: style,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            helperMaxLines: 3,
            errorText: errorText,
            errorMaxLines: 3,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
            suffixIcon: suffix,
            counterStyle: context.type.caption.copyWith(color: t.ink3),
          ),
        ),
      ],
    );
  }
}
