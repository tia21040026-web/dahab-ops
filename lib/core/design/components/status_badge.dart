import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../spacing.dart';
import 'primitives.dart';

/// Small status label: dot + text on a wash. Never used for decoration.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = Tone.neutral,
    this.dot = true,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final Tone tone;
  final bool dot;
  final IconData? icon;
  final bool outlined;

  /// Common mapping from server status strings.
  static Tone toneFor(String? status) => switch ((status ?? '').toLowerCase()) {
        'healthy' || 'active' || 'approved' || 'ok' || 'live' || 'grant' || 'confirmed' ||
        'completed' || 'delivered' || 'settled' || 'answered' || 'sent' || 'read' || 'published' ||
        'available' || 'success' || 'resolved' || 'checked_in' || 'paid' || 'captured' ||
        'accepted' || 'in_destination' =>
          Tone.positive,
        'degraded' || 'pending' || 'warning' || 'sandbox' || 'medium' || 'high' || 'open' ||
        'in_progress' || 'queued' || 'preparing' || 'escalated' || 'pending_confirmation' ||
        'pending_review' || 'almost_full' || 'draft' || 'stale' || 'simulated' || 'planned' ||
        'pending_verification' || 'out_for_delivery' || 'ready_for_pickup' || 'held' =>
          Tone.warning,
        'down' || 'suspended' || 'rejected' || 'critical' || 'failed' || 'deny' || 'cancelled' ||
        'voided' || 'failing' || 'sold_out' || 'no_show' || 'declined' || 'error' || 'urgent' =>
          Tone.critical,
        _ => Tone.neutral,
      };

  /// `PENDING_CONFIRMATION` → `Pending confirmation`.
  static String humanize(String? status) {
    final s = (status ?? '').replaceAll('_', ' ').trim().toLowerCase();
    if (s.isEmpty) return '—';
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final ink = t.toneInk(tone);
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.sm, vertical: 3),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : t.toneWash(tone),
        borderRadius: Radii.pill,
        border: outlined ? Border.all(color: ink.withValues(alpha: 0.5), width: t.hairline) : null,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: Icon(icon, size: 13, color: ink),
          )
        else if (dot) ...[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: ink, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.type.caption.copyWith(
              color: tone == Tone.neutral ? t.ink2 : ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}
