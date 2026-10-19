import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dahab_button.dart';
import '../../../core/design/components/dahab_text_field.dart';
import '../../../core/design/components/data_card.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/filter_bar.dart';
import '../../../core/design/components/primitives.dart';
import '../../../core/design/components/sla_ring.dart';
import '../../../core/design/components/status_badge.dart';
import '../../../core/design/spacing.dart';
import '../../../core/format/formatters.dart';
import '../../../core/api/models/paged.dart';
import '../../../core/list/async_list_view.dart';
import '../../../core/list/list_cubit.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/domain/permissions.dart';
import '../../access/presentation/session_cubit.dart';
import 'support_repository.dart';

/// Support inbox: open first, SLA ring against `support.slaMinutes` (30),
/// reply in place.
@RoutePage()
class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const sla = Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    final repo = GetIt.I<SupportRepository>();
    return BlocProvider(
      create: (_) => ListCubit<SupportMessage>(repo.messages,
          initial: const ListQuery(filters: {'status': 'OPEN'}))
        ..start(),
      child: const _SupportView(),
    );
  }
}

class _SupportView extends StatelessWidget {
  const _SupportView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.watch<ListCubit<SupportMessage>>();
    return SectionScaffold(
      title: l.sectionSupport,
      permission: P.opsSupport,
      body: AsyncListView<SupportMessage>(
        header: FilterBar<String>(
          options: [
            FilterOption(null, l.all),
            for (final s in SupportMessage.statuses) FilterOption(s, StatusBadge.humanize(s)),
          ],
          selected: cubit.state.filter('status') as String?,
          onSelected: (v) => cubit.setFilter('status', v),
        ),
        emptyIcon: Icons.support_agent_outlined,
        itemBuilder: (context, m) {
          final waiting = m.createdAt == null ? null : DateTime.now().difference(m.createdAt!);
          final openish = m.status == 'OPEN' || m.status == 'ESCALATED';
          return DataCard(
            title: m.traveler,
            subtitle: m.message,
            id: m.bookingRef,
            status: m.urgent ? l.urgent : StatusBadge.humanize(m.status),
            statusTone: m.urgent ? Tone.critical : StatusBadge.toneFor(m.status),
            leading: openish && waiting != null
                ? SlaRing(total: SupportPage.sla, remaining: SupportPage.sla - waiting, showLabel: false, size: 28)
                : null,
            fields: [
              if (m.category.isNotEmpty) DataField(l.fCategory, m.category),
              DataField(l.fCreated, Fmt.ago(context, m.createdAt)),
            ],
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<SessionCubit>()),
                  BlocProvider.value(value: context.read<ListCubit<SupportMessage>>()),
                ],
                child: _Thread(message: m),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Thread extends StatefulWidget {
  const _Thread({required this.message});

  final SupportMessage message;

  @override
  State<_Thread> createState() => _ThreadState();
}

class _ThreadState extends State<_Thread> {
  final _reply = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _reply.text.trim();
    if (text.isEmpty) return;
    setState(() => _busy = true);
    final cubit = context.read<ListCubit<SupportMessage>>();
    try {
      final updated = await GetIt.I<SupportRepository>().reply(widget.message.id, text);
      cubit.replaceWhere((m) => m.id == widget.message.id, updated);
      if (!mounted) return;
      showToast(context, context.l10n.replySent, tone: Tone.positive);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showErrorToast(context, e);
      }
    }
  }

  Widget _bubble(BuildContext context, String text, String meta, {required bool mine}) {
    final t = context.dg;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: Space.xs),
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(
            color: mine ? t.actionWash : t.surface,
            border: Border.all(color: t.line, width: t.hairline),
            borderRadius: Radii.mdAll,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SelectableText(text, style: context.type.body),
            Gap.h4,
            Text(meta, style: context.type.caption.copyWith(color: t.ink3)),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final m = widget.message;
    final canReply = context.select<SessionCubit, bool>((s) => s.state.can('ops.support.reply'));
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        builder: (context, scroll) => Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.lg, Space.gutter, Space.sm),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.traveler, style: context.type.heading),
                  if (m.phone != null) MonoText(m.phone!),
                ]),
              ),
              StatusBadge(label: StatusBadge.humanize(m.status), tone: StatusBadge.toneFor(m.status)),
            ]),
          ),
          if (m.bookingRef != null)
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: Space.gutter),
              leading: Icon(Icons.confirmation_number_outlined, color: t.ink2),
              title: MonoText(m.bookingRef!, color: t.ink),
              trailing: Text(l.openBooking, style: TextStyle(color: t.action)),
              onTap: () {
                Navigator.of(context).pop();
                context.router.push(BookingDetailRoute(ref: m.bookingRef!));
              },
            ),
          Container(height: t.hairline, color: t.line),
          Expanded(
            child: ListView(controller: scroll, padding: const EdgeInsets.all(Space.gutter), children: [
              _bubble(context, m.message, Fmt.dateTime(context, m.createdAt), mine: false),
              if (m.reply != null)
                _bubble(context, m.reply!, '${m.repliedBy ?? ''} · ${Fmt.dateTime(context, m.repliedAt)}',
                    mine: true),
            ]),
          ),
          if (canReply && m.reply == null)
            SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(border: Border(top: t.hairlineSide)),
                padding: const EdgeInsets.all(Space.md),
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: DahabTextField(
                      controller: _reply,
                      hint: l.replyHint,
                      maxLines: 4,
                      minLines: 1,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  Gap.w8,
                  DahabButton(
                    label: l.sendReply,
                    compact: true,
                    loading: _busy,
                    onPressed: _reply.text.trim().isEmpty ? null : _send,
                  ),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}
