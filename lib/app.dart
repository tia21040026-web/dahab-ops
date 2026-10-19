import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'core/design/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/access/presentation/session_cubit.dart';
import 'features/access/presentation/view_as_banner.dart';
import 'features/auth/presentation/app_lock/app_lock_cubit.dart';
import 'core/connectivity/connectivity_cubit.dart';
import 'core/preferences/preferences_cubit.dart';
import 'l10n/l10n.dart';

/// App root: theme + locale follow [PreferencesCubit], navigation follows
/// [SessionCubit] through the router guard, and [AppLockCubit] overlays the
/// biometric gate when the app returns from the background.
class DahabOpsApp extends StatelessWidget {
  const DahabOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final di = GetIt.I;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: di<SessionCubit>()),
        BlocProvider.value(value: di<PreferencesCubit>()),
        BlocProvider.value(value: di<ConnectivityCubit>()..start()),
        BlocProvider.value(value: di<AppLockCubit>()),
      ],
      child: const _ThemedApp(),
    );
  }
}

class _ThemedApp extends StatefulWidget {
  const _ThemedApp();

  @override
  State<_ThemedApp> createState() => _ThemedAppState();
}

class _ThemedAppState extends State<_ThemedApp> {
  @override
  void initState() {
    super.initState();
    final di = GetIt.I;
    // Lock only while signed in and the preference is on.
    unawaited(di<AppLockCubit>().start(enabled: () {
      final session = di<SessionCubit>().state;
      final prefs = di<PreferencesCubit>().state;
      return session.isAuthenticated && prefs.biometricLock;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, prefs) {
        return MaterialApp.router(
          title: 'Dahab Ops',
          theme: AppTheme.build(prefs.theme, prefs.locale),
          locale: prefs.locale,
          supportedLocales: PreferencesCubit.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: GetIt.I<AppRouter>().config(),
          builder: (context, child) =>
              _AppLockGate(child: _ViewAsShell(child: child ?? const SizedBox.shrink())),
        );
      },
    );
  }
}

/// Fullscreen biometric gate shown when [AppLockCubit] locks the app.
class _AppLockGate extends StatelessWidget {
  const _AppLockGate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, lock) {
        if (!lock.locked) return child;
        final l = context.l10n;
        return Stack(
          children: [
            child,
            Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.face, size: 56),
                      const SizedBox(height: 16),
                      Text(l.appLocked, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(l.appLockedBody, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: lock.busy
                            ? null
                            : () => context.read<AppLockCubit>().unlock(l.unlockReason),
                        child: Text(l.unlock),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Puts [ViewAsBanner] above every route while a view-as is active. The
/// banner takes the status-bar inset, so routes below drop theirs.
class _ViewAsShell extends StatelessWidget {
  const _ViewAsShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewing = context.select<SessionCubit, bool>((s) => s.state.isViewingAs);
    if (!viewing) return child;
    return Column(children: [
      const ViewAsBanner(),
      Expanded(child: MediaQuery.removePadding(context: context, removeTop: true, child: child)),
    ]);
  }
}
