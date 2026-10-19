import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// AppBar leading for every screen.
///
/// Tab roots (Pulse, Queue, Live, More, supplier tabs) get no button: their
/// own router cannot pop, even when the root stack underneath can, which made
/// Flutter's implied leading show a back arrow on them. Pushed screens get a
/// plain [BackButton]. Use with `automaticallyImplyLeading: false`.
///
/// Replaces `AutoLeadingButton`, which rendered a "No MaterialLocalizations"
/// error box on Live when it is a tab.
Widget? shellLeading(BuildContext context) {
  final router = context.router;
  if (router is TabsRouter) return null;
  return router.canPop(ignoreParentRoutes: true) ? const BackButton() : null;
}
