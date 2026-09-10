import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadInitialThemeEvent extends ThemeEvent {
  const LoadInitialThemeEvent();
}

final class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

final class SetThemeModeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const SetThemeModeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
