import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/api/api_error.dart';
import '../../../../core/design/components/dahab_button.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/components/dg_icons.dart';
import '../../../../core/design/components/instrument.dart';
import '../../../../core/design/spacing.dart';
import '../../../../core/design/typography.dart';
import '../../../../core/router/app_router.gr.dart';
import '../../../../l10n/l10n.dart';
import 'login_cubit.dart';

/// Staff-only sign in (prototype § Login): work email + password, Face ID on
/// registered devices, 12-hour sessions note, build stamp.
@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<LoginCubit>()..init(),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (p, c) => p.status != c.status && c.status == LoginStatus.success,
        listener: (context, _) => context.router.replaceAll([const TabsRoute()]),
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final cubit = context.read<LoginCubit>();
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, s) {
              final note = l.staffOnlyNote(s.deviceName.isEmpty ? '—' : s.deviceName);
              final cut = note.indexOf('.');
              final noteHead = cut > 0 ? note.substring(0, cut + 1) : '';
              final noteBody = cut > 0 ? note.substring(cut + 1).trim() : note;
              return ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 28, 24, 34),
                children: [
                  Row(children: [
                    DgMark(size: 24, color: t.action),
                    const SizedBox(width: 10),
                    Text(l.appNameLatin,
                        style: DahabFonts.fraunces(
                            TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: t.ink, height: 1.2))),
                  ]),
                  // Depth-chart backdrop (prototype `.sounding`), always drawn
                  // LTR. It lives in the gap between the mark and the
                  // headline and scrolls with them, so its labels can never
                  // sit under the headline or the fields (keyboard open).
                  SizedBox(
                    height: 118,
                    child: LayoutBuilder(
                      builder: (context, c) => OverflowBox(
                        minWidth: c.maxWidth + 48,
                        maxWidth: c.maxWidth + 48,
                        child: const ClipRect(child: SizedBox.expand(child: _Sounding())),
                      ),
                    ),
                  ),
                  Text(l.loginTitle, style: type.displayAt(34, height: 1.08).copyWith(color: t.ink)),
                  const SizedBox(height: 8),
                  Text(l.loginSubtitle, style: type.ui.copyWith(fontSize: 15, height: 1.5, color: t.ink2)),
                  const SizedBox(height: 24),
                  _Field(
                    label: l.email,
                    icon: DgIcons.mail,
                    hint: 'nour.hassan@dahab.eg',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textDirection: TextDirection.ltr,
                    autofillHints: const [AutofillHints.email],
                    onChanged: cubit.emailChanged,
                  ),
                  const SizedBox(height: 14),
                  _Field(
                    label: l.password,
                    icon: DgIcons.lock,
                    obscure: s.obscure,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onChanged: cubit.passwordChanged,
                    onSubmitted: (_) => cubit.submit(),
                    suffix: DgIconButton(
                      icon: DgIcons.eye,
                      size: 36,
                      color: s.obscure ? t.ink3 : t.action,
                      tooltip: l.showPassword,
                      onPressed: cubit.toggleObscure,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (s.error != null) ...[
                    Text(_message(context, s.error!), style: type.ui.copyWith(fontSize: 13, color: t.critical)),
                    const SizedBox(height: 10),
                  ],
                  DahabButton(
                    label: l.signIn,
                    expand: true,
                    loading: s.status == LoginStatus.submitting,
                    onPressed: s.canSubmit ? cubit.submit : null,
                  ),
                  if (s.faceIdAvailable) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(children: [
                        Expanded(child: Container(height: t.hairline, color: t.line)),
                        const SizedBox(width: 12),
                        Text(l.or, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
                        const SizedBox(width: 12),
                        Expanded(child: Container(height: t.hairline, color: t.line)),
                      ]),
                    ),
                    DahabButton.secondary(
                      label: l.unlockWithFaceId,
                      leading: const DgIcon(DgIcons.face),
                      expand: true,
                      onPressed: s.status == LoginStatus.submitting ? null : cubit.unlockWithBiometrics,
                    ),
                  ],
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: Radii.mdAll,
                      border: Border.all(color: t.line, width: t.hairline),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: DgIcon(DgIcons.shield, color: t.ink3),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(children: [
                            if (noteHead.isNotEmpty)
                              TextSpan(
                                  text: '$noteHead ',
                                  style: TextStyle(color: t.ink, fontWeight: FontWeight.w500)),
                            TextSpan(text: noteBody),
                          ]),
                          style: type.ui.copyWith(fontSize: 13, height: 1.5, color: t.ink2),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(l.buildStamp, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
                  ),
                ],
              );
            },
          ),
        ),
      ]),
    );
  }

  String _message(BuildContext context, ApiError e) {
    final l = context.l10n;
    return switch (e.kind) {
      ApiErrorKind.unauthorized => l.invalidCredentials,
      ApiErrorKind.network => l.errorNetwork,
      ApiErrorKind.timeout => l.errorTimeout,
      _ => e.detail?.isNotEmpty == true ? e.detail! : l.errorGeneric,
    };
  }
}

