import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dahab_tokens.dart';
import 'spacing.dart';
import 'typography.dart';

/// Builds Material 3 [ThemeData] from Dahab tokens.
///
/// No elevation shadows anywhere: depth is a surface step plus a hairline.
/// Every Material component the app touches is themed here so the default
/// Material look never leaks through.
abstract final class AppTheme {
  static ThemeData build(DahabThemeId id, Locale locale) {
    final t = DahabTokens.of(id);
    final type = DahabType.forLocale(locale, ink: t.ink);
    final text = type.toTextTheme();

    final scheme = ColorScheme(
      brightness: t.brightness,
      primary: t.action,
      onPrimary: t.actionInk,
      primaryContainer: t.actionWash,
      onPrimaryContainer: t.action,
      secondary: t.highlight,
      onSecondary: t.highlightInk,
      secondaryContainer: t.highlightWash,
      onSecondaryContainer: t.highlight,
      tertiary: t.positive,
      onTertiary: t.bg,
      error: t.critical,
      onError: t.bg,
      errorContainer: t.criticalWash,
      onErrorContainer: t.critical,
      surface: t.surface,
      onSurface: t.ink,
      onSurfaceVariant: t.ink2,
      surfaceContainerLowest: t.bgSunken,
      surfaceContainerLow: t.sunken,
      surfaceContainer: t.surface,
      surfaceContainerHigh: t.raised,
      surfaceContainerHighest: t.raised,
      outline: t.lineStrong,
      outlineVariant: t.line,
      shadow: Colors.transparent,
      scrim: t.scrim,
      inverseSurface: t.ink,
      onInverseSurface: t.bg,
      inversePrimary: t.action,
      surfaceTint: Colors.transparent,
    );

    final hair = t.hairlineSide;
    final mdShape = RoundedRectangleBorder(borderRadius: Radii.mdAll, side: hair);
    const minButton = Size(Geometry.touch, Geometry.touch);
    final buttonText = type.bodyStrong.copyWith(fontSize: 15);

    WidgetStateProperty<Color?> overlay(Color base) => WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.pressed)) return base.withValues(alpha: 0.16);
          if (s.contains(WidgetState.hovered) || s.contains(WidgetState.focused)) {
            return base.withValues(alpha: 0.08);
          }
          return null;
        });

    OutlineInputBorder inputBorder(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: Radii.mdAll,
          borderSide: BorderSide(color: c, width: w),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: t.brightness,
      colorScheme: scheme,
      extensions: [t],
      scaffoldBackgroundColor: t.bg,
      canvasColor: t.bg,
      cardColor: t.surface,
      dividerColor: t.line,
      disabledColor: t.ink3,
      hintColor: t.ink3,
      splashFactory: NoSplash.splashFactory,
      highlightColor: t.ink.withValues(alpha: 0.05),
      hoverColor: t.ink.withValues(alpha: 0.04),
      focusColor: t.actionWash,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      textTheme: text,
      primaryTextTheme: text,
      fontFamily: type.ui.fontFamily,
      iconTheme: IconThemeData(color: t.ink2, size: 22),
      primaryIconTheme: IconThemeData(color: t.ink, size: 22),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: t.action,
        selectionColor: t.actionWash,
        selectionHandleColor: t.action,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: t.bg,
        foregroundColor: t.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: Space.lg,
        toolbarHeight: Geometry.topBar,
        titleTextStyle: type.title,
        iconTheme: IconThemeData(color: t.ink, size: 22),
        systemOverlayStyle: t.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: t.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: mdShape,
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(color: t.line, thickness: t.hairline, space: t.hairline),
      listTileTheme: ListTileThemeData(
        iconColor: t.ink2,
        textColor: t.ink,
        titleTextStyle: type.body,
        subtitleTextStyle: type.bodySm.copyWith(color: t.ink2),
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: Space.lg),
        minVerticalPadding: Space.md,
        minTileHeight: 56,
        shape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.sunken,
        isDense: false,
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: Space.lg, vertical: 14),
        hintStyle: type.body.copyWith(color: t.ink3),
        labelStyle: type.bodySm.copyWith(color: t.ink2),
        floatingLabelStyle: type.bodySm.copyWith(color: t.action),
        helperStyle: type.caption.copyWith(color: t.ink3),
        errorStyle: type.caption.copyWith(color: t.critical),
        prefixIconColor: t.ink3,
        suffixIconColor: t.ink3,
        border: inputBorder(t.line, t.hairline),
        enabledBorder: inputBorder(t.line, t.hairline),
        disabledBorder: inputBorder(t.line.withValues(alpha: 0.05), t.hairline),
        focusedBorder: inputBorder(t.focus, 1.5),
        errorBorder: inputBorder(t.critical, t.hairline),
        focusedErrorBorder: inputBorder(t.critical, 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
          padding: const WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(horizontal: Space.xl, vertical: Space.md)),
          textStyle: WidgetStatePropertyAll(buttonText),
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Radii.mdAll)),
          backgroundColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.disabled)) return t.ink.withValues(alpha: 0.08);
            if (s.contains(WidgetState.pressed) || s.contains(WidgetState.hovered)) {
              return t.actionHover;
            }
            return t.action;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled) ? t.ink3 : t.actionInk),
          overlayColor: overlay(t.actionInk),
          animationDuration: Motion.quick,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
          padding: const WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(horizontal: Space.xl, vertical: Space.md)),
          textStyle: WidgetStatePropertyAll(buttonText),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Radii.mdAll)),
          side: WidgetStateProperty.resolveWith((s) => BorderSide(
              color: s.contains(WidgetState.disabled) ? t.line : t.lineStrong,
              width: t.hairline)),
          foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled) ? t.ink3 : t.ink),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          overlayColor: overlay(t.ink),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minButton),
          padding: const WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(horizontal: Space.md, vertical: Space.sm)),
          textStyle: WidgetStatePropertyAll(buttonText),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Radii.mdAll)),
          foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled) ? t.ink3 : t.action),
          overlayColor: overlay(t.action),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minButton),
          foregroundColor: WidgetStatePropertyAll(t.ink),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Radii.mdAll)),
          overlayColor: overlay(t.ink),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minButton),
          textStyle: WidgetStatePropertyAll(type.bodySm.copyWith(fontWeight: FontWeight.w600)),
          side: WidgetStatePropertyAll(hair),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: Radii.mdAll)),
          backgroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? t.actionWash : Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? t.action : t.ink2),
          overlayColor: overlay(t.ink),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: t.actionWash,
        disabledColor: Colors.transparent,
        checkmarkColor: t.action,
        deleteIconColor: t.ink3,
        labelStyle: type.bodySm.copyWith(color: t.ink2, fontWeight: FontWeight.w500),
        secondaryLabelStyle: type.bodySm.copyWith(color: t.action, fontWeight: FontWeight.w600),
        side: hair,
        shape: const StadiumBorder(),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.md, vertical: Space.sm),
        labelPadding: const EdgeInsetsDirectional.symmetric(horizontal: Space.xs),
        elevation: 0,
        pressElevation: 0,
        showCheckmark: false,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.raised,
        modalBackgroundColor: t.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        shadowColor: Colors.transparent,
        modalBarrierColor: t.scrim,
        showDragHandle: true,
        dragHandleColor: t.lineStrong,
        dragHandleSize: const Size(36, 4),
        shape: RoundedRectangleBorder(borderRadius: Radii.xlTop, side: hair),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: t.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        barrierColor: t.scrim,
        shape: RoundedRectangleBorder(borderRadius: Radii.lgAll, side: hair),
        titleTextStyle: type.title,
        contentTextStyle: type.body.copyWith(color: t.ink2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: t.raised,
        contentTextStyle: type.bodySm.copyWith(color: t.ink),
        actionTextColor: t.action,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        insetPadding: const EdgeInsets.all(Space.lg),
        shape: RoundedRectangleBorder(borderRadius: Radii.mdAll, side: t.strongSide),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: t.chrome,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        height: Geometry.tabBar,
        indicatorColor: t.actionWash,
        indicatorShape: const RoundedRectangleBorder(borderRadius: Radii.pill),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((s) => type.caption.copyWith(
            color: s.contains(WidgetState.selected) ? t.ink : t.ink3,
            fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500)),
        iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? t.action : t.ink3, size: 22)),
        overlayColor: overlay(t.ink),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: t.bgSunken,
        elevation: 0,
        indicatorColor: t.actionWash,
        indicatorShape: const RoundedRectangleBorder(borderRadius: Radii.mdAll),
        selectedIconTheme: IconThemeData(color: t.action, size: 22),
        unselectedIconTheme: IconThemeData(color: t.ink3, size: 22),
        selectedLabelTextStyle: type.caption.copyWith(color: t.ink, fontWeight: FontWeight.w600),
        unselectedLabelTextStyle: type.caption.copyWith(color: t.ink3),
        labelType: NavigationRailLabelType.all,
        minWidth: 88,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.disabled)) return t.ink3;
          return s.contains(WidgetState.selected) ? t.actionInk : t.ink2;
        }),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? t.action : t.sunken),
        trackOutlineColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? t.action : t.lineStrong),
        trackOutlineWidth: WidgetStatePropertyAll(t.hairline),
        overlayColor: overlay(t.action),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? t.action : Colors.transparent),
        checkColor: WidgetStatePropertyAll(t.actionInk),
        side: BorderSide(color: t.lineStrong, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: Radii.smAll),
        overlayColor: overlay(t.action),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? t.action : t.lineStrong),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: t.action,
        inactiveTrackColor: t.line,
        thumbColor: t.action,
        overlayColor: t.actionWash,
        valueIndicatorColor: t.raised,
        valueIndicatorTextStyle: type.monoSm,
        trackHeight: 3,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: t.action,
        linearTrackColor: t.line,
        circularTrackColor: Colors.transparent,
        refreshBackgroundColor: t.raised,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: t.raised,
          borderRadius: Radii.smAll,
          border: Border.fromBorderSide(t.strongSide),
        ),
        textStyle: type.caption.copyWith(color: t.ink),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: t.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: Radii.mdAll, side: t.strongSide),
        textStyle: type.bodySm,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: t.ink,
        unselectedLabelColor: t.ink3,
        labelStyle: type.bodySm.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: type.bodySm,
        indicatorColor: t.action,
        dividerColor: t.line,
        indicatorSize: TabBarIndicatorSize.label,
        overlayColor: overlay(t.ink),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(t.lineStrong),
        radius: const Radius.circular(Radii.full),
        thickness: const WidgetStatePropertyAll(4),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: t.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: Radii.lgAll, side: hair),
        headerBackgroundColor: t.surface,
        headerForegroundColor: t.ink,
        rangeSelectionBackgroundColor: t.actionWash,
        todayBorder: BorderSide(color: t.action),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}

/// Context shorthands: `context.dg` (tokens) and `context.type` (voices).
extension DahabContext on BuildContext {
  DahabTokens get dg => Theme.of(this).extension<DahabTokens>() ?? DahabTokens.abyss;

  DahabType get type => DahabType.forLocale(Localizations.maybeLocaleOf(this) ?? const Locale('en'),
      ink: dg.ink);

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  bool get isTablet => MediaQuery.sizeOf(this).width >= Geometry.tabletBreakpoint;
}
