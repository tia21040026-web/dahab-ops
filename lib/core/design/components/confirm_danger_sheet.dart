import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../l10n/l10n.dart';
import '../../platform/biometric_service.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'dahab_button.dart';
import 'dahab_text_field.dart';
import 'primitives.dart';

/// Asks for a reason (3..500 chars, contract § Conventions), optionally a
/// biometric check, and returns the reason. Null when dismissed or the
/// biometric check fails.
///
/// [requiresApproval] shows the "needs a second admin" notice up front so
/// nobody is surprised by the 403 approval-required answer.
Future<String?> showConfirmDangerSheet(
  BuildContext context, {
  required String title,
  String? body,
  String? confirmLabel,
  bool requiresApproval = false,
  bool biometric = true,
  bool destructive = true,
  List<String> presetReasons = const [],
  BiometricService? biometrics,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // The sheet draws its own handle; the theme's would make two.
    showDragHandle: false,
    builder: (_) => ConfirmDangerSheet(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      requiresApproval: requiresApproval,
      biometric: biometric,
      destructive: destructive,
      presetReasons: presetReasons,
      biometrics: biometrics,
    ),
  );
}

class ConfirmDangerSheet extends StatefulWidget {
  const ConfirmDangerSheet({
    super.key,
    required this.title,
    this.body,
    this.confirmLabel,
    this.requiresApproval = false,
    this.biometric = true,
    this.destructive = true,
    this.presetReasons = const [],
    this.biometrics,
    this.onConfirmed,
  });

  static const minReason = 3;
  static const maxReason = 500;

  final String title;
  final String? body;
  final String? confirmLabel;
  final bool requiresApproval;
  final bool biometric;
  final bool destructive;
  final List<String> presetReasons;
  final BiometricService? biometrics;

  /// Called with the reason instead of popping (embedding / tests).
  final ValueChanged<String>? onConfirmed;

  static bool validReason(String reason) {
    final r = reason.trim();
    return r.length >= minReason && r.length <= maxReason;
  }

  @override
  State<ConfirmDangerSheet> createState() => _ConfirmDangerSheetState();
}

class _ConfirmDangerSheetState extends State<ConfirmDangerSheet> {
  final _reason = TextEditingController();
  bool _busy = false;
  bool _failed = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  BiometricService get _bio =>
      widget.biometrics ??
      (GetIt.I.isRegistered<BiometricService>()
          ? GetIt.I<BiometricService>()
          : const NoopBiometricService());

  Future<void> _confirm() async {
    final l = context.l10n;
    final reason = _reason.text.trim();
    if (!ConfirmDangerSheet.validReason(reason)) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    if (widget.biometric) {
      final ok = await _bio.authenticate(l.biometricConfirmReason);
      if (!mounted) return;
      if (!ok) {
        setState(() {
          _busy = false;
          _failed = true;
        });
        return;
      }
    }
    if (widget.onConfirmed != null) {
      widget.onConfirmed!(reason);
      setState(() => _busy = false);
    } else {
      Navigator.of(context).pop(reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final l = context.l10n;
    final valid = ConfirmDangerSheet.validReason(_reason.text);
    final tooShort = _reason.text.isNotEmpty && _reason.text.trim().length < ConfirmDangerSheet.minReason;
    final label = widget.confirmLabel ?? (widget.biometric ? l.dangerConfirmBiometric : l.confirm);
    final onPressed = valid && !_busy ? _confirm : null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.xl),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: t.lineStrong, borderRadius: Radii.pill),
            ),
          ),
          Gap.h16,
          Text(widget.title, style: type.heading),
          if (widget.body != null) ...[
            Gap.h4,
            Text(widget.body!, style: type.bodySm.copyWith(color: t.ink2)),
          ],
          if (widget.requiresApproval) ...[
            Gap.h16,
            Panel(
              key: const Key('danger.approvalNotice'),
              color: t.warningWash,
              borderColor: t.warning.withValues(alpha: 0.35),
              padding: const EdgeInsets.all(Space.md),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.how_to_reg_outlined, size: 18, color: t.warning),
                Gap.w8,
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.dangerApprovalTitle, style: type.bodyStrong.copyWith(color: t.warning)),
                    Text(l.approvalNotice, style: type.caption.copyWith(color: t.ink2)),
                  ]),
                ),
              ]),
            ),
          ],
          if (widget.presetReasons.isNotEmpty) ...[
            Gap.h16,
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              for (final r in widget.presetReasons)
                ChoiceChip(
                  label: Text(r),
                  selected: _reason.text == r,
                  onSelected: (_) => setState(() => _reason.text = r),
                ),
            ]),
          ],
          Gap.h16,
          DahabTextField(
            fieldKey: const Key('danger.reason'),
            controller: _reason,
            label: '${l.dangerReasonLabel} *',
            hint: l.dangerReasonHint,
            maxLines: 3,
            maxLength: ConfirmDangerSheet.maxReason,
            errorText: tooShort ? l.dangerReasonTooShort : null,
            onChanged: (_) => setState(() {}),
          ),
          if (_failed) ...[
            Gap.h8,
            Text(l.biometricFailed, style: type.caption.copyWith(color: t.critical)),
          ],
          Gap.h16,
          widget.destructive
              ? DahabButton.danger(
                  key: const Key('danger.confirm'),
                  label: label,
                  icon: widget.biometric ? Icons.face : null,
                  loading: _busy,
                  expand: true,
                  onPressed: onPressed,
                )
              : DahabButton(
                  key: const Key('danger.confirm'),
                  label: label,
                  icon: widget.biometric ? Icons.face : null,
                  loading: _busy,
                  expand: true,
                  onPressed: onPressed,
                ),
          Gap.h8,
          Center(child: Text(l.dangerAuditNote, style: type.caption.copyWith(color: t.ink3))),
        ]),
      ),
    );
  }
}
