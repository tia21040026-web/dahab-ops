import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../../../core/api/models/admin_models.dart';
import '../../control/data/control_repository.dart';
import '../data/access_repository.dart';

enum UserDetailStatus { loading, ready, failure }

class UserDetailState extends Equatable {
  const UserDetailState({
    this.status = UserDetailStatus.loading,
    this.detail,
    this.roles = const [],
    this.catalog = const [],
    this.busy = false,
    this.error,
  });

  final UserDetailStatus status;
  final UserDetail? detail;
  final List<Role> roles;
  final List<PermissionDef> catalog;
  final bool busy;
  final ApiError? error;

  Role? get role {
    final d = detail;
    if (d == null) return null;
    for (final r in roles) {
      if (r.id == d.roleId || r.name == d.user.role) return r;
    }
    return null;
  }

  UserDetailState copyWith({
    UserDetailStatus? status,
    UserDetail? detail,
    List<Role>? roles,
    List<PermissionDef>? catalog,
    bool? busy,
    ApiError? error,
  }) =>
      UserDetailState(
        status: status ?? this.status,
        detail: detail ?? this.detail,
        roles: roles ?? this.roles,
        catalog: catalog ?? this.catalog,
        busy: busy ?? this.busy,
        error: error,
      );

  @override
  List<Object?> get props => [status, detail, roles, catalog, busy, error?.toString()];
}

/// One staff member: role, status, overrides, sessions, devices, view-as.
/// Every mutation carries a reason and re-reads the detail afterwards so
/// effective permissions stay server-computed.
@injectable
class UserDetailCubit extends Cubit<UserDetailState> {
  UserDetailCubit(this._access, this._control) : super(const UserDetailState());

  final AccessRepository _access;
  final ControlRepository _control;
  late String _id;

  Future<void> start(String userId) async {
    _id = userId;
    emit(state.copyWith(status: UserDetailStatus.loading));
    try {
      final results = await Future.wait([
        _access.userDetail(userId),
        _access.roles().catchError((_) => <Role>[]),
        _access.permissions().catchError((_) => <PermissionDef>[]),
      ]);
      if (isClosed) return;
      emit(state.copyWith(
        status: UserDetailStatus.ready,
        detail: results[0] as UserDetail,
        roles: results[1] as List<Role>,
        catalog: results[2] as List<PermissionDef>,
      ));
    } catch (e) {
      if (!isClosed) emit(state.copyWith(status: UserDetailStatus.failure, error: ApiError.from(e)));
    }
  }

  Future<void> reload() async {
    try {
      final d = await _access.userDetail(_id);
      if (!isClosed) emit(state.copyWith(detail: d));
    } catch (_) {
      // Keep what is shown.
    }
  }

  /// Runs [action]; returns the error (null on success).
  Future<ApiError?> _run(Future<void> Function() action) async {
    emit(state.copyWith(busy: true));
    try {
      await action();
      await reload();
      if (!isClosed) emit(state.copyWith(busy: false));
      return null;
    } catch (e) {
      final err = ApiError.from(e);
      if (!isClosed) emit(state.copyWith(busy: false, error: err));
      return err;
    }
  }

  Future<ApiError?> changeRole(Role role, String reason) =>
      _run(() => _access.patchUser(_id, roleId: role.id, reason: reason));

  Future<ApiError?> setStatus(String status, String reason) =>
      _run(() => _access.patchUser(_id, status: status, reason: reason));

  Future<ApiError?> setOverrides(List<PermissionOverride> overrides, String reason) =>
      _run(() => _access.setOverrides(_id, overrides, reason));

  int lastRevoked = 0;

  Future<ApiError?> revokeSessions(String reason) =>
      _run(() async => lastRevoked = await _access.revokeSessions(_id, reason));

  Future<ApiError?> startViewAs(String reason) => _run(() => _control.startViewAs(_id, reason));
}
