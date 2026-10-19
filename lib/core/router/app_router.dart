import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';
import 'auth_guard.dart';

/// App routes. Pages live in their features; this file only wires them.
/// Codegen: `fvm dart run build_runner build --delete-conflicting-outputs`.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.guard});

  final AuthGuard guard;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
        AutoRoute(page: LoginRoute.page, path: '/login', guards: [guard]),
        AutoRoute(
          page: TabsRoute.page,
          path: '/tabs',
          guards: [guard],
          children: [
            AutoRoute(page: PulseRoute.page, path: 'pulse', initial: true),
            AutoRoute(page: QueueRoute.page, path: 'queue'),
            AutoRoute(page: LiveRoute.page, path: 'live'),
            AutoRoute(page: SupportRoute.page, path: 'support'),
            AutoRoute(page: SupplierInboxRoute.page, path: 'inbox'),
            AutoRoute(page: SupplierInventoryRoute.page, path: 'inventory'),
            AutoRoute(page: SupplierRentalsRoute.page, path: 'rentals'),
            AutoRoute(page: SupplierRevenueRoute.page, path: 'revenue'),
            AutoRoute(page: MoreRoute.page, path: 'more'),
          ],
        ),
        AutoRoute(page: BookingDetailRoute.page, path: '/booking/:ref', guards: [guard]),
        // Command palette: a card over a scrim, so the screen below shows.
        CustomRoute(
          page: SearchRoute.page,
          path: '/search',
          guards: [guard],
          opaque: false,
          barrierDismissible: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          duration: const Duration(milliseconds: 200),
          reverseDuration: const Duration(milliseconds: 160),
        ),
        AutoRoute(page: UsersRoute.page, path: '/access/users', guards: [guard]),
        AutoRoute(page: ControlRoute.page, path: '/control', guards: [guard]),
        AutoRoute(page: UserDetailRoute.page, path: '/access/users/:id', guards: [guard]),
        AutoRoute(page: InviteStaffRoute.page, path: '/access/invite', guards: [guard]),
        AutoRoute(page: RoleEditorRoute.page, path: '/access/roles/edit', guards: [guard]),
        AutoRoute(page: SettingsRoute.page, path: '/control/settings', guards: [guard]),
        AutoRoute(page: FlagsRoute.page, path: '/control/flags', guards: [guard]),
        AutoRoute(page: MaintenanceRoute.page, path: '/control/maintenance', guards: [guard]),
        AutoRoute(page: IntegrationsRoute.page, path: '/control/integrations', guards: [guard]),
        AutoRoute(page: ApprovalsRoute.page, path: '/control/approvals', guards: [guard]),
        AutoRoute(page: AuditRoute.page, path: '/control/audit', guards: [guard]),
        AutoRoute(page: MyDevicesRoute.page, path: '/me/devices', guards: [guard]),
        // Ops sections (More).
        AutoRoute(page: ExceptionsRoute.page, path: '/ops/exceptions', guards: [guard]),
        AutoRoute(page: CommerceRoute.page, path: '/ops/commerce', guards: [guard]),
        AutoRoute(page: SupportRoute.page, path: '/ops/support', guards: [guard]),
        AutoRoute(page: NotificationsRoute.page, path: '/ops/notifications', guards: [guard]),
        AutoRoute(page: SmsRoute.page, path: '/ops/sms', guards: [guard]),
        AutoRoute(page: SuppliersRoute.page, path: '/ops/suppliers', guards: [guard]),
        AutoRoute(page: StaysRoute.page, path: '/ops/stays', guards: [guard]),
        AutoRoute(page: PricingRoute.page, path: '/ops/pricing', guards: [guard]),
        AutoRoute(page: DiningRoute.page, path: '/ops/dining', guards: [guard]),
        AutoRoute(page: JobsRoute.page, path: '/ops/jobs', guards: [guard]),
        AutoRoute(page: HealthRoute.page, path: '/ops/health', guards: [guard]),
        AutoRoute(page: KnowledgeRoute.page, path: '/ops/knowledge', guards: [guard]),
        AutoRoute(page: OpportunitiesRoute.page, path: '/ops/opportunities', guards: [guard]),
        AutoRoute(page: MarketRoute.page, path: '/market', guards: [guard]),
        AutoRoute(page: CmsListRoute.page, path: '/cms', guards: [guard]),
        AutoRoute(page: CmsEditorRoute.page, path: '/cms/pages/:id', guards: [guard]),
        // Catalogue CRUD (staff + supplier "My listings").
        AutoRoute(page: CatalogHomeRoute.page, path: '/catalog', guards: [guard]),
        AutoRoute(page: CatalogListRoute.page, path: '/catalog/:type', guards: [guard]),
        AutoRoute(page: CatalogCreateRoute.page, path: '/catalog/:type/new', guards: [guard]),
        AutoRoute(page: CatalogEditRoute.page, path: '/catalog/:type/:id', guards: [guard]),
        AutoRoute(page: CatalogChildrenRoute.page, path: '/catalog/:type/:id/:child', guards: [guard]),
        AutoRoute(page: CatalogRatesRoute.page, path: '/catalog-rates/:id', guards: [guard]),
        AutoRoute(page: CatalogSlotsRoute.page, path: '/catalog-slots/:id', guards: [guard]),
        AutoRoute(page: CatalogMenuRoute.page, path: '/catalog-menu/:id', guards: [guard]),
        // Live as a pushed screen too (from More when it is not a tab).
        AutoRoute(page: LiveRoute.page, path: '/ops/live', guards: [guard]),
        // Control Center additions: app experience + content surfaces.
        AutoRoute(page: AppExperienceRoute.page, path: '/control/app-experience', guards: [guard]),
        AutoRoute(page: HomepageEditorRoute.page, path: '/cms/homepage', guards: [guard]),
        AutoRoute(page: ProgrammesRoute.page, path: '/cms/programmes', guards: [guard]),
        AutoRoute(page: ProgrammeEditorRoute.page, path: '/cms/programmes/:id', guards: [guard]),
        AutoRoute(page: NavigationEditorRoute.page, path: '/cms/navigation', guards: [guard]),
        // Supplier portal (pushed; inbox/inventory/revenue are also tabs).
        AutoRoute(page: SupplierPortalRoute.page, path: '/supplier/portal', guards: [guard]),
        AutoRoute(page: SupplierInboxRoute.page, path: '/supplier/inbox', guards: [guard]),
        AutoRoute(page: SupplierInventoryRoute.page, path: '/supplier/inventory', guards: [guard]),
        AutoRoute(page: SupplierRevenueRoute.page, path: '/supplier/revenue', guards: [guard]),
        AutoRoute(page: SupplierStaysRoute.page, path: '/supplier/stays', guards: [guard]),
        AutoRoute(page: SupplierRentalsRoute.page, path: '/supplier/rentals', guards: [guard]),
        AutoRoute(page: SupplierReliabilityRoute.page, path: '/supplier/reliability', guards: [guard]),
        AutoRoute(page: SupplierAuditRoute.page, path: '/supplier/audit', guards: [guard]),
      ];
}