/// Login field (prototype `.field` / `.input`): 13px label, 52px surface box
/// with a leading stroke icon; the focused box takes the action border.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.icon,
    required this.onChanged,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.textDirection,
    this.autofillHints,
    this.onSubmitted,
    this.suffix,
  });

  final String label;
  final DgIcons icon;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    OutlineInputBorder border(Color c, [double w = 1]) =>
        OutlineInputBorder(borderRadius: Radii.mdAll, borderSide: BorderSide(color: c, width: w));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(label, style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.ink2)),
      const SizedBox(height: 6),
      TextField(
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textDirection: textDirection,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: type.ui.copyWith(fontSize: 16, color: t.ink),
        cursorColor: t.action,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: type.ui.copyWith(fontSize: 16, color: t.ink3),
          filled: true,
          fillColor: t.surface,
          constraints: const BoxConstraints(minHeight: 52),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 14, end: 10),
            child: DgIcon(icon, color: t.ink3),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 20),
          suffixIcon: suffix,
          border: border(t.lineStrong),
          enabledBorder: border(t.lineStrong),
          focusedBorder: border(t.action),
        ),
      ),
    ]);
  }
}

/// Bathymetric sounding behind the login head: contour ellipses, the arch
/// route dashed in coral and depth labels in mono (prototype SVG).
class _Sounding extends StatelessWidget {
  const _Sounding();

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: CustomPaint(
          painter: _SoundingPainter(
            line: t.lineStrong,
            action: t.action,
            hi: t.highlight,
            ink2: t.ink2,
            ink3: t.ink3,
            mono: context.type.mono,
          ),
        ),
      ),
    );
  }
}

class _SoundingPainter extends CustomPainter {
  _SoundingPainter({
    required this.line,
    required this.action,
    required this.hi,
    required this.ink2,
    required this.ink3,
    required this.mono,
  });

  final Color line;
  final Color action;
  final Color hi;
  final Color ink2;
  final Color ink3;
  final TextStyle mono;

  /// The band of the 390x330 viewBox shown: the contours and every depth
  /// label (labels draw up to ~10 units above their baseline).
  static const _windowTop = 92.0;
  static const _windowBottom = 204.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Fit the label band to the height, centered horizontally.
    final s = size.height / (_windowBottom - _windowTop);
    canvas.save();
    canvas.translate((size.width - 390 * s) / 2, -_windowTop * s);
    canvas.scale(s);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / s
      ..color = line;
    final top = Path()
      ..moveTo(-20, 70)
      ..cubicTo(80, 40, 160, 90, 250, 60)
      ..cubicTo(340, 30, 400, 40, 420, 70);
    canvas.drawPath(top, stroke);
    void ellipse(double cx, double cy, double rx, double ry, double deg, Paint p) {
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(deg * math.pi / 180);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2), p);
      canvas.restore();
    }

    ellipse(282, 168, 118, 92, -12, stroke);
    ellipse(290, 164, 86, 66, -14, stroke);
    ellipse(296, 160, 56, 43, -16, stroke);
    ellipse(300, 158, 28, 21, -18, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 / s
      ..color = action.withValues(alpha: 0.7));
    // Dashed arch route.
    final arch = Path()
      ..moveTo(206, 192)
      ..quadraticBezierTo(236, 174, 268, 186);
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..color = hi;
    for (final m in arch.computeMetrics()) {
      for (double d = 0; d < m.length; d += 7) {
        canvas.drawPath(m.extractPath(d, math.min(d + 3, m.length)), dash);
      }
    }
    void label(String text, double x, double y, Color c) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: mono.copyWith(fontSize: 13, color: c, height: 1)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x, y - tp.height * 0.8));
    }

    label('−30 m', 168, 104, ink3);
    label('−60 m', 214, 132, ink3);
    label('−100 m', 276, 148, ink2);
    label('arch −56 m', 112, 200, hi);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SoundingPainter old) =>
      old.line != line || old.action != action || old.hi != hi || old.ink2 != ink2 || old.ink3 != ink3;
}
