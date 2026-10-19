import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/access/presentation/session_cubit.dart';
import '../design/app_theme.dart';
import '../design/components/data_card.dart';
import '../design/components/primitives.dart';
import '../design/components/status_badge.dart';
import '../design/spacing.dart';

/// Record detail as a draggable sheet: header (title, mono id, status),
/// label/value rows, free content, and an action bar. Section screens use it
/// for their detail view so list → detail never loses the list position.
Future<T?> showDetailSheet<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  String? id,
  String? status,
  List<DataField> fields = const [],
  List<Widget> children = const [],
  List<Widget> Function(BuildContext sheetContext)? actions,
}) {
  final session = context.read<SessionCubit>();
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // The sheet draws its own handle; the theme's would make two.
    showDragHandle: false,
    builder: (_) => BlocProvider.value(
      value: session,
      child: Builder(
        builder: (sheet) => DetailSheet(
          title: title,
          subtitle: subtitle,
          id: id,
          status: status,
          fields: fields,
          actions: actions?.call(sheet) ?? const [],
          children: children,
        ),
      ),
    ),
  );
}

class DetailSheet extends StatelessWidget {
  const DetailSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.id,
    this.status,
    this.fields = const [],
    this.children = const [],
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final String? id;
  final String? status;
  final List<DataField> fields;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(children: [
        Expanded(
          child: ListView(controller: scroll, children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: Space.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: t.lineStrong, borderRadius: Radii.pill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, Space.md),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: type.heading),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(subtitle!, style: type.bodySm.copyWith(color: t.ink2)),
                    if (id != null && id!.isNotEmpty) ...[Gap.h4, MonoText(id!, color: t.ink3)],
                  ]),
                ),
                if (status != null && status!.isNotEmpty)
                  StatusBadge(label: StatusBadge.humanize(status), tone: StatusBadge.toneFor(status)),
              ]),
            ),
            if (fields.isNotEmpty) ...[
              Container(height: t.hairline, color: t.line),
              FieldList(fields: fields),
            ],
            ...children,
            Gap.h24,
          ]),
        ),
        if (actions.isNotEmpty)
          SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(border: Border(top: t.hairlineSide)),
              padding: const EdgeInsets.all(Space.md),
              child: Row(children: [
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) Gap.w8,
                  Expanded(child: actions[i]),
                ],
              ]),
            ),
          ),
      ]),
    );
  }
}
