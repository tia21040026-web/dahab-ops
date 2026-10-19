import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'dg_icons.dart';
import 'primitives.dart';

/// Shared atoms of the "Lagoon Instrument" prototype: the display top bar,
/// round icon buttons, the 46x28 switch, filter chips with mono counts,
/// section heads and the small meters.

// ── Top bar ────────────────────────────────────────────────────────────────

/// Screen top bar. Tab roots get a large display title with an optional
/// ink-3 subtitle; pushed screens get a back button and a smaller title.
///
/// Leading is automatic: a back button when the route's own stack can pop
/// (never on tab roots).
class DgTopBar extends StatelessWidget implements PreferredSizeWidget {
  const DgTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.titleWidget,
    this.large,
    this.bottom,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  /// Replaces the title text (e.g. a mono booking reference).
  final Widget? titleWidget;

  /// Display-size title. Defaults to true on tab roots, false when pushed.
  final bool? large;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBack;

  @override
  Size get preferredSize =>
      Size.fromHeight((subtitle != null ? 72 : 60) + (bottom?.preferredSize.height ?? 0));

  static bool canGoBack(BuildContext context) {
    final router = context.router;
    if (router is TabsRouter) return false;
    return router.canPop(ignoreParentRoutes: true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final back = onBack != null || canGoBack(context);
    final big = large ?? !back;
    final titleStyle = big
        ? type.displayTitle.copyWith(color: t.ink)
        : type.displayAt(22, height: 1.2).copyWith(color: t.ink);
    final head = titleWidget ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: titleStyle),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: type.caption.copyWith(color: t.ink3, fontWeight: FontWeight.w400, height: 1.3)),
              ),
          ],
        );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: t.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Material(
        color: t.bg,
        child: SafeArea(
          bottom: false,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: subtitle != null ? 72 : 60,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: back ? 8 : 20, end: 12),
                child: Row(children: [
                  if (back) ...[
                    DgIconButton(
                      icon: DgIcons.back,
                      tooltip: context.l10n.back,
                      onPressed: onBack ?? () => context.router.maybePop(),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(child: Semantics(header: true, child: head)),
                  ...actions,
                ]),
              ),
            ),
            if (bottom != null) bottom!,
          ]),
        ),
      ),
    );
  }
}

/// 44px round icon button with an optional coral notification dot.
class DgIconButton extends StatelessWidget {
  const DgIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.dot = false,
    this.color,
    this.size = 44,
  });

  final DgIcons icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool dot;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final btn = Semantics(
      button: true,
      label: tooltip,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: onPressed,
          radius: size / 2,
          highlightShape: BoxShape.circle,
          containedInkWell: true,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(alignment: Alignment.center, children: [
              DgIcon(icon, color: color ?? t.ink2),
              if (dot)
                PositionedDirectional(
                  top: 10,
                  end: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: t.highlight,
                      shape: BoxShape.circle,
                      border: Border.all(color: t.bg, width: 2),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

/// Underlined text tabs (prototype `.tabs`): start-aligned, 20px apart, ink
/// underline on the selected tab and a hairline under the row. Uses the
/// ambient [DefaultTabController] unless [controller] is given.
class DgUnderlineTabs extends StatelessWidget implements PreferredSizeWidget {
  const DgUnderlineTabs({super.key, required this.tabs, this.counts, this.controller, this.onTap});

  final List<String> tabs;

  /// Optional mono count per tab (null hides it).
  final List<int?>? counts;
  final TabController? controller;
  final ValueChanged<int>? onTap;

  @override
  Size get preferredSize => const Size.fromHeight(45);

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    // Fixed to [preferredSize]: 42 tab + 2 indicator + hairline. A 44 tab
    // plus the indicator overflowed the top bar by 2px.
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
      child: TabBar(
        controller: controller,
        indicatorWeight: 2,
        onTap: onTap,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
        labelPadding: const EdgeInsetsDirectional.only(end: 20),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(color: t.ink, width: 2)),
        dividerColor: Colors.transparent,
        labelColor: t.ink,
        unselectedLabelColor: t.ink3,
        labelStyle: type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        unselectedLabelStyle: type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        tabs: [
          for (var i = 0; i < tabs.length; i++)
            Tab(
              height: 42,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(tabs[i], maxLines: 1),
                if (counts != null && i < counts!.length && counts![i] != null) ...[
                  const SizedBox(width: 6),
                  Text('${counts![i]}',
                      textDirection: TextDirection.ltr, style: type.mono.copyWith(fontSize: 13)),
                ],
              ]),
            ),
        ],
      ),
    );
  }
}

