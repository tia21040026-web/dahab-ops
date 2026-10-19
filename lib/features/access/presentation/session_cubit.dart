import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api/api_error.dart';
import '../../../core/api/auth_events.dart';
import '../../../core/api/models/auth_models.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/permissions.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

/// Why the session ended, so login can say so.
enum SignOutReason { none, userAction, expired }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.unknown,
    this.user,
    this.permissions = const {},
    this.flags = const {},
    this.viewAs,
    this.restoreError,
    this.signOutReason = SignOutReason.none,
  });

  final SessionStatus status;
  final User? user;
  final Set<String> permissions;
  final Map<String, bool> flags;
  final ViewAs? viewAs;

  /// Set when restoring on launch failed for a reason other than "signed out"
  /// (offline, server down): the splash offers a retry instead of login.
  final ApiError? restoreError;
  final SignOutReason signOutReason;

  bool get isAuthenticated => status == SessionStatus.authenticated;
  bool get isViewingAs => viewAs != null;
  bool get isSupplier => user?.isSupplier ?? false;

  bool can(String key) => Permissions.can(permissions, key);
  bool canAny(Iterable<String> keys) => Permissions.canAny(permissions, keys);
  bool flag(String key) => flags[key] ?? false;

  SessionState copyWith({
    SessionStatus? status,
    User? user,
    Set<String>? permissions,
    Map<String, bool>? flags,
    ViewAs? viewAs,
    bool clearViewAs = false,
    ApiError? restoreError,
    bool clearRestoreError = false,
    SignOutReason? signOutReason,
  }) =>
      SessionState(
        status: status ?? this.status,
        user: user ?? this.user,
        permissions: permissions ?? this.permissions,
        flags: flags ?? this.flags,
        viewAs: clearViewAs ? null : (viewAs ?? this.viewAs),
        restoreError: clearRestoreError ? null : (restoreError ?? this.restoreError),
        signOutReason: signOutReason ?? this.signOutReason,
      );

  @override
  List<Object?> get props =>
      [status, user, permissions, flags, viewAs, restoreError, signOutReason];
}

/// Holds who is signed in, what they may do (`can`), and feature flags.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._auth, AuthEvents events) : super(const SessionState()) {
    _sub = events.stream.listen(_onAuthEvent);
  }

  final AuthRepository _auth;
  late final StreamSubscription<AuthEvent> _sub;
  Future<void>? _refreshing;

  bool can(String key) => state.can(key);
  bool canAny(Iterable<String> keys) => state.canAny(keys);

  Future<void> restore() async {
    emit(state.copyWith(clearRestoreError: true));
    if (!await _auth.hasStoredSession()) {
      emit(const SessionState(status: SessionStatus.unauthenticated));
      return;
    }
    try {
      _apply(await _auth.me());
    } on ApiError catch (e) {
      if (e.kind == ApiErrorKind.unauthorized) {
        await _auth.clearLocal();
        emit(const SessionState(
            status: SessionStatus.unauthenticated, signOutReason: SignOutReason.expired));
      } else {
        emit(state.copyWith(status: SessionStatus.unknown, restoreError: e));
      }
    }
  }

  void signedIn(LoginResponse r) => emit(SessionState(
        status: SessionStatus.authenticated,
        user: r.user,
        permissions: r.permissions.toSet(),
        flags: r.flags,
      ));

  void _apply(MeResponse me) => emit(SessionState(
        status: SessionStatus.authenticated,
        user: me.user,
        permissions: me.permissions.toSet(),
        flags: me.flags,
        viewAs: me.viewAs,
      ));

  /// Re-reads `/api/auth/me` (permissions, flags, view-as). Coalesced.
  Future<void> refresh() => _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<void> _doRefresh() async {
    if (!state.isAuthenticated) return;
    try {
      _apply(await _auth.me());
    } on ApiError catch (_) {
      // Keep the current session; the interceptor handles real sign-outs.
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    emit(const SessionState(
        status: SessionStatus.unauthenticated, signOutReason: SignOutReason.userAction));
  }

  void _onAuthEvent(AuthEvent e) {
    switch (e) {
      case AuthEvent.loggedOut:
        if (state.status != SessionStatus.unauthenticated) {
          emit(const SessionState(
              status: SessionStatus.unauthenticated, signOutReason: SignOutReason.expired));
        }
      case AuthEvent.permissionsStale:
        unawaited(refresh());
    }
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
