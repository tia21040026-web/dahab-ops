import 'package:dahab_ops/core/router/tabs_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// The tab set is derived purely from the session's role and permissions
/// (prototype § Main tabs: Pulse / Queue / Live / Inbox / More for staff;
/// Inbox / Calendar / Inventory / Payouts / Account for suppliers). A tab
/// whose permission is missing is dropped; More is always present.
void main() {
  test('operations staff get Pulse, Queue, Live, Inbox, More', () {
    final s = testSession(permissions: ['ops.*', 'supplier.*.view']).state;
    expect(TabsPage.tabsFor(s),
        [AppTab.pulse, AppTab.queue, AppTab.live, AppTab.staffInbox, AppTab.more]);
  });

  test('admin with * gets the staff tabs, not the supplier ones', () {
    final s = testSession(permissions: ['*']).state;
    expect(TabsPage.tabsFor(s),
        [AppTab.pulse, AppTab.queue, AppTab.live, AppTab.staffInbox, AppTab.more]);
  });

  test('supplier gets Inbox, Calendar, Inventory, Revenue, Account', () {
    final s = testSession(permissions: ['supplier.*'], supplier: true).state;
    expect(TabsPage.tabsFor(s),
        [AppTab.inbox, AppTab.calendar, AppTab.inventory, AppTab.revenue, AppTab.more]);
  });

  test('missing permissions drop tabs but keep More', () {
    final product = testSession(permissions: ['market.*', 'cms.*']).state;
    expect(TabsPage.tabsFor(product), [AppTab.more]);
    final inboxOnly = testSession(permissions: ['supplier.inbox.view'], supplier: true).state;
    expect(TabsPage.tabsFor(inboxOnly), [AppTab.inbox, AppTab.more]);
  });

  test('a staff session that only reads the queue keeps just Queue and More', () {
    final s = testSession(permissions: ['ops.overview.view']).state;
    expect(TabsPage.tabsFor(s), [AppTab.pulse, AppTab.queue, AppTab.more]);
  });

  test('supplier without inventory rights loses Calendar but keeps Inbox', () {
    final s = testSession(permissions: ['supplier.inbox.view', 'supplier.revenue.view'], supplier: true)
        .state;
    expect(TabsPage.tabsFor(s), [AppTab.inbox, AppTab.revenue, AppTab.more]);
  });
}
