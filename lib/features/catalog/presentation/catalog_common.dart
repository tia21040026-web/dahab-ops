import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/catalog_models.dart';
import '../data/catalog_repository.dart';
import '../form/catalog_form_engine.dart';

/// One repository per surface (staff / supplier), shared by the screens.
abstract final class CatalogScope {
  static final Map<bool, CatalogRepository> _repos = {};

  /// Tests inject a repository here.
  static CatalogRepository? override;

  static CatalogRepository of(BuildContext context) {
    if (override != null) return override!;
    final s = context.read<SessionCubit>().state;
    return _repos.putIfAbsent(s.isSupplier, () => CatalogRepository.forSession(s));
  }
}

/// Role checks for a catalogue type.
class CatalogAccess {
  const CatalogAccess(this.session, this.type);

  final SessionState session;
  final String type;

  bool get supplier => session.isSupplier;
  bool get canView => supplier ? session.can(supplierCatalogPermission) : session.can(catalogPerm(type, 'view'));
  bool get canManage => supplier ? session.can(supplierCatalogPermission) : session.can(catalogPerm(type, 'manage'));

  /// Suppliers "publish" into review; transfers have no publish key.
  bool get canPublish {
    if (supplier) return session.can(supplierCatalogPermission);
    final family = catalogFamily(type);
    return session.can(catalogPerm(type, family == 'transfers' ? 'manage' : 'publish'));
  }

  String get viewPermission => supplier ? supplierCatalogPermission : catalogPerm(type, 'view');
}

String catalogStatusLabel(AppLocalizations l, String status) => switch (status) {
      CatalogStatus.draft => l.catStatusDraft,
      CatalogStatus.review => l.catStatusReview,
      CatalogStatus.published => l.catStatusPublished,
      CatalogStatus.hidden => l.catStatusHidden,
      CatalogStatus.archived => l.catStatusArchived,
      _ => status,
    };

Tone catalogStatusTone(String status) => switch (status) {
      CatalogStatus.published => Tone.positive,
      CatalogStatus.review => Tone.warning,
      CatalogStatus.hidden => Tone.neutral,
      CatalogStatus.archived => Tone.critical,
      _ => Tone.action,
    };

IconData catalogTypeIcon(String type, [String? icon]) => switch (icon ?? '') {
      'bed' || 'hotel' => Icons.bed_outlined,
      'utensils' || 'restaurant' || 'food' => Icons.restaurant_outlined,
      'bus' => Icons.directions_bus_outlined,
      'car' || 'driver' => Icons.local_taxi_outlined,
      'map' || 'zone' => Icons.map_outlined,
      'package' || 'suitcase' || 'briefcase' => Icons.luggage_outlined,
      'compass' || 'activity' || 'waves' => Icons.scuba_diving_outlined,
      _ => switch (type) {
          'hotel' => Icons.bed_outlined,
          'restaurant' => Icons.restaurant_outlined,
          'transfer-bus' => Icons.directions_bus_outlined,
          'transfer-driver' => Icons.local_taxi_outlined,
          'transfer-zone' => Icons.map_outlined,
          'package' => Icons.luggage_outlined,
          _ => Icons.scuba_diving_outlined,
        },
    };

/// Thin completeness bar with a percent; warns below 100%.
class CompletenessBar extends StatelessWidget {
  const CompletenessBar({super.key, required this.value, this.width = 72});

  final double value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final done = value >= 0.999;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      DgMeter(value: value, width: width, color: done ? t.positive : t.warning),
      Gap.w8,
      Text(Fmt.percent(value), textDirection: TextDirection.ltr, style: context.type.monoSm.copyWith(color: done ? t.positive : t.ink3)),
    ]);
  }
}

/// Lists what is missing (from the 422 or the client gate), by label.
class MissingList extends StatelessWidget {
  const MissingList({super.key, required this.schema, required this.missing});

  final CatalogTypeSchema? schema;
  final List<String> missing;

  @override
  Widget build(BuildContext context) {
    final arabic = context.type.isArabic;
    final names = [for (final k in missing) schema?.field(k)?.labelOf(arabic) ?? k];
    return DgNotice(
      key: const Key('cat.missing'),
      icon: DgIcons.alert,
      title: context.l10n.catMissingTitle(missing.length),
      body: names.join(' · '),
    );
  }
}

/// Mutations shared by list rows and the editor. Each returns the updated
/// record, or null when cancelled / failed (a toast says why).
class CatalogActions {
  CatalogActions(this.context, this.repo, this.type, {this.schema});

