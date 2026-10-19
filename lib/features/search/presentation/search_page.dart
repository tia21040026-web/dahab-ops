import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/design/app_theme.dart';
import '../../../core/design/components/dg_icons.dart';
import '../../../core/design/spacing.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../l10n/l10n.dart';
import '../../access/presentation/session_cubit.dart';
import '../data/search_repository.dart';

/// Command palette (prototype § Command palette): one search across
/// bookings, travelers and suppliers, plus permission-gated actions.
@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _SearchCubit(GetIt.I<SearchRepository>()),
      child: const _SearchView(),
    );
  }
}

class _SearchCubit extends Cubit<_SearchState> {
  _SearchCubit(this._repo) : super(const _SearchState());

  final SearchRepository _repo;
  Timer? _debounce;

  void query(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      emit(const _SearchState());
      return;
    }
    emit(state.copyWith(loading: true, query: q));
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final items = await _repo.search(q);
        if (isClosed) return;
        // Drop stale responses.
        if (state.query != q) return;
        emit(state.copyWith(loading: false, items: items));
      } catch (_) {
        if (isClosed) return;
        if (state.query != q) return;
        emit(state.copyWith(loading: false, failed: true));
      }
    });
  }

  @override
  Future<void> close() async {
    _debounce?.cancel();
    return super.close();
  }
}

class _SearchState {
  const _SearchState({this.query = '', this.loading = false, this.items = const [], this.failed = false});

  final String query;
  final bool loading;
  final List<SearchHit> items;
  final bool failed;

  _SearchState copyWith({bool? loading, String? query, List<SearchHit>? items, bool? failed}) => _SearchState(
        loading: loading ?? this.loading,
        query: query ?? this.query,
        items: items ?? this.items,
        failed: failed ?? this.failed,
      );
}

class _SearchView extends StatelessWidget {
  const _SearchView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.dg;
    final type = context.type;
    final cubit = context.read<_SearchCubit>();
    final session = context.watch<SessionCubit>().state;
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.viewInsetsOf(context).bottom + MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => context.router.maybePop(),
            child: ColoredBox(color: t.scrim),
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          top: top + 8,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height - top - bottom - 24,
            ),
            child: Material(
              color: t.surface,
              shape: RoundedRectangleBorder(
                borderRadius: Radii.lgAll,
                side: BorderSide(color: t.lineStrong, width: t.hairline),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 56),
                  padding: const EdgeInsetsDirectional.only(start: 14, end: 8),
                  decoration: BoxDecoration(border: Border(bottom: t.hairlineSide)),
                  child: Row(children: [
                    DgIcon(DgIcons.search, color: t.ink3),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onChanged: cubit.query,
                        cursorColor: t.action,
                        style: type.ui.copyWith(fontSize: 17, color: t.ink),
                        decoration: InputDecoration(
                          hintText: l.searchHint,
                          hintStyle: type.ui.copyWith(fontSize: 17, color: t.ink3),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.router.maybePop(),
                      child: Text(l.cancel,
                          style: type.ui.copyWith(fontSize: 15, fontWeight: FontWeight.w500, color: t.action)),
                    ),
                  ]),
                ),
                Flexible(
                  child: BlocBuilder<_SearchCubit, _SearchState>(
                    builder: (context, s) {
                      final children = <Widget>[];
                      if (s.query.trim().isNotEmpty) {
                        if (s.loading && s.items.isEmpty) {
                          children.add(const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          ));
                        } else if (s.failed && s.items.isEmpty) {
                          children.add(_Note(l.errorGeneric));
                        } else if (s.items.isEmpty) {
                          children.add(_Note(l.searchEmptyBody));
                        } else {
                          final groups = <String, List<SearchHit>>{};
                          for (final h in s.items) {
                            groups.putIfAbsent(h.type, () => []).add(h);
                          }
                          for (final (i, entry) in groups.entries.indexed) {
                            children.add(_Group(
                              first: i == 0,
                              title: _groupTitle(context, entry.key),
                              children: [
                                for (final (j, h) in entry.value.indexed)
                                  _HitRow(hit: h, query: s.query, selected: i == 0 && j == 0),
                              ],
                            ));
                          }
                        }
                      }
                      final actions = _actions(context, session);
                      if (actions.isNotEmpty) {
                        children.add(_Group(first: children.isEmpty, title: l.actionsTitle, children: actions));
                      }
                      return ListView(shrinkWrap: true, padding: EdgeInsets.zero, children: children);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(border: Border(top: t.hairlineSide)),
                  child: Row(children: [
                    DgIcon(DgIcons.shield, size: 16, color: t.ink3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l.paletteFootnote, style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  List<Widget> _actions(BuildContext context, SessionState session) {
    final l = context.l10n;
    return [
      if (session.can('ops.commerce.refund'))
        _Row(
          icon: DgIcons.wallet,
          title: Text(l.refundAction),
          onTap: () => context.router.push(const QueueRoute()),
        ),
      if (session.can('admin.approvals.decide'))
        _Row(
          icon: DgIcons.shield,
          title: Text(l.controlApprovals),
          onTap: () => context.router.push(const ApprovalsRoute()),
        ),
    ];
  }

  String _groupTitle(BuildContext context, String type) {
    final l = context.l10n;
    return switch (type) {
      'booking' => l.typeBooking,
      'user' => l.typeUser,
      'supplier' => l.typeSupplier,
      'property' => l.typeProperty,
      _ => type,
    };
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text,
            textAlign: TextAlign.center, style: context.type.ui.copyWith(fontSize: 14, color: context.dg.ink3)),
      );
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children, this.first = false});

  final String title;
  final List<Widget> children;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      decoration: first ? null : BoxDecoration(border: Border(top: t.hairlineSide)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Semantics(
            header: true,
            child: Text(title,
                style: context.type.ui.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: t.ink3)),
          ),
        ),
        ...children,
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.title, required this.onTap, this.subtitle, this.selected = false});

  final DgIcons icon;
  final Widget title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    return Material(
      color: selected ? t.raised2 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: t.raised,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: t.line, width: t.hairline),
              ),
              child: DgIcon(icon, size: 17, color: t.ink2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: type.ui.copyWith(fontSize: 15, color: t.ink),
                  child: title,
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: type.ui.copyWith(fontSize: 13, color: t.ink3)),
              ]),
            ),
            DgIcon(DgIcons.chev, size: 16, color: t.ink3),
          ]),
        ),
      ),
    );
  }
}

