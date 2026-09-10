import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../common/errors/failures.dart';
import '../entities/post_item.dart';
import '../repositories/post_repository.dart';

@injectable
class CreatePostUseCase {
  final PostRepository _repository;

  CreatePostUseCase(this._repository);

  Future<Either<Failure, PostItem>> execute({
    required String title,
    required String body,
    required PostStatus status,
  }) {
    return _repository.createPost(title: title, body: body, status: status);
  }
}
