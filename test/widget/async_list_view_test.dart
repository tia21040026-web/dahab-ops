import 'dart:async';

import 'package:dahab_ops/core/api/api_error.dart';
import 'package:dahab_ops/core/api/models/paged.dart';
import 'package:dahab_ops/core/design/components/empty_state.dart';
import 'package:dahab_ops/core/design/components/error_view.dart';
import 'package:dahab_ops/core/list/async_list_view.dart';
import 'package:dahab_ops/core/list/list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  setUpAll(setUpTestFonts);

  Widget host(ListCubit<String> cubit) => testApp(BlocProvider.value(
        value: cubit,
        child: AsyncListView<String>(itemBuilder: (_, s) => ListTile(title: Text(s))),
      ));

  testWidgets('rows render', (tester) async {
    final cubit = ListCubit<String>((_) async => const Paged(items: ['DHB-1', 'DHB-2']));
    unawaited(cubit.start());
    await tester.pumpWidget(host(cubit));
    await tester.pumpAndSettle();
    expect(find.text('DHB-1'), findsOneWidget);
    expect(find.text('DHB-2'), findsOneWidget);
  });

  testWidgets('empty shows EmptyState', (tester) async {
    final cubit = ListCubit<String>((_) async => const Paged());
    unawaited(cubit.start());
    await tester.pumpWidget(host(cubit));
    await tester.pumpAndSettle();
    expect(find.byType(EmptyState), findsOneWidget);
  });

  testWidgets('first failure shows ErrorView with retry and reference', (tester) async {
    var calls = 0;
    final cubit = ListCubit<String>((_) async {
      calls++;
      throw const ApiError(kind: ApiErrorKind.server, correlationId: 'c-9');
    });
    unawaited(cubit.start());
    await tester.pumpWidget(host(cubit));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('c-9'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(calls, 2);
  });
}
