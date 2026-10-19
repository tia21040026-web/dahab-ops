import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/idempotency.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/detail_sheet.dart';
import '../../../core/list/list_cubit.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'messaging_repository.dart';

/// Notification log by channel. Sending is not on the API yet: the compose
/// button explains that instead of failing.
@RoutePage()
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const channels = ['IN_APP', 'PUSH', 'SMS', 'WHATSAPP', 'EMAIL'];

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<MessagingRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<OpsNotificationRow>(repo.notifications)..start(),
      child: Builder(builder: (context) {
        final cubit = context.watch<ListCubit<OpsNotificationRow>>();
        return SectionScaffold(
          title: l.sectionNotifications,
          permission: P.opsNotifications,
          floating: FloatingActionButton.extended(
            onPressed: () => showDetailSheet<void>(
              context,
              title: l.sendNotification,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Space.gutter),
                  child: Text(l.notificationsSendUnavailable, style: context.type.body),
                ),
              ],
            ),
            icon: const Icon(Icons.campaign_outlined),
            label: Text(l.sendNotification),
          ),
          body: AsyncListView<OpsNotificationRow>(
            header: FilterBar<String>(
              options: [
                FilterOption(null, l.all),
                for (final c in channels) FilterOption(c, StatusBadge.humanize(c)),
              ],
              selected: cubit.state.filter('channel') as String?,
              onSelected: (v) => cubit.setFilter('channel', v),
            ),
            emptyIcon: Icons.notifications_none,
            itemBuilder: (context, n) => DataCard(
              title: n.title,
              subtitle: n.message,
              status: StatusBadge.humanize(n.status),
              statusTone: StatusBadge.toneFor(n.status),
              leading: n.read ? null : StatusDot(color: context.dg.action),
              fields: [
                DataField(l.fChannel, StatusBadge.humanize(n.channel)),
                DataField(l.fCreated, Fmt.ago(context, n.createdAt)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// SMS log and an idempotent composer (`ops.sms.send`).
@RoutePage()
class SmsPage extends StatelessWidget {
  const SmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<MessagingRepository>();
    final l = context.l10n;
    return BlocProvider(
      create: (_) => ListCubit<SmsLog>(repo.smsLogs)..start(),
      child: Builder(builder: (context) {
        final canSend = context.select<SessionCubit, bool>((s) => s.state.can('ops.sms.send'));
        return SectionScaffold(
          title: l.sectionSms,
          permission: 'ops.sms.view',
          floating: canSend
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    final sent = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) => const SmsComposer(),
                    );
                    if (sent == true && context.mounted) {
                      await context.read<ListCubit<SmsLog>>().refresh();
                    }
                  },
                  icon: const Icon(Icons.sms_outlined),
                  label: Text(l.sendSms),
                )
              : null,
          body: AsyncListView<SmsLog>(
            emptyIcon: Icons.sms_outlined,
            itemBuilder: (context, m) => DataCard(
              title: m.name.isEmpty ? m.to : m.name,
              subtitle: m.message,
              id: m.to,
              status: m.simulated ? l.simulated : StatusBadge.humanize(m.status),
              statusTone: m.error != null ? Tone.critical : StatusBadge.toneFor(m.status),
              fields: [
                DataField(l.fChannel, StatusBadge.humanize(m.channel)),
                DataField(l.fDate, Fmt.ago(context, m.at)),
                if (m.bookingRef != null) DataField(l.fBooking, m.bookingRef!, mono: true),
              ],
              footer: m.error == null
                  ? null
                  : Text(m.error!, style: context.type.caption.copyWith(color: context.dg.critical)),
            ),
          ),
        );
      }),
    );
  }
}

class SmsComposer extends StatefulWidget {
  const SmsComposer({super.key});

  @override
  State<SmsComposer> createState() => _SmsComposerState();
}

class _SmsComposerState extends State<SmsComposer> {
  final _to = TextEditingController();
  final _name = TextEditingController();
  final _message = TextEditingController();
  final _booking = TextEditingController();

  /// One key per intent: a retry after a timeout reuses it, an edit resets it.
  String _key = Idempotency.newKey();
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_to, _name, _message, _booking]) {
      c.dispose();
    }
    super.dispose();
  }

  void _edited(String _) => setState(() => _key = Idempotency.newKey());

  bool get _valid =>
      RegExp(r'^\+?[0-9 ]{8,16}$').hasMatch(_to.text.trim()) &&
      _name.text.trim().isNotEmpty &&
      _message.text.trim().isNotEmpty;

  Future<void> _send() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final r = await GetIt.I<MessagingRepository>().sendSms(
        to: _to.text.replaceAll(' ', ''),
        recipientName: _name.text.trim(),
        message: _message.text.trim(),
        bookingRef: _booking.text.trim().isEmpty ? null : _booking.text.trim(),
        idempotencyKey: _key,
      );
      if (!mounted) return;
      showToast(context, r.replayed ? l.smsReplayed : l.smsSent, tone: Tone.positive);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showErrorToast(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          Text(l.sendSms, style: context.type.heading),
          Gap.h16,
          DahabTextField(
            label: l.fRecipient,
            controller: _to,
            mono: true,
            hint: '+20 1xx xxx xxxx',
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            onChanged: _edited,
          ),
          Gap.h12,
          DahabTextField(label: l.recipientName, controller: _name, onChanged: _edited),
          Gap.h12,
          DahabTextField(
            label: l.fMessage,
            controller: _message,
            maxLines: 5,
            maxLength: 480,
            onChanged: _edited,
          ),
          Gap.h12,
          DahabTextField(
            label: '${l.fBooking} (${l.optional})',
            controller: _booking,
            mono: true,
            onChanged: _edited,
          ),
          Gap.h16,
          DahabButton(
            label: l.sendSms,
            icon: Icons.send,
            expand: true,
            loading: _busy,
            onPressed: _valid ? _send : null,
          ),
        ]),
      ),
    );
  }
}
