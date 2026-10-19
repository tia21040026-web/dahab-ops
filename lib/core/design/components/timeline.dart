import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../spacing.dart';

enum TimelineState { done, now, bad, future }

class TimelineEntry {
  const TimelineEntry({
    required this.title,
    this.subtitle,
    this.when,
    this.state = TimelineState.done,
    this.detail,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? when;
  final TimelineState state;

  /// Expanded content (e.g. a before/after diff).
  final Widget? detail;
  final VoidCallback? onTap;
}

/// Vertical timeline (prototype `.tl`): hollow nodes on a hairline spine,
/// filled when done, critical when it went wrong, haloed for "now".
/// The spine sits on the start edge, so RTL mirrors it.
class Timeline extends StatelessWidget {
  const Timeline({super.key, required this.entries, this.padding});

  final List<TimelineEntry> entries;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.fromSTEB(Space.xl, Space.md, Space.xl, Space.xs),
      child: Column(children: [
        for (var i = 0; i < entries.length; i++)
          _Row(entry: entries[i], last: i == entries.length - 1),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.entry, required this.last});

  final TimelineEntry entry;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final e = entry;
    final future = e.state == TimelineState.future;
    final node = Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (e.state) {
          TimelineState.done => t.ink2,
          TimelineState.bad => t.critical,
          _ => t.bg,
        },
        border: Border.all(
          width: 1.5,
          color: switch (e.state) {
            TimelineState.done => t.ink2,
            TimelineState.bad => t.critical,
            TimelineState.now => t.highlight,
            TimelineState.future => t.ink3,
          },
        ),
        boxShadow: e.state == TimelineState.now
            ? [BoxShadow(color: t.highlightWash, spreadRadius: 4)]
            : null,
      ),
    );
    final content = Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              e.title,
              style: type.bodySm.copyWith(
                fontSize: 14,
                color: future ? t.ink3 : t.ink,
                decoration: future ? TextDecoration.lineThrough : null,
                decorationColor: t.lineStrong,
              ),
            ),
            if (e.subtitle != null)
              Text(e.subtitle!, style: type.caption.copyWith(color: t.ink3)),
            if (e.detail != null) ...[Gap.h8, e.detail!],
          ]),
        ),
        if (e.when != null) ...[
          Gap.w8,
          Text(e.when!, style: type.caption.copyWith(color: t.ink3)),
        ],
      ]),
    );
    return InkWell(
      onTap: e.onTap,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            width: 16,
            child: Stack(alignment: Alignment.topCenter, children: [
              if (!last)
                PositionedDirectional(
                  top: 14,
                  bottom: 0,
                  start: 7,
                  child: Container(width: 1, color: t.lineStrong),
                ),
              node,
            ]),
          ),
          Gap.w12,
          Expanded(child: content),
        ]),
      ),
    );
  }
}
