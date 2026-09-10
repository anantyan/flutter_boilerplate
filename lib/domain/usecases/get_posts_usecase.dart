import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../common/errors/failures.dart';
import '../entities/post_item.dart';
import '../repositories/post_repository.dart';

@injectable
class GetPostsUseCase {
  final PostRepository _repository;

  GetPostsUseCase(this._repository);

  Future<Either<Failure, List<PostItem>>> execute() {
    return _repository.getPosts();
  }
}
