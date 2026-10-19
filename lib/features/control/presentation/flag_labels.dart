import '../../../core/api/models/admin_models.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../l10n/l10n.dart';

/// Localized titles and descriptions for the fixed kill switches and the
/// maintenance flag. Other flags fall back to the server description, then
/// to a humanized key.
abstract final class FlagLabels {
  static String? _title(AppLocalizations l, String key) => switch (key) {
        'killswitch.payments' => l.killPaymentsTitle,
        'killswitch.bookings' => l.killBookingsTitle,
        'killswitch.ai' => l.killAiTitle,
        'killswitch.sms' => l.killSmsTitle,
        'killswitch.supplierSignup' => l.killSupplierSignupTitle,
        'system.maintenance' => l.flagMaintenanceTitle,
        _ => null,
      };

  static String? _description(AppLocalizations l, String key) => switch (key) {
        'killswitch.payments' => l.killPaymentsDesc,
        'killswitch.bookings' => l.killBookingsDesc,
        'killswitch.ai' => l.killAiDesc,
        'killswitch.sms' => l.killSmsDesc,
        'killswitch.supplierSignup' => l.killSupplierSignupDesc,
        'system.maintenance' => l.flagMaintenanceDesc,
        _ => null,
      };

  /// Drops trailing sentence punctuation: in an RTL row a Latin "." would
  /// render at the start (".Stops outbound SMS").
  static String clean(String s) => s.trim().replaceFirst(RegExp(r'[.。،,;:\s]+$'), '');

  static String title(AppLocalizations l, FlagItem f) {
    final known = _title(l, f.key);
    if (known != null) return known;
    final d = f.description;
    if (d != null && d.trim().isNotEmpty && d.length <= 28) return clean(d);
    final last = f.key
        .split(RegExp(r'[._:]'))
        .where((e) => e.isNotEmpty && e != 'killswitch' && e != 'kill')
        .lastOrNull;
    return StatusBadge.humanize((last ?? f.key).replaceAll('-', ' '));
  }

  static String? description(AppLocalizations l, FlagItem f) {
    final known = _description(l, f.key);
    if (known != null) return known;
    final d = f.description;
    return d == null || d.trim().isEmpty ? null : clean(d);
  }
}