class _HitRow extends StatelessWidget {
  const _HitRow({required this.hit, required this.query, this.selected = false});

  final SearchHit hit;
  final String query;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final t = context.dg;
    final type = context.type;
    final base = type.ui.copyWith(fontSize: 15, color: t.ink);
    final mark = base.copyWith(
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: t.action,
    );
    final q = query.trim().toLowerCase();
    final title = hit.title;
    final i = q.isEmpty ? -1 : title.toLowerCase().indexOf(q);
    final spans = i < 0
        ? [TextSpan(text: title)]
        : [
            TextSpan(text: title.substring(0, i)),
            TextSpan(text: title.substring(i, i + q.length), style: mark),
            TextSpan(text: title.substring(i + q.length)),
          ];
    return _Row(
      icon: switch (hit.type) {
        'booking' => DgIcons.cal,
        'user' => DgIcons.user,
        'supplier' => DgIcons.building,
        'property' => DgIcons.building,
        _ => DgIcons.search,
      },
      title: Text.rich(TextSpan(children: spans), style: base),
      subtitle: hit.subtitle,
      selected: selected,
      onTap: () => _open(context),
    );
  }

  void _open(BuildContext context) {
    final router = context.router;
    final route = hit.route;
    final booking = RegExp(r'/ops/bookings/([^/]+)').firstMatch(route);
    if (booking != null) {
      router.push(BookingDetailRoute(ref: Uri.decodeComponent(booking.group(1)!)));
      return;
    }
    final supplier = RegExp(r'/ops/suppliers/([^/]+)').firstMatch(route);
    if (supplier != null) {
      router.push(SupplierInboxRoute(supplierId: Uri.decodeComponent(supplier.group(1)!)));
      return;
    }
    if (route.startsWith('/admin/users')) {
      router.push(const UsersRoute());
      return;
    }
    router.maybePop();
  }
}
