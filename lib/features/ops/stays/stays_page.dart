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
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import 'stays_repository.dart';

/// Accommodations (activate / deactivate) and stay bookings (approve,
/// check in, complete, cancel).
@RoutePage()
class StaysPage extends StatelessWidget {
  const StaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<StaysRepository>();
    final l = context.l10n;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ListCubit<Accommodation>(repo.accommodations)..start()),
        BlocProvider(create: (_) => ListCubit<StayBooking>(repo.bookings)..start()),
      ],
      child: DefaultTabController(
        length: 2,
        child: SectionScaffold(
          title: l.sectionStays,
          permission: 'ops.accommodations.view',
          bottom: TabBar(tabs: [Tab(text: l.tabProperties), Tab(text: l.tabStayBookings)]),
          body: const TabBarView(children: [_Properties(), _Bookings()]),
        ),
      ),
    );
  }
}

class _Properties extends StatelessWidget {
  const _Properties();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final cubit = context.watch<ListCubit<Accommodation>>();
    final canManage = context.select<SessionCubit, bool>((s) => s.state.can('ops.accommodations.manage'));
    return AsyncListView<Accommodation>(
      header: FilterBar<String>(
        options: [
          FilterOption(null, l.all),
          FilterOption('true', l.statusActive),
          FilterOption('false', l.disabled),
        ],
        selected: cubit.state.filter('active') as String?,
        onSelected: (v) => cubit.setFilter('active', v),
      ),
      emptyIcon: Icons.hotel_outlined,
      itemBuilder: (context, a) => DataCard(
        title: a.name(arabic),
        subtitle: [a.type, a.area].where((x) => x.isNotEmpty).join(' · '),
        id: a.slug,
        status: a.active ? l.statusActive : l.disabled,
        statusTone: a.active ? Tone.positive : Tone.neutral,
        trailing: a.fromEGP == null ? null : Fmt.money(a.fromEGP!),
        onTap: () => showDetailSheet<void>(
          context,
          title: a.name(arabic),
          subtitle: a.type,
          id: a.id,
          status: a.active ? 'active' : 'disabled',
          fields: [
            DataField(l.fSlug, a.slug, mono: true),
            DataField(l.fArea, a.area.isEmpty ? '—' : a.area),
            if (a.rating != null) DataField(l.fRating, a.rating!.toStringAsFixed(1), mono: true),
          ],
          actions: (sheet) => [
            if (canManage)
              a.active
                  ? DahabButton.danger(
                      label: l.deactivate,
                      onPressed: () => _setActive(sheet, context, a, false),
                    )
                  : DahabButton(label: l.activate, onPressed: () => _setActive(sheet, context, a, true)),
          ],
        ),
      ),
    );
  }

  Future<void> _setActive(BuildContext sheet, BuildContext page, Accommodation a, bool active) async {
    final l = page.l10n;
    final cubit = page.read<ListCubit<Accommodation>>();
    final reason = await showConfirmDangerSheet(sheet,
        title: active ? l.activate : l.deactivate, destructive: !active, biometric: false);
    if (reason == null || !sheet.mounted) return;
    try {
      final updated = await GetIt.I<StaysRepository>().setActive(a.id, active, reason);
      cubit.replaceWhere((x) => x.id == a.id, updated);
      if (sheet.mounted) Navigator.of(sheet).pop();
    } catch (e) {
      if (sheet.mounted) showErrorToast(sheet, e);
    }
  }
}

class _Bookings extends StatelessWidget {
  const _Bookings();

  String _label(BuildContext context, String action) {
    final l = context.l10n;
    return switch (action) {
      'approve' => l.stayApprove,
      'decline' => l.stayDecline,
      'check-in' => l.stayCheckIn,
      'complete' => l.stayComplete,
      'cancel' => l.stayCancel,
      'no-show' => StatusBadge.humanize('no_show'),
      _ => action,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final cubit = context.watch<ListCubit<StayBooking>>();
    final canManage = context.select<SessionCubit, bool>((s) => s.state.can('ops.stays.manage'));
    return AsyncListView<StayBooking>(
      header: FilterBar<String>(
        options: [
          FilterOption(null, l.all),
          for (final s in const ['PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED'])
            FilterOption(s, StatusBadge.humanize(s)),
        ],
        selected: cubit.state.filter('status') as String?,
        onSelected: (v) => cubit.setFilter('status', v),
      ),
      emptyIcon: Icons.bed_outlined,
      itemBuilder: (context, b) => DataCard(
        title: b.name(arabic),
        subtitle: b.traveler,
        id: b.ref,
        status: StatusBadge.humanize(b.status),
        statusTone: StatusBadge.toneFor(b.status),
        trailing: Fmt.money(b.depositEGP),
        fields: [
          DataField(l.fCheckIn, Fmt.date(context, b.checkIn)),
          DataField(l.fNights, '${b.nights}', mono: true),
          DataField(l.fRooms, '${b.rooms}', mono: true),
        ],
        onTap: () => showDetailSheet<void>(
          context,
          title: b.name(arabic),
          subtitle: b.traveler,
          id: b.ref,
          status: b.status,
          fields: [
            DataField(l.fPhone, b.phone.isEmpty ? '—' : b.phone, mono: true),
            DataField(l.fCheckIn, Fmt.date(context, b.checkIn)),
            DataField(l.fCheckOut, Fmt.date(context, b.checkOut)),
            DataField(l.fNights, '${b.nights}', mono: true),
            DataField(l.fRooms, '${b.rooms}', mono: true),
            DataField(l.fPrice, Fmt.money(b.perNightEGP), mono: true),
            DataField(l.fDeposit, Fmt.money(b.depositEGP), mono: true),
          ],
          actions: (sheet) => [
            if (canManage)
              for (final a in b.actions.take(2))
                (a == 'decline' || a == 'cancel' || a == 'no-show')
                    ? DahabButton.secondary(label: _label(context, a), onPressed: () => _act(sheet, context, b, a))
                    : DahabButton(label: _label(context, a), onPressed: () => _act(sheet, context, b, a)),
          ],
        ),
      ),
    );
  }

  Future<void> _act(BuildContext sheet, BuildContext page, StayBooking b, String action) async {
    final cubit = page.read<ListCubit<StayBooking>>();
    final destructive = action == 'decline' || action == 'cancel' || action == 'no-show';
    final reason = await showConfirmDangerSheet(sheet,
        title: '${_label(page, action)} · ${b.ref}', destructive: destructive, biometric: action == 'cancel');
    if (reason == null || !sheet.mounted) return;
    try {
      final updated = await GetIt.I<StaysRepository>().act(b.ref, action, reason: reason);
      cubit.replaceWhere((x) => x.ref == b.ref, updated);
      if (sheet.mounted) {
        Navigator.of(sheet).pop();
        showToast(page, page.l10n.saved, tone: Tone.positive);
      }
    } catch (e) {
      if (sheet.mounted) showErrorToast(sheet, e);
    }
  }
}
