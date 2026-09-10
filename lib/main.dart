import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'app.dart';
import 'di/injection.dart';
import 'presentation/theme/theme_bloc.dart';
import 'presentation/theme/theme_event.dart';

void main() async {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  configureDependencies();
  getIt<ThemeBloc>().add(const LoadInitialThemeEvent());
  runApp(App());
}
