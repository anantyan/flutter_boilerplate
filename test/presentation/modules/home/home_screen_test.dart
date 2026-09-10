import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_bloc.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_event.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_state.dart';
import 'package:flutter_boilerplate/presentation/modules/home/screens/home_screen.dart';
import 'package:flutter_boilerplate/presentation/modules/home/widgets/post_item_card.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_bloc.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_event.dart';
import 'package:flutter_boilerplate/presentation/theme/theme_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

void main() {
  late MockPostBloc mockPostBloc;
  late MockThemeBloc mockThemeBloc;

  final testPost1 = PostItem(
    id: '1',
    title: 'Unit Test Post 1',
    body: 'Body description 1',
    status: PostStatus.active,
    createdAt: DateTime(2026, 1, 1),
  );

  final testPost2 = PostItem(
    id: '2',
    title: 'Unit Test Post 2',
    body: 'Body description 2',
    status: PostStatus.completed,
    createdAt: DateTime(2026, 1, 2),
  );

  setUp(() {
    mockPostBloc = MockPostBloc();
    mockThemeBloc = MockThemeBloc();

    when(
      () => mockThemeBloc.state,
    ).thenReturn(const ThemeState(themeMode: ThemeMode.system));
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>.value(value: mockPostBloc),
        BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
      ],
      child: const MaterialApp(home: HomeView()),
    );
  }

  group('HomeView Widget Tests', () {
    testWidgets(
      'displays CircularProgressIndicator when state is PostLoading',
      (tester) async {
        when(() => mockPostBloc.state).thenReturn(const PostLoading());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'displays empty state when state is PostLoaded with empty list',
      (tester) async {
        when(() => mockPostBloc.state).thenReturn(const PostLoaded(posts: []));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Belum Ada Item'), findsOneWidget);
        expect(find.text('Buat Item Pertama'), findsOneWidget);
      },
    );

    testWidgets('displays list of posts when state is PostLoaded with items', (
      tester,
    ) async {
      when(
        () => mockPostBloc.state,
      ).thenReturn(PostLoaded(posts: [testPost1, testPost2]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(PostItemCard), findsNWidgets(2));
      expect(find.text('Unit Test Post 1'), findsOneWidget);
      expect(find.text('Unit Test Post 2'), findsOneWidget);
    });

    testWidgets('displays error message and handles retry button', (
      tester,
    ) async {
      when(
        () => mockPostBloc.state,
      ).thenReturn(const PostFailure('Koneksi internet terputus'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Terjadi Kesalahan'), findsOneWidget);
      expect(find.text('Koneksi internet terputus'), findsOneWidget);

      final retryButton = find.text('Coba Lagi');
      expect(retryButton, findsOneWidget);

      await tester.tap(retryButton);
      verify(() => mockPostBloc.add(const LoadPostsEvent())).called(1);
    });

    testWidgets(
      'triggers ToggleThemeEvent when theme toggle button is tapped',
      (tester) async {
        when(() => mockPostBloc.state).thenReturn(const PostLoaded(posts: []));

        await tester.pumpWidget(createWidgetUnderTest());

        final themeButton = find.byKey(const Key('theme_toggle_button'));
        expect(themeButton, findsOneWidget);

        await tester.tap(themeButton);
        verify(() => mockThemeBloc.add(const ToggleThemeEvent())).called(1);
      },
    );

    testWidgets('tapping FAB opens CreatePostBottomSheet modal', (
      tester,
    ) async {
      when(() => mockPostBloc.state).thenReturn(const PostLoaded(posts: []));

      await tester.pumpWidget(createWidgetUnderTest());

      final fab = find.byKey(const Key('add_post_fab'));
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('Tambah Post Baru'), findsOneWidget);
      expect(find.text('Simpan Item Baru'), findsOneWidget);
    });

    testWidgets('swiping item left triggers RemovePostEvent', (tester) async {
      when(() => mockPostBloc.state).thenReturn(PostLoaded(posts: [testPost1]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Unit Test Post 1'), findsOneWidget);

      // Swipe left on the dismissible card
      await tester.drag(find.text('Unit Test Post 1'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      verify(() => mockPostBloc.add(const RemovePostEvent('1'))).called(1);
    });

    testWidgets('renders SafeArea wrapping body content', (tester) async {
      when(() => mockPostBloc.state).thenReturn(const PostLoaded(posts: []));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(
        find.byWidgetPredicate((widget) => widget is SafeArea && !widget.top),
        findsOneWidget,
      );
    });
  });
}
