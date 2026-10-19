import '../../../core/api/models/admin_models.dart';
import '../../../l10n/l10n.dart';

/// Display names for the built-in roles and the permission summary line.
/// Custom roles keep the name an admin gave them.
abstract final class RoleLabels {
  /// Localized name of a system role by its stored name (`Admin`,
  /// `Operations`, ...), or [name] unchanged for anything else.
  static String name(AppLocalizations l, String name) => switch (name.trim().toLowerCase()) {
        'traveler' || 'traveller' => l.roleTraveler,
        'supplier' => l.roleSupplier,
        'operations' || 'ops' => l.roleOperations,
        'product' => l.roleProduct,
        'admin' => l.roleAdmin,
        _ => name,
      };

  /// [Role] title: system roles are localized, custom ones are verbatim.
  static String of(AppLocalizations l, Role role) => role.isSystem ? name(l, role.name) : role.name;

  /// "All permissions" for a wildcard grant, else the plural count.
  static String permissions(AppLocalizations l, List<String> permissions) =>
      permissions.contains('*') ? l.allPermissions : l.permissionsCount(permissions.length);
}
