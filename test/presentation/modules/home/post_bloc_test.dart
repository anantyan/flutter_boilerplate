import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/common/errors/failures.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_boilerplate/domain/usecases/create_post_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/delete_post_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_bloc.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_event.dart';
import 'package:flutter_boilerplate/presentation/modules/home/bloc/post_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

class MockCreatePostUseCase extends Mock implements CreatePostUseCase {}

class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}

void main() {
  late MockGetPostsUseCase mockGetPostsUseCase;
  late MockCreatePostUseCase mockCreatePostUseCase;
  late MockDeletePostUseCase mockDeletePostUseCase;

  final testPost1 = PostItem(
    id: '1',
    title: 'Post 1',
    body: 'Description 1',
    status: PostStatus.active,
    createdAt: DateTime(2026, 1, 1),
  );

  final testPost2 = PostItem(
    id: '2',
    title: 'Post 2',
    body: 'Description 2',
    status: PostStatus.completed,
    createdAt: DateTime(2026, 1, 2),
  );

  setUpAll(() {
    registerFallbackValue(PostStatus.active);
  });

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    mockCreatePostUseCase = MockCreatePostUseCase();
    mockDeletePostUseCase = MockDeletePostUseCase();
  });

  PostBloc buildBloc() => PostBloc(
    mockGetPostsUseCase,
    mockCreatePostUseCase,
    mockDeletePostUseCase,
  );

  group('PostBloc Tests', () {
    test('initial state is PostInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, const PostInitial());
      bloc.close();
    });

    group('LoadPostsEvent', () {
      blocTest<PostBloc, PostState>(
        'emits [PostLoading, PostLoaded] when getPostsUseCase succeeds',
        build: () {
          when(
            () => mockGetPostsUseCase.execute(),
          ).thenAnswer((_) async => Right([testPost1, testPost2]));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadPostsEvent()),
        expect: () => [
          const PostLoading(),
          PostLoaded(posts: [testPost1, testPost2]),
        ],
        verify: (_) {
          verify(() => mockGetPostsUseCase.execute()).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits [PostLoading, PostFailure] when getPostsUseCase fails',
        build: () {
          when(() => mockGetPostsUseCase.execute()).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Gagal memuat data server.')),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadPostsEvent()),
        expect: () => [
          const PostLoading(),
          const PostFailure('Gagal memuat data server.'),
        ],
      );
    });

    group('AddPostEvent', () {
      final newPost = PostItem(
        id: 'new-3',
        title: 'New Post',
        body: 'New Body',
        status: PostStatus.pending,
        createdAt: DateTime(2026, 1, 3),
      );

      blocTest<PostBloc, PostState>(
        'emits PostLoaded with new post inserted when createPostUseCase succeeds',
        build: () {
          when(
            () => mockCreatePostUseCase.execute(
              title: any(named: 'title'),
              body: any(named: 'body'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => Right(newPost));
          return buildBloc();
        },
        seed: () => PostLoaded(posts: [testPost1]),
        act: (bloc) => bloc.add(
          const AddPostEvent(
            title: 'New Post',
            body: 'New Body',
            status: PostStatus.pending,
          ),
        ),
        expect: () => [
          PostLoaded(
            posts: [newPost, testPost1],
            notificationMessage: 'Post "New Post" berhasil ditambahkan.',
          ),
        ],
        verify: (_) {
          verify(
            () => mockCreatePostUseCase.execute(
              title: 'New Post',
              body: 'New Body',
              status: PostStatus.pending,
            ),
          ).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits PostFailure when createPostUseCase fails',
        build: () {
          when(
            () => mockCreatePostUseCase.execute(
              title: any(named: 'title'),
              body: any(named: 'body'),
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Gagal membuat post')),
          );
          return buildBloc();
        },
        seed: () => PostLoaded(posts: [testPost1]),
        act: (bloc) => bloc.add(
          const AddPostEvent(
            title: 'New Post',
            body: 'New Body',
            status: PostStatus.pending,
          ),
        ),
        expect: () => [const PostFailure('Gagal membuat post')],
      );
    });

    group('RemovePostEvent', () {
      blocTest<PostBloc, PostState>(
        'emits optimistic PostLoaded and confirmed PostLoaded when delete succeeds',
        build: () {
          when(
            () => mockDeletePostUseCase.execute('1'),
          ).thenAnswer((_) async => const Right(unit));
          return buildBloc();
        },
        seed: () => PostLoaded(posts: [testPost1, testPost2]),
        act: (bloc) => bloc.add(const RemovePostEvent('1')),
        expect: () => [
          PostLoaded(posts: [testPost2]),
          PostLoaded(
            posts: [testPost2],
            notificationMessage: 'Post "Post 1" berhasil dihapus.',
          ),
        ],
        verify: (_) {
          verify(() => mockDeletePostUseCase.execute('1')).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'rolls back list and emits PostFailure when delete fails',
        build: () {
          when(() => mockDeletePostUseCase.execute('1')).thenAnswer(
            (_) async =>
                const Left(ServerFailure(message: 'Gagal menghapus post')),
          );
          return buildBloc();
        },
        seed: () => PostLoaded(posts: [testPost1, testPost2]),
        act: (bloc) => bloc.add(const RemovePostEvent('1')),
        expect: () => [
          PostLoaded(posts: [testPost2]),
          PostLoaded(posts: [testPost1, testPost2]),
          const PostFailure('Gagal menghapus post'),
        ],
      );
    });
  });
}
