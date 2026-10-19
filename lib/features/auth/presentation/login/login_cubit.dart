import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_error.dart';
import '../../../../core/platform/biometric_service.dart';
import '../../../../core/platform/device_info_service.dart';
import '../../../access/presentation/session_cubit.dart';
import '../../data/auth_repository.dart';

enum LoginStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscure = true,
    this.status = LoginStatus.idle,
    this.error,
    this.faceIdAvailable = false,
    this.deviceName = '',
  });

  final String email;
  final String password;
  final bool obscure;
  final LoginStatus status;
  final ApiError? error;
  final bool faceIdAvailable;
  final String deviceName;

  bool get canSubmit => email.trim().isNotEmpty && password.isNotEmpty && status != LoginStatus.submitting;

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscure,
    LoginStatus? status,
    ApiError? error,
    bool? faceIdAvailable,
    String? deviceName,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        obscure: obscure ?? this.obscure,
        status: status ?? this.status,
        error: error,
        faceIdAvailable: faceIdAvailable ?? this.faceIdAvailable,
        deviceName: deviceName ?? this.deviceName,
      );

  @override
  List<Object?> get props => [email, password, obscure, status, error, faceIdAvailable, deviceName];
}

/// Staff sign-in: email + password, or Face ID to unlock a stored session.
@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth, this._session, this._biometrics, this._devices) : super(const LoginState());

  final AuthRepository _auth;
  final SessionCubit _session;
  final BiometricService _biometrics;
  final DeviceInfoService _devices;

  Future<void> init() async {
    final available = await _biometrics.isAvailable();
    String name = '';
    try {
      name = (await _devices.describe()).name;
    } catch (_) {
      // Device name is decoration; login works without it.
    }
    if (isClosed) return;
    emit(state.copyWith(faceIdAvailable: available, deviceName: name));
  }

  void emailChanged(String v) => emit(state.copyWith(email: v));
  void passwordChanged(String v) => emit(state.copyWith(password: v));
  void toggleObscure() => emit(state.copyWith(obscure: !state.obscure));

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(status: LoginStatus.submitting, error: null));
    try {
      final r = await _auth.login(email: state.email, password: state.password);
      _session.signedIn(r);
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  /// Face ID unlock: biometric gate, then restore the stored session.
  Future<void> unlockWithBiometrics() async {
    emit(state.copyWith(status: LoginStatus.submitting, error: null));
    final ok = await _biometrics.authenticate('Unlock Dahab Ops', requireHardware: true);
    if (!ok) {
      emit(state.copyWith(status: LoginStatus.failure, error: const ApiError(kind: ApiErrorKind.unknown, detail: 'biometric')));
      return;
    }
    await _session.restore();
    if (_session.state.isAuthenticated) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.idle));
    }
  }
}
