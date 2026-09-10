import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/post_item.dart';
import '../../../../domain/usecases/create_post_usecase.dart';
import '../../../../domain/usecases/delete_post_usecase.dart';
import '../../../../domain/usecases/get_posts_usecase.dart';
import 'post_event.dart';
import 'post_state.dart';

@injectable
class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase _getPostsUseCase;
  final CreatePostUseCase _createPostUseCase;
  final DeletePostUseCase _deletePostUseCase;

  PostBloc(
    this._getPostsUseCase,
    this._createPostUseCase,
    this._deletePostUseCase,
  ) : super(const PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<AddPostEvent>(_onAddPost);
    on<RemovePostEvent>(_onRemovePost);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());
    final result = await _getPostsUseCase.execute();
    result.fold(
      (failure) => emit(PostFailure(failure.message)),
      (posts) => emit(PostLoaded(posts: posts)),
    );
  }

  Future<void> _onAddPost(AddPostEvent event, Emitter<PostState> emit) async {
    final result = await _createPostUseCase.execute(
      title: event.title,
      body: event.body,
      status: event.status,
    );

    result.fold((failure) => emit(PostFailure(failure.message)), (createdPost) {
      final currentPosts = state is PostLoaded
          ? List<PostItem>.from((state as PostLoaded).posts)
          : <PostItem>[];
      currentPosts.insert(0, createdPost);
      emit(
        PostLoaded(
          posts: currentPosts,
          notificationMessage:
              'Post "${createdPost.title}" berhasil ditambahkan.',
        ),
      );
    });
  }

  Future<void> _onRemovePost(
    RemovePostEvent event,
    Emitter<PostState> emit,
  ) async {
    final currentPosts = state is PostLoaded
        ? List<PostItem>.from((state as PostLoaded).posts)
        : <PostItem>[];
    final targetIndex = currentPosts.indexWhere((p) => p.id == event.id);
    if (targetIndex == -1) return;

    final removedItem = currentPosts[targetIndex];
    currentPosts.removeAt(targetIndex);
    emit(PostLoaded(posts: currentPosts));

    final result = await _deletePostUseCase.execute(event.id);
    result.fold(
      (failure) {
        final rollbackPosts = state is PostLoaded
            ? List<PostItem>.from((state as PostLoaded).posts)
            : <PostItem>[];
        rollbackPosts.insert(
          targetIndex.clamp(0, rollbackPosts.length),
          removedItem,
        );
        emit(PostLoaded(posts: rollbackPosts));
        emit(PostFailure(failure.message));
      },
      (_) {
        emit(
          PostLoaded(
            posts: state is PostLoaded
                ? (state as PostLoaded).posts
                : currentPosts,
            notificationMessage:
                'Post "${removedItem.title}" berhasil dihapus.',
          ),
        );
      },
    );
  }
}
