import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/models/paged.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/design/spacing.dart';
import '../../../l10n/l10n.dart';
import '../../ops/suppliers/suppliers_repository.dart';

class SupplierChoice {
  const SupplierChoice(this.id, this.name);

  final String id;
  final String name;
}

/// Shows the chosen supplier; tap opens the picker sheet.
class SupplierTile extends StatelessWidget {
  const SupplierTile({super.key, this.supplierId, this.supplierName, required this.onPick, this.enabled = true});

  final String? supplierId;
  final String? supplierName;
  final VoidCallback onPick;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    final has = supplierId != null && supplierId!.isNotEmpty;
    return Material(
      color: t.surface,
      shape: RoundedRectangleBorder(borderRadius: Radii.mdAll, side: BorderSide(color: t.line, width: t.hairline)),
      child: ListTile(
        enabled: enabled,
        leading: Icon(Icons.storefront_outlined, color: t.ink2),
        title: Text(has ? (supplierName?.isNotEmpty == true ? supplierName! : supplierId!) : l.catNoSupplier),
        subtitle: has && supplierName?.isNotEmpty == true ? MonoText(supplierId!, color: t.ink3) : null,
        trailing: Icon(Icons.unfold_more, color: t.ink3),
        onTap: enabled ? onPick : null,
      ),
    );
  }
}

/// Searchable supplier list (`/api/suppliers`).
Future<SupplierChoice?> showSupplierPicker(BuildContext context) => showModalBottomSheet<SupplierChoice>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _SupplierPicker(),
    );

class _SupplierPicker extends StatefulWidget {
  const _SupplierPicker();

  @override
  State<_SupplierPicker> createState() => _SupplierPickerState();
}

class _SupplierPickerState extends State<_SupplierPicker> {
  late Future<Paged<OpsSupplier>> _future = _load();
  String _q = '';

  Future<Paged<OpsSupplier>> _load() => GetIt.I<SuppliersRepository>().suppliers(const ListQuery(limit: 100));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final arabic = context.type.isArabic;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, Space.sm),
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.catSearchSuppliers),
            onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
          ),
        ),
        Expanded(
          child: FutureBuilder<Paged<OpsSupplier>>(
            future: _future,
            builder: (context, snap) {
              if (snap.hasError) {
                return ErrorView(error: snap.error!, compact: true, onRetry: () => setState(() => _future = _load()));
              }
              if (!snap.hasData) return const SkeletonList(count: 6, lines: 1);
              final rows = snap.data!.items
                  .where((s) => _q.isEmpty || s.name(arabic).toLowerCase().contains(_q) || s.id.toLowerCase().contains(_q))
                  .toList();
              if (rows.isEmpty) return const EmptyState(icon: Icons.storefront_outlined);
              return ListView.builder(
                controller: scroll,
                itemCount: rows.length,
                itemBuilder: (context, i) {
                  final s = rows[i];
                  return ListTile(
                    title: Text(s.name(arabic)),
                    subtitle: Text([s.category, s.area].where((e) => e.isNotEmpty).join(' · '),
                        style: context.type.caption.copyWith(color: t.ink3)),
                    trailing: MonoText(s.id, color: t.ink3),
                    onTap: () => Navigator.of(context).pop(SupplierChoice(s.id, s.name(arabic))),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
