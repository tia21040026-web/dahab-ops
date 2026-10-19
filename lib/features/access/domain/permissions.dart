/// Permission keys are `area.section.action`; `*` grants everything.
///
/// A granted entry may also use `*` per segment: `ops.*` covers every ops key
/// and `supplier.*.view` covers every supplier view key. A trailing `*`
/// matches one or more remaining segments; an inner `*` matches exactly one.
abstract final class Permissions {
  static const all = '*';

  static bool grants(String granted, String key) {
    if (granted == all) return true;
    if (granted == key) return true;
    if (!granted.contains('*')) return false;
    final g = granted.split('.');
    final k = key.split('.');
    for (var i = 0; i < g.length; i++) {
      final seg = g[i];
      final last = i == g.length - 1;
      if (seg == '*') {
        if (last) return k.length > i;
        if (i >= k.length) return false;
        continue;
      }
      if (i >= k.length || k[i] != seg) return false;
    }
    return g.length == k.length;
  }

  static bool can(Iterable<String> granted, String key) {
    for (final g in granted) {
      if (grants(g, key)) return true;
    }
    return false;
  }

  static bool canAny(Iterable<String> granted, Iterable<String> keys) =>
      keys.any((k) => can(granted, k));
}

/// Keys the app checks directly (contract § Permissions).
abstract final class P {
  static const opsOverview = 'ops.overview.view';
  static const opsTrips = 'ops.trips.view';
  static const opsSupport = 'ops.support.view';
  static const opsExceptions = 'ops.exceptions.view';
  static const opsNotifications = 'ops.notifications.view';

  static const supplierInbox = 'supplier.inbox.view';
  static const supplierInventory = 'supplier.inventory.view';
  static const supplierRevenue = 'supplier.revenue.view';

  static const usersView = 'admin.users.view';
  static const usersManage = 'admin.users.manage';
  static const rolesManage = 'admin.roles.manage';
  static const settingsView = 'admin.settings.view';
  static const settingsManage = 'admin.settings.manage';
  static const flagsManage = 'admin.flags.manage';
  static const integrationsView = 'admin.integrations.view';
  static const integrationsManage = 'admin.integrations.manage';
  static const approvalsDecide = 'admin.approvals.decide';
  static const auditExport = 'admin.audit.export';
  static const viewAs = 'admin.viewas';
  static const opsAudit = 'ops.audit.view';
  static const opsFlags = 'ops.flags.view';
}