  final BuildContext context;
  final CatalogRepository repo;
  final String type;
  final CatalogTypeSchema? schema;

  AppLocalizations get l => context.l10n;

  /// Publish (staff) or submit for review (supplier). A 422 lists what is
  /// missing in a sheet.
  Future<CatalogItem?> publish(CatalogItem item) async {
    try {
      final next = await repo.publish(type, item.id);
      if (context.mounted) {
        showToast(context, repo.supplier ? l.catSubmittedToast : l.catPublishedToast, tone: Tone.positive);
      }
      return next;
    } catch (e) {
      if (!context.mounted) return null;
      if (isIncomplete(e)) {
        await showModalBottomSheet<void>(
          context: context,
          useSafeArea: true,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(Space.xl),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(l.catCannotPublish, style: context.type.heading),
              Gap.h12,
              MissingList(schema: schema, missing: missingFromError(e)),
            ]),
          ),
        );
      } else {
        showErrorToast(context, e);
      }
      return null;
    }
  }

  Future<CatalogItem?> hide(CatalogItem item) => _run(() => repo.transition(type, item.id, 'hide'), l.catHiddenToast);

  Future<CatalogItem?> restore(CatalogItem item) => _run(() => repo.transition(type, item.id, 'restore'), l.catRestoredToast);

  Future<CatalogItem?> duplicate(CatalogItem item) => _run(() => repo.duplicate(type, item.id), l.catDuplicatedToast);

  Future<CatalogItem?> archive(CatalogItem item, {String? reason}) async {
    final r = reason ??
        await showConfirmDangerSheet(context,
            title: l.catArchiveTitle(item.title.of(context.type.isArabic)),
            body: l.catArchiveBody,
            confirmLabel: l.catArchive,
            biometric: false);
    if (r == null || !context.mounted) return null;
    return _run(() => repo.transition(type, item.id, 'archive', reason: r), l.catArchivedToast);
  }

  /// Hard delete for never-booked drafts; a 409 in-use offers archive with
  /// the same reason. Returns true when the record is gone or archived.
  Future<bool> delete(CatalogItem item) async {
    final reason = await showConfirmDangerSheet(context,
        title: l.catDeleteTitle(item.title.of(context.type.isArabic)), body: l.catDeleteBody, confirmLabel: l.catDelete);
    if (reason == null || !context.mounted) return false;
    try {
      await repo.delete(type, item.id, reason: reason);
      if (context.mounted) showToast(context, l.catDeletedToast, tone: Tone.positive);
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      if (isConflict(e)) {
        final archive = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l.catInUseTitle),
            content: Text(l.catInUseBody),
            actions: [
              TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(l.cancel)),
              FilledButton(
                  key: const Key('cat.inUse.archive'),
                  onPressed: () => Navigator.of(c).pop(true),
                  child: Text(l.catArchive)),
            ],
          ),
        );
        if (archive == true && context.mounted) return (await this.archive(item, reason: reason)) != null;
        return false;
      }
      showErrorToast(context, e);
      return false;
    }
  }

  /// Quick price edit; a change above 30% asks for a reason (contract).
  Future<CatalogItem?> editPrice(CatalogItem item) async {
    final old = item.priceFromEGP;
    final v = await showNumberSheet(context, title: l.catEditPrice, initial: old, suffix: 'EGP',
        body: item.title.of(context.type.isArabic));
    if (v == null || !context.mounted || v == old) return null;
    String? reason;
    if (needsPriceReason(old, v)) {
      reason = await showConfirmDangerSheet(context,
          title: l.catPriceReasonTitle, body: l.catPriceReasonBody(Fmt.money(old ?? 0), Fmt.money(v)),
          biometric: false, destructive: false, confirmLabel: l.save);
      if (reason == null || !context.mounted) return null;
    }
    return _run(
        () => repo.patch(type, item.id, {'fields': {'priceFromEGP': v}, 'reason': reason},
            ifMatch: item.updatedAtRaw),
        l.saved);
  }

  Future<CatalogItem?> _run(Future<CatalogItem> Function() call, String ok) async {
    try {
      final next = await call();
      if (context.mounted) showToast(context, ok, tone: Tone.positive);
      return next;
    } catch (e) {
      if (context.mounted) showErrorToast(context, e);
      return null;
    }
  }
}

/// Contract: price changes larger than 30% need a reason.
bool needsPriceReason(num? old, num next) => old != null && old > 0 && ((next - old).abs() / old) > 0.3;
