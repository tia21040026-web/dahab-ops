import 'package:dahab_ops/core/design/components/dahab_button.dart';
import 'package:dahab_ops/features/catalog/calendar/range_calendar.dart';
import 'package:dahab_ops/features/catalog/presentation/catalog_children_pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  setUpAll(setUpTestFonts);
  final nov = DateTime(2026, 11);

  Future<List<(DateTime, DateTime)>> pumpCalendar(WidgetTester tester, {Locale locale = const Locale('en')}) async {
    final ranges = <(DateTime, DateTime)>[];
    await tester.pumpWidget(testApp(
      SizedBox(
        width: 350,
        child: RangeCalendar(month: nov, firstWeekday: 0, onRange: (a, b) => ranges.add((a, b))),
      ),
      locale: locale,
    ));
    await tester.pumpAndSettle();
    return ranges;
  }

  testWidgets('tap selects a single day', (tester) async {
    final ranges = await pumpCalendar(tester);
    await tester.tap(find.byKey(const Key('cat.day.12')));
    await tester.pump(const Duration(milliseconds: 500));
    expect(ranges, [(DateTime(2026, 11, 12), DateTime(2026, 11, 12))]);
  });

  Future<void> longPressDrag(WidgetTester tester, String from, String to) async {
    final start = tester.getCenter(find.byKey(Key(from)));
    final end = tester.getCenter(find.byKey(Key(to)));
    final g = await tester.startGesture(start);
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
    await g.moveTo(Offset.lerp(start, end, 0.5)!);
    await tester.pump();
    await g.moveTo(end);
    await tester.pump();
    await g.up();
    await tester.pump();
  }

  testWidgets('long-press drag selects a range (from <= to)', (tester) async {
    final ranges = await pumpCalendar(tester);
    await longPressDrag(tester, 'cat.day.3', 'cat.day.17');
    expect(ranges, [(DateTime(2026, 11, 3), DateTime(2026, 11, 17))]);
  });

  testWidgets('dragging backwards is normalised', (tester) async {
    final ranges = await pumpCalendar(tester);
    await longPressDrag(tester, 'cat.day.20', 'cat.day.9');
    expect(ranges, [(DateTime(2026, 11, 9), DateTime(2026, 11, 20))]);
  });

  testWidgets('range selection works in RTL', (tester) async {
    final ranges = await pumpCalendar(tester, locale: const Locale('ar'));
    await longPressDrag(tester, 'cat.day.5', 'cat.day.8');
    expect(ranges, [(DateTime(2026, 11, 5), DateTime(2026, 11, 8))]);
  });

  testWidgets('rate sheet: weekday toggles and close', (tester) async {
    RateEdit? result;
    await tester.pumpWidget(testApp(Builder(
      builder: (context) => TextButton(
        onPressed: () async => result = await showModalBottomSheet<RateEdit>(
          context: context,
          isScrollControlled: true,
          builder: (_) => RateRangeSheet(from: DateTime(2026, 11, 2), to: DateTime(2026, 11, 8), current: 2000),
        ),
        child: const Text('open'),
      ),
    )));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('7 nights'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('cat.rate.price')), '2200');
    await tester.pump();
    // Friday (5) and Saturday (6) off.
    for (final d in const [5, 6]) {
      await tester.ensureVisible(find.byKey(Key('cat.weekday.$d')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('cat.weekday.$d')));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byKey(const Key('cat.rate.apply')));
    await tester.pumpAndSettle();
    expect(result!.nightlyEGP, 2200);
    expect(result!.weekdays, {0, 1, 2, 3, 4});
    expect(result!.reason, isNull);
  });

  testWidgets('rate sheet asks for a reason above 30%', (tester) async {
    await tester.pumpWidget(testApp(RateRangeSheet(from: DateTime(2026, 11, 2), to: DateTime(2026, 11, 2), current: 2000)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('cat.rate.price')), '3000');
    await tester.pump();
    expect(find.byKey(const Key('cat.rate.reason')), findsOneWidget);
    expect(tester.widget<DahabButton>(find.byKey(const Key('cat.rate.apply'))).onPressed, isNull);
    await tester.enterText(find.byKey(const Key('cat.rate.reason')), 'High season');
    await tester.pump();
    expect(tester.widget<DahabButton>(find.byKey(const Key('cat.rate.apply'))).onPressed, isNotNull);
  });

  test('contract weekday numbering is JS getDay', () {
    expect(contractWeekday(DateTime(2026, 11, 1)), 0); // Sunday
    expect(contractWeekday(DateTime(2026, 11, 7)), 6); // Saturday
  });
}
