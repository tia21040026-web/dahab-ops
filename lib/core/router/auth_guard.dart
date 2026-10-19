import 'package:auto_route/auto_route.dart';

import '../../features/access/presentation/session_cubit.dart';
import 'app_router.gr.dart';

/// Signed-out users land on login; signed-in users never see login/splash.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._session);

  final SessionCubit _session;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authed = _session.state.isAuthenticated;
    final name = resolver.route.name;
    if (!authed && name != LoginRoute.name && name != SplashRoute.name) {
      resolver.next(false);
      router.replaceAll([const LoginRoute()]);
    } else if (authed && (name == LoginRoute.name || name == SplashRoute.name)) {
      resolver.next(false);
      router.replaceAll([const TabsRoute()]);
    } else {
      resolver.next();
    }
  }
}
