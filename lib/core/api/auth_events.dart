import 'dart:async';

enum AuthEvent {
  /// Refresh was rejected; the session is over.
  loggedOut,

  /// A 403 suggests the cached permissions are out of date.
  permissionsStale,
}

/// Bus between the HTTP layer and the session, so the interceptor never
/// depends on UI state.
class AuthEvents {
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get stream => _controller.stream;

  void emit(AuthEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  Future<void> dispose() => _controller.close();
}
