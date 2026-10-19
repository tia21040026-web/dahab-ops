import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/platform/biometric_service.dart';

class AppLockState extends Equatable {
  const AppLockState({this.locked = false, this.available = false, this.busy = false});

  final bool locked;
  final bool available;
  final bool busy;

  AppLockState copyWith({bool? locked, bool? available, bool? busy}) => AppLockState(
        locked: locked ?? this.locked,
        available: available ?? this.available,
        busy: busy ?? this.busy,
      );

  @override
  List<Object?> get props => [locked, available, busy];
}

/// Locks the app behind biometrics when it returns from the background after
/// [grace]. Only active while signed in and the preference is on.
class AppLockCubit extends Cubit<AppLockState> with WidgetsBindingObserver {
  AppLockCubit(this._biometrics, {this.grace = const Duration(seconds: 30)})
      : super(const AppLockState());

  final BiometricService _biometrics;
  final Duration grace;

  bool Function() isEnabled = () => false;
  DateTime? _backgroundedAt;

  Future<void> start({required bool Function() enabled}) async {
    isEnabled = enabled;
    WidgetsBinding.instance.addObserver(this);
    emit(state.copyWith(available: await _biometrics.isAvailable()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final s = state;
    final current = this.state;
    if (s == AppLifecycleState.paused || s == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
    } else if (s == AppLifecycleState.resumed) {
      final since = _backgroundedAt;
      _backgroundedAt = null;
      if (since != null &&
          DateTime.now().difference(since) >= grace &&
          current.available &&
          isEnabled()) {
        emit(current.copyWith(locked: true));
      }
    }
  }

  Future<void> unlock(String reason) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true));
    final ok = await _biometrics.authenticate(reason);
    emit(state.copyWith(busy: false, locked: !ok));
  }

  void reset() => emit(state.copyWith(locked: false));

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
