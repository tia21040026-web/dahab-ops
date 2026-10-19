@Tags(['golden'])
library;

import 'package:dahab_ops/core/design/components/kpi_card.dart';
import 'package:dahab_ops/core/design/components/primitives.dart';
import 'package:dahab_ops/core/design/components/status_strip.dart';
import 'package:dahab_ops/core/design/dahab_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// Goldens for the two instrument readings, in both shipping themes and
/// both languages. Regenerate with `flutter test --update-goldens test/golden`.
void main() {
  setUpAll(setUpTestFonts);

  final now = DateTime.utc(2026, 10, 15, 12);
  const themes = [DahabThemeId.abyss, DahabThemeId.salt];
  const locales = [Locale('en'), Locale('ar')];

  for (final theme in themes) {
    for (final locale in locales) {
      final tag = '${theme.wire}_${locale.languageCode}';
      final ar = locale.languageCode == 'ar';

      testWidgets('KpiCard $tag', (tester) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(testApp(
          locale: locale,
          theme: theme,
          RepaintBoundary(
            key: const Key('golden'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                KpiCard(
                  label: ar ? 'رحلات نشطة' : 'Active trips',
                  value: 1284,
                  delta: 0.12,
                  spark: const [3, 4, 3.5, 5, 6, 5.5, 7],
                  caption: ar ? 'آخر ٢٤ ساعة' : 'last 24 h',
                ),
                const SizedBox(height: 12),
                KpiCard(
                  label: ar ? 'مشاكل الدفع' : 'Payment issues',
                  value: 7,
                  delta: 0.4,
                  upIsGood: false,
                  tone: Tone.critical,
                ),
              ]),
            ),
          ),
        ));
        await tester.pump();
        await expectLater(find.byKey(const Key('golden')), matchesGoldenFile('goldens/kpi_card_$tag.png'));
      });

      testWidgets('StatusStrip $tag', (tester) async {
        tester.view.physicalSize = const Size(400, 260);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(testApp(
          locale: locale,
          theme: theme,
          RepaintBoundary(
            key: const Key('golden'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                StatusStrip(
                  health: SystemHealth.healthy,
                  feed: FeedState.polling,
                  updatedAt: now.subtract(const Duration(minutes: 3)),
                  now: now,
                ),
                const SizedBox(height: 12),
                StatusStrip(
                  health: SystemHealth.degraded,
                  feed: FeedState.reconnecting,
                  detail: ar ? 'المدفوعات متدهورة · ٣ استثناءات' : 'Payments degraded · 3 exceptions',
                  updatedAt: now.subtract(const Duration(minutes: 12)),
                  now: now,
                ),
                const SizedBox(height: 12),
                StatusStrip(
                  health: SystemHealth.actionRequired,
                  feed: FeedState.offline,
                  updatedAt: now.subtract(const Duration(hours: 2)),
                  now: now,
                ),
              ]),
            ),
          ),
        ));
        await tester.pump();
        await expectLater(
            find.byKey(const Key('golden')), matchesGoldenFile('goldens/status_strip_$tag.png'));
      });
    }
  }
}
