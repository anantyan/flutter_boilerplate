import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/common/errors/exceptions.dart';
import 'package:flutter_boilerplate/common/errors/failures.dart';
import 'package:flutter_boilerplate/data/datasources/remote/post_remote_datasource.dart';
import 'package:flutter_boilerplate/data/models/post_model.dart';
import 'package:flutter_boilerplate/data/repositories/post_repository_impl.dart';
import 'package:flutter_boilerplate/domain/entities/post_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late MockPostRemoteDataSource mockRemoteDataSource;
  late PostRepositoryImpl repository;

  final testModel = PostModel(
    id: 'post-1',
    title: 'Model Title',
    body: 'Model Body',
    status: 'active',
    createdAt: '2026-01-01T00:00:00.000',
  );

  setUp(() {
    mockRemoteDataSource = MockPostRemoteDataSource();
    repository = PostRepositoryImpl(mockRemoteDataSource);
    registerFallbackValue(testModel);
  });

  group('PostRepositoryImpl.getPosts', () {
    test('returns Right(List<PostItem>) on successful remote fetch', () async {
      when(
        () => mockRemoteDataSource.getPosts(),
      ).thenAnswer((_) async => [testModel]);

      final result = await repository.getPosts();

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should be a right value'), (items) {
        expect(items.length, equals(1));
        expect(items.first.title, equals('Model Title'));
        expect(items.first.status, equals(PostStatus.active));
      });
      verify(() => mockRemoteDataSource.getPosts()).called(1);
    });

    test('returns Left(NetworkFailure) on NoNetworkException', () async {
      when(() => mockRemoteDataSource.getPosts()).thenThrow(
        NoNetworkException(requestOptions: RequestOptions(path: '/posts')),
      );

      final result = await repository.getPosts();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should be a failure'),
      );
    });

    test('returns Left(ServerFailure) on NetworkException', () async {
      when(() => mockRemoteDataSource.getPosts()).thenThrow(
        InternalServerException(
          requestOptions: RequestOptions(path: '/posts'),
          message: 'Database connection failed',
        ),
      );

      final result = await repository.getPosts();

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, contains('Database connection failed'));
      }, (_) => fail('Should be a failure'));
    });
  });

  group('PostRepositoryImpl.deletePost', () {
    test('returns Right(unit) on successful deletion', () async {
      when(
        () => mockRemoteDataSource.deletePost('post-1'),
      ).thenAnswer((_) async {});

      final result = await repository.deletePost('post-1');

      expect(result, equals(const Right(unit)));
      verify(() => mockRemoteDataSource.deletePost('post-1')).called(1);
    });
  });
}
