import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../design/dahab_tokens.dart';
import '../storage/key_value_store.dart';

class PreferencesState extends Equatable {
  const PreferencesState({
    this.theme = DahabThemeId.abyss,
    this.locale = const Locale('en'),
    this.biometricLock = true,
  });

  final DahabThemeId theme;
  final Locale locale;
  final bool biometricLock;

  bool get isArabic => locale.languageCode == 'ar';

  PreferencesState copyWith({DahabThemeId? theme, Locale? locale, bool? biometricLock}) =>
      PreferencesState(
        theme: theme ?? this.theme,
        locale: locale ?? this.locale,
        biometricLock: biometricLock ?? this.biometricLock,
      );

  @override
  List<Object?> get props => [theme, locale, biometricLock];
}

/// Theme, language and app-lock preferences, persisted on device.
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit(this._store) : super(const PreferencesState());

  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const _kTheme = 'prefs.theme';
  static const _kLocale = 'prefs.locale';
  static const _kLock = 'prefs.biometricLock';

  final KeyValueStore _store;

  Future<void> load({Locale? deviceLocale}) async {
    final theme = await _store.read(_kTheme);
    final locale = await _store.read(_kLocale);
    final lock = await _store.read(_kLock);
    final fallback = deviceLocale?.languageCode == 'ar' ? 'ar' : 'en';
    emit(PreferencesState(
      theme: DahabThemeId.fromWire(theme),
      locale: Locale(locale ?? fallback),
      biometricLock: lock == null ? true : lock == 'true',
    ));
  }

  Future<void> setTheme(DahabThemeId theme) async {
    emit(state.copyWith(theme: theme));
    await _store.write(_kTheme, theme.wire);
  }

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await _store.write(_kLocale, locale.languageCode);
  }

  Future<void> setBiometricLock(bool enabled) async {
    emit(state.copyWith(biometricLock: enabled));
    await _store.write(_kLock, '$enabled');
  }
}
