import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../spacing.dart';
import 'primitives.dart';
import 'status_badge.dart';

/// A labelled reading inside a [DataCard] or detail screen.
class DataField {
  const DataField(this.label, this.value, {this.mono = false});

  final String label;
  final String value;
  final bool mono;
}

/// List/detail row: title, mono id, a status badge and up to a few label /
/// value readings. Hairline panel, no shadow; the only colour is the status.
class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.title,
    this.subtitle,
    this.id,
    this.status,
    this.statusTone,
    this.trailing,
    this.fields = const [],
    this.onTap,
    this.leading,
    this.footer,
  });

  final String title;
  final String? subtitle;
  final String? id;
  final String? status;
  final Tone? statusTone;

  /// Usually an amount in mono.
  final String? trailing;
  final List<DataField> fields;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.xs),
      child: Panel(
        onTap: onTap,
        semanticLabel: [title, if (status != null) status!, if (trailing != null) trailing!].join(', '),
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (leading != null) ...[leading!, Gap.w12],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: type.bodyStrong),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: type.caption.copyWith(color: t.ink2)),
                if (id != null && id!.isNotEmpty) ...[Gap.h4, MonoText(id!, size: 12, color: t.ink3)],
              ]),
            ),
            Gap.w8,
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (trailing != null) MonoText(trailing!, color: t.ink, weight: FontWeight.w600),
              if (status != null && status!.isNotEmpty) ...[
                if (trailing != null) Gap.h4,
                StatusBadge(label: status!, tone: statusTone ?? StatusBadge.toneFor(status)),
              ],
            ]),
          ]),
          if (fields.isNotEmpty) ...[
            Gap.h8,
            Wrap(spacing: Space.lg, runSpacing: Space.xs, children: [
              for (final f in fields) _FieldText(field: f),
            ]),
          ],
          if (footer != null) ...[Gap.h8, footer!],
        ]),
      ),
    );
  }
}

class _FieldText extends StatelessWidget {
  const _FieldText({required this.field});

  final DataField field;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('${field.label} ', style: context.type.caption.copyWith(color: t.ink3)),
      field.mono
          ? MonoText(field.value, size: 12)
          : Text(field.value, style: context.type.caption.copyWith(color: t.ink2)),
    ]);
  }
}

/// Label / value rows for detail screens.
class FieldList extends StatelessWidget {
  const FieldList({super.key, required this.fields});

  final List<DataField> fields;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Column(children: [
      for (final f in fields)
        Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
          decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
          child: Row(children: [
            Expanded(flex: 2, child: Text(f.label, style: type.bodySm.copyWith(color: t.ink2))),
            Gap.w12,
            Expanded(
              flex: 3,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: f.mono
                    ? MonoText(f.value, color: t.ink, maxLines: 2)
                    : Text(f.value, textAlign: TextAlign.end, style: type.bodySm),
              ),
            ),
          ]),
        ),
    ]);
  }
}
