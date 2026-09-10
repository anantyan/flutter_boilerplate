import 'package:flutter/material.dart';
import 'app.dart';
import 'di/injection.dart';
import 'presentation/theme/theme_bloc.dart';
import 'presentation/theme/theme_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  getIt<ThemeBloc>().add(const LoadInitialThemeEvent());
  runApp(App());
}
