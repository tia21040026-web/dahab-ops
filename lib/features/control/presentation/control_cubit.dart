import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../../core/api/api_error.dart';
import '../../../core/api/models/admin_models.dart';
import '../../access/data/access_repository.dart';
import '../data/control_repository.dart';

enum ControlStatus { initial, loading, ready, failure }

/// What a control screen needs loaded. The hub loads everything.
enum ControlPart { settings, flags, integrations, approvals, audit }

class ControlState extends Equatable {
  const ControlState({
    this.status = ControlStatus.initial,
    this.settings = const [],
    this.flags = const [],
    this.integrations = const [],
    this.approvals = const [],
    this.audit = const [],
    this.auditCursor,
    this.auditHasMore = false,
    this.actorNames = const {},
    this.error,
  });

  final ControlStatus status;
  final List<SettingItem> settings;
  final List<FlagItem> flags;
  final List<Integration> integrations;
  final List<Approval> approvals;
  final List<AuditEvent> audit;
  final String? auditCursor;
  final bool auditHasMore;

  /// `updatedBy` user id to a display name (name, else email), resolved
  /// for the flags the hub shows. Missing ids render as-is.
  final Map<String, String> actorNames;
  final ApiError? error;

  ControlState copyWith({
    ControlStatus? status,
    List<SettingItem>? settings,
    List<FlagItem>? flags,
    List<Integration>? integrations,
    List<Approval>? approvals,
    List<AuditEvent>? audit,
    String? auditCursor,
    bool? auditHasMore,
    Map<String, String>? actorNames,
    ApiError? error,
  }) =>
      ControlState(
        status: status ?? this.status,
        settings: settings ?? this.settings,
        flags: flags ?? this.flags,
        integrations: integrations ?? this.integrations,
        approvals: approvals ?? this.approvals,
        audit: audit ?? this.audit,
        auditCursor: auditCursor ?? this.auditCursor,
        auditHasMore: auditHasMore ?? this.auditHasMore,
        actorNames: actorNames ?? this.actorNames,
        error: error,
      );

  @override
  List<Object?> get props =>
      [status, settings, flags, integrations, approvals, audit, auditCursor, auditHasMore, actorNames, error?.toString()];
}

/// Control and settings: commerce settings, kill switches, maintenance mode
/// and integration health. Every change carries the caller's reason.
@injectable
class ControlCubit extends Cubit<ControlState> {
  ControlCubit(this._repo) : super(const ControlState());

  final ControlRepository _repo;

  /// Looks a user id up for "stopped by". Defaults to the access directory
  /// when registered; tests can swap it.
  Future<String?> Function(String userId)? resolveUser;

  Future<String?> Function(String userId)? get _resolver {
    if (resolveUser != null) return resolveUser;
    if (!GetIt.I.isRegistered<AccessRepository>()) return null;
    final access = GetIt.I<AccessRepository>();
    return (id) async => (await access.userDetail(id)).user.displayName;
  }

  /// Resolves the `updatedBy` of switches and maintenance flags to names.
  /// Failures (no users.view, unknown id) keep the raw id.
  Future<void> _resolveActors(List<FlagItem> flags) async {
    final resolve = _resolver;
    if (resolve == null) return;
    final ids = {
      for (final f in flags)
        if ((f.isKillSwitch || f.isMaintenance) && f.updatedBy != null && f.updatedBy!.isNotEmpty) f.updatedBy!,
    }.where((id) => id != 'SYSTEM' && !state.actorNames.containsKey(id)).toList();
    if (ids.isEmpty) return;
    final names = await Future.wait(ids.map((id) => resolve(id).catchError((_) => null)));
    if (isClosed) return;
    final next = {...state.actorNames};
    for (final (i, id) in ids.indexed) {
      final n = names[i];
      if (n != null && n.isNotEmpty) next[id] = n;
    }
    emit(state.copyWith(actorNames: next, error: state.error));
  }

  Set<ControlPart> _parts = ControlPart.values.toSet();

