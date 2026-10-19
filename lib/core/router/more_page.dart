import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/access/domain/permissions.dart';
import '../../features/access/presentation/session_cubit.dart';
import '../../features/catalog/data/catalog_models.dart';
import '../../l10n/l10n.dart';
import '../design/app_theme.dart';
import '../design/components/offline_banner.dart';
import '../design/components/primitives.dart';
import '../design/components/section_header.dart';
import '../design/dahab_tokens.dart';
import '../design/spacing.dart';
import '../preferences/preferences_cubit.dart';
import 'app_router.gr.dart';
import 'shell_leading.dart';
import '../../features/access/presentation/role_labels.dart';

/// One entry on the More list.
class MoreLink {
  const MoreLink(this.icon, this.label, this.permission, this.route);

  final IconData icon;
  final String Function(AppLocalizations l) label;

  /// Any of these grants the link. Empty means "everyone signed in".
  final List<String> permission;
  final PageRouteInfo Function() route;
}

/// The "More" tab: permission-gated links to every staff surface, grouped
/// as on the web console, then appearance, devices and sign-out.
@RoutePage()
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  /// (label, links, for suppliers?) — supplier accounts see only the
  /// supplier group; staff reach a supplier's portal from Suppliers.
  static final groups = <(String Function(AppLocalizations), List<MoreLink>, bool)>[
    (
      (l) => l.groupCore,
      [
        MoreLink(Icons.route_outlined, (l) => l.sectionLive, const [P.opsTrips], () => const LiveRoute()),
        MoreLink(Icons.report_outlined, (l) => l.sectionExceptions, const [P.opsExceptions], () => const ExceptionsRoute()),
        MoreLink(Icons.receipt_long_outlined, (l) => l.sectionCommerce, const ['ops.commerce.view'], () => const CommerceRoute()),
        MoreLink(Icons.support_agent_outlined, (l) => l.sectionSupport, const [P.opsSupport], () => const SupportRoute()),
        MoreLink(Icons.notifications_none, (l) => l.sectionNotifications, const [P.opsNotifications], () => const NotificationsRoute()),
        MoreLink(Icons.sms_outlined, (l) => l.sectionSms, const ['ops.sms.view'], () => const SmsRoute()),
      ],
      false,
    ),
    (
      (l) => l.groupDomain,
      [
        MoreLink(Icons.storefront_outlined, (l) => l.sectionSuppliers, const ['ops.suppliers.view'], () => const SuppliersRoute()),
        MoreLink(Icons.hotel_outlined, (l) => l.sectionStays, const ['ops.accommodations.view'], () => const StaysRoute()),
        MoreLink(Icons.sell_outlined, (l) => l.sectionPricing, const ['ops.pricing.view'], () => const PricingRoute()),
        MoreLink(Icons.restaurant_outlined, (l) => l.sectionDining, const ['ops.dining.view'], () => const DiningRoute()),
      ],
      false,
    ),
    (
      (l) => l.groupSystem,
      [
        MoreLink(Icons.schedule_outlined, (l) => l.sectionJobs, const ['ops.jobs.view'], () => const JobsRoute()),
        MoreLink(Icons.monitor_heart_outlined, (l) => l.sectionHealth, const ['ops.health.view'], () => const HealthRoute()),
        MoreLink(Icons.history, (l) => l.sectionAudit, const [P.opsAudit], () => AuditRoute(ops: true)),
        MoreLink(Icons.menu_book_outlined, (l) => l.sectionKnowledge, const ['ops.knowledge.view'], () => const KnowledgeRoute()),
        MoreLink(Icons.lightbulb_outline, (l) => l.sectionOpportunities, const ['ops.opportunities.view'], () => const OpportunitiesRoute()),
      ],
      false,
    ),
    (
      (l) => l.groupCatalog,
      [
        MoreLink(Icons.inventory_2_outlined, (l) => l.sectionCatalog, catalogViewPermissions, () => const CatalogHomeRoute()),
      ],
      false,
    ),
    (
      (l) => l.groupMarket,
      [
        MoreLink(Icons.insights_outlined, (l) => l.sectionMarket, const ['market.view'], () => const MarketRoute()),
        MoreLink(Icons.article_outlined, (l) => l.sectionCms, const ['cms.content.view'], () => const CmsListRoute()),
        MoreLink(Icons.tune, (l) => l.ccTileExperience, const [P.settingsManage, P.flagsManage, P.opsFlags, P.settingsView], () => const AppExperienceRoute()),
        MoreLink(Icons.grid_view_outlined, (l) => l.ccTileHomepage, const ['cms.content.edit'], () => const HomepageEditorRoute()),
        MoreLink(Icons.route_outlined, (l) => l.ccTileProgrammes, const ['cms.content.view', 'cms.content.edit'], () => const ProgrammesRoute()),
        MoreLink(Icons.list_outlined, (l) => l.ccTileNavigation, const ['cms.content.edit'], () => const NavigationEditorRoute()),
      ],
      false,
    ),
    (
      (l) => l.groupSupplier,
      [
        MoreLink(Icons.inbox_outlined, (l) => l.supplierInbox, const [P.supplierInbox], () => SupplierInboxRoute()),
        MoreLink(Icons.bed_outlined, (l) => l.supplierStays, const ['supplier.stays.manage'], () => const SupplierStaysRoute()),
        MoreLink(Icons.directions_bike_outlined, (l) => l.supplierRentals, const ['supplier.rentals.manage'], () => const SupplierRentalsRoute()),
        MoreLink(Icons.verified_outlined, (l) => l.supplierReliability, const ['supplier.reliability.view'], () => SupplierReliabilityRoute()),
        MoreLink(Icons.inventory_2_outlined, (l) => l.catMyListings, const [supplierCatalogPermission], () => const CatalogHomeRoute()),
        MoreLink(Icons.history, (l) => l.supplierAudit, const ['supplier.audit.view'], () => const SupplierAuditRoute()),
      ],
      true,
    ),
    (
      (l) => l.groupControl,
      [
        MoreLink(Icons.tune, (l) => l.controlTitle,
            const [P.settingsView, P.opsFlags, P.integrationsView, P.approvalsDecide, P.usersView], () => const ControlRoute()),
        MoreLink(Icons.people_outline, (l) => l.controlUsers, const [P.usersView], () => const UsersRoute()),
      ],
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final session = context.watch<SessionCubit>().state;
    final prefs = context.watch<PreferencesCubit>().state;
    bool allowed(MoreLink m) => m.permission.isEmpty || session.canAny(m.permission);
    final visible = [
      for (final g in groups)
        if (g.$3 == session.isSupplier) (g.$1, g.$2.where(allowed).toList()),
    ].where((g) => g.$2.isNotEmpty);
    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(l.navMore),
        actions: [
          IconButton(
            tooltip: l.commandPalette,
            icon: const Icon(Icons.search),
            onPressed: () => context.router.push(const SearchRoute()),
          ),
        ],
      ),
      body: ListView(children: [
        const OfflineBanner(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter, vertical: Space.sm),
          leading: Monogram(session.user?.initials ?? ''),
          title: Text(session.user?.displayName ?? ''),
          subtitle: Text(
              [session.user?.email, session.user?.role == null ? null : RoleLabels.name(l, session.user!.role)]
                  .whereType<String>()
                  .join(' · '),
              style: context.type.caption.copyWith(color: t.ink3)),
        ),
        for (final g in visible) ...[
          SectionHeader(title: g.$1(l)),
          for (final m in g.$2) _Link(icon: m.icon, label: m.label(l), onTap: () => context.router.push(m.route())),
        ],
        SectionHeader(title: l.groupAccount),
        _Link(icon: Icons.devices_outlined, label: l.myDevices, onTap: () => context.router.push(const MyDevicesRoute())),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          leading: Icon(Icons.palette_outlined, color: t.ink2),
          title: Text(l.theme),
          trailing: DropdownButton<DahabThemeId>(
            value: prefs.theme,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(value: DahabThemeId.abyss, child: Text(l.themeAbyss)),
              DropdownMenuItem(value: DahabThemeId.salt, child: Text(l.themeSalt)),
              DropdownMenuItem(value: DahabThemeId.highContrastPro, child: Text(l.themeHighContrast)),
            ],
            onChanged: (v) => v == null ? null : context.read<PreferencesCubit>().setTheme(v),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          leading: Icon(Icons.translate, color: t.ink2),
          title: Text(l.language),
          trailing: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 'en', label: Text(l.english)),
              ButtonSegment(value: 'ar', label: Text(l.arabic)),
            ],
            selected: {prefs.locale.languageCode},
            onSelectionChanged: (s) => context.read<PreferencesCubit>().setLocale(Locale(s.first)),
          ),
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          secondary: Icon(Icons.face, color: t.ink2),
          title: Text(l.biometricLock),
          subtitle: Text(l.biometricLockHint),
          value: prefs.biometricLock,
          onChanged: (v) => context.read<PreferencesCubit>().setBiometricLock(v),
        ),
        const Hairline(),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
          leading: Icon(Icons.logout, color: t.critical),
          title: Text(l.logout, style: TextStyle(color: t.critical)),
          onTap: () => _logout(context),
        ),
        Gap.h32,
      ]),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final l = context.l10n;
    final session = context.read<SessionCubit>();
    final router = context.router;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.logout),
        content: Text(l.logoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(l.cancel)),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text(l.logout)),
        ],
      ),
    );
    if (confirm != true) return;
    await session.logout();
    await router.replaceAll([const LoginRoute()]);
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
      leading: Icon(icon, color: t.ink2),
      title: Text(label),
      trailing: Icon(Icons.chevron_right, color: t.ink3),
      onTap: onTap,
    );
  }
}
