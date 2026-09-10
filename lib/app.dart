import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/router/app_router.dart';
import 'common/theme/app_theme.dart';
import 'di/injection.dart';
import 'presentation/theme/theme_bloc.dart';
import 'presentation/theme/theme_state.dart';

class App extends StatelessWidget {
  final AppRouter _appRouter;

  App({super.key, AppRouter? appRouter})
    : _appRouter = appRouter ?? getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Flutter Boilerplate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: _appRouter.config(),
          );
        },
      ),
    );
  }
}
