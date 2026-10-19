import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../../../core/api/models/admin_models.dart';
import '../data/access_repository.dart';

enum UsersStatus { initial, loading, ready, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.rows = const [],
    this.total = 0,
    this.hasMore = false,
    this.query = '',
    this.role = '',
    this.statusFilter = '',
    this.error,
    this.roles = const [],
    this.catalog = const [],
    this.cursor,
  });

  final UsersStatus status;
  final List<AdminUserRow> rows;
  final int total;
  final bool hasMore;
  final String query;
  final String role;
  final String statusFilter;
  final ApiError? error;
  final List<Role> roles;
  final List<PermissionDef> catalog;

  /// Opaque cursor for the next page; transport detail, not UI state.
  final String? cursor;

  UsersState copyWith({
    UsersStatus? status,
    List<AdminUserRow>? rows,
    int? total,
    bool? hasMore,
    String? query,
    String? role,
    String? statusFilter,
    ApiError? error,
    List<Role>? roles,
    List<PermissionDef>? catalog,
    String? cursor,
    bool clearCursor = false,
  }) {
    return UsersState(
      status: status ?? this.status,
      rows: rows ?? this.rows,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      role: role ?? this.role,
      statusFilter: statusFilter ?? this.statusFilter,
      error: error,
      roles: roles ?? this.roles,
      catalog: catalog ?? this.catalog,
      cursor: clearCursor ? null : (cursor ?? this.cursor),
    );
  }

  @override
  List<Object?> get props =>
      [status, rows, total, hasMore, query, role, statusFilter, error?.toString(), roles, catalog, cursor];
}

/// Staff access: user directory (search/filter/paginate) plus the role
/// catalogue and permission matrix data.
@injectable
class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._repo) : super(const UsersState());

  final AccessRepository _repo;

  Future<void> start() async {
    await Future.wait([refresh(), _loadRefs()]);
  }

  Future<void> _loadRefs() async {
    try {
      final results = await Future.wait([_repo.roles(), _repo.permissions()]);
      if (isClosed) return;
      emit(state.copyWith(roles: results[0] as List<Role>, catalog: results[1] as List<PermissionDef>));
    } catch (_) {
      // Directory works without the matrix reference data.
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: UsersStatus.loading, error: null, clearCursor: true));
    try {
      final page = await _repo.users(q: state.query, role: state.role, status: state.statusFilter);
      if (isClosed) return;
      emit(state.copyWith(
        status: UsersStatus.ready,
        rows: page.items,
        total: page.total,
        hasMore: page.hasMore,
        cursor: page.nextCursor,
      ));
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: state.rows.isEmpty ? UsersStatus.failure : UsersStatus.ready, error: e));
    }
  }

  Future<void> loadMore() async {
    final cursor = state.cursor;
    if (!state.hasMore || cursor == null || cursor.isEmpty) return;
    try {
      final page = await _repo.users(
          q: state.query, role: state.role, status: state.statusFilter, cursor: cursor);
      if (isClosed) return;
      emit(state.copyWith(
        rows: [...state.rows, ...page.items],
        total: page.total,
        hasMore: page.hasMore,
        cursor: page.nextCursor,
      ));
    } catch (_) {
      // Pagination failure keeps the loaded rows.
    }
  }

  void setQuery(String q) {
    emit(state.copyWith(query: q));
  }

  void setRole(String role) {
    emit(state.copyWith(role: role));
    unawaited(refresh());
  }

  void setStatusFilter(String s) {
    emit(state.copyWith(statusFilter: s));
    unawaited(refresh());
  }

  Future<void> setRolePermissions(Role role, List<String> permissions, String reason) async {
    await _repo.updateRole(role.id, permissions: permissions, reason: reason);
    await _loadRefs();
  }
}
