import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dahab_ops/core/api/models/json_record.dart';
import 'package:dahab_ops/core/api/models/paged.dart';
import 'package:dahab_ops/core/list/list_cubit.dart';
import 'package:dahab_ops/features/control/presentation/audit_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _Row extends JsonRecord {
  const _Row(super.json);
}

void main() {
  group('ListCubit', () {
    test('loads, pages with the cursor, and filters', () async {
      final seen = <ListQuery>[];
      final cubit = ListCubit<int>((q) async {
        seen.add(q);
        return q.cursor == null
            ? const Paged(items: [1, 2], nextCursor: 'c2', total: 3)
            : const Paged(items: [3]);
      });
      await cubit.start();
      expect(cubit.state.items, [1, 2]);
      expect(cubit.state.hasMore, isTrue);
      await cubit.loadMore();
      expect(cubit.state.items, [1, 2, 3]);
      expect(cubit.state.hasMore, isFalse);
      expect(seen.last.cursor, 'c2');

      await cubit.setFilter('status', 'OPEN');
      expect(seen.last.filters, {'status': 'OPEN'});
      expect(seen.last.cursor, isNull);
      await cubit.setFilters({'status': null, 'actor': 'a@b.c', 'action': ''});
      expect(seen.last.filters, {'actor': 'a@b.c'});
      await cubit.close();
    });

    test('first failure is a failure state; later failures keep rows', () async {
      var fail = true;
      final cubit = ListCubit<int>((q) async {
        if (fail) throw const ApiError(kind: ApiErrorKind.network);
        return const Paged(items: [1]);
      });
      await cubit.start();
      expect(cubit.state.status, ListStatus.failure);
      expect(cubit.state.error?.kind, ApiErrorKind.network);
      fail = false;
      await cubit.refresh();
      expect(cubit.state.items, [1]);
      fail = true;
      await cubit.refresh();
      expect(cubit.state.items, [1], reason: 'stale rows survive a failed refresh');
      await cubit.close();
    });

    test('replaceWhere / removeWhere patch locally', () async {
      final cubit = ListCubit<int>((_) async => const Paged(items: [1, 2, 3]));
      await cubit.start();
      cubit
        ..replaceWhere((i) => i == 2, 20)
        ..removeWhere((i) => i == 3);
      expect(cubit.state.items, [1, 20]);
      await cubit.close();
    });
  });

  group('pagedFrom', () {
    test('reads contract and legacy shapes', () {
      final contract = pagedFrom({'items': [{'id': 'a'}], 'nextCursor': 'n', 'total': 9}, const ['trips'], _Row.new);
      expect(contract.items.single.id, 'a');
      expect(contract.nextCursor, 'n');
      expect(contract.total, 9);
      final legacy = pagedFrom({'trips': [{'id': 'b'}, 'junk']}, const ['trips'], _Row.new);
      expect(legacy.items.single.id, 'b');
      expect(legacy.total, 1);
    });

    test('JsonRecord accessors are lenient', () {
      const r = _Row({'n': '12', 'b': 1, 'actor': {'email': 'x@y.z'}, 'd': '2026-10-15T00:00:00Z'});
      expect(r.n('n'), 12);
      expect(r.b('b'), isTrue);
      expect(r.s('actor'), 'x@y.z');
      expect(r.d('d')?.year, 2026);
      expect(r.s('missing', '—'), '—');
    });
  });

  test('AuditDiff.changedKeys skips unchanged values', () {
    expect(
      AuditDiff.changedKeys({'rate': 0.15, 'cur': 'EGP'}, {'rate': 0.12, 'cur': 'EGP', 'new': true}),
      ['new', 'rate'],
    );
    expect(AuditDiff.changedKeys(null, 5), ['value']);
    expect(AuditDiff.changedKeys({'a': 1}, {'a': 1}), isEmpty);
  });
}
