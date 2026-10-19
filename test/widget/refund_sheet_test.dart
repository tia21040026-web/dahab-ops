import 'package:dahab_ops/core/platform/biometric_service.dart';
import 'package:dahab_ops/features/booking/data/booking_models.dart';
import 'package:dahab_ops/features/refund/data/refund_repository.dart';
import 'package:dahab_ops/features/refund/presentation/refund_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/pump_app.dart';

class _MockRefunds extends Mock implements RefundRepository {}

void main() {
  late _MockRefunds refunds;

  setUpAll(setUpTestFonts);

  setUp(() {
    refunds = _MockRefunds();
    GetIt.I
      ..registerSingleton<RefundRepository>(refunds)
      ..registerSingleton<BiometricService>(const NoopBiometricService());
  });

  tearDown(() => GetIt.I.reset());

  final booking = Booking.fromJson(const {
    'id': 'b1',
    'bookingRef': 'DHB-1042',
    'amountEGP': 2400,
    'travelerName': 'Mona',
  });

  FilledButton submit(WidgetTester tester) => tester.widget<FilledButton>(find.byType(FilledButton).last);

  testWidgets('refund needs a reason before it can be requested', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    when(() => refunds.request(
          bookingRef: any(named: 'bookingRef'),
          amountEGP: any(named: 'amountEGP'),
          reason: any(named: 'reason'),
        )).thenAnswer((_) async => const RefundOutcome.executed(refundId: 'r1', amountEGP: 1800));

    await tester.pumpWidget(testApp(Builder(
      builder: (context) => TextButton(
        onPressed: () => showRefundSheet(context, booking: booking),
        child: const Text('open'),
      ),
    )));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(submit(tester).onPressed, isNull, reason: 'no reason yet');

    await tester.tap(find.text('Supplier cancelled'));
    await tester.pump();
    expect(submit(tester).onPressed, isNotNull);

    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    verify(() => refunds.request(
          bookingRef: 'DHB-1042',
          amountEGP: 1800,
          reason: 'Supplier cancelled',
        )).called(1);
  });
}
