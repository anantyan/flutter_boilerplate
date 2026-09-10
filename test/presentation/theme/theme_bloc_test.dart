import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/common/storage/secure_storage_service.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_bloc.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_event.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements ISecureStorageService {}

void main() {
  late MockSecureStorageService mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageService();
  });

  group('ThemeBloc', () {
    test('initial state has ThemeMode.system', () {
      final bloc = ThemeBloc(mockStorage);
      expect(bloc.state.themeMode, equals(ThemeMode.system));
      bloc.close();
    });

    blocTest<ThemeBloc, ThemeState>(
      'emits ThemeMode.dark when stored theme is dark',
      build: () {
        when(
          () => mockStorage.read(key: 'app_theme_mode'),
        ).thenAnswer((_) async => 'dark');
        return ThemeBloc(mockStorage);
      },
      act: (bloc) => bloc.add(const LoadInitialThemeEvent()),
      expect: () => [const ThemeState(themeMode: ThemeMode.dark)],
    );

    blocTest<ThemeBloc, ThemeState>(
      'toggles from system (non-dark) to dark mode and writes to storage',
      build: () {
        when(
          () => mockStorage.write(key: 'app_theme_mode', value: 'dark'),
        ).thenAnswer((_) async {});
        return ThemeBloc(mockStorage);
      },
      act: (bloc) => bloc.add(const ToggleThemeEvent()),
      expect: () => [const ThemeState(themeMode: ThemeMode.dark)],
      verify: (_) {
        verify(
          () => mockStorage.write(key: 'app_theme_mode', value: 'dark'),
        ).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'toggles from dark to light mode and writes to storage',
      build: () {
        when(
          () => mockStorage.write(key: 'app_theme_mode', value: 'light'),
        ).thenAnswer((_) async {});
        return ThemeBloc(mockStorage);
      },
      seed: () => const ThemeState(themeMode: ThemeMode.dark),
      act: (bloc) => bloc.add(const ToggleThemeEvent()),
      expect: () => [const ThemeState(themeMode: ThemeMode.light)],
      verify: (_) {
        verify(
          () => mockStorage.write(key: 'app_theme_mode', value: 'light'),
        ).called(1);
      },
    );
  });
}
