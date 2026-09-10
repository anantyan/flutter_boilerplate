import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../common/errors/failures.dart';
import '../repositories/post_repository.dart';

@injectable
class DeletePostUseCase {
  final PostRepository _repository;

  DeletePostUseCase(this._repository);

  Future<Either<Failure, Unit>> execute(String id) {
    return _repository.deletePost(id);
  }
}
