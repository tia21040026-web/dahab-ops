import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'core/di/di.dart';
import 'core/preferences/preferences_cubit.dart';
import 'features/access/presentation/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final di = GetIt.I;
  await di<PreferencesCubit>().load(deviceLocale: PlatformDispatcher.instance.locale);
  // Session restore runs in the background; Splash routes when it settles.
  unawaited(di<SessionCubit>().restore());
  runApp(const DahabOpsApp());
}
