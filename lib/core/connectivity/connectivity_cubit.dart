import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// `true` while the device has a network route. The OfflineBanner and
/// realtime layer read it; requests still decide for themselves.
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit(this._connectivity) : super(true);

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  static bool _online(List<ConnectivityResult> r) =>
      r.any((c) => c != ConnectivityResult.none);

  Future<void> start() async {
    try {
      emit(_online(await _connectivity.checkConnectivity()));
      _sub = _connectivity.onConnectivityChanged.listen((r) => emit(_online(r)));
    } catch (_) {
      // Plugin unavailable (tests, desktop): assume online.
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
