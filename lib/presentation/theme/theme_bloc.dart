import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../common/storage/secure_storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeStorageKey = 'app_theme_mode';
  final ISecureStorageService _storageService;

  ThemeBloc(this._storageService) : super(const ThemeState()) {
    on<LoadInitialThemeEvent>(_onLoadInitialTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeModeEvent>(_onSetThemeMode);
  }

  Future<void> _onLoadInitialTheme(
    LoadInitialThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final savedTheme = await _storageService.read(key: _themeStorageKey);
    if (savedTheme != null) {
      if (savedTheme == 'dark') {
        emit(state.copyWith(themeMode: ThemeMode.dark));
      } else if (savedTheme == 'light') {
        emit(state.copyWith(themeMode: ThemeMode.light));
      } else {
        emit(state.copyWith(themeMode: ThemeMode.system));
      }
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
    await _storageService.write(
      key: _themeStorageKey,
      value: newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> _onSetThemeMode(
    SetThemeModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));
    final value = event.themeMode == ThemeMode.dark
        ? 'dark'
        : event.themeMode == ThemeMode.light
        ? 'light'
        : 'system';
    await _storageService.write(key: _themeStorageKey, value: value);
  }
}
