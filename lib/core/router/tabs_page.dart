import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/access/domain/permissions.dart';
import '../../features/access/presentation/session_cubit.dart';
import '../../features/queue/data/queue_repository.dart';
import '../../features/supplier/data/supplier_repository.dart';
import '../../l10n/l10n.dart';
import '../design/app_theme.dart';
import '../design/components/dg_icons.dart';
import 'app_router.gr.dart';

/// Bottom tabs, as in the prototype. Staff get Pulse / Queue / Live / Inbox /
/// More; suppliers get Inbox / Calendar / Inventory / Payouts / Account.
/// A tab whose permission is missing is left out; More (Account) is always
/// there.
enum AppTab { pulse, queue, live, staffInbox, inbox, calendar, inventory, revenue, more }

@RoutePage()
class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  /// Tabs for [s], in order. Pure so it can be tested without a router.
  static List<AppTab> tabsFor(SessionState s) {
    if (s.isSupplier) {
      return [
        if (s.can(P.supplierInbox)) AppTab.inbox,
        if (s.can(P.supplierInventory)) AppTab.calendar,
        if (s.canAny(const ['supplier.rentals.manage', 'supplier.stays.manage'])) AppTab.inventory,
        if (s.can(P.supplierRevenue)) AppTab.revenue,
        AppTab.more,
      ];
    }
    return [
      if (s.can(P.opsOverview)) AppTab.pulse,
      if (s.can(P.opsOverview)) AppTab.queue,
      if (s.can(P.opsTrips)) AppTab.live,
      if (s.can(P.opsSupport)) AppTab.staffInbox,
      AppTab.more,
    ];
  }

  static PageRouteInfo route(AppTab t) => switch (t) {
        AppTab.pulse => const PulseRoute(),
        AppTab.queue => const QueueRoute(),
        AppTab.live => const LiveRoute(),
        AppTab.staffInbox => const SupportRoute(),
        AppTab.inbox => SupplierInboxRoute(),
        AppTab.calendar => SupplierInventoryRoute(),
        AppTab.inventory => const SupplierRentalsRoute(),
        AppTab.revenue => SupplierRevenueRoute(),
        AppTab.more => const MoreRoute(),
      };

  @override
  Widget build(BuildContext context) {
    final tabs = context.select<SessionCubit, List<AppTab>>((c) => tabsFor(c.state));
    final supplier = context.select<SessionCubit, bool>((c) => c.state.isSupplier);
    return AutoTabsScaffold(
      key: ValueKey(tabs.join(',')),
      routes: [for (final t in tabs) route(t)],
      bottomNavigationBuilder: (context, tabsRouter) => DgTabBar(
        tabs: tabs,
        supplier: supplier,
        activeIndex: tabsRouter.activeIndex,
        onTap: tabsRouter.setActiveIndex,
      ),
    );
  }
}

/// The prototype tab bar: surface ground with a hairline top, 24px stroke
/// icons, 13px labels, a 2px lagoon line above the active tab and a coral
/// count badge (Queue for staff, Inbox for suppliers).
class DgTabBar extends StatelessWidget {
  const DgTabBar({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onTap,
    this.supplier = false,
  });

  final List<AppTab> tabs;
  final int activeIndex;
  final ValueChanged<int> onTap;
  final bool supplier;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    (DgIcons, String) spec(AppTab tab) => switch (tab) {
          AppTab.pulse => (DgIcons.activity, l.navPulse),
          AppTab.queue => (DgIcons.queue, l.navQueue),
          AppTab.live => (DgIcons.live, l.navLive),
          AppTab.staffInbox || AppTab.inbox => (DgIcons.inbox, l.navInbox),
          AppTab.calendar => (DgIcons.cal, l.navCalendar),
          AppTab.inventory => (DgIcons.box, l.navInventory),
          AppTab.revenue => (DgIcons.wallet, l.navPayouts),
          AppTab.more => supplier ? (DgIcons.user, l.navAccount) : (DgIcons.grid, l.navMore),
        };
    ValueListenable<int>? badgeFor(AppTab tab) => switch (tab) {
          AppTab.queue => GetIt.I.isRegistered<QueueRepository>() ? GetIt.I<QueueRepository>().openCount : null,
          AppTab.inbox =>
            GetIt.I.isRegistered<SupplierRepository>() ? GetIt.I<SupplierRepository>().pendingCount : null,
          _ => null,
        };
    return Material(
      color: t.surface,
      shape: Border(top: t.hairlineSide),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
          child: Row(children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: _Tab(
                  icon: spec(tabs[i]).$1,
                  label: spec(tabs[i]).$2,
                  active: i == activeIndex,
                  badge: badgeFor(tabs[i]),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                ),
              ),
          ]),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.icon, required this.label, required this.active, required this.onTap, this.badge});

  final DgIcons icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final ValueListenable<int>? badge;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final color = active ? t.ink : t.ink3;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        child: SizedBox(
          height: 56,
          child: Stack(clipBehavior: Clip.none, alignment: Alignment.topCenter, children: [
            if (active)
              Positioned(
                top: -6,
                child: Container(
                  width: 24,
                  height: 2,
                  decoration: BoxDecoration(color: t.action, borderRadius: BorderRadius.circular(2)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DgIcon(icon, size: 24, color: color),
                const SizedBox(height: 3),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: color, height: 1.2)),
              ]),
            ),
            if (badge != null)
              ValueListenableBuilder<int>(
                valueListenable: badge!,
                builder: (context, n, _) => n <= 0
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 0,
                        child: Transform.translate(
                          offset: Offset((context.isRtl ? -1 : 1) * 15, 0),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 18),
                            height: 18,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: t.highlight, borderRadius: BorderRadius.circular(9)),
                            child: Text(n > 99 ? '99+' : '$n',
                                textDirection: TextDirection.ltr,
                                style: type.mono.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: t.bg, height: 1)),
                          ),
                        ),
                      ),
              ),
          ]),
        ),
      ),
    );
  }
}
