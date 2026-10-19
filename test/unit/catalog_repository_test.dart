import 'package:dahab_ops/core/api/api_client.dart';
import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dahab_ops/core/api/models/paged.dart';
import 'package:dahab_ops/features/catalog/data/catalog_models.dart';
import 'package:dahab_ops/features/catalog/data/catalog_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/catalog_fixtures.dart';
import '../helpers/fake_adapter.dart';

void main() {
  late FakeAdapter adapter;
  late Future<FakeReply> Function(RequestOptions o) reply;

  CatalogRepository repo({bool supplier = false}) {
    adapter = FakeAdapter((o) => reply(o));
    return CatalogRepository(ApiClient(fakeDio(adapter)), supplier: supplier);
  }

  test('schema parses types, sections, fields and children', () async {
    reply = (_) async => const FakeReply(200, {'types': [sampleSchemaJson]});
    final types = await repo().schema();
    expect(adapter.requests.single.path, '/api/admin/catalog/schema');
    final t = types.single;
    expect(t.type, 'hotel');
    expect(t.labelOf(true), 'الفنادق والإقامات');
    expect(t.sections.map((s) => s.key), ['basics', 'media', 'pricing']);
    expect({for (final f in t.fields) f.kind}, FieldKind.values.toSet());
    expect(t.field('area')!.options.first.label.of(false), 'Lighthouse');
    expect(t.field('amenities')!.suggestions, ['wifi', 'pool']);
    expect(t.children.last.isRateCalendar, isTrue);
    expect(t.children.first.itemType, 'hotel-room');
  });

  test('list parses envelopes, cursor and total; query params pass through', () async {
    reply = (_) async => FakeReply(200, {
          'items': [envelope(images: ['/api/media/a.jpg', '/api/media/b.jpg'])],
          'nextCursor': 'c2',
          'total': 41,
        });
    final page = await repo().list('hotel', const ListQuery(q: 'lag', filters: {'status': 'draft'}));
    final q = adapter.requests.single.queryParameters;
    expect(adapter.requests.single.path, '/api/admin/catalog/hotel');
    expect(q['status'], 'draft');
    expect(q['q'], 'lag');
    expect(page.total, 41);
    expect(page.nextCursor, 'c2');
    final item = page.items.single;
    expect(item.title.of(false), 'Lagoon House');
    expect(item.title.of(true), 'بيت اللاجون');
    expect(item.coverImage, '/api/media/a.jpg');
    expect(item.supplierName, 'Lagoon Co');
    expect(item.completeness, 0.5);
    expect(item.updatedAtRaw, '2026-10-01T10:00:00.000Z');
  });

  test('supplier role uses the supplier surface', () async {
    reply = (_) async => const FakeReply(200, {'items': []});
    await repo(supplier: true).list('activity', const ListQuery());
    expect(adapter.requests.single.path, '/api/supplier/catalog/activity');
  });

  test('detail parses item and children', () async {
    reply = (_) async => FakeReply(200, {
          'item': envelope(),
          'children': {
            'rooms': [envelope(id: 'R1', title: const {'en': 'Sea room', 'ar': ''})],
          },
        });
    final d = await repo().get('hotel', 'H1');
    expect(d.item.id, 'H1');
    expect(d.children['rooms']!.single.title.of(true), 'Sea room');
  });

  test('patch sends If-Match and returns the updated envelope', () async {
    reply = (_) async => FakeReply(200, {'item': envelope(updatedAt: '2026-10-02T00:00:00.000Z')});
    final next = await repo().patch('hotel', 'H1', {'fields': {'rooms': 3}}, ifMatch: '2026-10-01T10:00:00.000Z');
    final r = adapter.requests.single;
    expect(r.method, 'PATCH');
    expect(r.headers['If-Match'], '2026-10-01T10:00:00.000Z');
    expect(r.data, {'fields': {'rooms': 3}});
    expect(next.updatedAtRaw, '2026-10-02T00:00:00.000Z');
  });

  test('stale If-Match surfaces as a conflict', () async {
    reply = (_) async => const FakeReply(409, {'type': 'https://dahab.travel/problems/conflict', 'status': 409});
    await expectLater(
      repo().patch('hotel', 'H1', const {}, ifMatch: 'x'),
      throwsA(predicate((Object? e) => e != null && isConflict(e) && e is ApiError && e.kind == ApiErrorKind.conflict)),
    );
  });

  test('publish 422 lists missing fields', () async {
    reply = (_) async => const FakeReply(422, {
          'type': 'https://dahab.travel/problems/incomplete',
          'status': 422,
          'missing': ['images', 'priceFromEGP'],
        });
    try {
      await repo().publish('hotel', 'H1');
      fail('expected 422');
    } catch (e) {
      expect(isIncomplete(e), isTrue);
      expect(missingFromError(e), ['images', 'priceFromEGP']);
    }
  });

  test('delete 409 in-use is recognised', () async {
    reply = (_) async => const FakeReply(409, {'type': 'https://dahab.travel/problems/in-use', 'status': 409});
    try {
      await repo().delete('hotel', 'H1', reason: 'duplicate listing');
      fail('expected 409');
    } catch (e) {
      expect(isInUse(e), isTrue);
    }
    expect(adapter.requests.single.data, {'reason': 'duplicate listing'});
  });

  test('rates parse nights; setRates sends the range body', () async {
    reply = (o) async => o.method == 'GET'
        ? const FakeReply(200, {
            'nights': [
              {'date': '2026-11-01', 'roomId': 'R1', 'nightlyEGP': 2400, 'closed': false},
              {'date': '2026-11-02', 'roomId': 'R1', 'nightlyEGP': null, 'closed': true},
            ],
          })
        : const FakeReply(200, {'ok': true});
    final r = repo();
    final nights = await r.rates('H1', roomId: 'R1', from: DateTime(2026, 11, 1), to: DateTime(2026, 11, 30));
    expect(adapter.requests.first.queryParameters, {'roomId': 'R1', 'from': '2026-11-01', 'to': '2026-11-30'});
    expect(nights.first.nightlyEGP, 2400);
    expect(nights.last.closed, isTrue);
    expect(nights.first.date, DateTime(2026, 11, 1));

    await r.setRates('H1', roomId: 'R1', from: DateTime(2026, 11, 3), to: DateTime(2026, 11, 9), nightlyEGP: 2600, weekdays: [4, 5]);
    final put = adapter.requests.last;
    expect(put.method, 'PUT');
    expect(put.path, '/api/admin/catalog/hotel/H1/rates');
    expect(put.data, {'roomId': 'R1', 'from': '2026-11-03', 'to': '2026-11-09', 'nightlyEGP': 2600, 'weekdays': [4, 5]});
  });

  test('slots parse from startsAt; all-week weekdays are omitted', () async {
    reply = (o) async => o.method == 'GET'
        ? const FakeReply(200, {
            'items': [
              {'id': 'S1', 'startsAt': '2026-11-05T08:30:00', 'capacity': 12, 'booked': 4},
            ],
          })
        : const FakeReply(200, {});
    final r = repo();
    final slots = await r.slots('A1', from: DateTime(2026, 11, 1), to: DateTime(2026, 11, 30));
    expect(slots.single.time, '08:30');
    expect(slots.single.date, DateTime(2026, 11, 5));
    expect(slots.single.capacity - slots.single.booked, 8);
    await r.setSlots('A1', from: DateTime(2026, 11, 1), to: DateTime(2026, 11, 30), times: ['08:30'], capacity: 12, weekdays: [0, 1, 2, 3, 4, 5, 6]);
    expect(adapter.requests.last.data, {'from': '2026-11-01', 'to': '2026-11-30', 'times': ['08:30'], 'capacity': 12});
  });

  test('write body splits envelope keys from fields and skips local keys', () {
    final body = CatalogValues.body({
      'title': const I18n(en: 'A', ar: 'ب'),
      'images': ['/x.jpg'],
      'priceFromEGP': 900,
      '_supplierName': 'Lagoon',
      'supplierId': 'SUP-1',
    });
    expect(body, {
      'title': {'en': 'A', 'ar': 'ب'},
      'images': ['/x.jpg'],
      'supplierId': 'SUP-1',
      'fields': {'priceFromEGP': 900},
    });
  });
}
