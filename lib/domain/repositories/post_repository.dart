import 'package:dartz/dartz.dart';
import '../../common/errors/failures.dart';
import '../entities/post_item.dart';

/// Contract definition for Post operations in the domain layer.
abstract class PostRepository {
  Future<Either<Failure, List<PostItem>>> getPosts();

  Future<Either<Failure, PostItem>> createPost({
    required String title,
    required String body,
    required PostStatus status,
  });

  Future<Either<Failure, Unit>> deletePost(String id);
}
