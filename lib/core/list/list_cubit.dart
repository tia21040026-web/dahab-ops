import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_error.dart';
import '../api/models/paged.dart';

enum ListStatus { initial, loading, ready, failure }

class ListState<T> extends Equatable {
  const ListState({
    this.status = ListStatus.initial,
    this.items = const [],
    this.nextCursor,
    this.total = 0,
    this.query = const ListQuery(),
    this.loadingMore = false,
    this.error,
  });

  final ListStatus status;
  final List<T> items;
  final String? nextCursor;
  final int total;
  final ListQuery query;
  final bool loadingMore;
  final ApiError? error;

  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;
  bool get isLoading => status == ListStatus.initial || status == ListStatus.loading;
  Object? filter(String key) => query.filters[key];

  ListState<T> copyWith({
    ListStatus? status,
    List<T>? items,
    String? nextCursor,
    bool clearCursor = false,
    int? total,
    ListQuery? query,
    bool? loadingMore,
    ApiError? error,
    bool clearError = false,
  }) =>
      ListState<T>(
        status: status ?? this.status,
        items: items ?? this.items,
        nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
        total: total ?? this.total,
        query: query ?? this.query,
        loadingMore: loadingMore ?? this.loadingMore,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [
        status,
        items,
        nextCursor,
        total,
        query.toQuery().toString(),
        loadingMore,
        error?.toString(),
      ];
}

typedef PageLoader<T> = Future<Paged<T>> Function(ListQuery query);

/// One cubit for every list screen: first load, pull to refresh, cursor
/// paging, filters, sort and search. Sections pass their repository call.
class ListCubit<T> extends Cubit<ListState<T>> {
  ListCubit(this._load, {ListQuery initial = const ListQuery()})
      : super(ListState<T>(query: initial));

  final PageLoader<T> _load;

  Future<void> start() => _reload(showLoading: true);

  Future<void> refresh() => _reload(showLoading: state.items.isEmpty);

  Future<void> _reload({required bool showLoading}) async {
    if (showLoading) emit(state.copyWith(status: ListStatus.loading, clearError: true));
    final q = state.query.copyWith(clearCursor: true);
    try {
      final page = await _load(q);
      if (isClosed) return;
      emit(state.copyWith(
        status: ListStatus.ready,
        items: page.items,
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        total: page.count,
        clearError: true,
      ));
    } catch (e) {
      if (isClosed) return;
      // Keep stale rows on a failed refresh; the view shows a toast.
      emit(state.copyWith(status: ListStatus.failure, error: ApiError.from(e)));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final page = await _load(state.query.copyWith(cursor: state.nextCursor));
      if (isClosed) return;
      emit(state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        total: page.total > 0 ? page.total : null,
        loadingMore: false,
      ));
    } catch (e) {
      if (!isClosed) emit(state.copyWith(loadingMore: false, error: ApiError.from(e)));
    }
  }

  Future<void> setFilter(String key, Object? value) {
    final filters = {...state.query.filters, key: value}..removeWhere((_, v) => v == null);
    emit(state.copyWith(query: ListQuery(
      limit: state.query.limit,
      sort: state.query.sort,
      q: state.query.q,
      filters: filters,
    )));
    return _reload(showLoading: true);
  }

  /// Merges [changes] into the filters (null / empty removes) and reloads once.
  Future<void> setFilters(Map<String, Object?> changes) {
    final filters = {...state.query.filters, ...changes}
      ..removeWhere((_, v) => v == null || (v is String && v.isEmpty));
    emit(state.copyWith(query: ListQuery(
      limit: state.query.limit,
      sort: state.query.sort,
      q: state.query.q,
      filters: filters,
    )));
    return _reload(showLoading: true);
  }

  Future<void> setSort(String? sort) {
    emit(state.copyWith(query: ListQuery(
      limit: state.query.limit,
      sort: sort,
      q: state.query.q,
      filters: state.query.filters,
    )));
    return _reload(showLoading: true);
  }

  Future<void> setSearch(String q) {
    emit(state.copyWith(query: state.query.copyWith(q: q, clearCursor: true)));
    return _reload(showLoading: true);
  }

  /// Local patch after a successful mutation.
  void replaceWhere(bool Function(T) test, T next) =>
      emit(state.copyWith(items: [for (final i in state.items) test(i) ? next : i]));

  void removeWhere(bool Function(T) test) =>
      emit(state.copyWith(items: state.items.where((i) => !test(i)).toList()));
}
