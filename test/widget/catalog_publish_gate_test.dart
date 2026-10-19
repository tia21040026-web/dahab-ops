import 'package:dahab_ops/core/api/api_client.dart';
import 'package:dahab_ops/core/design/components/dahab_button.dart';
import 'package:dahab_ops/features/catalog/data/catalog_models.dart';
import 'package:dahab_ops/features/catalog/data/catalog_repository.dart';
import 'package:dahab_ops/features/catalog/presentation/catalog_draft.dart';
import 'package:dahab_ops/features/catalog/presentation/catalog_editor_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/catalog_fixtures.dart';
import '../helpers/fake_adapter.dart';
import '../helpers/pump_app.dart';

void main() {
  setUpAll(setUpTestFonts);
  final schema = sampleSchema();

  CatalogRepository repoWith(FakeHandler h, [List<FakeAdapter>? out]) {
    final a = FakeAdapter(h);
    out?.add(a);
    return CatalogRepository(ApiClient(fakeDio(a)));
  }

  group('client gate', () {
    test('lists required fields, both languages and the photo minimum', () {
      final d = CatalogDraft(repo: repoWith((_) async => const FakeReply(200)), type: 'hotel', schema: schema);
      expect(d.missing, ['title', 'area', 'images', 'priceFromEGP']);
      d.set('title', const I18n(en: 'Lagoon House'));
      expect(d.missing, contains('title'), reason: 'Arabic still empty');
      d.set('title', const I18n(en: 'Lagoon House', ar: 'بيت اللاجون'));
      d.set('area', 'lighthouse');
      d.set('images', ['/api/media/a.jpg']);
      expect(d.missing, ['priceFromEGP']);
      expect(d.complete, isFalse);
      d.set('priceFromEGP', 2400);
      expect(d.complete, isTrue);
      expect(d.completeness, 1);
    });

    test('wizard steps: basics, photos, price', () {
      final s = WizardSteps(schema);
      expect(s.basics.map((f) => f.key), containsAll(['title', 'summary', 'area', 'supplierId']));
      expect(s.basics.map((f) => f.key), isNot(contains('priceFromEGP')));
      expect(s.photos.map((f) => f.key), ['images']);
      expect(s.price.map((f) => f.key), containsAll(['priceFromEGP', 'departures', 'days']));
    });
  });

  test('draft saves POST first, then PATCH dirty keys with If-Match', () async {
    final adapters = <FakeAdapter>[];
    final repo = repoWith((o) async {
      if (o.method == 'POST') return FakeReply(201, {'item': envelope(id: 'H9', updatedAt: 'v1')});
      return FakeReply(200, {'item': envelope(id: 'H9', updatedAt: 'v2')});
    }, adapters);
    final d = CatalogDraft(repo: repo, type: 'hotel', schema: schema);
    d.set('title', const I18n(en: 'A', ar: 'ب'));
    expect(await d.save(), isTrue);
    expect(adapters.single.requests.single.method, 'POST');
    expect(d.item!.id, 'H9');
    d.set('rooms', 4);
    expect(await d.save(), isTrue);
    final patch = adapters.single.requests.last;
    expect(patch.method, 'PATCH');
    expect(patch.headers['If-Match'], 'v1');
    expect(patch.data, {'fields': {'rooms': 4}});
    expect(d.saveState, DraftSave.saved);
  });

  test('409 on autosave moves to conflict; keep mine re-sends with the fresh version', () async {
    var patches = 0;
    final adapters = <FakeAdapter>[];
    final repo = repoWith((o) async {
      if (o.method == 'GET') return FakeReply(200, {'item': envelope(updatedAt: 'v3'), 'children': {}});
      patches++;
      if (patches == 1) return const FakeReply(409, {'status': 409, 'type': 'https://dahab.travel/problems/conflict'});
      return FakeReply(200, {'item': envelope(updatedAt: 'v4')});
    }, adapters);
    final d = CatalogDraft(repo: repo, type: 'hotel', schema: schema, item: CatalogItem(envelope(updatedAt: 'v1')));
    d.set('rooms', 5);
    expect(await d.save(), isFalse);
    expect(d.saveState, DraftSave.conflict);
    expect(await d.resolveConflict(keepMine: true), isTrue);
    expect(adapters.single.requests.last.headers['If-Match'], 'v3');
    expect(d.item!.updatedAtRaw, 'v4');
    expect(d.saveState, DraftSave.saved);
  });

  test('server 422 adds its missing keys to the gate', () async {
    final repo = repoWith((o) async {
      if (o.path.endsWith('/publish')) {
        return const FakeReply(422, {
          'status': 422,
          'type': 'https://dahab.travel/problems/incomplete',
          'missing': ['checkIn'],
        });
      }
      return FakeReply(200, {'item': envelope()});
    });
    final d = CatalogDraft(repo: repo, type: 'hotel', schema: schema, item: CatalogItem(envelope()));
    d
      ..set('title', const I18n(en: 'A', ar: 'ب'))
      ..set('area', 'lighthouse')
      ..set('images', ['/a.jpg'])
      ..set('priceFromEGP', 900);
    expect(d.complete, isTrue);
    expect(await d.publish(), isNull);
    expect(d.missing, ['checkIn']);
    d.set('checkIn', '14:00');
    expect(d.complete, isTrue);
  });

  testWidgets('Publish stays disabled until complete and lists what is missing', (tester) async {
    final d = CatalogDraft(repo: repoWith((_) async => const FakeReply(200)), type: 'hotel', schema: schema);
    var published = 0;
    await tester.pumpWidget(testApp(
      ListenableBuilder(
        listenable: d,
        builder: (context, _) => PublishBar(draft: d, supplier: false, canPublish: true, onPublish: () => published++),
      ),
    ));
    await tester.pumpAndSettle();
    DahabButton publish() => tester.widget<DahabButton>(find.byKey(const Key('cat.publish')));
    expect(publish().onPressed, isNull);
    expect(find.text('4 missing'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cat.missingHint')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cat.missing')), findsOneWidget);
    expect(find.textContaining('Price from'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    d
      ..set('title', const I18n(en: 'A', ar: 'ب'))
      ..set('area', 'lighthouse')
      ..set('images', ['/a.jpg'])
      ..set('priceFromEGP', 900);
    await tester.pump();
    expect(publish().onPressed, isNotNull);
    await tester.tap(find.byKey(const Key('cat.publish')));
    expect(published, 1);
  });

  testWidgets('suppliers submit for review instead of publishing', (tester) async {
    final d = CatalogDraft(repo: repoWith((_) async => const FakeReply(200)), type: 'hotel', schema: schema);
    await tester.pumpWidget(testApp(PublishBar(draft: d, supplier: true, canPublish: true, onPublish: () {})));
    await tester.pumpAndSettle();
    expect(find.text('Submit for review'), findsOneWidget);
    expect(find.text('Publish'), findsNothing);
  });
}
