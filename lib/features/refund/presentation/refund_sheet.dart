import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_error.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/dahab_tokens.dart';
import '../../../core/design/spacing.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/format/formatters.dart';
import '../../../core/platform/biometric_service.dart';
import '../../../l10n/l10n.dart';
import '../../booking/data/booking_models.dart';
import '../data/refund_repository.dart';

/// Presents the refund sheet (prototype § Refund). Returns the outcome, or
/// null when dismissed.
Future<RefundOutcome?> showRefundSheet(
  BuildContext context, {
  required Booking booking,
  double commissionRate = 0.15,
}) {
  return showModalBottomSheet<RefundOutcome>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: Theme.of(context).extension<DahabTokens>()?.surface,
    builder: (_) => _RefundSheet(booking: booking, commissionRate: commissionRate),
  );
}

class _RefundSheet extends StatefulWidget {
  const _RefundSheet({required this.booking, required this.commissionRate});

  final Booking booking;
  final double commissionRate;

  @override
  State<_RefundSheet> createState() => _RefundSheetState();
}

class _RefundSheetState extends State<_RefundSheet> {
  double _fraction = 0.75;
  String? _reasonCode;
  final _note = TextEditingController();
  bool _busy = false;
  ApiError? _error;
  RefundOutcome? _done;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  double get _amount => (widget.booking.amountEGP * _fraction * 100).round() / 100;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_done != null) return _Result(outcome: _done!);
    final b = widget.booking;
    final repo = GetIt.I<RefundRepository>();
    final biometrics = GetIt.I<BiometricService>();
    final reasons = [l.reasonSupplierCancelled, l.reasonWeather, l.reasonNotDelivered, l.reasonDuplicateCharge];
    final note = _note.text.trim();
    final reason = [_reasonCode, if (note.isNotEmpty) note].join(' — ');
    final canSubmit = !_busy && reason.trim().length >= 3;

    final t = context.dg;
    final type = context.type;
    final overThreshold = _amount > 5000;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Center(
            child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: t.lineStrong)),
          ),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: '${l.refund} '),
              TextSpan(text: b.bookingRef, style: type.mono.copyWith(fontSize: 20, color: t.ink)),
            ]),
            style: type.displayAt(24, height: 1.15).copyWith(color: t.ink),
          ),
          const SizedBox(height: 4),
          Text(l.refundSheetSub(Fmt.money(b.amountEGP)), style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: t.bg,
              borderRadius: Radii.mdAll,
              border: Border.all(color: t.action),
              boxShadow: [BoxShadow(color: t.actionWash, spreadRadius: 3)],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              Text(Fmt.number(_amount),
                  textDirection: TextDirection.ltr,
                  style: type.displayNumber.copyWith(fontSize: 40, color: t.ink)),
              const SizedBox(width: 8),
              Text(l.egp, style: type.ui.copyWith(fontWeight: FontWeight.w500, color: t.ink3)),
              const Spacer(),
              Flexible(
                child: Text(l.refundOf(Fmt.money(b.amountEGP)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final f in const [0.25, 0.5, 0.75, 1.0]) ...[
                if (f != 0.25) const SizedBox(width: 6),
                Expanded(
                  child: DgChip(
                    label: f == 1.0 ? l.refundFull : '${(f * 100).round()}%',
                    selected: _fraction == f,
                    height: 34,
                    expand: true,
                    onTap: () => setState(() => _fraction = f),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Expanded(
              child: Text(l.refundReason,
                  style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.ink2)),
            ),
            Text(l.required, style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.highlight)),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final r in reasons)
                DgChip(
                  label: r,
                  selected: _reasonCode == r,
                  height: 34,
                  fontSize: 13,
                  onTap: () => setState(() => _reasonCode = r),
                ),
            ],
          ),
          const SizedBox(height: 10),
          DahabTextField(
            controller: _note,
            hint: l.refundNoteHint,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
          ),
          if (overThreshold) ...[
            const SizedBox(height: 12),
            DgNotice(title: l.refundNeedsApprovalTitle, body: l.refundNeedsApproval),
          ],
          const SizedBox(height: 10),
          _Split(amount: _amount, rate: widget.commissionRate),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_friendly(context, _error!), style: type.ui.copyWith(fontSize: 13, color: t.critical)),
            ),
          const SizedBox(height: 14),
          DahabButton(
            label: l.requestApprovalWithFaceId,
            leading: const DgIcon(DgIcons.face),
            expand: true,
            loading: _busy,
            onPressed: canSubmit
                ? () async {
                    setState(() {
                      _busy = true;
                      _error = null;
                    });
                    final ok = await biometrics.authenticate(l.biometricConfirmReason);
                    if (!ok && mounted) {
                      setState(() {
                        _busy = false;
                        _error = const ApiError(kind: ApiErrorKind.unknown, detail: 'biometric');
                      });
                      return;
                    }
                    try {
                      final outcome = await repo.request(
                        bookingRef: b.bookingRef,
                        amountEGP: _amount,
                        reason: reason.trim(),
                      );
                      if (mounted) setState(() => _done = outcome);
                    } on ApiError catch (e) {
                      if (mounted) {
                        setState(() {
                          _busy = false;
                          _error = e;
                        });
                      }
                    }
                  }
                : null,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(l.refundAuditNote,
                textAlign: TextAlign.center, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
          ),
        ],
      ),
    );
  }

  String _friendly(BuildContext context, ApiError e) => friendlyError(context, e);
}

class _Split extends StatelessWidget {
  const _Split({required this.amount, required this.rate});

  final double amount;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final commission = amount * rate;
    final rows = [
      (l.refundToGuest, amount),
      (l.refundCommissionReversed, commission),
      (l.refundFromPayout, amount - commission),
    ];
    final t = context.dg;
    final type = context.type;
    return Column(children: [
      for (final (i, r) in rows.indexed)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            Expanded(child: Text(r.$1, style: type.ui.copyWith(fontSize: 13, color: t.ink2))),
            MonoText('${i == 1 ? '−' : ''}${Fmt.amount(r.$2)}', color: t.ink, size: 13),
          ]),
        ),
    ]);
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.outcome});

  final RefundOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Icon(outcome.needsApproval ? Icons.hourglass_top : Icons.check_circle,
              size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(outcome.needsApproval ? l.refundQueuedTitle : l.refundDoneTitle,
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            outcome.needsApproval ? l.refundQueuedBody : l.refundDoneBody(Fmt.money(outcome.amountEGP)),
            textAlign: TextAlign.center,
          ),
          if (outcome.approvalId != null) ...[
            const SizedBox(height: 8),
            Center(child: MonoText(outcome.approvalId!)),
          ],
          const SizedBox(height: 20),
          DahabButton(
            label: l.done,
            expand: true,
            onPressed: () => Navigator.of(context).pop(outcome),
          ),
        ]),
      ),
    );
  }
}
