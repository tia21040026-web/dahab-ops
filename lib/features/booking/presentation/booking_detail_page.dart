import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/dahab_tokens.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../refund/presentation/refund_sheet.dart';
import '../data/booking_models.dart';
import '../data/booking_repository.dart';
import 'booking_detail_cubit.dart';

/// Booking detail (prototype § Booking): head with status pills, facts row,
/// timeline, traveler and supplier, payments ledger and an action bar — all
/// read from `/api/operations/*` and `/api/suppliers`.
@RoutePage()
class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key, @PathParam('ref') required this.ref});

  final String ref;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<BookingDetailCubit>()..load(ref),
      child: _BookingDetailView(ref: ref),
    );
  }
}

class _BookingDetailView extends StatelessWidget {
  const _BookingDetailView({required this.ref});

  final String ref;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return BlocBuilder<BookingDetailCubit, BookingDetailState>(
      builder: (context, s) {
        final ready = s.status == BookingDetailStatus.ready;
        return Scaffold(
          appBar: DgTopBar(
            title: ref,
            titleWidget: Text(ref,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                textAlign: context.isRtl ? TextAlign.right : TextAlign.left,
                style: context.type.mono.copyWith(fontSize: 15, color: t.ink2)),
          ),
          bottomNavigationBar: ready
              ? DgBottomBar(
                  child: Row(children: [
                    Expanded(child: DahabButton.secondary(label: l.rebook, onPressed: () {})),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DahabButton(
                        label: l.reviewRefund,
                        leading: const DgIcon(DgIcons.wallet),
                        onPressed: () => showRefundSheet(context,
                            booking: s.detail!.booking, commissionRate: s.detail!.commissionRate),
                      ),
                    ),
                  ]),
                )
              : null,
          body: switch (s.status) {
            BookingDetailStatus.initial || BookingDetailStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            BookingDetailStatus.failure => Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(s.error is BookingNotFound ? l.errorNotFound : l.errorGeneric),
                  const SizedBox(height: 12),
                  DahabButton.secondary(label: l.close, onPressed: () => context.router.pop()),
                ]),
              ),
            BookingDetailStatus.ready => _Body(detail: s.detail!),
          },
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final b = detail.booking;
    final title = StatusBadge.humanize(b.serviceType);
    final when = [
      if (b.scheduledAt != null)
        DateFormat('EEE d MMM, HH:mm', Localizations.localeOf(context).languageCode).format(b.scheduledAt!)
      else
        b.scheduledDate,
      b.pickupLocation,
    ].whereType<String>().where((e) => e.isNotEmpty).join(' · ');
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: type.displayAt(26, height: 1.12).copyWith(color: t.ink)),
            const SizedBox(height: 6),
            if (when.isNotEmpty) ...[
              Text(when, style: type.ui.copyWith(fontSize: 14, color: t.ink2)),
              const SizedBox(height: 10),
            ],
            Wrap(spacing: 6, runSpacing: 6, children: [
              if (b.paymentState.isNotEmpty)
                StatusBadge(label: StatusBadge.humanize(b.paymentState), tone: StatusBadge.toneFor(b.paymentState)),
              if (b.supplierState.isNotEmpty)
                StatusBadge(label: StatusBadge.humanize(b.supplierState), tone: StatusBadge.toneFor(b.supplierState)),
            ]),
          ]),
        ),
        _Facts(detail: detail),
        _Timeline(booking: b),
        _People(detail: detail),
        _Ledger(detail: detail),
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final b = detail.booking;
    final cells = [
      (l.total, Fmt.number(b.amountEGP), l.egp),
      (l.guests, '${b.passengersCount}', null),
      (l.commissionRate, Fmt.percent(detail.commissionRate), null),
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(border: Border.symmetric(horizontal: t.hairlineSide)),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : 12, top: 10, bottom: 10),
                decoration: i == 0
                    ? null
                    : BoxDecoration(border: BorderDirectional(start: t.hairlineSide)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cells[i].$1, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: cells[i].$2, style: type.displayNumber.copyWith(fontSize: 20, color: t.ink)),
                      if (cells[i].$3 != null)
                        TextSpan(
                          text: ' ${cells[i].$3}',
                          style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.ink3),
                        ),
                    ]),
                    maxLines: 1,
                  ),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

enum _Node { done, bad, now, future }

