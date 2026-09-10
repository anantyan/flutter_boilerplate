import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app.dart';
import 'package:flutter_boilerplate/common/router/app_router.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_bloc.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_event.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_state.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_bloc.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_event.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}

void main() {
  late MockThemeBloc mockThemeBloc;
  late MockPostBloc mockPostBloc;
  late AppRouter appRouter;

  setUp(() {
    final getIt = GetIt.instance;
    getIt.reset();

    mockThemeBloc = MockThemeBloc();
    mockPostBloc = MockPostBloc();
    appRouter = AppRouter();

    getIt.registerLazySingleton<ThemeBloc>(() => mockThemeBloc);
    getIt.registerFactory<PostBloc>(() => mockPostBloc);
    getIt.registerLazySingleton<AppRouter>(() => appRouter);

    when(
      () => mockThemeBloc.state,
    ).thenReturn(const ThemeState(themeMode: ThemeMode.dark));
    when(
      () => mockPostBloc.state,
    ).thenReturn(const PostLoaded(posts: <PostItem>[]));
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets(
    'App renders MaterialApp.router with configured theme and home route',
    (tester) async {
      await tester.pumpWidget(App(appRouter: appRouter));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Flutter Boilerplate'), findsOneWidget);
    },
  );
}
