import 'package:dahab_ops/core/design/components/confirm_danger_sheet.dart';
import 'package:dahab_ops/core/design/components/error_view.dart';
import 'package:dahab_ops/core/design/components/kpi_card.dart';
import 'package:dahab_ops/core/design/components/permission_gate.dart';
import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dahab_ops/core/platform/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  setUpAll(setUpTestFonts);

  group('PermissionGate', () {
    testWidgets('shows child when granted', (tester) async {
      await tester.pumpWidget(testApp(
        const PermissionGate(permission: 'ops.trips.view', child: Text('secret')),
        session: testSession(permissions: ['ops.*']),
      ));
      expect(find.text('secret'), findsOneWidget);
    });

    testWidgets('hides child when not granted', (tester) async {
      await tester.pumpWidget(testApp(
        const PermissionGate(permission: 'admin.users.manage', child: Text('secret')),
        session: testSession(permissions: ['ops.*']),
      ));
      expect(find.text('secret'), findsNothing);
    });

    testWidgets('explain shows the missing key', (tester) async {
      await tester.pumpWidget(testApp(
        const PermissionGate(permission: 'admin.users.manage', explain: true, child: Text('secret')),
        session: testSession(permissions: ['ops.*']),
      ));
      expect(find.text('No access'), findsOneWidget);
      expect(find.text('admin.users.manage'), findsOneWidget);
    });

    testWidgets('anyOf and fallback', (tester) async {
      await tester.pumpWidget(testApp(
        const Column(children: [
          PermissionGate(anyOf: ['x.y.z', 'supplier.inbox.view'], child: Text('any')),
          PermissionGate(permission: 'ops.overview.view', fallback: Text('fallback'), child: Text('no')),
        ]),
        session: testSession(permissions: ['supplier.*'], supplier: true),
      ));
      expect(find.text('any'), findsOneWidget);
      expect(find.text('fallback'), findsOneWidget);
      expect(find.text('no'), findsNothing);
    });
  });

  group('ConfirmDangerSheet', () {
    FilledButton confirmButton(WidgetTester tester) => tester.widget<FilledButton>(
        find.descendant(of: find.byKey(const Key('danger.confirm')), matching: find.byType(FilledButton)));

    testWidgets('requires a reason of at least 3 chars', (tester) async {
      String? confirmed;
      await tester.pumpWidget(testApp(ConfirmDangerSheet(
        title: 'Turn off payments',
        biometrics: const NoopBiometricService(),
        onConfirmed: (r) => confirmed = r,
      )));
      expect(confirmButton(tester).onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump();
      expect(confirmButton(tester).onPressed, isNull);
      expect(find.text('Write at least 3 characters.'), findsOneWidget,
          reason: 'too-short hint is visible');

      await tester.enterText(find.byType(TextField), 'Gateway outage');
      await tester.pump();
      expect(confirmButton(tester).onPressed, isNotNull);
      await tester.tap(find.byKey(const Key('danger.confirm')));
      await tester.pumpAndSettle();
      expect(confirmed, 'Gateway outage');
    });

    testWidgets('failed biometric does not confirm', (tester) async {
      String? confirmed;
      await tester.pumpWidget(testApp(ConfirmDangerSheet(
        title: 'Revoke sessions',
        biometrics: const NoopBiometricService(available: true, result: false),
        onConfirmed: (r) => confirmed = r,
      )));
      await tester.enterText(find.byType(TextField), 'Lost phone');
      await tester.pump();
      await tester.tap(find.byKey(const Key('danger.confirm')));
      await tester.pumpAndSettle();
      expect(confirmed, isNull);
      expect(find.text('Biometric check failed.'), findsOneWidget);
    });

    testWidgets('shows approval notice when required', (tester) async {
      await tester.pumpWidget(testApp(const ConfirmDangerSheet(
        title: 'Grant Admin',
        requiresApproval: true,
        biometric: false,
      )));
      expect(find.byKey(const Key('danger.approvalNotice')), findsOneWidget);
    });

    test('validReason bounds', () {
      expect(ConfirmDangerSheet.validReason('  ab '), isFalse);
      expect(ConfirmDangerSheet.validReason('abc'), isTrue);
      expect(ConfirmDangerSheet.validReason('x' * 501), isFalse);
    });
  });

  testWidgets('ErrorView shows a copyable correlation id', (tester) async {
    await tester.pumpWidget(testApp(const ErrorView(
      error: ApiError(kind: ApiErrorKind.server, status: 500, correlationId: 'corr-42'),
    )));
    expect(find.text('corr-42'), findsOneWidget);
    expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
  });

  group('KpiCard RTL', () {
    testWidgets('mirrors layout in Arabic but keeps the number LTR', (tester) async {
      await tester.pumpWidget(testApp(
        const Center(
          child: SizedBox(
            width: 220,
            child: KpiCard(label: 'رحلات نشطة', value: 1234, delta: 0.12, spark: [1, 3, 2, 5]),
          ),
        ),
        locale: const Locale('ar'),
      ));
      final ctx = tester.element(find.byType(KpiCard));
      expect(Directionality.of(ctx), TextDirection.rtl);

      final number = tester.widget<Text>(find.text('1,234'));
      expect(number.textDirection, TextDirection.ltr);
      expect(number.textAlign, TextAlign.right, reason: 'reading starts on the RTL start edge');

      // Label starts on the right edge in RTL.
      final card = tester.getRect(find.byType(KpiCard));
      final label = tester.getRect(find.text('رحلات نشطة'));
      expect((card.right - label.right).abs(), lessThan((label.left - card.left).abs()));
      // Sparkline (end side) sits on the left in RTL.
      final spark = tester.getRect(find.byType(Sparkline));
      expect(spark.center.dx, lessThan(card.center.dx));
    });

    testWidgets('LTR keeps sparkline on the right', (tester) async {
      await tester.pumpWidget(testApp(
        const Center(
          child: SizedBox(
            width: 220,
            child: KpiCard(label: 'Active trips', value: 12, spark: [1, 3, 2, 5]),
          ),
        ),
      ));
      final card = tester.getRect(find.byType(KpiCard));
      final spark = tester.getRect(find.byType(Sparkline));
      expect(spark.center.dx, greaterThan(card.center.dx));
    });
  });
}
