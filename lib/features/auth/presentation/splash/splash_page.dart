import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../access/presentation/session_cubit.dart';
import '../../../../core/design/components/primitives.dart';
import '../../../../core/design/spacing.dart';
import '../../../../core/router/app_router.gr.dart';

/// Launch gate: waits for session restore, then routes by auth state.
@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state.status == SessionStatus.authenticated) {
          context.router.replaceAll([const TabsRoute()]);
        } else if (state.status == SessionStatus.unauthenticated) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Monogram('DG', size: 64),
              Gap.h16,
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