  Future<void> start({Set<ControlPart>? parts}) async {
    if (parts != null) _parts = parts;
    final p = _parts;
    final single = p.length == 1;
    emit(state.copyWith(status: ControlStatus.loading, error: null));
    // With one part a failure is the screen's failure; the hub degrades.
    Future<T> part<T>(ControlPart part, Future<T> Function() load, T empty) {
      if (!p.contains(part)) return Future.value(empty);
      return single ? load() : load().catchError((_) => empty);
    }

    try {
      final results = await Future.wait([
        part(ControlPart.settings, _repo.settings, <SettingItem>[]),
        part(ControlPart.flags, _repo.flags, <FlagItem>[]),
        part(ControlPart.integrations, _repo.integrations, <Integration>[]),
        part(ControlPart.approvals, _repo.approvals, <Approval>[]),
        part<_AuditPage>(
          ControlPart.audit,
          () => _repo.audit().then((p) => _AuditPage(p.items, p.nextCursor, p.hasMore)),
          _emptyAudit(),
        ),
      ]);
      if (isClosed) return;
      final audit = results[4] as _AuditPage;
      emit(state.copyWith(
        status: ControlStatus.ready,
        settings: results[0] as List<SettingItem>,
        flags: results[1] as List<FlagItem>,
        integrations: results[2] as List<Integration>,
        approvals: results[3] as List<Approval>,
        audit: audit.events,
        auditCursor: audit.cursor,
        auditHasMore: audit.hasMore,
      ));
      await _resolveActors(state.flags);
    } on ApiError catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: ControlStatus.failure, error: e));
    }
  }

  Future<void> refresh() => start();

  Future<bool> rollbackSetting(SettingItem item, int version, String reason) async {
    try {
      final updated = await _repo.rollbackSetting(item.key, version, reason);
      if (isClosed) return false;
      emit(state.copyWith(
          settings: [for (final s in state.settings) s.key == item.key ? updated : s]));
      return true;
    } on ApiError catch (e) {
      if (!isClosed) emit(state.copyWith(error: e));
      return false;
    }
  }

  Future<bool> patchIntegration(Integration integration,
      {bool? enabled, String? mode, required String reason}) async {
    try {
      final updated = await _repo.patchIntegration(integration.id,
          enabled: enabled, mode: mode, reason: reason);
      if (isClosed) return false;
      emit(state.copyWith(
          integrations: [for (final i in state.integrations) i.id == updated.id ? updated : i]));
      return true;
    } on ApiError catch (e) {
      if (!isClosed) emit(state.copyWith(error: e));
      return false;
    }
  }

  Future<bool> saveSetting(SettingItem item, Object? value, String reason) async {
    try {
      final updated = await _repo.setSetting(item.key, value, reason);
      if (isClosed) return false;
      emit(state.copyWith(
          settings: [for (final s in state.settings) s.key == item.key ? updated : s]));
      return true;
    } on ApiError catch (e) {
      if (!isClosed) emit(state.copyWith(error: e));
      return false;
    }
  }

  Future<bool> setFlag(FlagItem flag, bool enabled, String reason, {int? rolloutPercent}) async {
    try {
      final updated =
          await _repo.setFlag(flag.key, enabled: enabled, rolloutPercent: rolloutPercent, reason: reason);
      if (isClosed) return false;
      emit(state.copyWith(flags: [
        for (final f in state.flags)
          f.key == flag.key
              ? (updated ??
                  _toggled(f, enabled).copyWith(rolloutPercent: rolloutPercent ?? f.rolloutPercent))
              : f
      ]));
      // Re-read so "stopped by / at" reflect the server's record.
      try {
        final fresh = await _repo.flags();
        if (isClosed) return true;
        emit(state.copyWith(flags: fresh));
      } catch (_) {
        // The optimistic row stays.
      }
      await _resolveActors(state.flags);
      return true;
    } on ApiError catch (e) {
      if (!isClosed) emit(state.copyWith(error: e));
      return false;
    }
  }

  FlagItem _toggled(FlagItem f, bool enabled) => FlagItem(
        key: f.key,
        kind: f.kind,
        enabled: enabled,
        rolloutPercent: f.rolloutPercent,
        roles: f.roles,
        description: f.description,
        updatedBy: f.updatedBy,
        updatedAt: f.updatedAt,
      );

  Future<void> checkIntegration(Integration integration) async {
    try {
      final updated = await _repo.checkIntegration(integration.id);
      if (isClosed) return;
      emit(state.copyWith(
          integrations: [for (final i in state.integrations) i.id == updated.id ? updated : i]));
    } catch (_) {
      // A failed probe keeps the last reading; the list shows it as-is.
    }
  }

  Future<bool> decideApproval(Approval approval, bool approve, String? note) async {
    try {
      await _repo.decideApproval(approval.id, approve: approve, note: note);
      if (isClosed) return false;
      emit(state.copyWith(
          approvals: state.approvals.where((a) => a.id != approval.id).toList()));
      return true;
    } on ApiError catch (e) {
      if (!isClosed) emit(state.copyWith(error: e));
      return false;
    }
  }

  Future<void> loadMoreAudit() async {
    final cursor = state.auditCursor;
    if (!state.auditHasMore || cursor == null) return;
    try {
      final page = await _repo.audit(cursor: cursor);
      if (isClosed) return;
      emit(state.copyWith(
        audit: [...state.audit, ...page.items],
        auditCursor: page.nextCursor,
        auditHasMore: page.hasMore,
      ));
    } catch (_) {
      // Keeps the loaded rows.
    }
  }

  static _AuditPage _emptyAudit() => _AuditPage(const [], null, false);
}

class _AuditPage {
  _AuditPage(this.events, this.cursor, this.hasMore);

  final List<AuditEvent> events;
  final String? cursor;
  final bool hasMore;
}
