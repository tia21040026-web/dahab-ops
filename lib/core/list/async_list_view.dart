import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../design/components/empty_state.dart';
import '../design/components/error_view.dart';
import '../design/components/offline_banner.dart';
import '../design/components/permission_gate.dart';
import '../design/components/skeleton_list.dart';
import '../design/spacing.dart';
import 'list_cubit.dart';
import '../router/shell_leading.dart';

/// Renders a [ListCubit]: skeleton while loading, [ErrorView] on a first
/// failure, [EmptyState] when empty, pull to refresh and infinite scroll.
/// A failed refresh keeps the rows and shows a toast.
class AsyncListView<T> extends StatelessWidget {
  const AsyncListView({
    super.key,
    required this.itemBuilder,
    this.header,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyTitle,
    this.emptyBody,
    this.where,
    this.padding = const EdgeInsets.only(top: Space.sm, bottom: Space.x3),
  });

  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Sits above the rows and stays visible in every state (filters).
  final Widget? header;
  final IconData emptyIcon;
  final String? emptyTitle;
  final String? emptyBody;

  /// Client-side filter for endpoints that cannot filter server-side.
  final bool Function(T item)? where;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListCubit<T>, ListState<T>>(
      listenWhen: (a, b) => b.error != null && a.error != b.error && b.items.isNotEmpty,
      listener: (context, s) => showErrorToast(context, s.error!),
      builder: (context, s) {
        final cubit = context.read<ListCubit<T>>();
        final rows = where == null ? s.items : s.items.where(where!).toList();
        Widget body;
        if (s.isLoading && s.items.isEmpty) {
          body = const SkeletonList();
        } else if (s.status == ListStatus.failure && s.items.isEmpty) {
          body = ListView(children: [ErrorView(error: s.error!, onRetry: cubit.start, compact: true)]);
        } else if (rows.isEmpty) {
          body = ListView(children: [
            EmptyState(icon: emptyIcon, title: emptyTitle, body: emptyBody),
          ]);
        } else {
          body = NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 400) cubit.loadMore();
              return false;
            },
            child: ListView.builder(
              padding: padding,
              itemCount: rows.length + (s.hasMore ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= rows.length) {
                  return const Padding(
                    padding: EdgeInsets.all(Space.lg),
                    child: Center(child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                  );
                }
                return itemBuilder(context, rows[i]);
              },
            ),
          );
        }
        return Column(children: [
          const OfflineBanner(),
          if (header != null) header!,
          Expanded(child: RefreshIndicator(onRefresh: cubit.refresh, child: body)),
        ]);
      },
    );
  }
}

/// Standard section screen: app bar + permission gate + body.
class SectionScaffold extends StatelessWidget {
  const SectionScaffold({
    super.key,
    required this.title,
    required this.permission,
    required this.body,
    this.actions = const [],
    this.floating,
    this.bottom,
  });

  final String title;
  final String permission;
  final Widget body;
  final List<Widget> actions;
  final Widget? floating;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: shellLeading(context),
        automaticallyImplyLeading: false,
        title: Text(title),
        actions: actions,
        bottom: bottom,
      ),
      floatingActionButton: floating == null
          ? null
          : PermissionGate(permission: permission, child: floating!),
      body: PermissionGate(permission: permission, explain: true, child: body),
    );
  }
}

/// Polished stand-in for a section that has no mobile endpoint yet.
class ComingNextView extends StatelessWidget {
  const ComingNextView({super.key, this.body});

  final String? body;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return EmptyState(
      icon: Icons.construction_outlined,
      title: l.comingNextTitle,
      body: body ?? l.comingNextBody,
    );
  }
}
