import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../common/errors/exceptions.dart';
import '../../common/errors/failures.dart';
import '../../domain/entities/post_item.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/remote/post_remote_datasource.dart';
import '../models/post_model.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;

  PostRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PostItem>>> getPosts() async {
    try {
      final models = await _remoteDataSource.getPosts();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on NoNetworkException catch (e) {
      return Left(
        NetworkFailure(message: e.message ?? 'No network connection'),
      );
    } on NetworkException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostItem>> createPost({
    required String title,
    required String body,
    required PostStatus status,
  }) async {
    try {
      final newEntity = PostItem(
        id: 'post-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        status: status,
        createdAt: DateTime.now(),
      );

      final model = PostModel.fromEntity(newEntity);
      final createdModel = await _remoteDataSource.createPost(model);
      return Right(createdModel.toEntity());
    } on NoNetworkException catch (e) {
      return Left(
        NetworkFailure(message: e.message ?? 'No network connection'),
      );
    } on NetworkException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String id) async {
    try {
      await _remoteDataSource.deletePost(id);
      return const Right(unit);
    } on NoNetworkException catch (e) {
      return Left(
        NetworkFailure(message: e.message ?? 'No network connection'),
      );
    } on NetworkException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
