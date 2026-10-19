import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/kpi_card.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import 'commerce_repository.dart';

/// Commerce: money readings, the signed ledger (all / refunds) and failed
/// payments. Refunds start from a booking (Booking → Refund) so the amount
/// is always tied to a reference.
@RoutePage()
class CommercePage extends StatelessWidget {
  const CommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<CommerceRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<LedgerEntry>(repo.ledger)..start(),
      child: SectionScaffold(
        title: l.sectionCommerce,
        permission: 'ops.commerce.view',
        body: const _CommerceView(),
      ),
    );
  }
}

class _CommerceView extends StatefulWidget {
  const _CommerceView();

  @override
  State<_CommerceView> createState() => _CommerceViewState();
}

class _CommerceViewState extends State<_CommerceView> {
  late Future<PaymentsSummary> _summary = GetIt.I<CommerceRepository>().summary();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final cubit = context.watch<ListCubit<LedgerEntry>>();
    final kind = cubit.state.filter('kind') as String?;
    return AsyncListView<LedgerEntry>(
      header: Column(children: [
        FutureBuilder<PaymentsSummary>(
          future: _summary,
          builder: (context, snap) {
            final s = snap.data;
            if (s == null) return const SizedBox(height: Space.sm);
            return Padding(
              padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
              child: Column(children: [
                Row(children: [
                  Expanded(child: KpiCard(label: l.captured, value: s.captured, caption: 'EGP')),
                  Gap.w8,
                  Expanded(child: KpiCard(label: l.refunded, value: s.refunded, caption: 'EGP')),
                ]),
                Gap.h8,
                Row(children: [
                  Expanded(child: KpiCard(label: l.commission, value: s.commission, caption: 'EGP')),
                  Gap.w8,
                  Expanded(
                    child: KpiCard(
                      label: l.tabFailedPayments,
                      value: s.failed.length,
                      tone: s.failed.isEmpty ? Tone.neutral : Tone.critical,
                      onTap: s.failed.isEmpty ? null : () => _failed(context, s),
                    ),
                  ),
                ]),
                if (s.ledgerValid != null) ...[
                  Gap.h8,
                  Row(children: [
                    StatusDot(color: s.ledgerValid! ? t.positive : t.critical),
                    Text(s.ledgerValid! ? l.ledgerIntact : l.ledgerBroken,
                        style: context.type.caption.copyWith(color: s.ledgerValid! ? t.ink2 : t.critical)),
                    const Spacer(),
                    Text('${l.escrow} ', style: context.type.caption.copyWith(color: t.ink3)),
                    MonoText(Fmt.money(s.escrow)),
                  ]),
                ],
              ]),
            );
          },
        ),
        FilterBar<String>(
          options: [FilterOption(null, l.tabLedger), FilterOption('refunds', l.tabRefunds)],
          selected: kind,
          onSelected: (v) {
            setState(() => _summary = GetIt.I<CommerceRepository>().summary());
            cubit.setFilter('kind', v);
          },
        ),
      ]),
      emptyIcon: Icons.receipt_long_outlined,
      itemBuilder: (context, e) => DataCard(
        title: StatusBadge.humanize(e.type),
        subtitle: '${e.debit} → ${e.credit}',
        id: e.bookingRef.isEmpty ? e.transactionId : e.bookingRef,
        trailing: Fmt.money(e.amountEGP),
        status: StatusBadge.humanize(e.status),
        statusTone: StatusBadge.toneFor(e.status),
        fields: [DataField(l.fDate, Fmt.dateTime(context, e.at))],
        onTap: () => showDetailSheet<void>(
          context,
          title: StatusBadge.humanize(e.type),
          id: e.id,
          status: e.status,
          fields: [
            DataField(l.fAmount, Fmt.money(e.amountEGP), mono: true),
            DataField(l.fBooking, e.bookingRef.isEmpty ? '—' : e.bookingRef, mono: true),
            DataField(l.fDebit, e.debit, mono: true),
            DataField(l.fCredit, e.credit, mono: true),
            DataField(l.fDate, Fmt.dateTime(context, e.at)),
            DataField('Tx', e.transactionId, mono: true),
            DataField('Hash', Fmt.shortId(e.hash, keep: 16), mono: true),
          ],
          actions: (sheet) => [
            if (e.bookingRef.isNotEmpty)
              PermissionGate(
                permission: 'ops.commerce.view',
                child: DahabButton.secondary(
                  label: l.openBooking,
                  onPressed: () {
                    Navigator.of(sheet).pop();
                    context.router.push(BookingDetailRoute(ref: e.bookingRef));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _failed(BuildContext context, PaymentsSummary s) {
    final l = context.l10n;
    showDetailSheet<void>(
      context,
      title: l.tabFailedPayments,
      children: [
        for (final f in s.failed)
          DataCard(
            title: f.bookingRef,
            trailing: Fmt.money(f.amountEGP),
            status: StatusBadge.humanize(f.paymentState),
            onTap: () {
              Navigator.of(context).pop();
              context.router.push(BookingDetailRoute(ref: f.bookingRef));
            },
          ),
      ],
    );
  }
}
