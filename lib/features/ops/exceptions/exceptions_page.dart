import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/confirm_danger_sheet.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/permission_gate.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'exceptions_repository.dart';

/// Exceptions, most severe first: market alerts, urgent support, review
/// queue and knowledge gaps. Alerts resolve by acknowledging; support
/// items open the support inbox.
@RoutePage()
class ExceptionsPage extends StatelessWidget {
  const ExceptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<ExceptionsRepository>();
    return BlocProvider(
      create: (_) => ListCubit<OpsException>(repo.all)..start(),
      child: const _ExceptionsView(),
    );
  }
}

class _ExceptionsView extends StatelessWidget {
  const _ExceptionsView();

  String _sourceLabel(BuildContext context, ExceptionSource s) {
    final l = context.l10n;
    return switch (s) {
      ExceptionSource.alert => l.sourceAlert,
      ExceptionSource.support => l.sourceSupport,
      ExceptionSource.review => l.sourceReview,
      ExceptionSource.gap => l.sourceGap,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final cubit = context.watch<ListCubit<OpsException>>();
    return SectionScaffold(
      title: l.sectionExceptions,
      permission: P.opsExceptions,
      body: AsyncListView<OpsException>(
        header: FilterBar<String>(
          options: [
            FilterOption(null, l.all),
            for (final s in ExceptionSource.values) FilterOption(s.name, _sourceLabel(context, s)),
          ],
          selected: cubit.state.filter('source') as String?,
          onSelected: (v) => cubit.setFilter('source', v),
        ),
        emptyIcon: Icons.verified_outlined,
        itemBuilder: (context, e) => DataCard(
          title: e.titleFor(arabic),
          subtitle: e.messageFor(arabic),
          status: StatusBadge.humanize(e.severity),
          statusTone: StatusBadge.toneFor(e.severity),
          fields: [
            DataField(l.fSource, _sourceLabel(context, e.source)),
            DataField(l.fCreated, Fmt.ago(context, e.at)),
            if (e.acknowledged) DataField(l.fStatus, l.acknowledged),
          ],
          onTap: () => _open(context, e),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, OpsException e) {
    final l = context.l10n;
    final arabic = context.type.isArabic;
    final cubit = context.read<ListCubit<OpsException>>();
    return showDetailSheet<void>(
      context,
      title: e.titleFor(arabic),
      subtitle: _sourceLabel(context, e.source),
      id: e.id,
      status: e.severity,
      fields: [
        DataField(l.fMessage, e.messageFor(arabic)),
        DataField(l.fCreated, Fmt.dateTime(context, e.at)),
        if (e.so('bookingRef') != null) DataField(l.fBooking, e.s('bookingRef'), mono: true),
      ],
      actions: (sheet) => [
        if (e.canAcknowledge)
          PermissionGate(
            permission: 'ops.exceptions.resolve',
            child: DahabButton(
              label: l.acknowledge,
              icon: Icons.done_all,
              onPressed: () async {
                final reason = await showConfirmDangerSheet(sheet,
                    title: l.acknowledge, biometric: false, destructive: false);
                if (reason == null || !sheet.mounted) return;
                final who = sheet.read<SessionCubit>().state.user?.email ?? 'ops';
                try {
                  await GetIt.I<ExceptionsRepository>().acknowledge(e.id, who);
                  cubit.removeWhere((x) => x.id == e.id && x.source == e.source);
                  if (sheet.mounted) {
                    Navigator.of(sheet).pop();
                    showToast(context, l.acknowledged, tone: Tone.positive);
                  }
                } catch (err) {
                  if (sheet.mounted) showErrorToast(sheet, err);
                }
              },
            ),
          ),
        if (e.source == ExceptionSource.support)
          DahabButton(
            label: l.openSupport,
            onPressed: () {
              Navigator.of(sheet).pop();
              context.router.push(const SupportRoute());
            },
          ),
        if (e.so('bookingRef') != null)
          DahabButton.secondary(
            label: l.openBooking,
            onPressed: () {
              Navigator.of(sheet).pop();
              context.router.push(BookingDetailRoute(ref: e.s('bookingRef')));
            },
          ),
      ],
    );
  }
}
