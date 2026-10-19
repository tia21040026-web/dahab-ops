import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
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
import 'pricing_repository.dart';

/// SKUs with base prices and the next 30 days of inventory slots. Every
/// price change asks for a reason.
@RoutePage()
class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  static const serviceTypes = ['TRANSFER', 'ACTIVITY', 'DIVING', 'SAFARI', 'STAY', 'RENTAL'];

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<PricingRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<Sku>(repo.skus)..start(),
      child: Builder(builder: (context) {
        final cubit = context.watch<ListCubit<Sku>>();
        final arabic = context.type.isArabic;
        return SectionScaffold(
          title: l.sectionPricing,
          permission: 'ops.pricing.view',
          body: AsyncListView<Sku>(
            header: FilterBar<String>(
              options: [
                FilterOption(null, l.all),
                for (final s in serviceTypes) FilterOption(s, StatusBadge.humanize(s)),
              ],
              selected: cubit.state.filter('serviceType') as String?,
              onSelected: (v) => cubit.setFilter('serviceType', v),
            ),
            emptyIcon: Icons.sell_outlined,
            itemBuilder: (context, s) => DataCard(
              title: s.title(arabic),
              subtitle: s.supplier,
              id: s.id,
              trailing: Fmt.money(s.basePriceEGP),
              status: s.active ? null : context.l10n.disabled,
              fields: [
                DataField(l.fService, StatusBadge.humanize(s.serviceType)),
                DataField(l.fCapacity, '${s.capacity}', mono: true),
              ],
              onTap: () => _open(context, s),
            ),
          ),
        );
      }),
    );
  }

  void _open(BuildContext context, Sku sku) {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final cubit = context.read<ListCubit<Sku>>();
    final canManage = context.read<SessionCubit>().can('ops.pricing.manage');
    showDetailSheet<void>(
      context,
      title: sku.title(arabic),
      subtitle: sku.supplier,
      id: sku.id,
      fields: [
        DataField(l.fBasePrice, Fmt.money(sku.basePriceEGP), mono: true),
        DataField(l.fCapacity, '${sku.capacity}', mono: true),
        DataField(l.fService, StatusBadge.humanize(sku.serviceType)),
      ],
      children: [_Slots(sku: sku, canManage: canManage)],
      actions: (sheet) => [
        if (canManage)
          DahabButton(
            label: l.editPrice,
            icon: Icons.edit_outlined,
            onPressed: () async {
              final price = await promptPrice(sheet, current: sku.basePriceEGP, title: sku.title(arabic));
              if (price == null || !sheet.mounted) return;
              try {
                final reason = await showConfirmDangerSheet(sheet,
                    title: '${l.editPrice}: ${Fmt.money(sku.basePriceEGP)} → ${Fmt.money(price)}',
                    biometric: false,
                    destructive: false);
                if (reason == null) return;
                await GetIt.I<PricingRepository>().setSkuPrice(sku.id, price, reason);
                cubit.replaceWhere((x) => x.id == sku.id, sku.withPrice(price));
                if (sheet.mounted) {
                  Navigator.of(sheet).pop();
                  showToast(context, l.priceChanged, tone: Tone.positive);
                }
              } catch (e) {
                if (sheet.mounted) showErrorToast(sheet, e);
              }
            },
          ),
      ],
    );
  }
}

/// Asks for a new EGP amount. Null when cancelled.
Future<num?> promptPrice(BuildContext context, {required num current, required String title}) {
  final controller = TextEditingController(text: '$current');
  final l = context.l10n;
  return showDialog<num>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: DahabTextField(
        label: '${l.fPrice} (EGP)',
        controller: controller,
        mono: true,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(c).pop(), child: Text(l.cancel)),
        TextButton(
          onPressed: () {
            final v = num.tryParse(controller.text.trim());
            if (v != null && v > 0) Navigator.of(c).pop(v);
          },
          child: Text(l.confirm),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}

class _Slots extends StatefulWidget {
  const _Slots({required this.sku, required this.canManage});

  final Sku sku;
  final bool canManage;

  @override
  State<_Slots> createState() => _SlotsState();
}

class _SlotsState extends State<_Slots> {
  late Future<List<InventorySlot>> _future = GetIt.I<PricingRepository>().inventory(widget.sku.id);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    return FutureBuilder<List<InventorySlot>>(
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) return ErrorView(error: snap.error!, compact: true);
        if (!snap.hasData) return const LinearProgressIndicator(minHeight: 1);
        final slots = snap.data!;
        return Column(children: [
          SectionHeader(title: l.inventorySlots, count: slots.length),
          for (final s in slots)
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
              title: MonoText('${s.date}  ${s.time}', color: t.ink),
              subtitle: Text('${l.fReserved} ${s.reserved}/${s.total}${s.held > 0 ? ' · +${s.held}' : ''}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                StatusBadge(label: StatusBadge.humanize(s.status), tone: StatusBadge.toneFor(s.status)),
                Gap.w8,
                MonoText(Fmt.money(s.priceEGP), color: t.ink),
              ]),
              onTap: !widget.canManage
                  ? null
                  : () async {
                      final price = await promptPrice(context, current: s.priceEGP, title: '${s.date} ${s.time}');
                      if (price == null || !context.mounted) return;
                      final reason = await showConfirmDangerSheet(context,
                          title: '${l.editPrice}: ${Fmt.money(s.priceEGP)} → ${Fmt.money(price)}',
                          biometric: false,
                          destructive: false);
                      if (reason == null || !context.mounted) return;
                      try {
                        await GetIt.I<PricingRepository>().setSlotPrice(s.id, price, reason);
                        if (!mounted || !context.mounted) return;
                        setState(() => _future = GetIt.I<PricingRepository>().inventory(widget.sku.id));
                        showToast(context, l.priceChanged, tone: Tone.positive);
                      } catch (e) {
                        if (context.mounted) showErrorToast(context, e);
                      }
                    },
            ),
        ]);
      },
    );
  }
}
