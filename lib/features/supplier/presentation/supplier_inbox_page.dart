import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/api/api_error.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../../booking/data/booking_models.dart';
import '../data/supplier_repository.dart';
import 'supplier_inbox_cubit.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';

/// Supplier inbox (prototype § Supplier inbox): pending confirmations with
/// accept / decline, plus confirmed and declined history.
@RoutePage()
class SupplierInboxPage extends StatelessWidget {
  const SupplierInboxPage({super.key, this.supplierId});

  /// Explicit supplier for Operations/Admin. Suppliers default to their own.
  final String? supplierId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<SupplierInboxCubit>(),
      child: _InboxView(explicitSupplierId: supplierId),
    );
  }
}

class _InboxView extends StatefulWidget {
  const _InboxView({this.explicitSupplierId});

  final String? explicitSupplierId;

  @override
  State<_InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<_InboxView> {
  @override
  void initState() {
    super.initState();
    final session = GetIt.I<SessionCubit>().state;
    final id = widget.explicitSupplierId ?? session.user?.supplierId ?? '';
    final acting = session.isSupplier ? null : widget.explicitSupplierId;
    if (id.isNotEmpty) {
      context.read<SupplierInboxCubit>().load(supplierId: id, actingSupplierId: acting);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: DgTopBar(
        title: l.navInbox,
        large: true,
        subtitle: context.select<SupplierInboxCubit, String?>((c) {
          final sup = c.state.dashboard?.supplier;
          if (sup == null) return null;
          return [sup.businessName, if (sup.category.isNotEmpty) StatusBadge.humanize(sup.category)].join(', ');
        }),
      ),
      body: BlocBuilder<SupplierInboxCubit, SupplierInboxState>(
        builder: (context, s) {
          final hasSupplier = (widget.explicitSupplierId ??
                  GetIt.I<SessionCubit>().state.user?.supplierId ??
                  '')
              .isNotEmpty;
          if (!hasSupplier) {
            return EmptyState(icon: Icons.storefront_outlined, title: l.noSupplier);
          }
          if (s.status == InboxStatus.initial || s.status == InboxStatus.loading) {
            return const SkeletonList(count: 6);
          }
          if (s.status == InboxStatus.failure && s.dashboard == null) {
            return ErrorView(
              error: s.error ?? const ApiError(kind: ApiErrorKind.unknown),
              onRetry: () {
                final session = GetIt.I<SessionCubit>().state;
                context.read<SupplierInboxCubit>().load(
                      supplierId: widget.explicitSupplierId ?? session.user?.supplierId ?? '',
                    );
              },
            );
          }
          final d = s.dashboard!;
          return RefreshIndicator(
            onRefresh: () => context.read<SupplierInboxCubit>().refresh(),
            child: ListView(
              children: [
                _Header(dashboard: d),
                _Tabs(state: s),
                for (final b in s.shown) _RequestCard(booking: b, working: s.workingId == b.id),
                if (s.shown.isEmpty) EmptyState(icon: Icons.inbox_outlined, title: l.emptyList),
                if (s.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.errorGeneric, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.dashboard});

  final SupplierDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final cells = <(String, String, String?)>[
      (l.inboxWaiting, Fmt.number(dashboard.pending().length), null),
      (l.inboxEarnings, Fmt.compact(dashboard.totalEarningsEGP), l.egp),
      (
        l.inboxReliability,
        dashboard.reliabilityScore != null ? '${dashboard.reliabilityScore!.toStringAsFixed(0)}%' : '—',
        null,
      ),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(border: Border.symmetric(horizontal: t.hairlineSide)),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : 12, top: 10, bottom: 10),
                decoration: i == 0 ? null : BoxDecoration(border: BorderDirectional(start: t.hairlineSide)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cells[i].$1,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: cells[i].$2,
                          style: type.displayNumber.copyWith(fontSize: 24, height: 1.1, color: t.ink)),
                      if (cells[i].$3 != null)
                        TextSpan(
                            text: ' ${cells[i].$3}',
                            style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.ink3)),
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.state});

  final SupplierInboxState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final cubit = context.read<SupplierInboxCubit>();
    final tabs = <(InboxTab, String, int?)>[
      (InboxTab.pending, l.inboxPending, state.dashboard?.pending().length),
      (InboxTab.confirmed, l.inboxConfirmed, null),
      (InboxTab.declined, l.inboxDeclined, null),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
      child: Row(children: [
        for (final (tab, label, count) in tabs)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: Semantics(
              selected: state.tab == tab,
              button: true,
              child: InkWell(
                onTap: () => cubit.setTab(tab),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: state.tab == tab ? t.ink : Colors.transparent, width: 2),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: label),
                      if (count != null) ...[
                        const TextSpan(text: ' '),
                        TextSpan(text: '$count', style: type.mono.copyWith(fontSize: 13)),
                      ],
                    ]),
                    style: type.ui.copyWith(
                        fontSize: 14, fontWeight: FontWeight.w500, color: state.tab == tab ? t.ink : t.ink3),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.booking, required this.working});

  final Booking booking;
  final bool working;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final cubit = context.read<SupplierInboxCubit>();
    final pending = booking.needsSupplierConfirm;
    final when = [booking.scheduledDate, booking.scheduledTime].where((e) => e.isNotEmpty).join(', ');
    Widget meta(DgIcons icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
          DgIcon(icon, size: 15, color: t.ink3),
          const SizedBox(width: 5),
          Text(text, style: type.ui.copyWith(fontSize: 13, color: t.ink2)),
        ]);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Text(
              [StatusBadge.humanize(booking.serviceType), if (booking.travelerName.isNotEmpty) booking.travelerName]
                  .join(' · '),
              style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w500, height: 1.3, color: t.ink),
            ),
          ),
          Gap.w8,
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(Fmt.number(booking.amountEGP),
                textDirection: TextDirection.ltr, style: type.displayNumber.copyWith(fontSize: 20, color: t.ink)),
            Text(l.egp, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
          ]),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 14, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
          if (when.isNotEmpty) meta(DgIcons.cal, when),
          meta(DgIcons.users, l.guestsCount(booking.passengersCount)),
          if (booking.pickupLocation?.isNotEmpty == true) meta(DgIcons.pin, booking.pickupLocation!),
          Text(booking.bookingRef,
              textDirection: TextDirection.ltr, style: type.mono.copyWith(fontSize: 13, color: t.ink3)),
        ]),
        if (pending) ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: booking.createdAt == null
                  ? const SizedBox.shrink()
                  : Row(children: [
                      DgIcon(DgIcons.snooze, size: 16, color: t.warning),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(l.requestedAgo(Fmt.ago(context, booking.createdAt)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: type.ui.copyWith(fontSize: 13, color: t.warning)),
                      ),
                    ]),
            ),
            DahabButton.secondary(
              label: l.decline,
              compact: true,
              onPressed: working ? null : () => _decline(context, cubit),
            ),
            Gap.w8,
            DahabButton(
              label: l.accept,
              compact: true,
              loading: working,
              onPressed: working ? null : () => cubit.respond(booking, accept: true),
            ),
          ]),
        ],
      ]),
    );
  }

  Future<void> _decline(BuildContext context, SupplierInboxCubit cubit) async {
    final l = context.l10n;
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.declineBookingTitle),
        content: DahabTextField(controller: controller, hint: l.declineReasonHint, maxLines: 2),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(), child: Text(l.cancel)),
          TextButton(onPressed: () => Navigator.of(c).pop(controller.text.trim()), child: Text(l.decline)),
        ],
      ),
    );
    controller.dispose();
    if (reason == null) return;
    if (!context.mounted) return;
    final ok = await cubit.respond(booking, accept: false, reason: reason.isEmpty ? 'declined' : reason);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.errorGeneric)));
    }
  }
}
