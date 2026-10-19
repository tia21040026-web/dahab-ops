import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/api/api_error.dart';
import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/components/empty_state.dart';
import '../../../core/design/components/error_view.dart';
import '../../../core/design/components/instrument.dart';
import '../../../core/design/components/skeleton_list.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import 'queue_cubit.dart';
import 'queue_item_tile.dart';

/// Priority-sorted action queue with SLA timers (prototype § Queue). Swipe a
/// row toward the start edge to reveal Snooze and Resolve; tap opens the
/// screen that resolves it.
@RoutePage()
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<QueueCubit>()..start(),
      child: const _QueueView(),
    );
  }
}

class _QueueView extends StatelessWidget {
  const _QueueView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final s = context.watch<QueueCubit>().state;
    final ready = s.status == QueueStatus.ready || s.items.isNotEmpty;
    return Scaffold(
      appBar: DgTopBar(
        title: l.queueTitle,
        subtitle: ready ? l.queueSubtitle(s.items.length, s.criticalCount) : null,
        actions: [
          DgIconButton(
            icon: DgIcons.search,
            tooltip: l.search,
            onPressed: () => context.router.push(const SearchRoute()),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (s.status == QueueStatus.initial || s.status == QueueStatus.loading) {
          return const SkeletonList(count: 8);
        }
        if (s.status == QueueStatus.failure && s.items.isEmpty) {
          return ErrorView(
            error: s.error ?? const ApiError(kind: ApiErrorKind.unknown),
            onRetry: () => context.read<QueueCubit>().refresh(),
          );
        }
        final visible = s.visible;
        final cubit = context.read<QueueCubit>();
        return RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView(
            children: [
              DgChipRow(children: [
                for (final (f, label) in [
                  (QueueFilter.all, l.filterAll),
                  (QueueFilter.critical, l.filterCritical),
                  (QueueFilter.suppliers, l.filterSuppliers),
                  (QueueFilter.payments, l.filterPayments),
                  (QueueFilter.support, l.filterSupport),
                ])
                  DgChip(
                    label: label,
                    count: s.countFor(f),
                    selected: s.filter == f,
                    onTap: () => cubit.setFilter(f),
                  ),
              ]),
              if (visible.isEmpty)
                EmptyState(icon: Icons.inbox_outlined, title: l.queueEmpty, body: l.queueEmptyBody)
              else ...[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                  child: Row(children: [
                    DgIcon(DgIcons.back, size: 16, color: t.ink3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l.swipeHint, style: context.type.ui.copyWith(fontSize: 13, color: t.ink3)),
                    ),
                  ]),
                ),
                Container(height: t.hairline, color: t.line),
                for (final item in visible)
                  DecoratedBox(
                    key: ValueKey(item.id),
                    decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
                    child: SwipeActionsRow(
                      onSnooze: () => cubit.snooze(item),
                      onResolve: () => openQueueItem(context, item),
                      child: QueueItemTile(item: item),
                    ),
                  ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}
