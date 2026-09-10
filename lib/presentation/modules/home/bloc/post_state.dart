import 'package:equatable/equatable.dart';
import '../../../../domain/entities/post_item.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

final class PostInitial extends PostState {
  const PostInitial();
}

final class PostLoading extends PostState {
  const PostLoading();
}

final class PostLoaded extends PostState {
  final List<PostItem> posts;
  final String? notificationMessage;

  const PostLoaded({required this.posts, this.notificationMessage});

  PostLoaded copyWith({List<PostItem>? posts, String? notificationMessage}) {
    return PostLoaded(
      posts: posts ?? this.posts,
      notificationMessage: notificationMessage,
    );
  }

  @override
  List<Object?> get props => [posts, notificationMessage];
}

final class PostFailure extends PostState {
  final String message;

  const PostFailure(this.message);

  @override
  List<Object?> get props => [message];
}
