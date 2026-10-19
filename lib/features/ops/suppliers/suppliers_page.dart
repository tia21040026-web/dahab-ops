import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import 'suppliers_repository.dart';

/// Supplier directory with reliability, opening into the supplier portal
/// as that supplier.
@RoutePage()
class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<SuppliersRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<OpsSupplier>(repo.suppliers)..start(),
      child: Builder(builder: (context) {
        final cubit = context.watch<ListCubit<OpsSupplier>>();
        final arabic = context.type.isArabic;
        return SectionScaffold(
          title: l.sectionSuppliers,
          permission: 'ops.suppliers.view',
          body: AsyncListView<OpsSupplier>(
            header: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(Space.gutter, Space.md, Space.gutter, 0),
                child: DahabTextField(
                  hint: l.search,
                  prefixIcon: Icons.search,
                  textInputAction: TextInputAction.search,
                  onSubmitted: cubit.setSearch,
                ),
              ),
              FilterBar<String>(
                options: [
                  FilterOption(null, l.all),
                  for (final s in const ['Active', 'Pending_Verification', 'Suspended'])
                    FilterOption(s, StatusBadge.humanize(s)),
                ],
                selected: cubit.state.filter('status') as String?,
                onSelected: (v) => cubit.setFilter('status', v),
              ),
            ]),
            emptyIcon: Icons.storefront_outlined,
            itemBuilder: (context, s) => DataCard(
              title: s.name(arabic),
              subtitle: [s.category, s.area].where((x) => x.isNotEmpty).join(' · '),
              status: StatusBadge.humanize(s.status),
              statusTone: StatusBadge.toneFor(s.status),
              trailing: s.confirmationRate == null ? null : Fmt.percent(s.confirmationRate! > 1 ? s.confirmationRate! / 100 : s.confirmationRate!),
              fields: [
                if (s.rating != null) DataField(l.fRating, s.rating!.toStringAsFixed(1), mono: true),
                if (s.totalBookings > 0) DataField(l.tabBookings, '${s.totalBookings}', mono: true),
                if (s.pendingCount > 0) DataField(l.pending, '${s.pendingCount}', mono: true),
              ],
              onTap: () => _open(context, s),
            ),
          ),
        );
      }),
    );
  }

  void _open(BuildContext context, OpsSupplier s) {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    String pct(num? v) => v == null ? '—' : Fmt.percent(v > 1 ? v / 100 : v);
    showDetailSheet<void>(
      context,
      title: s.name(arabic),
      subtitle: s.category,
      id: s.id,
      status: s.status,
      fields: [
        DataField(l.fArea, s.area.isEmpty ? '—' : s.area),
        DataField(l.fTier, s.tier.isEmpty ? '—' : s.tier),
        DataField(l.fPhone, s.phone.isEmpty ? '—' : s.phone, mono: true),
        DataField(l.fRating, s.rating == null ? '—' : '${s.rating!.toStringAsFixed(1)} (${s.reviews})', mono: true),
        DataField(l.fConfirmationRate, pct(s.confirmationRate), mono: true),
        DataField(l.fRejectionRate, pct(s.rejectionRate), mono: true),
        if (s.license.isNotEmpty) DataField('License', s.license, mono: true),
      ],
      actions: (sheet) => [
        DahabButton(
          label: l.openPortal,
          icon: Icons.storefront,
          onPressed: () {
            Navigator.of(sheet).pop();
            context.router.push(SupplierPortalRoute(supplierId: s.id));
          },
        ),
      ],
    );
  }
}
