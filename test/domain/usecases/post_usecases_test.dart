import 'package:dartz/dartz.dart';
import 'package:flutter_boilerplate/common/errors/failures.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_boilerplate/domain/repositories/post_repository.dart';
import 'package:flutter_boilerplate/domain/usecases/create_post_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/delete_post_usecase.dart';
import 'package:flutter_boilerplate/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late MockPostRepository mockRepository;
  late GetPostsUseCase getPostsUseCase;
  late CreatePostUseCase createPostUseCase;
  late DeletePostUseCase deletePostUseCase;

  final testPost = PostItem(
    id: '1',
    title: 'Test Title',
    body: 'Test Body',
    status: PostStatus.active,
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepository = MockPostRepository();
    getPostsUseCase = GetPostsUseCase(mockRepository);
    createPostUseCase = CreatePostUseCase(mockRepository);
    deletePostUseCase = DeletePostUseCase(mockRepository);
  });

  group('GetPostsUseCase', () {
    test('returns List<PostItem> from repository on success', () async {
      when(
        () => mockRepository.getPosts(),
      ).thenAnswer((_) async => Right([testPost]));

      final result = await getPostsUseCase.execute();

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be right'),
        (posts) => expect(posts, equals([testPost])),
      );
      verify(() => mockRepository.getPosts()).called(1);
    });

    test('returns ServerFailure when repository fails', () async {
      const failure = ServerFailure(message: 'Server Error');
      when(
        () => mockRepository.getPosts(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await getPostsUseCase.execute();

      expect(result, equals(const Left(failure)));
      verify(() => mockRepository.getPosts()).called(1);
    });
  });

  group('CreatePostUseCase', () {
    test('creates post and returns created entity', () async {
      when(
        () => mockRepository.createPost(
          title: 'New Title',
          body: 'New Body',
          status: PostStatus.pending,
        ),
      ).thenAnswer((_) async => Right(testPost));

      final result = await createPostUseCase.execute(
        title: 'New Title',
        body: 'New Body',
        status: PostStatus.pending,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should be right'),
        (post) => expect(post, equals(testPost)),
      );
      verify(
        () => mockRepository.createPost(
          title: 'New Title',
          body: 'New Body',
          status: PostStatus.pending,
        ),
      ).called(1);
    });
  });

  group('DeletePostUseCase', () {
    test('deletes post and returns unit', () async {
      when(
        () => mockRepository.deletePost('1'),
      ).thenAnswer((_) async => const Right(unit));

      final result = await deletePostUseCase.execute('1');

      expect(result, equals(const Right(unit)));
      verify(() => mockRepository.deletePost('1')).called(1);
    });
  });
}
