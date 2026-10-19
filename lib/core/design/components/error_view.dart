import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../../api/api_error.dart';
import '../app_theme.dart';
import '../spacing.dart';
import 'dahab_button.dart';
import 'primitives.dart';

/// Plain-language message for an [ApiError]. Falls back to the server's
/// `detail` for kinds the app has no copy for.
String friendlyError(BuildContext context, Object error) {
  final l = context.l10n;
  final e = ApiError.from(error);
  return switch (e.kind) {
    ApiErrorKind.network => l.errorNetwork,
    ApiErrorKind.timeout => l.errorTimeout,
    ApiErrorKind.unauthorized => l.errorUnauthorized,
    ApiErrorKind.forbidden => l.errorForbidden,
    ApiErrorKind.notFound => l.errorNotFound,
    ApiErrorKind.conflict => l.errorConflict,
    ApiErrorKind.validation => e.detail?.isNotEmpty == true ? e.detail! : l.errorValidation,
    ApiErrorKind.approvalRequired => l.approvalNotice,
    ApiErrorKind.killSwitch => l.errorKillSwitch,
    ApiErrorKind.maintenance => l.errorMaintenance,
    ApiErrorKind.viewAsReadonly => l.errorViewAsReadonly,
    ApiErrorKind.server => l.errorServer,
    _ => e.detail?.isNotEmpty == true ? e.detail! : l.errorGeneric,
  };
}

/// Toast for a failed action, with the correlation id when there is one.
void showErrorToast(BuildContext context, Object error) {
  final e = ApiError.from(error);
  final tone = e.isApprovalRequired ? Tone.warning : Tone.critical;
  final id = e.correlationId;
  showToast(
    context,
    friendlyError(context, e),
    tone: tone,
    actionLabel: id == null ? null : context.l10n.copyReference,
    onAction: id == null ? null : () => Clipboard.setData(ClipboardData(text: id)),
  );
}

/// Full-area error: what happened, a retry, and the correlation id people
/// can paste into a support thread.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry, this.compact = false});

  final Object error;
  final VoidCallback? onRetry;

  /// Inline (inside a list) instead of centred.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final l = context.l10n;
    final e = ApiError.from(error);
    final offline = e.isOffline;
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(offline ? Icons.cloud_off_outlined : Icons.error_outline,
            size: 32, color: offline ? t.ink3 : t.critical),
        Gap.h12,
        Text(l.errorTitle, style: type.title, textAlign: TextAlign.center),
        Gap.h4,
        Text(friendlyError(context, e),
            style: type.bodySm.copyWith(color: t.ink2), textAlign: TextAlign.center),
        if (e.correlationId != null) ...[
          Gap.h12,
          CorrelationChip(id: e.correlationId!),
        ],
        if (onRetry != null) ...[
          Gap.h16,
          DahabButton.secondary(label: l.retry, icon: Icons.refresh, onPressed: onRetry),
        ],
      ],
    );
    if (compact) {
      return Padding(padding: const EdgeInsets.all(Space.xl), child: body);
    }
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.x2),
        child: body,
      ),
    );
  }
}

/// `Reference c-1a2b…` in mono; tap copies the full id.
class CorrelationChip extends StatelessWidget {
  const CorrelationChip({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final l = context.l10n;
    return Semantics(
      button: true,
      label: '${l.copyReference} $id',
      child: InkWell(
        borderRadius: Radii.smAll,
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: id));
          if (context.mounted) showToast(context, l.copied);
        },
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.sm, vertical: Space.xs),
          decoration: BoxDecoration(
            borderRadius: Radii.smAll,
            border: Border.all(color: t.line, width: t.hairline),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('${l.correlationId} ', style: context.type.caption.copyWith(color: t.ink3)),
            Flexible(child: MonoText(id, size: 12)),
            Gap.w4,
            Icon(Icons.copy_rounded, size: 14, color: t.ink3),
          ]),
        ),
      ),
    );
  }
}
