import 'package:dahab_ops/core/design/components/instrument.dart';
import 'package:dahab_ops/features/catalog/data/catalog_models.dart';
import 'package:dahab_ops/features/catalog/form/catalog_form_engine.dart';
import 'package:dahab_ops/features/catalog/form/supplier_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/catalog_fixtures.dart';
import '../helpers/pump_app.dart';

/// Hosts one field of the sample schema and records every change.
class _Host extends StatefulWidget {
  const _Host({required this.field, this.initial = const {}, required this.log, this.pickSupplier});

  final CatalogField field;
  final Map<String, Object?> initial;
  final Map<String, Object?> log;
  final SupplierPick? pickSupplier;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late Map<String, Object?> values = {...widget.initial};

  @override
  Widget build(BuildContext context) => CatalogFormEngine(
        fields: [widget.field],
        values: values,
        pickSupplier: widget.pickSupplier,
        uploader: (_, __, ____) async => '/api/media/new.jpg',
        onChanged: (k, v) => setState(() {
          values = {...values, k: v};
          widget.log[k] = v;
        }),
      );
}

void main() {
  setUpAll(setUpTestFonts);
  final schema = sampleSchema();
  CatalogField f(String key) => schema.field(key)!;

  Future<Map<String, Object?>> pump(WidgetTester tester, String key,
      {Map<String, Object?> initial = const {}, Locale locale = const Locale('en'), SupplierPick? pick}) async {
    final log = <String, Object?>{};
    await tester.pumpWidget(testApp(_Host(field: f(key), initial: initial, log: log, pickSupplier: pick), locale: locale));
    await tester.pumpAndSettle();
    return log;
  }

  testWidgets('every kind in the sample schema renders', (tester) async {
    await tester.pumpWidget(testApp(CatalogFormEngine(sections: schema.sections, values: const {}, onChanged: (_, __) {})));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Basics'), findsOneWidget);
  });

  testWidgets('text', (tester) async {
    final log = await pump(tester, 'code');
    await tester.enterText(find.byKey(const Key('cat.code')), 'LH-01');
    expect(log['code'], 'LH-01');
  });

  testWidgets('i18nText: EN/AR tabs with missing-language dot', (tester) async {
    final log = await pump(tester, 'title');
    expect(find.byKey(const Key('cat.title.missing.en')), findsOneWidget);
    expect(find.byKey(const Key('cat.title.missing.ar')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('cat.title.en')), 'Lagoon House');
    await tester.pump();
    expect(find.byKey(const Key('cat.title.missing.en')), findsNothing);
    expect(find.byKey(const Key('cat.title.missing.ar')), findsOneWidget);
    expect(find.text('Arabic is missing'.replaceFirst('Arabic', 'العربية')), findsOneWidget);
    await tester.tap(find.byKey(const Key('cat.title.tab.ar')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('cat.title.ar')), 'بيت اللاجون');
    await tester.pump();
    expect(find.byKey(const Key('cat.title.missing.ar')), findsNothing);
    expect(log['title'], const I18n(en: 'Lagoon House', ar: 'بيت اللاجون'));
  });

  testWidgets('i18nTextarea opens on the Arabic tab in Arabic', (tester) async {
    final log = await pump(tester, 'summary', locale: const Locale('ar'));
    await tester.enterText(find.byKey(const Key('cat.summary.ar')), 'وصف');
    expect((log['summary'] as I18n).ar, 'وصف');
  });

  testWidgets('number', (tester) async {
    final log = await pump(tester, 'rooms');
    await tester.enterText(find.byKey(const Key('cat.rooms')), '12');
    expect(log['rooms'], 12);
  });

  testWidgets('money shows EGP and parses', (tester) async {
    final log = await pump(tester, 'priceFromEGP');
    expect(find.text('EGP'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('cat.priceFromEGP')), '2450');
    expect(log['priceFromEGP'], 2450);
    await tester.enterText(find.byKey(const Key('cat.priceFromEGP')), '');
    expect(log['priceFromEGP'], isNull);
  });

  testWidgets('boolean', (tester) async {
    final log = await pump(tester, 'instant');
    await tester.tap(find.byType(DgSwitch));
    expect(log['instant'], isTrue);
  });

  testWidgets('select (chips)', (tester) async {
    final log = await pump(tester, 'area');
    await tester.tap(find.byKey(const Key('cat.area.mashraba')));
    expect(log['area'], 'mashraba');
  });

  testWidgets('multiselect toggles', (tester) async {
    final log = await pump(tester, 'languages');
    await tester.tap(find.byKey(const Key('cat.languages.en')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('cat.languages.ar')));
    expect(log['languages'], ['en', 'ar']);
    await tester.pump();
    await tester.tap(find.byKey(const Key('cat.languages.en')));
    expect(log['languages'], ['ar']);
  });

  testWidgets('tags: type, suggestions, delete', (tester) async {
    final log = await pump(tester, 'amenities');
    await tester.enterText(find.byKey(const Key('cat.amenities.input')), 'parking');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(log['amenities'], ['parking']);
    await tester.tap(find.byKey(const Key('cat.amenities.suggest.wifi')));
    await tester.pump();
    expect(log['amenities'], ['parking', 'wifi']);
    tester.widget<InputChip>(find.byKey(const Key('cat.amenities.tag.parking'))).onDeleted!();
    await tester.pump();
    expect(log['amenities'], ['wifi']);
  });

  testWidgets('time shows the value', (tester) async {
    await pump(tester, 'checkIn', initial: {'checkIn': '14:00'});
    expect(find.text('14:00'), findsOneWidget);
  });

  testWidgets('timeList sorts and deletes', (tester) async {
    final log = await pump(tester, 'departures', initial: {
      'departures': ['10:00', '08:30'],
    });
    final chips = tester.widgetList<InputChip>(find.byType(InputChip)).map((c) => ((c.label as Text).data)).toList();
    expect(chips, ['08:30', '10:00']);
    tester.widget<InputChip>(find.byKey(const Key('cat.departures.time.08:30'))).onDeleted!();
    expect(log['departures'], ['10:00']);
    expect(find.byKey(const Key('cat.departures.addTime')), findsOneWidget);
  });

  testWidgets('duration presets', (tester) async {
    final log = await pump(tester, 'duration');
    await tester.tap(find.byKey(const Key('cat.duration.120')));
    expect(log['duration'], 120);
    expect(find.text('2 h'), findsOneWidget);
  });

  testWidgets('geo needs both coordinates', (tester) async {
    final log = await pump(tester, 'location');
    await tester.enterText(find.byKey(const Key('cat.location.lat')), '28.5');
    expect(log['location'], isNull);
    await tester.enterText(find.byKey(const Key('cat.location.lng')), '34.51');
    expect(log['location'], {'lat': 28.5, 'lng': 34.51});
  });

  testWidgets('gallery: cover badge, remove, add tile', (tester) async {
    final log = await pump(tester, 'images', initial: {
      'images': ['/api/media/a.jpg', '/api/media/b.jpg'],
    });
    expect(find.byKey(const Key('cat.images.cover')), findsOneWidget);
    expect(find.byKey(const Key('cat.images.add')), findsOneWidget);
    await tester.tap(find.byKey(const Key('cat.images.remove.0')));
    await tester.pump();
    expect(log['images'], ['/api/media/b.jpg']);
    // The new first photo is the cover.
    expect(find.byKey(const Key('cat.images.cover')), findsOneWidget);
  });

  testWidgets('supplier picker sets id and display name', (tester) async {
    final log = await pump(tester, 'supplierId', pick: (_) async => const SupplierChoice('SUP-9', 'Blue Hole Divers'));
    expect(find.text('Choose a supplier'), findsOneWidget);
    await tester.tap(find.byKey(const Key('cat.supplierId')));
    await tester.pumpAndSettle();
    expect(log['supplierId'], 'SUP-9');
    expect(log[supplierNameKey], 'Blue Hole Divers');
    expect(find.text('Blue Hole Divers'), findsOneWidget);
  });

  testWidgets('dayPlan: add a day and fill it', (tester) async {
    final log = await pump(tester, 'days');
    await tester.tap(find.byKey(const Key('cat.days.addDay')));
    await tester.pumpAndSettle();
    expect(find.text('Day 1'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('cat.days.0.title.en')), 'Blue Hole');
    await tester.pump();
    final days = log['days'] as List;
    expect(days.single, containsPair('day', 1));
    expect((days.single as Map)['title'], {'en': 'Blue Hole', 'ar': ''});
  });

  testWidgets('json validates', (tester) async {
    final log = await pump(tester, 'extra');
    await tester.enterText(find.byKey(const Key('cat.extra')), '{"a": 1}');
    expect(log['extra'], {'a': 1});
    await tester.enterText(find.byKey(const Key('cat.extra')), '{"a": ');
    await tester.pump();
    expect(find.text('Not valid JSON'), findsOneWidget);
    expect(log['extra'], {'a': 1});
  });

  testWidgets('RTL renders the whole form', (tester) async {
    await tester.pumpWidget(testApp(
      CatalogFormEngine(sections: schema.sections, values: const {}, missing: const {'title'}, onChanged: (_, __) {}),
      locale: const Locale('ar'),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('الأساسيات'), findsOneWidget);
  });
}