// ── Switch ─────────────────────────────────────────────────────────────────

/// The prototype's 46x28 switch: raised track, ink-3 knob; on is an action
/// wash with an action knob, or crit for kill switches.
class DgSwitch extends StatelessWidget {
  const DgSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.kill = false,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool kill;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final on = kill ? t.critical : t.action;
    final onWash = kill ? t.criticalWash : t.actionWash;
    final enabled = onChanged != null;
    final rtl = context.isRtl;
    final dur = (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ? Duration.zero : Motion.quick;
    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onChanged!(!value);
              }
            : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Padding(
            // 44 high hit area around the 28 track.
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AnimatedContainer(
              duration: dur,
              curve: Motion.easeOut,
              width: 46,
              height: 28,
              decoration: BoxDecoration(
                color: value ? onWash : t.raised2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: value ? on.withValues(alpha: kill ? 0.6 : 0.55) : t.lineStrong,
                  width: t.hairline,
                ),
              ),
              child: AnimatedAlign(
                duration: dur,
                curve: Motion.easeOut,
                alignment: (value != rtl) ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AnimatedContainer(
                    duration: dur,
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(color: value ? on : t.ink3, shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Chips ──────────────────────────────────────────────────────────────────

/// Pill chip: hairline outline, optional mono count; pressed is an action
/// wash with action ink.
class DgChip extends StatelessWidget {
  const DgChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
    this.height = 36,
    this.fontSize = 14,
    this.expand = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final int? count;
  final double height;
  final double fontSize;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final fg = selected ? t.action : t.ink2;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? t.actionWash : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? t.action.withValues(alpha: 0.5) : t.lineStrong,
            width: t.hairline,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: Container(
            constraints: BoxConstraints(minHeight: height),
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: type.ui.copyWith(fontSize: fontSize, color: fg, height: 1.2)),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Text('$count',
                      textDirection: TextDirection.ltr,
                      style: type.mono.copyWith(fontSize: 13, color: selected ? t.action : t.ink3)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A horizontal row of [DgChip]s that scrolls when it overflows.
class DgChipRow extends StatelessWidget {
  const DgChipRow({super.key, required this.children, this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 14)});

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            children[i],
          ],
        ]),
      );
}

// ── Section heads and rows ─────────────────────────────────────────────────

/// `Needs action  7 ........ See all` (15/600 title, mono count, link).
class DgSectionHead extends StatelessWidget {
  const DgSectionHead({
    super.key,
    required this.title,
    this.count,
    this.countText,
    this.linkLabel,
    this.onLink,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
  });

  final String title;
  final int? count;
  final String? countText;
  final String? linkLabel;
  final VoidCallback? onLink;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final c = countText ?? (count == null ? null : '$count');
    return Padding(
      padding: padding,
      child: Semantics(
        header: true,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: t.ink)),
          ),
          if (c != null) ...[
            Gap.w8,
            Text(c,
                textDirection: count != null ? TextDirection.ltr : null,
                style: (count != null ? type.mono : type.ui).copyWith(fontSize: 13, color: t.ink3)),
          ],
          const Spacer(),
          if (linkLabel != null)
            InkWell(
              onTap: onLink,
              borderRadius: Radii.smAll,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 32, minWidth: 44),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  widthFactor: 1,
                  child: Text(linkLabel!,
                      style: type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: t.action)),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

/// Group title for settings lists: 13/600 ink-2 with an optional quiet
/// trailing note (`Kill switches ...... On stops the service`).
class DgGroupTitle extends StatelessWidget {
  const DgGroupTitle(this.title, {super.key, this.note, this.color});

  final String title;
  final String? note;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 8),
      child: Semantics(
        header: true,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
            child: Text(title,
                style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: color ?? t.ink2)),
          ),
          if (note != null)
            Flexible(
              child: Text(note!,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
            ),
        ]),
      ),
    );
  }
}

