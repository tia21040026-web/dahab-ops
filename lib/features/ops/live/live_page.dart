import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/components/timeline.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import 'live_repository.dart';

/// Live trips and transfers. Trips filter by status and open a day-by-day
/// itinerary; transfers show driver, plate and the last telemetry ping.
@RoutePage()
class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<LiveRepository>();
    final l = context.l10n;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ListCubit<Trip>(repo.trips)..start()),
        BlocProvider(create: (_) => ListCubit<Transfer>(repo.transfers)..start()),
      ],
      child: DefaultTabController(
        length: 2,
        child: SectionScaffold(
          title: l.sectionLive,
          permission: P.opsTrips,
          bottom: TabBar(tabs: [Tab(text: l.tabTrips), Tab(text: l.tabTransfers)]),
          body: const TabBarView(children: [_Trips(), _Transfers()]),
        ),
      ),
    );
  }
}

class _Trips extends StatelessWidget {
  const _Trips();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.watch<ListCubit<Trip>>();
    return AsyncListView<Trip>(
      header: FilterBar<String>(
        options: [
          FilterOption(null, l.all),
          for (final s in Trip.statuses) FilterOption(s, StatusBadge.humanize(s)),
        ],
        selected: cubit.state.filter('status') as String?,
        onSelected: (v) => cubit.setFilter('status', v),
      ),
      emptyIcon: Icons.map_outlined,
      itemBuilder: (context, t) => DataCard(
        title: t.title,
        id: t.id,
        status: StatusBadge.humanize(t.status),
        statusTone: StatusBadge.toneFor(t.status),
        trailing: Fmt.money(t.estimatedEGP),
        fields: [
          DataField(l.fDays, '${t.days}', mono: true),
          DataField(l.fTravelers, '${t.travelers}', mono: true),
          if (t.startDate != null) DataField(l.fScheduled, Fmt.date(context, t.startDate)),
          if (t.activeTransfers > 0) DataField(l.tabTransfers, '${t.activeTransfers}', mono: true),
        ],
        onTap: () => _openTrip(context, t),
      ),
    );
  }

  Future<void> _openTrip(BuildContext context, Trip trip) async {
    final l = context.l10n;
    final repo = GetIt.I<LiveRepository>();
    final cubit = context.read<ListCubit<Trip>>();
    await showDetailSheet<void>(
      context,
      title: trip.title,
      id: trip.id,
      status: trip.status,
      fields: [
        DataField(l.fDays, '${trip.days}', mono: true),
        DataField(l.fTravelers, '${trip.travelers}', mono: true),
        DataField(l.fEstimated, Fmt.money(trip.estimatedEGP), mono: true),
        DataField(l.fPaid, Fmt.money(trip.paidEGP), mono: true),
        DataField(l.fScheduled, '${Fmt.date(context, trip.startDate)} – ${Fmt.date(context, trip.endDate)}'),
      ],
      children: [_TripItems(tripId: trip.id)],
      actions: (sheet) => [
        PermissionGate(
          permission: 'ops.trips.manage',
          child: DahabButton.secondary(
            label: l.changeStatus,
            onPressed: () async {
              final next = await showModalBottomSheet<String>(
                context: sheet,
                builder: (c) => SafeArea(
                  child: ListView(shrinkWrap: true, children: [
                    for (final s in Trip.statuses)
                      ListTile(
                        title: Text(StatusBadge.humanize(s)),
                        trailing: s == trip.status ? const Icon(Icons.check) : null,
                        onTap: () => Navigator.of(c).pop(s),
                      ),
                  ]),
                ),
              );
              if (next == null || next == trip.status || !sheet.mounted) return;
              final reason = await showConfirmDangerSheet(sheet,
                  title: '${l.changeStatus}: ${StatusBadge.humanize(next)}',
                  biometric: next == 'CANCELLED',
                  destructive: next == 'CANCELLED');
              if (reason == null || !sheet.mounted) return;
              try {
                final updated = await repo.setTripStatus(trip.id, next);
                cubit.replaceWhere((t) => t.id == trip.id, updated);
                if (sheet.mounted) Navigator.of(sheet).pop();
              } catch (e) {
                if (sheet.mounted) showErrorToast(sheet, e);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _TripItems extends StatelessWidget {
  const _TripItems({required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder(
      future: GetIt.I<LiveRepository>().trip(tripId),
      builder: (context, snap) {
        if (snap.hasError) return ErrorView(error: snap.error!, compact: true);
        if (!snap.hasData) return const LinearProgressIndicator(minHeight: 1);
        final items = snap.data!.$2..sort((a, b) => a.day.compareTo(b.day));
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(title: l.timelineBooked, count: items.length),
          Timeline(entries: [
            for (final i in items)
              TimelineEntry(
                title: i.title,
                subtitle: '${l.fDays} ${i.day} · ${i.timeSlot} · ${Fmt.money(i.priceEGP)}',
                when: StatusBadge.humanize(i.status),
                state: switch (StatusBadge.toneFor(i.status)) {
                  Tone.critical => TimelineState.bad,
                  Tone.positive => TimelineState.done,
                  _ => TimelineState.future,
                },
                onTap: i.bookingId == null
                    ? null
                    : () => context.router.push(BookingDetailRoute(ref: i.bookingId!)),
              ),
          ]),
        ]);
      },
    );
  }
}

class _Transfers extends StatelessWidget {
  const _Transfers();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return AsyncListView<Transfer>(
      emptyIcon: Icons.directions_car_outlined,
      itemBuilder: (context, x) => DataCard(
        title: '${x.pickup} → ${x.dropoff}',
        subtitle: x.traveler,
        id: x.bookingRef,
        status: StatusBadge.humanize(x.status),
        statusTone: StatusBadge.toneFor(x.status),
        trailing: Fmt.money(x.amountEGP),
        fields: [
          DataField(l.fScheduled, x.scheduled, mono: true),
          if (x.driver.isNotEmpty) DataField(l.fDriver, x.driver),
          if (x.plate.isNotEmpty) DataField(l.fVehicle, x.plate, mono: true),
        ],
        footer: x.lastTelemetryAt == null
            ? null
            : Row(children: [
                StatusDot(
                  color: DateTime.now().difference(x.lastTelemetryAt!).inMinutes < 5 ? t.positive : t.ink3,
                  size: 6,
                  pulse: DateTime.now().difference(x.lastTelemetryAt!).inMinutes < 5,
                ),
                Text(Fmt.ago(context, x.lastTelemetryAt), style: context.type.caption.copyWith(color: t.ink3)),
              ]),
        onTap: () => showDetailSheet<void>(
          context,
          title: '${x.pickup} → ${x.dropoff}',
          subtitle: x.traveler,
          id: x.bookingRef,
          status: x.status,
          fields: [
            DataField(l.fScheduled, x.scheduled, mono: true),
            DataField(l.fTravelers, '${x.passengers}', mono: true),
            DataField(l.fDriver, x.driver.isEmpty ? '—' : x.driver),
            DataField(l.fVehicle, x.plate.isEmpty ? '—' : x.plate, mono: true),
            DataField(l.fAmount, Fmt.money(x.amountEGP), mono: true),
            if (x.marginEGP != null) DataField(l.fMargin, Fmt.money(x.marginEGP!), mono: true),
            DataField(l.fPaid, StatusBadge.humanize(x.paymentState)),
          ],
          actions: (sheet) => [
            DahabButton.secondary(
              label: l.openBooking,
              onPressed: () {
                Navigator.of(sheet).pop();
                context.router.push(BookingDetailRoute(ref: x.bookingRef));
              },
            ),
          ],
        ),
      ),
    );
  }
}
