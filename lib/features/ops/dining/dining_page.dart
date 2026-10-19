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
import '../../../core/design/components/section_header.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import 'dining_repository.dart';

/// Dining orders: advance through the kitchen flow, or cancel with a reason.
@RoutePage()
class DiningPage extends StatelessWidget {
  const DiningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<DiningRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<DiningOrder>(repo.orders)..start(),
      child: Builder(builder: (context) {
        final cubit = context.watch<ListCubit<DiningOrder>>();
        final arabic = context.type.isArabic;
        return SectionScaffold(
          title: l.sectionDining,
          permission: 'ops.dining.view',
          body: AsyncListView<DiningOrder>(
            header: FilterBar<String>(
              options: [
                FilterOption(null, l.all),
                for (final s in DiningOrder.statuses) FilterOption(s, StatusBadge.humanize(s)),
              ],
              selected: cubit.state.filter('status') as String?,
              onSelected: (v) => cubit.setFilter('status', v),
            ),
            emptyIcon: Icons.restaurant_outlined,
            itemBuilder: (context, o) => DataCard(
              title: o.venue(arabic),
              subtitle: '${o.lines.length} × · ${StatusBadge.humanize(o.fulfillment)}',
              id: o.ref,
              status: StatusBadge.humanize(o.status),
              statusTone: StatusBadge.toneFor(o.status),
              trailing: Fmt.money(o.totalEGP),
              fields: [
                DataField(l.fCreated, Fmt.ago(context, o.createdAt)),
                if (o.etaMinutes != null) DataField(l.fEta, l.slaMinutes(o.etaMinutes!), mono: true),
              ],
              onTap: () => _open(context, o),
            ),
          ),
        );
      }),
    );
  }

  void _open(BuildContext context, DiningOrder o) {
    final l = context.l10n;
    final t = context.dg;
    final arabic = context.type.isArabic;
    final cubit = context.read<ListCubit<DiningOrder>>();
    final canManage = context.read<SessionCubit>().can('ops.dining.manage');
    Future<void> run(BuildContext sheet, Future<DiningOrder> Function() action) async {
      try {
        final updated = await action();
        cubit.replaceWhere((x) => x.id == o.id, updated);
        if (sheet.mounted) Navigator.of(sheet).pop();
      } catch (e) {
        if (sheet.mounted) showErrorToast(sheet, e);
      }
    }

    showDetailSheet<void>(
      context,
      title: o.venue(arabic),
      id: o.ref,
      status: o.status,
      fields: [
        DataField(l.fType, StatusBadge.humanize(o.fulfillment)),
        if (o.address.isNotEmpty) DataField(l.fDropoff, o.address),
        DataField(l.fAmount, Fmt.money(o.totalEGP), mono: true),
        DataField(l.fCreated, Fmt.dateTime(context, o.createdAt)),
        if (o.notes.isNotEmpty) DataField(l.fMessage, o.notes),
      ],
      children: [
        SectionHeader(title: l.details, count: o.lines.length),
        for (final line in o.lines)
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
            leading: MonoText('${line['quantity'] ?? 1}×', color: t.ink),
            title: Text('${(arabic ? line['nameAr'] : null) ?? line['nameEn'] ?? line['menuItemId']}'),
            trailing: MonoText(Fmt.money((line['lineTotalEGP'] as num?) ?? 0)),
          ),
      ],
      actions: (sheet) => [
        if (canManage && o.cancellable)
          DahabButton.secondary(
            label: l.cancelOrder,
            onPressed: () async {
              final reason = await showConfirmDangerSheet(sheet, title: l.cancelOrder, biometric: false);
              if (reason == null || !sheet.mounted) return;
              await run(sheet, () => GetIt.I<DiningRepository>().cancel(o.id, reason));
            },
          ),
        if (canManage && o.next != null)
          DahabButton(
            label: l.advanceTo(StatusBadge.humanize(o.next)),
            onPressed: () => run(sheet, () => GetIt.I<DiningRepository>().setStatus(o.id, o.next!)),
          ),
      ],
    );
  }
}
