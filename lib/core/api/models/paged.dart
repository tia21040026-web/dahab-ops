import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged.freezed.dart';
part 'paged.g.dart';

/// The contract's list shape: `{ items: T[], nextCursor: string | null, total }`.
/// Endpoints that return `{ items }` only parse with `nextCursor == null`.
@Freezed(genericArgumentFactories: true)
abstract class Paged<T> with _$Paged<T> {
  const Paged._();

  const factory Paged({
    @Default([]) List<T> items,
    String? nextCursor,
    @Default(0) int total,
  }) = _Paged<T>;

  factory Paged.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PagedFromJson(json, fromJsonT);

  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;

  /// Total if the server sent one, else what we hold.
  int get count => total > 0 ? total : items.length;

  Paged<T> append(Paged<T> next) =>
      Paged(items: [...items, ...next.items], nextCursor: next.nextCursor, total: next.total);
}

/// Standard list query: `cursor`, `limit` (1..100, default 25), `sort`, `q`.
class ListQuery {
  const ListQuery({this.cursor, this.limit = 25, this.sort, this.q, this.filters = const {}});

  final String? cursor;
  final int limit;

  /// `field` ascending, `-field` descending.
  final String? sort;
  final String? q;
  final Map<String, Object?> filters;

  ListQuery copyWith({
    String? cursor,
    bool clearCursor = false,
    int? limit,
    String? sort,
    String? q,
    Map<String, Object?>? filters,
  }) =>
      ListQuery(
        cursor: clearCursor ? null : (cursor ?? this.cursor),
        limit: limit ?? this.limit,
        sort: sort ?? this.sort,
        q: q ?? this.q,
        filters: filters ?? this.filters,
      );

  Map<String, dynamic> toQuery() => {
        if (cursor != null) 'cursor': cursor,
        'limit': limit.clamp(1, 100),
        if (sort != null && sort!.isNotEmpty) 'sort': sort,
        if (q != null && q!.trim().isNotEmpty) 'q': q!.trim(),
        for (final e in filters.entries)
          if (e.value != null && '${e.value}'.isNotEmpty) e.key: e.value,
      };
}