class _Timeline extends StatelessWidget {
  const _Timeline({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final pay = booking.paymentState;
    final sup = booking.supplierState;
    final supNode = switch (sup) {
      'CONFIRMED' || 'COMPLETED' => _Node.done,
      'REJECTED' || 'CANCELLED' || 'FAILED' => _Node.bad,
      _ => _Node.now,
    };
    final steps = <(String, DateTime?, _Node)>[
      (l.timelineBooked, booking.createdAt, _Node.done),
      if (pay.isNotEmpty)
        (
          pay == 'CAPTURED' ? l.timelinePaid : StatusBadge.humanize(pay),
          booking.updatedAt,
          pay == 'CAPTURED' ? _Node.done : (booking.isFailedPayment ? _Node.bad : _Node.now),
        ),
      if (sup.isNotEmpty) (StatusBadge.humanize(sup), booking.updatedAt, supNode),
      if (booking.scheduledAt != null) (l.timelinePickup, booking.scheduledAt, _Node.future),
    ];
    String when(DateTime? d) =>
        d == null ? '' : DateFormat('d MMM HH:mm', 'en').format(d.toLocal());
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
      child: Column(children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(
                width: 16,
                child: Stack(alignment: Alignment.topCenter, children: [
                  if (i < steps.length - 1)
                    Positioned(top: 14, bottom: 0, child: Container(width: 1, color: t.lineStrong)),
                  Padding(padding: const EdgeInsets.only(top: 2), child: _dot(t, steps[i].$3)),
                ]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(steps[i].$1,
                      style: type.ui.copyWith(
                        fontSize: 14,
                        height: 1.35,
                        color: steps[i].$3 == _Node.future ? t.ink3 : t.ink,
                        decoration: steps[i].$3 == _Node.future ? TextDecoration.lineThrough : null,
                        decorationColor: t.lineStrong,
                      )),
                ),
              ),
              Gap12(child: Text(when(steps[i].$2),
                  textDirection: TextDirection.ltr,
                  style: type.mono.copyWith(fontSize: 13, color: t.ink3))),
            ]),
          ),
      ]),
    );
  }

  Widget _dot(DahabTokens t, _Node n) => Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: switch (n) {
            _Node.done => t.ink2,
            _Node.bad => t.critical,
            _ => t.bg,
          },
          border: Border.all(
            width: 1.5,
            color: switch (n) {
              _Node.done => t.ink2,
              _Node.bad => t.critical,
              _Node.now => t.highlight,
              _Node.future => t.ink3,
            },
          ),
          boxShadow: n == _Node.now ? [BoxShadow(color: t.highlightWash, spreadRadius: 4)] : null,
        ),
      );
}

/// Start padding before the trailing timestamp.
class Gap12 extends StatelessWidget {
  const Gap12({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsetsDirectional.only(start: 12), child: child);
}

class _People extends StatelessWidget {
  const _People({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final b = detail.booking;
    Widget person(Widget av, String name, String sub, List<Widget> actions) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 6, 10),
          child: Row(children: [
            av,
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: t.ink)),
                if (sub.isNotEmpty)
                  Text(sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
              ]),
            ),
            ...actions,
          ]),
        );
    void copy(String v) {
      Clipboard.setData(ClipboardData(text: v));
      showToast(context, l.copied);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.line, width: t.hairline),
      ),
      child: Column(children: [
        person(
          DgAvatar(initials: DgAvatar.initialsOf(b.travelerName)),
          b.travelerName,
          [l.traveler, if (b.travelerEmail.isNotEmpty) b.travelerEmail].join(', '),
          [
            if (b.travelerPhone.isNotEmpty)
              DgIconButton(icon: DgIcons.phone, tooltip: b.travelerPhone, onPressed: () => copy(b.travelerPhone)),
            if (b.travelerEmail.isNotEmpty)
              DgIconButton(icon: DgIcons.msg, tooltip: b.travelerEmail, onPressed: () => copy(b.travelerEmail)),
          ],
        ),
        Container(height: t.hairline, color: t.line),
        person(
          const DgAvatar(icon: DgIcons.anchor, square: true),
          detail.supplierName,
          detail.supplierReliability.isNotEmpty ? detail.supplierReliability : l.supplierLabel,
          const [],
        ),
      ]),
    );
  }
}

class _Ledger extends StatelessWidget {
  const _Ledger({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    String label(String key) => switch (key) {
          'charge' => l.ledgerCharge,
          'commission' =>
            l.ledgerCommission(Fmt.percent(detail.commissionRate)),
          'payout' => l.ledgerPayout,
          'net' => l.ledgerNet,
          _ => key,
        };
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DgSectionHead(title: l.paymentsLedger, countText: l.egp, padding: const EdgeInsets.only(bottom: 10)),
        for (final r in detail.rows)
          Container(
            margin: EdgeInsets.only(top: r.label == 'net' ? 4 : 0),
            padding: EdgeInsets.only(top: r.label == 'net' ? 10 : 7, bottom: 7),
            decoration: r.label == 'net' ? BoxDecoration(border: Border(top: t.strongSide)) : null,
            child: Row(children: [
              Expanded(
                child: Text(label(r.label),
                    style: type.ui.copyWith(
                        fontSize: 14,
                        color: r.label == 'net' ? t.ink : t.ink2,
                        fontWeight: r.label == 'net' ? FontWeight.w500 : FontWeight.w400)),
              ),
              MonoText(
                '${r.negative ? '−' : (r.label == 'charge' ? '+' : '')}${Fmt.amount(r.amount)}',
                size: 14,
                color: r.negative ? t.critical : t.ink,
              ),
            ]),
          ),
      ]),
    );
  }
}
