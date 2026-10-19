import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';

/// Formatting helpers. Numbers, IDs and amounts use Latin digits in both
/// languages (they are read against the web console and receipts).
abstract final class Fmt {
  static final _int = NumberFormat.decimalPattern('en');
  static final _compact = NumberFormat.compact(locale: 'en');

  static String number(num value) => _int.format(value);

  static String compact(num value) => value.abs() >= 10000 ? _compact.format(value) : number(value);

  static String money(num value, {String currency = 'EGP'}) =>
      '${NumberFormat.decimalPatternDigits(locale: 'en', decimalDigits: value % 1 == 0 ? 0 : 2).format(value)} $currency';

  /// Ledger amount with two decimals and no currency (`7,200.00`).
  static String amount(num value) =>
      NumberFormat.decimalPatternDigits(locale: 'en', decimalDigits: 2).format(value);

  static String percent(num ratio, {int digits = 0}) =>
      '${(ratio * 100).toStringAsFixed(digits)}%';

  static String signedPercent(num delta) {
    final v = (delta * 100).abs();
    final s = v >= 10 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return '${delta >= 0 ? '+' : '−'}$s%';
  }

  static String dateTime(BuildContext context, DateTime? value) {
    if (value == null) return '—';
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.yMMMd(locale).add_Hm().format(value.toLocal());
  }

  static String date(BuildContext context, DateTime? value) {
    if (value == null) return '—';
    return DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(value.toLocal());
  }

  /// "just now", "4 min ago", "2 h ago", "3 days ago", then a date.
  static String ago(BuildContext context, DateTime? value, {DateTime? now}) {
    if (value == null) return '—';
    final l = context.l10n;
    final diff = (now ?? DateTime.now()).difference(value);
    if (diff.inSeconds < 45) return l.justNow;
    if (diff.inMinutes < 60) return l.minutesAgo(diff.inMinutes < 1 ? 1 : diff.inMinutes);
    if (diff.inHours < 24) return l.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return l.daysAgo(diff.inDays);
    return date(context, value);
  }

  /// Short, copy-safe ID: keeps the tail people read out loud.
  static String shortId(String id, {int keep = 8}) =>
      id.length <= keep + 1 ? id : '…${id.substring(id.length - keep)}';
}