/// Settings row: bold key with a quiet line under it, then a trailing value
/// or control, hairline on top (`.set`).
class DgSetRow extends StatelessWidget {
  const DgSetRow({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.leading,
    this.trailing,
    this.value,
    this.onTap,
    this.chevron = false,
    this.topBorder = true,
    this.background,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.minHeight = 52,
  });

  final String title;
  final String? subtitle;
  final Color? subtitleColor;

  /// Small icon before the title (inside the title line).
  final Widget? leading;
  final Widget? trailing;

  /// Mono reading on the end side.
  final String? value;
  final VoidCallback? onTap;
  final bool chevron;
  final bool topBorder;
  final Color? background;
  final EdgeInsetsGeometry padding;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final row = Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: topBorder ? Border(top: t.hairlineSide) : null,
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                if (leading != null) ...[leading!, Gap.w8],
                Flexible(
                  child: Text(title,
                      style: type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: t.ink)),
                ),
              ]),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: type.ui.copyWith(fontSize: 13, color: subtitleColor ?? t.ink3)),
            ],
          ),
        ),
        if (value != null) ...[
          Gap.w12,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: type.mono.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: t.ink)),
          ),
        ],
        if (trailing != null) ...[Gap.w12, trailing!],
        if (chevron) ...[Gap.w8, DgIcon(DgIcons.chev, size: 16, color: t.ink3)],
      ]),
    );
    if (onTap == null) return row;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}

// ── Small meters ───────────────────────────────────────────────────────────

/// Three-segment health gauge (14x6 segments, 3px gap).
class DgGauge extends StatelessWidget {
  const DgGauge({super.key, required this.segments});

  /// One tone per lit segment; missing segments render unlit.
  final List<Tone> segments;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      for (var i = 0; i < 3; i++) ...[
        if (i > 0) const SizedBox(width: 3),
        Container(
          width: 14,
          height: 6,
          decoration: BoxDecoration(
            color: i < segments.length ? t.toneInk(segments[i]) : t.raised2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ]);
  }
}

/// Thin progress bar (meters on permission groups, latency bars).
class DgMeter extends StatelessWidget {
  const DgMeter({super.key, required this.value, this.color, this.width = 90, this.height = 4});

  /// 0..1
  final double value;
  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: t.raised2, borderRadius: BorderRadius.circular(height / 2)),
      clipBehavior: Clip.antiAlias,
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        heightFactor: 1,
        child: ColoredBox(color: color ?? t.data),
      ),
    );
  }
}

/// Round initials avatar on the raised-2 fill (`.av`), or square ([square]).
class DgAvatar extends StatelessWidget {
  const DgAvatar({super.key, this.initials, this.icon, this.size = 38, this.square = false});

  final String? initials;
  final DgIcons? icon;
  final double size;
  final bool square;

  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.raised2,
        shape: square ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: square ? BorderRadius.circular(10) : null,
      ),
      child: icon != null
          ? DgIcon(icon!, size: 16, color: t.ink2)
          : Text(initials ?? '',
              textDirection: TextDirection.ltr,
              style: context.type.ui.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: t.ink2, height: 1)),
    );
  }
}

/// Sticky bottom bar on surface with a hairline top (action / save bars).
class DgBottomBar extends StatelessWidget {
  const DgBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      decoration: BoxDecoration(color: t.surface, border: Border(top: t.hairlineSide)),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 6), child: child),
      ),
    );
  }
}

/// Warning notice box: warn wash, shield icon, bold warn heading.
class DgNotice extends StatelessWidget {
  const DgNotice({super.key, required this.title, this.body, this.icon = DgIcons.shield, this.tone = Tone.warning});

  final String title;
  final String? body;
  final DgIcons icon;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: t.toneWash(tone), borderRadius: Radii.mdAll),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(top: 1), child: DgIcon(icon, color: t.toneInk(tone))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: t.toneInk(tone), height: 1.5)),
            if (body != null)
              Text(body!, style: type.ui.copyWith(fontSize: 13, color: t.ink, height: 1.5)),
          ]),
        ),
      ]),
    );
  }
}
